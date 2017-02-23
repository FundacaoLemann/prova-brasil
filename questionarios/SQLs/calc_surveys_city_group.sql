DELIMITER ;;
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
        SELECT
            dependence.name AS 'dependence',
            grade.name AS 'grade',
            column_name AS 'column',
            fact_question,
            fact_alternative,
            origin_table,
            survey_id
            FROM ( SELECT 'all' AS name UNION SELECT 'grouped' ) AS dependence
            INNER JOIN (
                SELECT 'fact_question_director' AS fact_question, 'fact_alternative_director' AS fact_alternative, 1 AS survey_id, 'survey_director_responses_2011' AS origin_table
                UNION SELECT 'fact_question_teacher', 'fact_alternative_teacher' , 2, 'survey_teacher_responses_2011'
                UNION SELECT 'fact_question_students_5', 'fact_alternative_students_5' , 4, 'survey_students_responses_2011_5ano'
                UNION SELECT 'fact_question_students_9', 'fact_alternative_students_9' , 5, 'survey_students_responses_2011_9ano'
            ) AS tables
            LEFT JOIN ( SELECT 'all' AS name UNION SELECT 'grouped' ) AS grade ON tables.survey_id = 2
            INNER JOIN information_schema.columns
         WHERE table_name=tables.origin_table AND column_name LIKE 'Q%';


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP

    FETCH opcoes INTO _dependence, _grade, _coluna, _fact_question, _fact_alternative, _origin_table, _survey_id;

    IF done THEN
      LEAVE loop_leitura;
    END IF;

    SET _num = SUBSTRING(_coluna,3);

    SET @queryQ = '
        insert into :fact_question
        SELECT
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) AS dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) AS dim_politic_aggregation,
          q.id AS question_id,
          count(*) AS total_surveys,
           sum( is_filled ) AS total_responses,
          sum( if(is_filled, :column = \'.\', 0)) AS invalid,
          sum( :column = \'*\') AS erASe,
          0 AS sampling_error
        FROM waitress_dw_prova_brasil_2011.:origin_table AS sdr
           INNER JOIN question AS q ON q.order = :num AND q.survey_id = :survey_id AND q.edition_id = 4
            INNER JOIN waitress_entities.city_in_group AS cig ON cig.city_id = sdr.city_id AND cig.city_group_id = :cg_id
            INNER JOIN waitress_entities.city_group AS cg ON cig.city_group_id = cg.id AND cg.id = :cg_id
           group by cg.id :group_by_dependence :group_by_grade;
';

    SET @queryA = '
        insert into :fact_alternative
        SELECT
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) AS dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) AS dim_politic_aggregation,
          a.id,
          count(*) AS responses,
          :survey_id AS survey_id
        FROM waitress_dw_prova_brasil_2011.:origin_table AS sdr
           INNER JOIN question AS q ON q.order = :num AND q.survey_id = :survey_id AND q.edition_id = 4
           INNER JOIN alternative AS a ON a.question_id = q.id AND a.alternative = :column
            INNER JOIN waitress_entities.city_in_group AS cig ON cig.city_id = sdr.city_id AND cig.city_group_id = :cg_id
            INNER JOIN waitress_entities.city_group AS cg ON cig.city_group_id = cg.id AND cg.id = :cg_id
        WHERE :column != \'.\' AND :column != \'*\' AND is_filled = 1
        group by cg.id, :group_by_dependence :group_by_grade :column;
    ';


    if _dependence = 'grouped' THEN

        SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
        SET @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

        SET @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
        SET @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');


    elseif _dependence = 'all' THEN
        SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
        SET @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

        SET @queryA = REPLACE(@queryA, ':group_by_dependence', '');
        SET @queryA = REPLACE(@queryA, ':filter_dependence', '0');

    END if;



    if _grade = 'grouped' THEN
        SET @queryQ = REPLACE(@queryQ, ':group_by_grade', ',sdr.grade_id');
        SET @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

        SET @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
        SET @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');


    elseif _grade = 'all' or _grade is NULL THEN
        SET @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
        SET @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

        SET @queryA = REPLACE(@queryA, ':group_by_grade', '');
        SET @queryA = REPLACE(@queryA, ':filter_grade', '0');

    END if;

    SET @queryQ = REPLACE(@queryQ, ':cg_id', cg_id);
    SET @queryQ = REPLACE(@queryQ, ':fact_question', _fact_question);
    SET @queryQ = REPLACE(@queryQ, ':origin_table', _origin_table);
    SET @queryQ = REPLACE(@queryQ, ':survey_id', _survey_id);
    SET @queryQ = REPLACE(@queryQ, ':column', _coluna);
    SET @queryQ = REPLACE(@queryQ, ':num', _num);

    SET @queryA = REPLACE(@queryA, ':cg_id', cg_id);
    SET @queryA = REPLACE(@queryA, ':fact_alternative', _fact_alternative);
    SET @queryA = REPLACE(@queryA, ':origin_table', _origin_table);
    SET @queryA = REPLACE(@queryA, ':survey_id', _survey_id);
    SET @queryA = REPLACE(@queryA, ':column', _coluna);
    SET @queryA = REPLACE(@queryA, ':num', _num);

    INSERT INTO log (message) VALUES (@queryQ);
    prepare stmt1 FROM @queryQ;
    EXECUTE stmt1;

    INSERT INTO log (message) VALUES (@queryA);
    prepare stmt2 FROM @queryA;
    EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;

END ;;