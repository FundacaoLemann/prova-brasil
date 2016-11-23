START TRANSACTION;
INSERT INTO aggregation_tmp
	-- Grupo de Cidade 
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregationCityGroup(a.state_id, cg.city_group_id) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, a.dependence_id, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 cg.city_group_id AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
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
	INNER JOIN 
	waitress_entities.city_in_group AS cg ON cg.city_id=a.city_id
	WHERE a.city_id IS NOT NULL 
	GROUP BY  cg.city_group_id, a.localization_id, a.dependence_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Grupo de Cidade (Localizacao=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregationCityGroup(a.state_id, cg.city_group_id) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, a.dependence_id, 0, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 0 AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 cg.city_group_id AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
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
	INNER JOIN 
	waitress_entities.city_in_group AS cg ON cg.city_id=a.city_id
	WHERE a.city_id IS NOT NULL 
	GROUP BY  cg.city_group_id, a.dependence_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Grupo de Cidade (Dependencia=Todas) 
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregationCityGroup(a.state_id, cg.city_group_id) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, 0, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 0 AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 cg.city_group_id AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
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
	INNER JOIN 
	waitress_entities.city_in_group AS cg ON cg.city_id=a.city_id
	WHERE a.city_id IS NOT NULL AND a.dependence_id<>4
	GROUP BY  cg.city_group_id, a.localization_id, a.grade_id, a.discipline_id;
INSERT INTO aggregation_tmp
	-- Grupo de Cidade (Localizacao=Todas, Dependencia=Todas)
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregationCityGroup(a.state_id, cg.city_group_id) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, 0, 0, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 0 AS dependence_id,
	 0 AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 cg.city_group_id AS city_group_id,
	 0 AS city_id,
	 0 AS school_id,
	 0 AS ID_MUNICIPIO,
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
	INNER JOIN 
	waitress_entities.city_in_group AS cg ON cg.city_id=a.city_id
	WHERE a.city_id IS NOT NULL AND a.dependence_id<>4
	GROUP BY  cg.city_group_id, a.grade_id, a.discipline_id;

-- Grupo de Cidades
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.ID_DEPENDENCIA_ADM=a.dependence_id AND e.ID_LOCALIZACAO=a.localization_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.dependence_id=a.dependence_id AND e.localization_id=a.localization_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.ID_DEPENDENCIA_ADM=a.dependence_id AND e.ID_LOCALIZACAO=a.localization_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.city_group_id<>0 AND a.state_id<>0 AND a.localization_id<>0 AND a.dependence_id<>0;

-- Grupo de Cidades (Localizacao=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.ID_DEPENDENCIA_ADM=a.dependence_id),
   	enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.dependence_id=a.dependence_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.ID_DEPENDENCIA_ADM=a.dependence_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.city_group_id<>0 AND a.state_id<>0 AND a.localization_id=0 AND a.dependence_id<>0;

-- Grupo de Cidades (Dependencia=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.ID_LOCALIZACAO=a.localization_id),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.localization_id=a.localization_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.ID_LOCALIZACAO=a.localization_id),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.city_group_id<>0 AND a.state_id<>0 AND a.localization_id<>0 AND a.dependence_id=0;

-- Grupo de Cidades (Localizacao=Todas, Dependencia=Todas)
UPDATE aggregation_tmp AS a SET 
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id)),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id) AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_MUNICIPIO IN (SELECT ibge_id FROM waitress_entities.city AS c INNER JOIN waitress_entities.city_in_group AS cg ON cg.city_id=c.id WHERE cg.city_group_id=a.city_group_id)),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO=0 AND a.city_group_id<>0 AND a.state_id<>0 AND a.localization_id=0 AND a.dependence_id=0;

-- Grupo de Cidades
UPDATE aggregation_tmp AS a 
INNER JOIN 
 (SELECT
        cg.city_group_id,
        s.dependence_id,
        s.localization_id,
        s.grade_id,
        s.discipline_id
        FROM waitress_entities.city_in_group AS cg
        INNER JOIN waitress_entities.city AS c ON c.id=cg.city_id
        INNER JOIN
            (SELECT 
                s.ID_MUNICIPIO,
                    s.dependence_id,
                    s.localization_id,
                    s.grade_id,
                    s.discipline_id,
                    ROUND(SUM(s.proficience * s.weight) / SUM(s.weight), 2) AS average
            FROM
                aggregation_students AS s
            GROUP BY s.ID_MUNICIPIO , s.dependence_id , s.localization_id , s.grade_id , s.discipline_id) 
            AS s ON s.ID_MUNICIPIO = c.ibge_id
        INNER JOIN resultados_municipios AS r 
            ON r.dependence_id = s.dependence_id AND s.localization_id = s.localization_id AND r.ibge_id = c.ibge_id
        WHERE s.average <> IF(s.grade_id = 5,
                IF(s.discipline_id = 1,
                    r.media_5EF_LP,
                    r.media_5EF_MT),
                IF(s.discipline_id = 1,
                    r.media_9EF_LP,
                    r.media_9EF_MT))
        GROUP BY cg.city_group_id, s.dependence_id, s.localization_id, s.grade_id, s.discipline_id)
AS comp 
ON comp.city_group_id=a.city_group_id AND comp.dependence_id=a.dependence_id AND comp.localization_id=a.localization_id AND comp.grade_id=a.grade_id AND comp.discipline_id=a.discipline_id
SET 
    needs_to_be_from_sheet = 1 
WHERE
    a.ID_ESCOLA_ALUNO = 0 AND a.city_id = 0
        AND a.city_group_id <> 0
        AND a.state_id <> 0
        AND a.dependence_id <> 0
        AND a.localization_id <> 0;

-- Grupo de Cidades (dependencia=todas)
UPDATE aggregation_tmp AS a 
INNER JOIN 
 (SELECT
        cg.city_group_id,
        s.dependence_id,
        s.localization_id,
        s.grade_id,
        s.discipline_id
        FROM waitress_entities.city_in_group AS cg
        INNER JOIN waitress_entities.city AS c ON c.id=cg.city_id
        INNER JOIN
            (SELECT 
                s.ID_MUNICIPIO,
                    0 AS dependence_id,
                    s.localization_id,
                    s.grade_id,
                    s.discipline_id,
                    ROUND(SUM(s.proficience * s.weight) / SUM(s.weight), 2) AS average
            FROM
                aggregation_students AS s
            GROUP BY s.ID_MUNICIPIO , s.localization_id , s.grade_id , s.discipline_id) 
            AS s ON s.ID_MUNICIPIO = c.ibge_id
        INNER JOIN resultados_municipios AS r 
            ON r.dependence_id = s.dependence_id AND s.localization_id = s.localization_id AND r.ibge_id = c.ibge_id
        WHERE s.average <> IF(s.grade_id = 5,
                IF(s.discipline_id = 1,
                    r.media_5EF_LP,
                    r.media_5EF_MT),
                IF(s.discipline_id = 1,
                    r.media_9EF_LP,
                    r.media_9EF_MT))
        GROUP BY cg.city_group_id, s.dependence_id, s.localization_id, s.grade_id, s.discipline_id)
AS comp 
ON comp.city_group_id=a.city_group_id AND comp.dependence_id=a.dependence_id AND comp.localization_id=a.localization_id AND comp.grade_id=a.grade_id AND comp.discipline_id=a.discipline_id
SET 
    needs_to_be_from_sheet = 1 
WHERE
    a.ID_ESCOLA_ALUNO = 0 AND a.city_id = 0
        AND a.city_group_id <> 0
        AND a.state_id <> 0
        AND a.dependence_id = 0
        AND a.localization_id <> 0;

-- Grupo de Cidades (localizacao=todas)
UPDATE aggregation_tmp AS a 
INNER JOIN 
 (SELECT
        cg.city_group_id,
        s.dependence_id,
        s.localization_id,
        s.grade_id,
        s.discipline_id
        FROM waitress_entities.city_in_group AS cg
        INNER JOIN waitress_entities.city AS c ON c.id=cg.city_id
        INNER JOIN
            (SELECT 
                s.ID_MUNICIPIO,
                    s.dependence_id,
                    0 AS localization_id,
                    s.grade_id,
                    s.discipline_id,
                    ROUND(SUM(s.proficience * s.weight) / SUM(s.weight), 2) AS average
            FROM
                aggregation_students AS s
            GROUP BY s.ID_MUNICIPIO , s.dependence_id , s.grade_id , s.discipline_id) 
            AS s ON s.ID_MUNICIPIO = c.ibge_id
        INNER JOIN resultados_municipios AS r 
            ON r.dependence_id = s.dependence_id AND s.localization_id = s.localization_id AND r.ibge_id = c.ibge_id
        WHERE s.average <> IF(s.grade_id = 5,
                IF(s.discipline_id = 1,
                    r.media_5EF_LP,
                    r.media_5EF_MT),
                IF(s.discipline_id = 1,
                    r.media_9EF_LP,
                    r.media_9EF_MT))
        GROUP BY cg.city_group_id, s.dependence_id, s.localization_id, s.grade_id, s.discipline_id)
AS comp 
ON comp.city_group_id=a.city_group_id AND comp.dependence_id=a.dependence_id AND comp.localization_id=a.localization_id AND comp.grade_id=a.grade_id AND comp.discipline_id=a.discipline_id
SET 
    needs_to_be_from_sheet = 1 
WHERE
    a.ID_ESCOLA_ALUNO = 0 AND a.city_id = 0
        AND a.city_group_id <> 0
        AND a.state_id <> 0
        AND a.dependence_id <> 0
        AND a.localization_id = 0;

-- Grupo de Cidades (dependencia=todas,localizacao=todas)
UPDATE aggregation_tmp AS a 
INNER JOIN 
 (SELECT
        cg.city_group_id,
        s.dependence_id,
        s.localization_id,
        s.grade_id,
        s.discipline_id
        FROM waitress_entities.city_in_group AS cg
        INNER JOIN waitress_entities.city AS c ON c.id=cg.city_id
        INNER JOIN
            (SELECT 
                s.ID_MUNICIPIO,
                    0 AS dependence_id,
                    0 AS localization_id,
                    s.grade_id,
                    s.discipline_id,
                    ROUND(SUM(s.proficience * s.weight) / SUM(s.weight), 2) AS average
            FROM
                aggregation_students AS s
            GROUP BY s.ID_MUNICIPIO , s.grade_id , s.discipline_id) 
            AS s ON s.ID_MUNICIPIO = c.ibge_id
        INNER JOIN resultados_municipios AS r 
            ON r.dependence_id = s.dependence_id AND s.localization_id = s.localization_id AND r.ibge_id = c.ibge_id
        WHERE s.average <> IF(s.grade_id = 5,
                IF(s.discipline_id = 1,
                    r.media_5EF_LP,
                    r.media_5EF_MT),
                IF(s.discipline_id = 1,
                    r.media_9EF_LP,
                    r.media_9EF_MT))
        GROUP BY cg.city_group_id, s.dependence_id, s.localization_id, s.grade_id, s.discipline_id)
AS comp 
ON comp.city_group_id=a.city_group_id AND comp.dependence_id=a.dependence_id AND comp.localization_id=a.localization_id AND comp.grade_id=a.grade_id AND comp.discipline_id=a.discipline_id
SET 
    needs_to_be_from_sheet = 1 
WHERE
    a.ID_ESCOLA_ALUNO = 0 AND a.city_id = 0
        AND a.city_group_id <> 0
        AND a.state_id <> 0
        AND a.dependence_id = 0
        AND a.localization_id = 0;


COMMIT;