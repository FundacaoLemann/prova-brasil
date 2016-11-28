START TRANSACTION;
-- Agregacao estudantes
CREATE TABLE `aggregation_students` (
	`discipline_id` INT(1) NOT NULL DEFAULT '0',
	`grade_id` INT(1) NOT NULL DEFAULT '0',
	`state_id` TINYINT(3) UNSIGNED NULL DEFAULT '0',
	`city_id` SMALLINT(5) UNSIGNED NULL DEFAULT '0',
	`school_id` MEDIUMINT(8) UNSIGNED NULL DEFAULT '0',
	`ID_MUNICIPIO` INT(11) NULL DEFAULT NULL,
	`ID_ESCOLA_ALUNO` INT(11) NULL DEFAULT NULL,
	`masked` INT(1) NOT NULL DEFAULT '0',
	`ID_ALUNO` INT(11) NULL DEFAULT NULL,
	`dependence_id` INT(11) NULL DEFAULT NULL,
	`localization_id` INT(11) NULL DEFAULT NULL,
	`proficience` DOUBLE NULL DEFAULT NULL,
	`weight` DOUBLE NULL DEFAULT NULL,
	`level_quantitative` INT(11) UNSIGNED NULL,
	`level_qualitative` INT(11) UNSIGNED NULL,
	INDEX `grade_id` (`grade_id`, `discipline_id`),
	INDEX `ID_ESCOLA_ALUNO` (`ID_ESCOLA_ALUNO`, `grade_id`, `discipline_id`, `dependence_id`, `localization_id`),
	INDEX `ID_MUNICIPIO` (`ID_MUNICIPIO`),
	INDEX `state_id` (`state_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

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
	pb_test_import.alunos_5ef AS a
	LEFT JOIN waitress_entities.school AS sc ON sc.ibge_id=a.ID_ESCOLA 
	LEFT JOIN waitress_entities.city AS c ON c.ibge_id=a.ID_MUNICIPIO
	LEFT JOIN waitress_entities.state AS st ON st.ibge_id=a.ID_UF
	LEFT JOIN pb_test_import.escolas AS es ON es.ID_ESCOLA=a.ID_ESCOLA
	LEFT JOIN pb_test_import.level AS l ON l.grade_id=5 AND discipline_id=1 AND l.min <= a.PROFICIENCIA_LP_SAEB AND l.max > a.PROFICIENCIA_LP_SAEB
	WHERE a.IN_PROFICIENCIA=1;

INSERT INTO aggregation_students
	SELECT
	1 AS discipline_id,
	9 AS grade_id,
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
	pb_test_import.alunos_9ef AS a
	LEFT JOIN waitress_entities.school AS sc ON sc.ibge_id=a.ID_ESCOLA 
	LEFT JOIN waitress_entities.city AS c ON c.ibge_id=a.ID_MUNICIPIO
	LEFT JOIN waitress_entities.state AS st ON st.ibge_id=a.ID_UF
	LEFT JOIN pb_test_import.escolas AS es ON es.ID_ESCOLA=a.ID_ESCOLA
	LEFT JOIN pb_test_import.level AS l ON l.grade_id=9 AND discipline_id=1 AND l.min <= a.PROFICIENCIA_LP_SAEB AND l.max > a.PROFICIENCIA_LP_SAEB
	WHERE a.IN_PROFICIENCIA=1;

INSERT INTO aggregation_students
	SELECT
	2 AS discipline_id,
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
	a.PROFICIENCIA_MT_SAEB as proficience,
	a.PESO_ALUNO_MT AS weight,
	l.level_quantitative AS level_quantitative,
	l.level_qualitative AS level_qualitative
	FROM
	pb_test_import.alunos_5ef AS a
	LEFT JOIN waitress_entities.school AS sc ON sc.ibge_id=a.ID_ESCOLA 
	LEFT JOIN waitress_entities.city AS c ON c.ibge_id=a.ID_MUNICIPIO
	LEFT JOIN waitress_entities.state AS st ON st.ibge_id=a.ID_UF 
	LEFT JOIN pb_test_import.escolas AS es ON es.ID_ESCOLA=a.ID_ESCOLA
	LEFT JOIN pb_test_import.level AS l ON l.grade_id=5 AND discipline_id=2 AND l.min <= a.PROFICIENCIA_MT_SAEB AND l.max > a.PROFICIENCIA_MT_SAEB
	WHERE a.IN_PROFICIENCIA=1;

INSERT INTO aggregation_students
	SELECT
	2 AS discipline_id,
	9 AS grade_id,
	st.id AS state_id,
	c.id AS city_id,
	sc.id AS school_id,
	a.ID_MUNICIPIO,
	a.ID_ESCOLA AS ID_ESCOLA_ALUNO,
	es.ID_ESCOLA IS NULL AS masked,
	a.ID_ALUNO,
	a.ID_DEPENDENCIA_ADM AS dependence_id,
	a.ID_LOCALIZACAO AS localization_id,
	a.PROFICIENCIA_MT_SAEB as proficience,
	a.PESO_ALUNO_MT AS weight,
	l.level_quantitative AS level_quantitative,
	l.level_qualitative AS level_qualitative
	FROM
	pb_test_import.alunos_9ef AS a
	LEFT JOIN waitress_entities.school AS sc ON sc.ibge_id=a.ID_ESCOLA 
	LEFT JOIN waitress_entities.city AS c ON c.ibge_id=a.ID_MUNICIPIO
	LEFT JOIN waitress_entities.state AS st ON st.ibge_id=a.ID_UF
	LEFT JOIN pb_test_import.escolas AS es ON es.ID_ESCOLA=a.ID_ESCOLA
	LEFT JOIN pb_test_import.level AS l ON l.grade_id=9 AND discipline_id=2 AND l.min <= a.PROFICIENCIA_MT_SAEB AND l.max > a.PROFICIENCIA_MT_SAEB
	WHERE a.IN_PROFICIENCIA=1;
COMMIT;