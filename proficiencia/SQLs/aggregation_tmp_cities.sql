START TRANSACTION;
INSERT INTO aggregation_tmp
	-- Cidade 
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(a.state_id, a.city_id, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(6, a.dependence_id, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 a.city_id AS city_id,
	 0 AS school_id,
	 a.ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 a.masked AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
	GROUP BY  a.ID_MUNICIPIO, a.localization_id, a.dependence_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Cidade (Localizacao=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(a.state_id, a.city_id, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(6, a.dependence_id, 0, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 0 AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 a.city_id AS city_id,
	 0 AS school_id,
	 a.ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 a.masked AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
	GROUP BY  a.ID_MUNICIPIO, a.dependence_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Cidade (Dependencia=Todas) 
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(a.state_id, a.city_id, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(6, 0, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 0 AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 a.city_id AS city_id,
	 0 AS school_id,
	 a.ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 a.masked AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
    WHERE a.dependence_id<>4
	GROUP BY  a.ID_MUNICIPIO, a.localization_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Cidade (Localizacao=Todas, Dependencia=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(a.state_id, a.city_id, 0, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(6, 0, 0, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 0 AS dependence_id,
	 0 AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 a.city_id AS city_id,
	 0 AS school_id,
	 a.ID_MUNICIPIO,
	 0 AS ID_ESCOLA_ALUNO,
	 a.masked AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
    WHERE a.dependence_id<>4
	GROUP BY  a.ID_MUNICIPIO, a.grade_id, a.discipline_id;

-- Cidades
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.ID_DEPENDENCIA_ADM=a.dependence_id AND e.ID_LOCALIZACAO=a.localization_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.dependence_id=a.dependence_id AND e.localization_id=a.localization_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.ID_DEPENDENCIA_ADM=a.dependence_id AND e.ID_LOCALIZACAO=a.localization_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO<>0 AND a.state_id<>0 AND a.localization_id<>0 AND a.dependence_id<>0;

-- Cidades (Localizacao=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.ID_DEPENDENCIA_ADM=a.dependence_id),
   	enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.dependence_id=a.dependence_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.ID_DEPENDENCIA_ADM=a.dependence_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO<>0 AND a.state_id<>0 AND a.localization_id=0 AND a.dependence_id<>0;

-- Cidades (Dependencia=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.ID_LOCALIZACAO=a.localization_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.localization_id=a.localization_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.ID_LOCALIZACAO=a.localization_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO<>0 AND a.state_id<>0 AND a.localization_id<>0 AND a.dependence_id=0;

-- Cidades (Localizacao=Todas, Dependencia=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO=a.ID_MUNICIPIO),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO<>0 AND a.state_id<>0 AND a.localization_id=0 AND a.dependence_id=0;

UPDATE aggregation_tmp AS a 
SET 
    needs_to_be_from_sheet=1
WHERE
    a.ID_ESCOLA_ALUNO = 0
        AND a.ID_MUNICIPIO <> 0
        AND ROUND(a.average, 2) <> (SELECT 
            IF(a.grade_id = 5,
                    IF(a.discipline_id = 1,
                        r.media_5EF_LP,
                        r.media_5EF_MT),
                    IF(a.discipline_id = 1,
                        r.media_9EF_LP,
                        r.media_9EF_MT)) AS media
        FROM
            resultados_municipios AS r
        WHERE
            r.dependence_id = a.dependence_id
                AND r.localization_id = a.localization_id
                AND r.ibge_id = a.ID_MUNICIPIO
        )
    AND (SELECT 
        IF(a.grade_id = 5,
                IF(a.discipline_id = 1,
                    r.media_5EF_LP,
                    r.media_5EF_MT),
                IF(a.discipline_id = 1,
                    r.media_9EF_LP,
                    r.media_9EF_MT)) AS media
    FROM
        resultados_municipios AS r
    WHERE
        r.dependence_id = a.dependence_id
            AND r.localization_id = a.localization_id
            AND r.ibge_id = a.ID_MUNICIPIO) IS NOT NULL;
COMMIT;