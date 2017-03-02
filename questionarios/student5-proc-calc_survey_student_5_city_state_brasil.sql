DELIMITER ;;
CREATE PROCEDURE `calc_survey_student_5_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);
  DECLARE opcoes CURSOR FOR
        SELECT region.name AS aggregation, dependence.name AS dependence, column_name AS 'column'
            FROM (SELECT 'city' AS name UNION SELECT 'state' UNION SELECT 'brasil') AS region
            INNER JOIN ( SELECT 'all' AS name UNION SELECT 'grouped' ) AS dependence
            INNER JOIN information_schema.columns
         WHERE table_name='survey_students_responses_2015_5ano' AND column_name LIKE 'TX_RESP_Q%';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP

    FETCH opcoes INTO _aggregation, _dependence, _coluna;

    IF done THEN
      LEAVE loop_leitura;
    END IF;

    SET _num = SUBSTRING(_coluna,10);

    SET @queryQ = '
        INSERT INTO fact_question_students_5
        SELECT
          getDimRegionalAggregation(:filter_dim_regional_aggregation) AS dim_regional_aggregation,
          getDimPoliticAggregation(6, :filter_dependence, 0, 0, 0) AS dim_politic_aggregation,
          q.id AS question_id,
          COUNT(*) AS total_surveys,
          SUM(is_filled) AS total_responses,
          SUN(if(is_filled, :column = \'.\', 0)) AS invalid,
          SUM(:column = \'*\') AS erase,
          0 AS sampling_error
        FROM survey_students_responses_2015_5ano AS sdr
           INNER JOIN question AS q on q.order = :num AND q.survey_id = 4 AND q.edition_id = 6
            :has_group_by :group_by_dependence :group_by_aggregation;';

    SET @queryA = '
        INSERT INTO fact_alternative_students_5
        SELECT
          getDimRegionalAggregation(:filter_dim_regional_aggregation) AS dim_regional_aggregation,
          getDimPoliticAggregation(6, :filter_dependence, 0, 0, 0) AS dim_politic_aggregation,
          a.id,
          COUNT(*) AS responses,
          4 AS survey_id
        FROM survey_students_responses_2015_5ano AS sdr
           INNER JOIN question AS q on q.order = :num AND q.survey_id = 4 AND q.edition_id = 6
           INNER JOIN alternative AS a on a.question_id = q.id AND a.alternative = :column
        WHERE :column != \'.\' AND :column != \'*\' AND is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;';

    IF _dependence = 'grouped' THEN
        IF _aggregation = 'brasil' THEN
            SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
        ELSE
            SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
        END if;
        SET @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

        SET @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
        SET @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');
    ELSEIF _dependence = 'all' THEN
        SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
        SET @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

        SET @queryA = REPLACE(@queryA, ':group_by_dependence', '');
        SET @queryA = REPLACE(@queryA, ':filter_dependence', '0');
    END if;

    IF _aggregation = 'city' THEN
        SET @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
        SET @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');
        SET @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

        SET @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
        SET @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');


    ELSEIF _aggregation = 'state' THEN
        SET @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
        SET @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
        SET @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

        SET @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
        SET @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

    ELSEIF _aggregation = 'brasil' THEN
        SET @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
        SET @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
        IF _dependence = 'grouped' THEN
            SET @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
        ELSE
            SET @queryQ = REPLACE(@queryQ, ':has_group_by', '');
        END if;

        SET @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
        SET @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
    END if;

    SET @queryQ = REPLACE(@queryQ, ':column', _coluna);
    SET @queryQ = REPLACE(@queryQ, ':num', _num);

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