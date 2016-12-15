START TRANSACTION;
INSERT INTO aggregation_tmp
	-- Pais
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(100, 0, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, a.dependence_id, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 100 AS state_id,
	 0 AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 0 AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
	GROUP BY a.localization_id, a.dependence_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Pais (Localizacao=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(100, 0, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, a.dependence_id, 0, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 0 AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 100 AS state_id,
	 0 AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 0 AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
	GROUP BY a.dependence_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Pais (Dependencia=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(100, 0, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, 0, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 0 AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 100 AS state_id,
	 0 AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 0 AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
    WHERE a.dependence_id<>4
	GROUP BY a.localization_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Pais (Localizacao=Todas, Dependencia=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(100, 0, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, 0, 0, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 0 AS dependence_id,
	 0 AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 100 AS state_id,
	 0 AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 0 AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
    WHERE a.dependence_id<>4
	GROUP BY a.grade_id, a.discipline_id;




-- Pais
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_DEPENDENCIA_ADM=a.dependence_id AND e.ID_LOCALIZACAO=a.localization_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.localization_id=a.localization_id AND e.dependence_id=a.dependence_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_DEPENDENCIA_ADM=a.dependence_id AND e.ID_LOCALIZACAO=a.localization_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.state_id=100 AND a.localization_id<>0 AND a.dependence_id<>0;

-- Pais (Localizacao=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_DEPENDENCIA_ADM=a.dependence_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.dependence_id=a.dependence_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_DEPENDENCIA_ADM=a.dependence_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.state_id=100 AND a.localization_id=0 AND a.dependence_id<>0;

-- Pais (Dependencia=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_LOCALIZACAO=a.localization_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.localization_id=a.localization_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_LOCALIZACAO=a.localization_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.state_id=100 AND a.localization_id<>0 AND a.dependence_id=0;

-- Pais (Localizacao=Todas, Dependencia=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.state_id=100 AND a.localization_id=0 AND a.dependence_id=0;
COMMIT;