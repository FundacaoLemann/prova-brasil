DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_teacher_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);
  DECLARE _grade VARCHAR(40);
  DECLARE _depENDence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);
  DECLARE opcoes CURSOR FOR
        SELECT region.name AS aggregation, depENDence.name AS depENDence, grade.name AS grade, column_name AS 'column'
            FROM (SELECT 'city' AS name UNION SELECT 'state' UNION SELECT 'brasil') AS region
            INNER JOIN ( SELECT 'all' AS name UNION SELECT 'grouped' ) AS depENDence
            INNER JOIN ( SELECT 'all' AS name UNION SELECT 'grouped' ) AS grade
            INNER JOIN information_schema.columns
         WHERE table_name='survey_teacher_responses_2011' AND column_name LIKE 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP

    FETCH opcoes INTO _aggregation, _depENDence, _grade, _coluna;

    IF done THEN
      LEAVE loop_leitura;
    END IF;

    SET _num = SUBSTRING(_coluna,3);

    SET @queryQ = '
        INSERT INTO fact_question_teacher
        SELECT
          getDimRegionalAggregation(:filter_dim_regional_aggregation) AS dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_depENDence, 0, :filter_grade, 0) AS dim_politic_aggregation,
          q.id AS question_id,
          COUNT(*) AS total_surveys,
          SUM( is_filled ) AS total_responses,
          SUM( IF(is_filled, :column = \'.\', 0)) AS invalid,
          SUM( :column = \'*\') AS erase,
          0 AS sampling_error,
          NULL
        FROM survey_teacher_responses_2011 AS sdr
           INNER JOIN question AS q on q.order = :num AND q.survey_id = 2 AND q.edition_id = 4
            :has_group_by :group_by_depENDence :group_by_grade :group_by_aggregation ;';

    SET @queryA = '
        INSERT INTO fact_alternative_teacher
        SELECT
          getDimRegionalAggregation(:filter_dim_regional_aggregation) AS dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_depENDence, 0, :filter_grade, 0) AS dim_politic_aggregation,
          a.id,
          COUNT(*) AS responses,
          2 AS survey_id
        FROM survey_teacher_responses_2011 AS sdr
           INNER JOIN question AS q on q.order = :num AND q.survey_id = 2 AND q.edition_id = 4
           INNER JOIN alternative AS a on a.question_id = q.id AND a.alternative = :column
        WHERE :column != \'.\' AND :column != \'*\' AND is_filled = 1
        GROUP BY :group_by_depENDence :group_by_grade :group_by_aggregation :column;

    ';



    IF _depENDence = 'grouped' THEN
        IF _aggregation = 'brasil' AND _grade = 'all' THEN
            SET @queryQ = REPLACE(@queryQ, ':group_by_depENDence', 'sdr.depENDence_id');
        ELSE
            SET @queryQ = REPLACE(@queryQ, ':group_by_depENDence', 'sdr.depENDence_id,');
        END IF;
        SET @queryQ = REPLACE(@queryQ, ':filter_depENDence', 'sdr.depENDence_id');

        SET @queryA = REPLACE(@queryA, ':group_by_depENDence', 'sdr.depENDence_id,');
        SET @queryA = REPLACE(@queryA, ':filter_depENDence', 'sdr.depENDence_id');
    ELSEIF _depENDence = 'all' THEN
        SET @queryQ = REPLACE(@queryQ, ':group_by_depENDence', '');
        SET @queryQ = REPLACE(@queryQ, ':filter_depENDence', '0');

        SET @queryA = REPLACE(@queryA, ':group_by_depENDence', '');
        SET @queryA = REPLACE(@queryA, ':filter_depENDence', '0');
    END IF;

    IF _grade = 'grouped' THEN
        IF _aggregation = 'brasil' THEN
            SET @queryQ = REPLACE(@queryQ, ':group_by_grade', 'sdr.grade_id');
        ELSE
            SET @queryQ = REPLACE(@queryQ, ':group_by_grade', 'sdr.grade_id,');
        END IF;
        SET @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

        SET @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
        SET @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');

    ELSEIF _grade = 'all' THEN
        SET @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
        SET @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

        SET @queryA = REPLACE(@queryA, ':group_by_grade', '');
        SET @queryA = REPLACE(@queryA, ':filter_grade', '0');
    END IF;

    IF _aggregation = 'city' THEN
        SET @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
        SET @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');
        SET @queryQ = REPLACE(@queryQ, ':has_group_by', 'GROUP BY ');

        SET @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
        SET @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');

    ELSEIF _aggregation = 'state' THEN
        SET @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
        SET @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
        SET @queryQ = REPLACE(@queryQ, ':has_group_by', 'GROUP BY ');

        SET @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
        SET @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

    ELSEIF _aggregation = 'brasil' THEN
        SET @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
        SET @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
        IF _depENDence = 'grouped' or _grade = 'grouped' THEN
            SET @queryQ = REPLACE(@queryQ, ':has_group_by', 'GROUP BY ');
        ELSE
            SET @queryQ = REPLACE(@queryQ, ':has_group_by', '');
        END IF;

        SET @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
        SET @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
    END IF;

    SET @queryQ = REPLACE(@queryQ, ':column', _coluna);
    SET @queryQ = REPLACE(@queryQ, ':num', _num);

    SET @queryA = REPLACE(@queryA, ':column', _coluna);
    SET @queryA = REPLACE(@queryA, ':num', _num);

    INSERT INTO log4 (message) values (@queryQ);
    prepare stmt1 FROM @queryQ;
    EXECUTE stmt1;

    INSERT INTO log4 (message) values (@queryA);
    prepare stmt2 FROM @queryA;
    EXECUTE stmt2;

  END LOOP;
  CLOSE opcoes;
END ;;