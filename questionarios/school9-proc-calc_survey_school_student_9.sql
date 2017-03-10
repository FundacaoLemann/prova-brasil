DELIMITER ;;
CREATE PROCEDURE `calc_survey_school_student_9`()
BEGIN
  DECLARE coluna varchar(15);
  DECLARE num varchar(3);
  DECLARE colunas_surveys CURSOR FOR SELECT column_name FROM information_schema.columns
    WHERE table_name='survey_students_responses_2015_school_9ano' AND column_name LIKE 'TX_RESP_Q%';

  OPEN colunas_surveys;

  loop_leitura: LOOP

    FETCH colunas_surveys INTO coluna;
    SET num = SUBSTRING(coluna,10);

    SET @query_questions = '
    INSERT INTO fact_question_students_9
      SELECT
      getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) AS dim_regional_aggregation,
      getDimPoliticAggregation(6, dependence_id, localization_id, 0, 0) AS dim_politic_aggregation,
      q.id AS question_id,
      COUNT(*) AS total_surveys,
      SUM(is_filled) AS total_responses,
      SUM(if(is_filled, :column = \'.\', 0)) AS invalid,
      SUM(:column = \'*\') AS erase,
      0 AS sampling_error
      FROM survey_students_responses_2015_school_9ano AS sdr
      INNER JOIN question AS q on q.order = :num AND q.survey_id = 5 AND q.edition_id = 6
      GROUP BY sdr.state_id, sdr.city_id, sdr.school_id, sdr.dependence_id, sdr.localization_id;';

  SET @query_alternatives = '
     INSERT INTO fact_alternative_students_9
        SELECT
          getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) AS dim_regional_aggregation,
          getDimPoliticAggregation(6, dependence_id, localization_id, 0, 0) AS dim_politic_aggregation,
          a.id,
          COUNT(*) AS responses,
          5 AS survey_id
        FROM survey_students_responses_2015_school_9ano AS sdr
           INNER JOIN question AS q on q.order = :num AND q.survey_id = 5 AND q.edition_id = 6
           INNER JOIN alternative AS a on a.question_id = q.id AND a.alternative = :column
        WHERE :column != \'.\' AND :column != \'*\' AND is_filled = 1
        GROUP BY sdr.state_id, sdr.city_id, sdr.school_id, :column, dependence_id, sdr.localization_id;';


  SET @query_questions = REPLACE(@query_questions, ':column', coluna);
  SET @query_questions = REPLACE(@query_questions, ':num', num);

  SET @query_alternatives = REPLACE(@query_alternatives, ':column', coluna);
  SET @query_alternatives = REPLACE(@query_alternatives, ':num', num);

  INSERT INTO log (message) VALUES (@query_questions);
  prepare stmt1 FROM @query_questions;
  EXECUTE stmt1;

  INSERT INTO log (message) VALUES (@query_alternatives);
  prepare stmt2 FROM @query_alternatives;
  EXECUTE stmt2;

  END LOOP;

  CLOSE colunas_surveys;

END ;;