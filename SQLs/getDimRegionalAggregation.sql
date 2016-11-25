CREATE DEFINER=`qedu`@`%` FUNCTION `getDimRegionalAggregation`(`state_id` INT, `city_id` INT, `school_id` INT, `team_id` INT) RETURNS int(11)
DETERMINISTIC
BEGIN
   DECLARE retorno int;
   select id into retorno from dim_regional_aggregation as dra
		where dra.team_id = team_id
		and dra.school_id = school_id
		and dra.city_id = city_id
		and dra.state_id = state_id
		limit 1;
   RETURN retorno;
END;