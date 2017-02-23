CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_director_city_state_brasil_questoes_com_bug`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_director_responses_2011' and column_name in ('Q_163', 'Q_168', 'Q_173', 'Q_179', 'Q_184', 'Q_189', 'Q_195', 'Q_200', 'Q_205', 'Q_211');

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryA = '
		insert into fact_alternative_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          1 as survey_id
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
