START TRANSACTION;
CREATE TABLE `fact_proficiency_new` (
	`dim_regional_aggregation_id` INT(11) NULL DEFAULT NULL,
	`dim_politic_aggregation_id` INT(11) NULL DEFAULT NULL,
	`partition_state_id` TINYINT(3) UNSIGNED NULL,
	`enrolled` INT(1) NOT NULL DEFAULT '0',
	`presents` INT(1) NOT NULL DEFAULT '0',
	`with_proficiency` BIGINT(21) NOT NULL DEFAULT '0',
	`with_proficiency_weight` DOUBLE(19,2) NULL DEFAULT NULL,
	`average` DOUBLE(19,2) NULL DEFAULT NULL,
	`level_quantitative` INT(1) NOT NULL DEFAULT '0',
	`level_qualitative` INT(1) NOT NULL DEFAULT '0',
	`level_optimal` DECIMAL(10,2) NULL DEFAULT NULL,
	`qualitative_0` DECIMAL(10,2) NULL DEFAULT NULL,
	`qualitative_1` DECIMAL(10,2) NULL DEFAULT NULL,
	`qualitative_2` DECIMAL(10,2) NULL DEFAULT NULL,
	`qualitative_3` DECIMAL(10,2) NULL DEFAULT NULL,
	`disclosure` INT(1) NOT NULL DEFAULT '0'
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;
COMMIT;