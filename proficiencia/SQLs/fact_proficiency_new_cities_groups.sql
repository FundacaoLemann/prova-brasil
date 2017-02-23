START TRANSACTION;
INSERT INTO fact_proficiency_new
  -- Grupo de cidades
  SELECT
    t.dim_regional_aggregation as `dim_regional_aggregation_id`,
    t.dim_politic_aggregation as `dim_politic_aggregation_id`,
    t.state_id as `partition_state_id`,
    t.enrolled AS `enrolled`, -- enrolled, will be calculate
    t.presents AS `presents`, -- presents
    count(*) as `with_proficiency`,
    ROUND(SUM(s.weight), 2) as `with_proficiency_weight`,

    ROUND(t.average, 2)  as `average`,
    t.level_quantitative as `level_quantitative`,
    t.level_qualitative as `level_qualitative`,

    -- alunos no nivel adequado/avançado (2, 3)
    ROUND(SUM( IF(s.level_qualitative > 1,  s.weight, 0)), 2) AS `level_optimal`,

    -- niveis qualitativos absolutos
    ROUND(SUM( IF(s.level_qualitative = 0,  s.weight , 0)), 2) AS `qualitative_0`,
    ROUND(SUM( IF(s.level_qualitative = 1,  s.weight , 0)), 2) AS `qualitative_1`,
    ROUND(SUM( IF(s.level_qualitative = 2,  s.weight , 0)), 2) AS `qualitative_2`,
    ROUND(SUM( IF(s.level_qualitative = 3,  s.weight , 0)), 2) AS `qualitative_3`,

    1 AS disclosure 
  FROM
  provabrasil_2015.aggregation_students AS s
  INNER JOIN
    provabrasil_2015.aggregation_tmp AS t
  ON
    t.dependence_id=s.dependence_id AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=s.localization_id AND t.state_id=s.state_id AND t.city_group_id IN (SELECT city_group_id FROM waitress_entities.city_in_group AS cg WHERE cg.city_id=s.city_id) AND t.city_id=0 AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

INSERT INTO fact_proficiency_new
 -- Grupo de cidades (Localizacao=Todas)
  SELECT
    t.dim_regional_aggregation as `dim_regional_aggregation_id`,
    t.dim_politic_aggregation as `dim_politic_aggregation_id`,
    t.state_id as `partition_state_id`,
    t.enrolled AS `enrolled`, -- enrolled, will be calculate
    t.presents AS `presents`, -- presents
    count(*) as `with_proficiency`,
    ROUND(SUM(s.weight), 2) as `with_proficiency_weight`,

    ROUND(t.average, 2)  as `average`,
    t.level_quantitative as `level_quantitative`,
    t.level_qualitative as `level_qualitative`,

    -- alunos no nivel adequado/avançado (2, 3)
    ROUND(SUM( IF(s.level_qualitative > 1,  s.weight, 0)), 2) AS `level_optimal`,

    -- niveis qualitativos absolutos
    ROUND(SUM( IF(s.level_qualitative = 0,  s.weight , 0)), 2) AS `qualitative_0`,
    ROUND(SUM( IF(s.level_qualitative = 1,  s.weight , 0)), 2) AS `qualitative_1`,
    ROUND(SUM( IF(s.level_qualitative = 2,  s.weight , 0)), 2) AS `qualitative_2`,
    ROUND(SUM( IF(s.level_qualitative = 3,  s.weight , 0)), 2) AS `qualitative_3`,

    1 AS disclosure 
  FROM
  provabrasil_2015.aggregation_students AS s
  INNER JOIN
    provabrasil_2015.aggregation_tmp AS t
  ON
    t.dependence_id=s.dependence_id AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=0 AND t.state_id=s.state_id AND t.city_group_id IN (SELECT city_group_id FROM waitress_entities.city_in_group AS cg WHERE cg.city_id=s.city_id) AND t.city_id=0 AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

INSERT INTO fact_proficiency_new
 -- Grupo de cidades (Dependencia=Todas)
  SELECT
    t.dim_regional_aggregation as `dim_regional_aggregation_id`,
    t.dim_politic_aggregation as `dim_politic_aggregation_id`,
    t.state_id as `partition_state_id`,
    t.enrolled AS `enrolled`, -- enrolled, will be calculate
    t.presents AS `presents`, -- presents
    count(*) as `with_proficiency`,
    ROUND(SUM(s.weight), 2) as `with_proficiency_weight`,

    ROUND(t.average, 2)  as `average`,
    t.level_quantitative as `level_quantitative`,
    t.level_qualitative as `level_qualitative`,

    -- alunos no nivel adequado/avançado (2, 3)
    ROUND(SUM( IF(s.level_qualitative > 1,  s.weight, 0)), 2) AS `level_optimal`,

    -- niveis qualitativos absolutos
    ROUND(SUM( IF(s.level_qualitative = 0,  s.weight , 0)), 2) AS `qualitative_0`,
    ROUND(SUM( IF(s.level_qualitative = 1,  s.weight , 0)), 2) AS `qualitative_1`,
    ROUND(SUM( IF(s.level_qualitative = 2,  s.weight , 0)), 2) AS `qualitative_2`,
    ROUND(SUM( IF(s.level_qualitative = 3,  s.weight , 0)), 2) AS `qualitative_3`,

    1 AS disclosure 
  FROM
  provabrasil_2015.aggregation_students AS s
  INNER JOIN
    provabrasil_2015.aggregation_tmp AS t
  ON
    t.dependence_id=0 AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=s.localization_id AND t.state_id=s.state_id AND t.city_group_id IN (SELECT city_group_id FROM waitress_entities.city_in_group AS cg WHERE cg.city_id=s.city_id) AND t.city_id=0 AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0 AND s.dependence_id<>4 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

INSERT INTO fact_proficiency_new
 -- Grupo de cidades (Localizacao=Todas, Dependencia=Todas)
  SELECT
    t.dim_regional_aggregation as `dim_regional_aggregation_id`,
    t.dim_politic_aggregation as `dim_politic_aggregation_id`,
    t.state_id as `partition_state_id`,
    t.enrolled AS `enrolled`, -- enrolled, will be calculate
    t.presents AS `presents`, -- presents
    count(*) as `with_proficiency`,
    ROUND(SUM(s.weight), 2) as `with_proficiency_weight`,

    ROUND(t.average, 2)  as `average`,
    t.level_quantitative as `level_quantitative`,
    t.level_qualitative as `level_qualitative`,

    -- alunos no nivel adequado/avançado (2, 3)
    ROUND(SUM( IF(s.level_qualitative > 1,  s.weight, 0)), 2) AS `level_optimal`,

    -- niveis qualitativos absolutos
    ROUND(SUM( IF(s.level_qualitative = 0,  s.weight , 0)), 2) AS `qualitative_0`,
    ROUND(SUM( IF(s.level_qualitative = 1,  s.weight , 0)), 2) AS `qualitative_1`,
    ROUND(SUM( IF(s.level_qualitative = 2,  s.weight , 0)), 2) AS `qualitative_2`,
    ROUND(SUM( IF(s.level_qualitative = 3,  s.weight , 0)), 2) AS `qualitative_3`,

    1 AS disclosure 
  FROM
  provabrasil_2015.aggregation_students AS s
  INNER JOIN
    provabrasil_2015.aggregation_tmp AS t
  ON
    t.dependence_id=0 AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=0 AND t.state_id=s.state_id AND t.city_group_id IN (SELECT city_group_id FROM waitress_entities.city_in_group AS cg WHERE cg.city_id=s.city_id) AND t.city_id=0 AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0 AND s.dependence_id<>4 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;
  COMMIT;