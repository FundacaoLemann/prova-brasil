CREATE DEFINER=`qedu`@`%` FUNCTION `getDimPoliticAggregation`(`edition_id` INT, `dependence_id` INT, `localization_id` INT, `grade_id` INT, `discipline_id` INT) RETURNS int(11)
    DETERMINISTIC
BEGIN
       DECLARE retorno int;
       select id into retorno from dim_politic_aggregation as dpa
  			where dpa.edition_id = edition_id
				and dpa.dependence_id = dependence_id
				and dpa.localization_id = localization_id
				and dpa.grade_id = grade_id
				and dpa.discipline_id = discipline_id
				limit 1;
       RETURN retorno;
    END;
