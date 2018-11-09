DELIMITER ;;
CREATE PROCEDURE `calc_representatividade_questionarios`()
BEGIN
DECLARE done INT DEFAULT FALSE;

DECLARE _survey_id INT;
DECLARE _survey_table VARCHAR(50);
DECLARE _survey_question int;
DECLARE _edition_id int;

DECLARE opcoes CURSOR FOR       select 1 as survey_id, 2000 as survey_question, 'fact_question_director'   as survey_table, 6 as edition_id
                          union select 2 as survey_id, 2111 as survey_question, 'fact_question_teacher'    as survey_table, 6 as edition_id
                          union select 4 as survey_id, 2304 as survey_question, 'fact_question_students_5' as survey_table, 6 as edition_id
                          union select 5 as survey_id, 2355 as survey_question, 'fact_question_students_9' as survey_table, 6 as edition_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN opcoes;
loop_leitura: LOOP

FETCH opcoes INTO _survey_id, _survey_question, _survey_table, _edition_id;

IF done THEN
    LEAVE loop_leitura;
END IF;

SET @querySchool = '
    insert into representativeness_surveys
    select
        dim_regional_aggregation_id,
        dim_politic_aggregation_id,
        :survey_id,
        0,
        :edition_id,
        f.total_surveys,
        f.total_responses,
        (total_responses - invalid_responses - erase_responses) as \'valid\',
        NULL
    from :survey_table as f
    inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
    inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
    where f.question_id = :survey_question and school_id != 0';


SET @querySchool = REPLACE(@querySchool, ':survey_id', _survey_id);
SET @querySchool = REPLACE(@querySchool, ':survey_table', _survey_table);
SET @querySchool = REPLACE(@querySchool, ':survey_question', _survey_question);
SET @querySchool = REPLACE(@querySchool, ':edition_id', _edition_id);

INSERT INTO log (message) VALUES (@querySchool);
prepare stmtSchool FROM @querySchool;
EXECUTE stmtSchool;

SET @queryCities = '
    insert into representativeness_surveys
    select
        dim_regional_aggregation_id,
        dim_politic_aggregation_id,
        :survey_id,
        dpa.dependence_id,
        :edition_id,
        f.total_surveys,
        f.total_responses,
        (total_responses - invalid_responses - erase_responses) as \'valid\',
        count(s.id) as num_schools
    from :survey_table as f
    inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
    inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
    inner join school as s on s.city_id = dra.city_id and s.state_id = dra.state_id and s.edition_id = :edition_id
    where f.question_id = :survey_question and school_id = 0 and dra.city_id != 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
    group by dra.city_id;';


SET @queryCities = REPLACE(@queryCities, ':survey_id', _survey_id);
SET @queryCities = REPLACE(@queryCities, ':survey_table', _survey_table);
SET @queryCities = REPLACE(@queryCities, ':survey_question', _survey_question);
SET @queryCities = REPLACE(@queryCities, ':edition_id', _edition_id);

INSERT INTO log (message) VALUES (@queryCities);
prepare stmtCities FROM @queryCities;
EXECUTE stmtCities;

SET @queryStates = '
    insert into representativeness_surveys
    select
        dim_regional_aggregation_id,
        dim_politic_aggregation_id,
        :survey_id,
        dpa.dependence_id,
        :edition_id,
        f.total_surveys,
        f.total_responses,
        (total_responses - invalid_responses - erase_responses) as \'valid\',
        count(s.id)
    from :survey_table as f
    inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
    inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
    inner join school as s on s.state_id = dra.state_id and s.edition_id = :edition_id
    inner join waitress_entities.state as st on dra.state_id = st.id
    where f.question_id = :survey_question and dra.state_id not in (0, 100) and dra.city_id = 0 and city_group_id = 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
    group by dra.state_id;
    ';


SET @queryStates = REPLACE(@queryStates, ':survey_id', _survey_id);
SET @queryStates = REPLACE(@queryStates, ':survey_table', _survey_table);
SET @queryStates = REPLACE(@queryStates, ':survey_question', _survey_question);
SET @queryStates = REPLACE(@queryStates, ':edition_id', _edition_id);

INSERT INTO log (message) VALUES (@queryStates);
prepare stmtStates FROM @queryStates;
EXECUTE stmtStates;

SET @queryBrasil = '
    insert into representativeness_surveys
    select
        dim_regional_aggregation_id,
        dim_politic_aggregation_id,
        :survey_id,
        dpa.dependence_id,
        :edition_id,
        f.total_surveys,
        f.total_responses,
        (total_responses - invalid_responses - erase_responses) as \'valid\',
        count(s.id)
    from :survey_table as f
    inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
    inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
    inner join school as s on s.edition_id = :edition_id
    where f.question_id = :survey_question and dra.state_id = 100 and dra.city_id = 0 and city_group_id = 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
    group by dpa.edition_id;';

SET @queryBrasil = REPLACE(@queryBrasil, ':survey_id', _survey_id);
SET @queryBrasil = REPLACE(@queryBrasil, ':survey_table', _survey_table);
SET @queryBrasil = REPLACE(@queryBrasil, ':survey_question', _survey_question);
SET @queryBrasil = REPLACE(@queryBrasil, ':edition_id', _edition_id);

INSERT INTO log3 (message) VALUES (@queryBrasil);
prepare stmtBrasil FROM @queryBrasil;
EXECUTE stmtBrasil;


END LOOP;

CLOSE opcoes;

END ;;