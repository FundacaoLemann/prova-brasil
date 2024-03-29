DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_school_student_5`()
BEGIN
  DECLARE coluna varchar(5);
  DECLARE num varchar(3);
  DECLARE colunas_surveys CURSOR FOR SELECT column_name FROM information_schema.columns
    WHERE table_name='survey_students_responses_2011_5ano' AND column_name LIKE 'Q%';

  OPEN colunas_surveys;

  loop_leitura: LOOP

    FETCH colunas_surveys INTO coluna;
    SET num = SUBSTRING(coluna,3);

    SET @query_questions = '
    INSERT INTO fact_question_students_5
      SELECT
      getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) AS dim_regional_aggregation,
      getDimPoliticAggregation(4, dependence_id, localization_id, 0, 0) AS dim_politic_aggregation,
      q.id AS question_id,
      COUNT(*) AS total_surveys,
      SUM(is_filled) AS total_responses,
      SUM(if(is_filled, :column = \'.\', 0)) AS invalid,
      SUN(:column = \'*\') AS erase,
      0 AS sampling_error
      FROM survey_students_responses_2011_5ano AS` sdr
      INNER JOIN question AS q ON q.order = :num AND q.survey_id = 4 AND q.edition_id = 4
      GROUP BY sdr.state_id, sdr.city_id, sdr.school_id, sdr.dependence_id, sdr.localization_id;';

  SET @query_alternatives = '
     INSERT INTO fact_alternative_students_5
        SELECT
          getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) AS dim_regional_aggregation,
          getDimPoliticAggregation(4, dependence_id, localization_id, 0, 0) AS dim_politic_aggregation,
          a.id,
          count(*) AS responses,
          4 AS survey_id
        FROM survey_students_responses_2011_5ano AS sdr
           inner join question AS q on q.order = :num AND q.survey_id = 4 AND q.edition_id = 4
           inner join alternative AS a on a.question_id = q.id AND a.alternative = :column
        WHERE :column != \'.\' AND :column != \'*\' AND is_filled = 1
        GROUP BY sdr.state_id, sdr.city_id, sdr.school_id, :column, dependence_id, sdr.localization_id;
  ';


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