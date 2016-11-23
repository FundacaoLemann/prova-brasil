START TRANSACTION;
-- No Masked
INSERT INTO fact_proficiency_new
  -- Cidade
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
  provabrasil_2013.aggregation_students AS s
  INNER JOIN
    provabrasil_2013.aggregation_tmp AS t
  ON
    t.dependence_id=s.dependence_id AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=s.localization_id AND t.state_id=s.state_id AND t.city_id=s.city_id AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

INSERT INTO fact_proficiency_new
 -- Cidade (Localizacao=Todas)
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
  provabrasil_2013.aggregation_students AS s
  INNER JOIN
    provabrasil_2013.aggregation_tmp AS t
  ON
    t.dependence_id=s.dependence_id AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=0 AND t.state_id=s.state_id AND t.city_id=s.city_id AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

INSERT INTO fact_proficiency_new
 -- Cidade (Dependencia=Todas)
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
  provabrasil_2013.aggregation_students AS s
  INNER JOIN
    provabrasil_2013.aggregation_tmp AS t
  ON
    t.dependence_id=0 AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=s.localization_id AND t.state_id=s.state_id AND t.city_id=s.city_id AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0 AND s.dependence_id<>4 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

INSERT INTO fact_proficiency_new
 -- Cidade (Localizacao=Todas, Dependencia=Todas)
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
  provabrasil_2013.aggregation_students AS s
  INNER JOIN
    provabrasil_2013.aggregation_tmp AS t
  ON
    t.dependence_id=0 AND t.discipline_id=s.discipline_id AND t.grade_id=s.grade_id AND t.localization_id=0 AND t.state_id=s.state_id AND t.city_id=s.city_id AND t.school_id=0
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=0 AND s.dependence_id<>4 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;

-- Masked

INSERT INTO fact_proficiency_new
  -- Cidade
  SELECT
    t.dim_regional_aggregation as `dim_regional_aggregation_id`,
    t.dim_politic_aggregation as `dim_politic_aggregation_id`,
    t.state_id as `partition_state_id`,
    100 AS `enrolled`, -- enrolled, will be calculate
    100 AS `presents`, -- presents
    100 as `with_proficiency`,
    100 as `with_proficiency_weight`,

    ROUND(t.average, 2)  as `average`,
    t.level_quantitative as `level_quantitative`,
    t.level_qualitative as `level_qualitative`,

    -- alunos no nivel adequado/avançado (2, 3)
    ROUND(IF(
      t.grade_id=5,
      IF(
          t.discipline_id=1,
          r.distribuicao_5ef_LP_nivel_5+r.distribuicao_5ef_LP_nivel_4+r.distribuicao_5ef_LP_nivel_6+r.distribuicao_5ef_LP_nivel_9+r.distribuicao_5ef_LP_nivel_8+r.distribuicao_5ef_LP_nivel_7,
          r.distribuicao_5ef_MT_nivel_5+r.distribuicao_5ef_MT_nivel_6+r.distribuicao_5ef_MT_nivel_10+r.distribuicao_5ef_MT_nivel_9+r.distribuicao_5ef_MT_nivel_8+r.distribuicao_5ef_MT_nivel_7
        ),
      IF(
          t.discipline_id=1,
          r.distribuicao_9ef_LP_nivel_5+r.distribuicao_9ef_LP_nivel_4+r.distribuicao_9ef_LP_nivel_6+r.distribuicao_9ef_LP_nivel_7+r.distribuicao_9ef_LP_nivel_8,
          r.distribuicao_9ef_MT_nivel_5+r.distribuicao_9ef_MT_nivel_6+r.distribuicao_9ef_MT_nivel_8+r.distribuicao_9ef_MT_nivel_7+r.distribuicao_9ef_MT_nivel_9
        )
    ), 2) AS `level_optimal`,

    -- niveis qualitativos absolutos
    ROUND(IF(
      t.grade_id=5,
      IF(
          t.discipline_id=1,
          r.distribuicao_5ef_LP_ate_nivel_1, 
          r.distribuicao_5ef_MT_nivel_2+r.distribuicao_5ef_MT_nivel_1+r.distribuicao_5ef_MT_abaixo_nivel_1
        ),
      IF(
          t.discipline_id=1,
          r.distribuicao_9ef_LP_abaixo_nivel_1,
          r.distribuicao_9ef_MT_nivel_1+r.distribuicao_9ef_MT_abaixo_nivel_1
        )
    ), 2) AS `qualitative_0`,
    ROUND(IF(
      t.grade_id=5,
      IF(
          t.discipline_id=1,
          r.distribuicao_5ef_LP_nivel_2+r.distribuicao_5ef_LP_nivel_3,
          r.distribuicao_5ef_MT_nivel_3+r.distribuicao_5ef_MT_nivel_4
        ),
      IF(
          t.discipline_id=1,
          r.distribuicao_9ef_LP_nivel_3+r.distribuicao_9ef_LP_nivel_2+r.distribuicao_9ef_LP_nivel_1,
          r.distribuicao_9ef_MT_nivel_2+r.distribuicao_9ef_MT_nivel_3+r.distribuicao_9ef_MT_nivel_4
        )
    ), 2) AS `qualitative_1`,
    ROUND(IF(
      t.grade_id=5,
      IF(
          t.discipline_id=1,
          r.distribuicao_5ef_LP_nivel_5+r.distribuicao_5ef_LP_nivel_4,
          r.distribuicao_5ef_MT_nivel_5+r.distribuicao_5ef_MT_nivel_6
        ),
      IF(
          t.discipline_id=1,
          r.distribuicao_9ef_LP_nivel_5+r.distribuicao_9ef_LP_nivel_4,
          r.distribuicao_9ef_MT_nivel_5+r.distribuicao_9ef_MT_nivel_6
        )
    ), 2) AS `qualitative_2`,
    ROUND(IF(
      t.grade_id=5,
      IF(
          t.discipline_id=1,
          r.distribuicao_5ef_LP_nivel_6+r.distribuicao_5ef_LP_nivel_9+r.distribuicao_5ef_LP_nivel_8+r.distribuicao_5ef_LP_nivel_7,
          r.distribuicao_5ef_MT_nivel_10+r.distribuicao_5ef_MT_nivel_9+r.distribuicao_5ef_MT_nivel_8+r.distribuicao_5ef_MT_nivel_7
        ),
      IF(
          t.discipline_id=1,
          r.distribuicao_9ef_LP_nivel_6+r.distribuicao_9ef_LP_nivel_7+r.distribuicao_9ef_LP_nivel_8,
          r.distribuicao_9ef_MT_nivel_8+r.distribuicao_9ef_MT_nivel_7+r.distribuicao_9ef_MT_nivel_9
        )
    ), 2) AS `qualitative_3`,

    4 AS disclosure 
  FROM 
    provabrasil_2013.aggregation_tmp AS t
  INNER JOIN 
    provabrasil_2013.resultados_municipios AS r 
  ON
    r.dependence_id = t.dependence_id
                AND r.localization_id = t.localization_id
                AND r.ibge_id = t.ID_MUNICIPIO 
  WHERE t.masked=0 AND t.needs_to_be_from_sheet=1 
  GROUP BY t.dim_regional_aggregation, t.dim_politic_aggregation;
  COMMIT;