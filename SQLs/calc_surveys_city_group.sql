CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_surveys_city_group`(cg_id int)
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _grade VARCHAR(40);
  DECLARE _dependence VARCHAR(40);
  DECLARE _fact_question VARCHAR(60);
  DECLARE _fact_alternative VARCHAR(60);
  DECLARE _origin_table VARCHAR(60);
  DECLARE _survey_id int;

  
  DECLARE opcoes CURSOR FOR 
		select 
			dependence.name as 'dependence', 
			grade.name as 'grade', 
			column_name as 'column', 
			fact_question,
			fact_alternative,
			origin_table,
			survey_id 
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join (
				select 'fact_question_director' as fact_question, 'fact_alternative_director' as fact_alternative, 1 as survey_id, 'survey_director_responses_2011' as origin_table
				union select 'fact_question_teacher', 'fact_alternative_teacher' , 2, 'survey_teacher_responses_2011'
				union select 'fact_question_students_5', 'fact_alternative_students_5' , 4, 'survey_students_responses_2011_5ano'
				union select 'fact_question_students_9', 'fact_alternative_students_9' , 5, 'survey_students_responses_2011_9ano'
			) as tables
			left join ( select 'all' as name union select 'grouped' ) as grade on tables.survey_id = 2
			inner join information_schema.columns 
		 where table_name=tables.origin_table and column_name like 'Q%';


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence, _grade, _coluna, _fact_question, _fact_alternative, _origin_table, _survey_id;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into :fact_question
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from waitress_dw_prova_brasil_2011.:origin_table as sdr
           inner join question as q on q.order = :num and q.survey_id = :survey_id and q.edition_id = 4
			inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id and cig.city_group_id = :cg_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id and cg.id = :cg_id
           group by cg.id :group_by_dependence :group_by_grade;				
';

	set @queryA = '
		insert into :fact_alternative
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          :survey_id as survey_id
        from waitress_dw_prova_brasil_2011.:origin_table as sdr
           inner join question as q on q.order = :num and q.survey_id = :survey_id and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
			inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id and cig.city_group_id = :cg_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id and cg.id = :cg_id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id, :group_by_dependence :group_by_grade :column;	
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


	
	if _grade = 'grouped' then		
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', ',sdr.grade_id');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

		set @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
		set @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');

	
	elseif _grade = 'all' or _grade is NULL then
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

		set @queryA = REPLACE(@queryA, ':group_by_grade', '');
		set @queryA = REPLACE(@queryA, ':filter_grade', '0');
		
    end if;

	set @queryQ = REPLACE(@queryQ, ':cg_id', cg_id);
	set @queryQ = REPLACE(@queryQ, ':fact_question', _fact_question);
	set @queryQ = REPLACE(@queryQ, ':origin_table', _origin_table);
	set @queryQ = REPLACE(@queryQ, ':survey_id', _survey_id);
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':cg_id', cg_id);
	set @queryA = REPLACE(@queryA, ':fact_alternative', _fact_alternative);
	set @queryA = REPLACE(@queryA, ':origin_table', _origin_table);
	set @queryA = REPLACE(@queryA, ':survey_id', _survey_id);
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
