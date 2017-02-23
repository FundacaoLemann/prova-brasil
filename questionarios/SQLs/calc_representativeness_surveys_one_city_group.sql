DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_representativeness_surveys_one_city_group`(cg_id int)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE _survey_id INT;
  DECLARE _survey_table VARCHAR(50);
  DECLARE _survey_question int;
  DECLARE _edition_id int;
  DECLARE opcoes CURSOR FOR select 1 as survey_id, 1 as survey_question, 'fact_question_director' as survey_table, 3 as edition_id
                            union select 2 as survey_id, 213 as survey_question, 'fact_question_teacher' as survey_table, 3 as edition_id
                            union select 4 as survey_id, 378 as survey_question, 'fact_question_students_5' as survey_table, 3 as edition_id
                            union select 5 as survey_id, 422 as survey_question, 'fact_question_students_9' as survey_table, 3 as edition_id
                            union select 1 as survey_id, 1001 as survey_question, 'fact_question_director' as survey_table, 4 as edition_id
                            union select 2 as survey_id, 1004 as survey_question, 'fact_question_teacher' as survey_table, 4 as edition_id
                            union select 4 as survey_id, 1003 as survey_question, 'fact_question_students_5' as survey_table, 4 as edition_id
                            union select 5 as survey_id, 1005 as survey_question, 'fact_question_students_9' as survey_table, 4 as edition_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP
    FETCH opcoes INTO _survey_id, _survey_question, _survey_table, _edition_id;
    IF done THEN
      LEAVE loop_leitura;
    END IF;

    SET @queryCityGroups = '
        insert into representativeness_surveys
        select
            dim_regional_aggregation_id,
            dim_politic_aggregation_id,
            :survey_id,
            :edition_id,
            f.total_surveys,
            f.total_responses,
            (total_responses - invalid_responses - erase_responses) as \'valid\',
            count(s.id) as num_schools
        from :survey_table as f
        inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
        inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
        inner join waitress_entities.city_group as cg on cg.id = dra.city_group_id
        inner join waitress_entities.city_in_group as cig on cig.city_group_id = cg.id
        inner join school as s on s.city_id = cig.city_id and s.state_id = dra.state_id and s.edition_id = :edition_id
        where f.question_id = :survey_question and dra.city_id = 0 and dra.city_group_id = :cg_id and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
        group by dra.city_group_id;';

    SET @queryCityGroups = REPLACE(@queryCityGroups, ':survey_id', _survey_id);
    SET @queryCityGroups = REPLACE(@queryCityGroups, ':survey_table', _survey_table);
    SET @queryCityGroups = REPLACE(@queryCityGroups, ':survey_question', _survey_question);
    SET @queryCityGroups = REPLACE(@queryCityGroups, ':edition_id', _edition_id);
    SET @queryCityGroups = REPLACE(@queryCityGroups, ':cg_id', cg_id);

    INSERT INTO log (message) VALUES (@queryCityGroups);
    prepare stmtCities FROM @queryCityGroups;
    EXECUTE stmtCities;

  END LOOP;
  CLOSE opcoes;

END ;;