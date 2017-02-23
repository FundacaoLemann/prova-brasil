START TRANSACTION;
-- Atualizacao fact_proficiency
-- Create a copy of the table using the new structure
CREATE TABLE IF NOT EXISTS waitress_dw_prova_brasil.fact_proficiency_new (
	`dim_regional_aggregation_id` MEDIUMINT(8) UNSIGNED NOT NULL,
	`dim_politic_aggregation_id` MEDIUMINT(8) UNSIGNED NOT NULL,
	`partition_state_id` TINYINT(3) UNSIGNED NOT NULL,
	`enrolled` INT(10) UNSIGNED NOT NULL,
	`presents` INT(10) UNSIGNED NOT NULL,
	`with_proficiency` INT(11) NOT NULL,
	`with_proficiency_weight` DECIMAL(10,2) NOT NULL,
	`average` DECIMAL(5,2) UNSIGNED NOT NULL,
	`level_quantitative` TINYINT(3) UNSIGNED NOT NULL,
	`level_qualitative` TINYINT(3) UNSIGNED NOT NULL,
	`level_optimal` DECIMAL(10,2) UNSIGNED NOT NULL,
	`qualitative_0` DECIMAL(10,2) UNSIGNED NOT NULL,
	`qualitative_1` DECIMAL(10,2) UNSIGNED NOT NULL,
	`qualitative_2` DECIMAL(10,2) UNSIGNED NOT NULL,
	`qualitative_3` DECIMAL(10,2) UNSIGNED NOT NULL,
	`disclosure` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',
	PRIMARY KEY (`dim_regional_aggregation_id`, `dim_politic_aggregation_id`, `partition_state_id`),
	INDEX `fk_fact_proficiency_dim_politic_aggregation1_idx` (`dim_politic_aggregation_id`),
	INDEX `state_id` (`partition_state_id`)
)
COLLATE='utf8_general_ci'
ENGINE=MyISAM
ROW_FORMAT=FIXED;

-- Copy all the valid data from the old table to the new table
INSERT INTO waitress_dw_prova_brasil.fact_proficiency_new SELECT 
	f.dim_regional_aggregation_id,
	f.dim_politic_aggregation_id,
	f.partition_state_id,
	f.enrolled,
	f.presents,
	f.with_proficiency,
	f.with_proficiency_weight,
	f.average,
	f.level_quantitative,
	f.level_qualitative,
	f.level_optimal,
	f.qualitative_0,
	f.qualitative_1,
	f.qualitative_2,
	f.qualitative_3,
	f.disclosure
FROM waitress_dw_prova_brasil.fact_proficiency AS f
WHERE f.dim_politic_aggregation_id NOT IN (SELECT p.id FROM waitress_dw_prova_brasil.dim_politic_aggregation AS p WHERE p.edition_id=6);

-- Copy data directly from 2013
INSERT INTO waitress_dw_prova_brasil.fact_proficiency_new SELECT * FROM fact_proficiency_new;

-- Drop the old table
DROP TABLE waitress_dw_prova_brasil.fact_proficiency;

-- Rename the old table to the new table
RENAME TABLE waitress_dw_prova_brasil.fact_proficiency_new TO waitress_dw_prova_brasil.fact_proficiency;

COMMIT;