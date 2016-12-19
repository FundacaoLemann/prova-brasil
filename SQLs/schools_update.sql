START TRANSACTION;
DELETE FROM waitress_dw_prova_brasil.school WHERE edition_id=6;
INSERT INTO waitress_dw_prova_brasil.school SELECT
	DISTINCT school_id AS id,
	6 AS edition_id,
	state_id AS state_id,
	city_id AS city_id,
	localization_id AS localization_id,
	dependence_id AS dependence_id
FROM provabrasil_2013.aggregation_tmp AS t WHERE t.school_id<>0 AND t.masked=0;
COMMIT;