START TRANSACTION;
INSERT INTO aggregation_tmp
	-- Escola 
	SELECT
	 waitress_dw_prova_brasil.getDimRegionalAggregation(a.state_id, a.city_id, a.school_id, 0) as dim_regional_aggregation,
	 waitress_dw_prova_brasil.getDimPoliticAggregation(5, a.dependence_id, a.localization_id, a.grade_id, a.discipline_id) as dim_politic_aggregation,
	 a.dependence_id AS dependence_id,
	 a.localization_id AS localization_id,
	 a.grade_id AS grade_id,
	 a.discipline_id AS discipline_id,
	 a.state_id AS state_id,
	 a.city_id AS city_id,
	 a.school_id AS school_id,
	 a.ID_MUNICIPIO,
	 a.ID_ESCOLA_ALUNO,
	 a.masked AS masked,
	 0 AS enrolled_weight, -- Enrolled based on weight, will be calculate
	 0 AS enrolled, -- enrolled, will be calculate too
	 0 AS presents, -- presents
	 0 AS needs_to_be_from_sheet, 
	 SUM(a.proficience * a.weight) / SUM(a.weight) as average,
	 0 AS level_quantitative,
	 0 AS level_qualitative
	FROM aggregation_students AS a
	GROUP BY a.ID_ESCOLA_ALUNO, a.localization_id, a.dependence_id, a.grade_id, a.discipline_id;

-- Escolas
UPDATE aggregation_tmp AS a set
    enrolled=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_MATRICULADOS_CENSO_5EF, e.NU_MATRICULADOS_CENSO_9EF)), 0) FROM escolas AS e WHERE e.ID_ESCOLA=a.ID_ESCOLA_ALUNO),
    enrolled_weight=(SELECT IFNULL(SUM(e.weight), 0) FROM aggregation_students AS e WHERE e.ID_ESCOLA_ALUNO=a.ID_ESCOLA_ALUNO AND e.grade_id=a.grade_id AND e.discipline_id=a.discipline_id AND e.dependence_id=a.dependence_id AND e.localization_id=a.localization_id),
    presents=(SELECT IFNULL(SUM(IF(a.grade_id=5, e.NU_PRESENTES_5EF, e.NU_PRESENTES_9EF)), 0) FROM escolas AS e WHERE e.ID_ESCOLA=a.ID_ESCOLA_ALUNO),
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO<>0 AND a.ID_MUNICIPIO<>0 AND a.state_id<>0 AND a.localization_id<>0 AND a.dependence_id<>0;
COMMIT;