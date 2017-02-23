DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_director_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);
  DECLARE opcoes CURSOR FOR
        select region.name as aggregation, dependence.name as dependence, column_name as 'column'
            from (select 'city' as name union select 'state' union select 'brasil') as region
            inner join ( select 'all' as name union select 'grouped' ) as dependence
            inner join information_schema.columns
         where table_name='survey_director_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;
  loop_leitura: LOOP

    FETCH opcoes INTO _aggregation, _dependence, _coluna;

    IF done THEN
      LEAVE loop_leitura;
    END IF;

    SET _num = SUBSTRING(_coluna,3);

    SET @queryQ = '
        insert into fact_question_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
          sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
          NULL
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
           :has_group_by :group_by_dependence :group_by_aggregation ;';

    SET @queryA = '
        insert into fact_alternative_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          1 as survey_id
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;';



    IF _dependence = 'grouped' THEN
        IF _aggregation = 'brasil' THEN
            SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
        ELSE
            SET @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
        ENF IF;
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


    elseif _aggregation = 'state' THEN
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

    INSERT INTO log3 (message) VALUES (@queryQ);
    prepare stmt1 FROM @queryQ;
    EXECUTE stmt1;

    INSERT INTO log3 (message) VALUES (@queryA);
    prepare stmt2 FROM @queryA;
    EXECUTE stmt2;

  END LOOP;
  CLOSE opcoes;
END ;;