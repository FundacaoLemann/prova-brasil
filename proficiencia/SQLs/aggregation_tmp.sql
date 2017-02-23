START TRANSACTION;
CREATE TABLE `aggregation_tmp` (
	`dim_regional_aggregation` INT(11) NULL DEFAULT NULL,
	`dim_politic_aggregation` INT(11) NULL DEFAULT NULL,
	`dependence_id` INT(11) NULL DEFAULT NULL,
	`localization_id` INT(11) NULL DEFAULT NULL,
	`grade_id` INT(1) NOT NULL DEFAULT '0',
	`discipline_id` INT(1) NOT NULL DEFAULT '0',
	`state_id` TINYINT(3) UNSIGNED NULL DEFAULT '0',
	`city_id` SMALLINT(5) UNSIGNED NULL DEFAULT '0',
	`school_id` MEDIUMINT(8) UNSIGNED NULL DEFAULT '0',
	`ID_MUNICIPIO` INT(11) NULL DEFAULT NULL,
	`ID_ESCOLA_ALUNO` INT(11) NULL DEFAULT NULL,
	`masked` INT(1) NOT NULL DEFAULT '0',
	`enrolled_weight` INT(1) NOT NULL DEFAULT '0',
	`enrolled` INT(1) NOT NULL DEFAULT '0',
	`presents` INT(1) NOT NULL DEFAULT '0',
	`needs_to_be_from_sheet` INT(1) NOT NULL DEFAULT '0',
	`average` DOUBLE NULL DEFAULT NULL,
	`level_quantitative` INT(1) NULL DEFAULT '0',
	`level_qualitative` INT(1) NULL DEFAULT '0',
	UNIQUE INDEX `tmp_filter` (`dependence_id`, `discipline_id`, `grade_id`, `localization_id`, `state_id`, `city_id`, `school_id`),
	INDEX `updates` (`ID_ESCOLA_ALUNO`, `ID_MUNICIPIO`, `state_id`, `localization_id`, `dependence_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;
COMMIT;