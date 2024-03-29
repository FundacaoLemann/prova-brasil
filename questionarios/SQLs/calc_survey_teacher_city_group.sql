DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_teacher_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);
  DECLARE _grade VARCHAR(40);
  DECLARE _dependence VARCHAR(40);


  DECLARE opcoes CURSOR FOR
        select dependence.name as dependence, grade.name as grade, column_name as 'column'
            from ( select 'all' as name union select 'grouped' ) as dependence
            inner join ( select 'all' as name union select 'grouped' ) as grade
            inner join information_schema.columns
         where table_name='survey_teacher_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP

    FETCH opcoes INTO _dependence, _grade, _coluna;

    IF done THEN
      LEAVE loop_leitura;
    END IF;

    set _num = SUBSTRING(_coluna,3);

    set @queryQ = '
        insert into fact_question_teacher_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
           sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
           NULL
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
            inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
            inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
           group by cg.id :group_by_dependence :group_by_grade;
';

    set @queryA = '
        insert into fact_alternative_teacher_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          2 as survey_id
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
            inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
            inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
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


    elseif _grade = 'all' then
        set @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
        set @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

        set @queryA = REPLACE(@queryA, ':group_by_grade', '');
        set @queryA = REPLACE(@queryA, ':filter_grade', '0');

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