

INSERT INTO aggregation_students
SELECT
	1 AS discipline_id,
	5 AS grade_id,
	st.id AS state_id,
	c.id AS city_id,
	sc.id AS school_id,
	a.ID_MUNICIPIO,
	a.ID_ESCOLA AS ID_ESCOLA_ALUNO,
	es.ID_ESCOLA IS NULL AS masked,
	a.ID_ALUNO,
	a.ID_DEPENDENCIA_ADM AS dependence_id,
	a.ID_LOCALIZACAO AS localization_id,
	a.PROFICIENCIA_LP_SAEB as proficience,
	a.PESO_ALUNO_LP AS weight,
	l.level_quantitative AS level_quantitative,
	l.level_qualitative AS level_qualitative
	FROM
	provabrasil_2015.alunos_5ef AS a
	LEFT JOIN waitress_entities.school AS sc ON sc.ibge_id=a.ID_ESCOLA 
	LEFT JOIN waitress_entities.city AS c ON c.ibge_id=a.ID_MUNICIPIO
	LEFT JOIN waitress_entities.state AS st ON st.ibge_id=a.ID_UF
	LEFT JOIN provabrasil_2015.escolas AS es ON es.ID_ESCOLA=a.ID_ESCOLA
	LEFT JOIN provabrasil_2015.level AS l ON l.grade_id=5 AND discipline_id=1 AND l.min <= a.PROFICIENCIA_LP_SAEB AND l.max > a.PROFICIENCIA_LP_SAEB
	WHERE a.IN_PROFICIENCIA=1;
