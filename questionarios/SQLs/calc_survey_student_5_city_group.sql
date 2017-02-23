DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_student_5_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);
  DECLARE _dependence VARCHAR(40);


  DECLARE opcoes CURSOR FOR
		select dependence.name as dependence, column_name as 'column'
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns
		 where table_name='survey_students_responses_2011_5ano' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP

    FETCH opcoes INTO _dependence, _coluna;

	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_students_5_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
			 inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
		    group by cg.id :group_by_dependence;
';

	set @queryA = '
		insert into fact_alternative_students_5_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          4 as survey_id
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
		    inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id, :group_by_dependence :column;

	';


	if _dependence = 'grouped' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');


	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');

    end if;

	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);

	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;

END ;;