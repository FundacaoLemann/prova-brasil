CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_director_city_state_brasil`()
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
		 where table_name='survey_director_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
		   NULL
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_aggregation ;				
';

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
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log3 (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log3 (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
