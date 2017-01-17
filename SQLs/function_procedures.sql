-- MySQL dump 10.13  Distrib 5.6.28, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: waitress_dw_prova_brasil
-- ------------------------------------------------------
-- Server version	5.6.28-0ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'waitress_dw_prova_brasil'
--
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
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
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
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
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` FUNCTION `getDimRegionalAggregationCityGroup`(`state_id` INT, `city_group_id` INT) RETURNS int(11)
    DETERMINISTIC
BEGIN
       DECLARE retorno int;
       select id into retorno from dim_regional_aggregation as dra
  			where dra.team_id = 0
  			and dra.school_id = 0
  			and dra.city_id = 0
  			and dra.state_id = state_id
  			and dra.city_group_id = city_group_id
				limit 1;
       RETURN retorno;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` FUNCTION `provabrasil_media_para_qualitativo`(quantitativo TINYINT, disciplina TINYINT, ano TINYINT) RETURNS tinyint(1) unsigned
    DETERMINISTIC
RETURN
		CASE
		WHEN disciplina = 1 AND ano = 5 THEN
			
			CASE
			WHEN quantitativo <= 1 THEN 0
			WHEN quantitativo <= 3 THEN 1
			WHEN quantitativo <= 5 THEN 2
			ELSE						3
			END
		WHEN disciplina = 1 AND ano = 9 THEN
			
			CASE
			WHEN quantitativo <= 3 THEN 0
			WHEN quantitativo <= 6 THEN 1
			WHEN quantitativo <= 8 THEN 2
			ELSE						3
			END
		WHEN disciplina = 2 AND ano = 5 THEN
			
			CASE
			WHEN quantitativo <= 2 THEN 0
			WHEN quantitativo <= 4 THEN 1
			WHEN quantitativo <= 6 THEN 2
			ELSE						3
			END
		WHEN disciplina = 2 AND ano = 9 THEN
			
			CASE
			WHEN quantitativo <= 4 THEN 0
			WHEN quantitativo <= 7 THEN 1
			WHEN quantitativo <= 9 THEN 2
			ELSE						3
			END
		ELSE
			0 
		END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` FUNCTION `provabrasil_media_para_quantitativo`(media DECIMAL(14,11)) RETURNS tinyint(2) unsigned
    DETERMINISTIC
RETURN
		CASE
		WHEN media < 125 						  THEN 0
		WHEN media >= 125 AND media < 150 THEN 1
		WHEN media >= 150 AND media < 175 THEN 2
		WHEN media >= 175 AND media < 200 THEN 3
		WHEN media >= 200 AND media < 225 THEN 4
		WHEN media >= 225 AND media < 250 THEN 5
		WHEN media >= 250 AND media < 275 THEN 6
		WHEN media >= 275 AND media < 300 THEN 7
		WHEN media >= 300 AND media < 325 THEN 8
		WHEN media >= 325 AND media < 350 THEN 9
		WHEN media >= 350 AND media < 375 THEN 10
		WHEN media >= 375 AND media < 400 THEN 11
		WHEN media >= 400 AND media < 425 THEN 12
		WHEN media >= 425 AND media < 450 THEN 13
		WHEN media >= 450 AND media < 475 THEN 14
		WHEN media >= 475 AND media < 500 THEN 15
		ELSE 											   16
		END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calcula_representatividade_questionarios`()
BEGIN
  DECLARE done INT DEFAULT FALSE;

  
  DECLARE _survey_id INT;
  DECLARE _survey_table VARCHAR(50);
  DECLARE _survey_question int;
  DECLARE _edition_id int;

  
  DECLARE opcoes CURSOR FOR       select 1 as survey_id, 1 as survey_question, 'fact_question_director' as survey_table, 3 as edition_id
								union select 2 as survey_id, 213 as survey_question, 'fact_question_teacher' as survey_table, 3 as edition_id
								union select 4 as survey_id, 378 as survey_question, 'fact_question_students_5' as survey_table, 3 as edition_id
								union select 5 as survey_id, 422 as survey_question, 'fact_question_students_9' as survey_table, 3 as edition_id
								union select 1 as survey_id, 1001 as survey_question, 'fact_question_director' as survey_table, 4 as edition_id
								union select 2 as survey_id, 1004 as survey_question, 'fact_question_teacher' as survey_table, 4 as edition_id
								union select 4 as survey_id, 1003 as survey_question, 'fact_question_students_5' as survey_table, 4 as edition_id
								union select 5 as survey_id, 1005 as survey_question, 'fact_question_students_9' as survey_table, 4 as edition_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  
  OPEN opcoes;  
  
  loop_leitura: LOOP	
    
    
    FETCH opcoes INTO _survey_id, _survey_question, _survey_table, _edition_id;	

	
  	IF done THEN
      LEAVE loop_leitura;
    END IF;
    
    
    
    set @querySchool = '
		insert into representativeness_surveys
		select
			dim_regional_aggregation_id, 
			dim_politic_aggregation_id,
			:survey_id,
			:edition_id,
			f.total_surveys,
			f.total_responses,
			(total_responses - invalid_responses - erase_responses) as \'valid\',
			NULL
		from :survey_table as f
		inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
		inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
		where f.question_id = :survey_question and school_id != 0';

    
    set @querySchool = REPLACE(@querySchool, ':survey_id', _survey_id);
    set @querySchool = REPLACE(@querySchool, ':survey_table', _survey_table);
    set @querySchool = REPLACE(@querySchool, ':survey_question', _survey_question);
	 set @querySchool = REPLACE(@querySchool, ':edition_id', _edition_id);
	
	insert into log (message) values (@querySchool);
	prepare stmtSchool from @querySchool;
 	EXECUTE stmtSchool;

    set @queryCities = '
		insert into representativeness_surveys
		select
			dim_regional_aggregation_id, 
			dim_politic_aggregation_id,
			:survey_id,
			:edition_id,
			f.total_surveys,
			f.total_responses,
			(total_responses - invalid_responses - erase_responses) as \'valid\',
			count(s.id) as num_schools
		from :survey_table as f
		inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
		inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
		inner join school as s on s.city_id = dra.city_id and s.state_id = dra.state_id and s.edition_id = :edition_id
		where f.question_id = :survey_question and school_id = 0 and dra.city_id != 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
		group by dra.city_id;';

    
    set @queryCities = REPLACE(@queryCities, ':survey_id', _survey_id);
    set @queryCities = REPLACE(@queryCities, ':survey_table', _survey_table);
    set @queryCities = REPLACE(@queryCities, ':survey_question', _survey_question);
    set @queryCities = REPLACE(@queryCities, ':edition_id', _edition_id);
	
	insert into log (message) values (@queryCities);
	prepare stmtCities from @queryCities;
	 EXECUTE stmtCities;

    set @queryStates = '
		insert into representativeness_surveys
		select
			dim_regional_aggregation_id, 
			dim_politic_aggregation_id,
			:survey_id,
			:edition_id,
			f.total_surveys,
			f.total_responses,
			(total_responses - invalid_responses - erase_responses) as \'valid\',
			count(s.id)
		from :survey_table as f
		inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
		inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
		inner join school as s on s.state_id = dra.state_id and s.edition_id = :edition_id
		inner join waitress_entities.state as st on dra.state_id = st.id
		where f.question_id = :survey_question and dra.state_id not in (0, 100) and dra.city_id = 0 and city_group_id = 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
		group by dra.state_id;
		';

    
    set @queryStates = REPLACE(@queryStates, ':survey_id', _survey_id);
    set @queryStates = REPLACE(@queryStates, ':survey_table', _survey_table);
    set @queryStates = REPLACE(@queryStates, ':survey_question', _survey_question);
    set @queryStates = REPLACE(@queryStates, ':edition_id', _edition_id);
	
	insert into log (message) values (@queryStates);
	prepare stmtStates from @queryStates;
	 EXECUTE stmtStates;

	set @queryBrasil = '
		insert into representativeness_surveys
		select
			dim_regional_aggregation_id, 
			dim_politic_aggregation_id,
			:survey_id,
			:edition_id,
			f.total_surveys,
			f.total_responses,
			(total_responses - invalid_responses - erase_responses) as \'valid\',
			count(s.id)
		from :survey_table as f
		inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
		inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
		inner join school as s on s.edition_id = :edition_id
		where f.question_id = :survey_question and dra.state_id = 100 and dra.city_id = 0 and city_group_id = 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0
		group by dpa.edition_id;';

    
    set @queryBrasil = REPLACE(@queryBrasil, ':survey_id', _survey_id);
    set @queryBrasil = REPLACE(@queryBrasil, ':survey_table', _survey_table);
    set @queryBrasil = REPLACE(@queryBrasil, ':survey_question', _survey_question);
	 set @queryBrasil = REPLACE(@queryBrasil, ':edition_id', _edition_id);
	
	insert into log (message) values (@queryBrasil);
	prepare stmtBrasil from @queryBrasil;
	 EXECUTE stmtBrasil;	
  
  
  END LOOP;

  
  CLOSE opcoes;
  

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calcula_representatividade_questionarios_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;

  
  DECLARE _survey_id INT;
  DECLARE _survey_table VARCHAR(50);
  DECLARE _survey_question int;
  DECLARE _edition_id int;

  
  DECLARE opcoes CURSOR FOR        select 1 as survey_id, 1 as survey_question, 'fact_question_director' as survey_table, 3 as edition_id
								union select 2 as survey_id, 213 as survey_question, 'fact_question_teacher' as survey_table, 3 as edition_id
								union select 4 as survey_id, 378 as survey_question, 'fact_question_students_5' as survey_table, 3 as edition_id
								union select 5 as survey_id, 422 as survey_question, 'fact_question_students_9' as survey_table, 3 as edition_id
								union select 1 as survey_id, 1001 as survey_question, 'fact_question_director' as survey_table, 4 as edition_id
								union select 2 as survey_id, 1004 as survey_question, 'fact_question_teacher' as survey_table, 4 as edition_id
								union select 4 as survey_id, 1003 as survey_question, 'fact_question_students_5' as survey_table, 4 as edition_id
								union select 5 as survey_id, 1005 as survey_question, 'fact_question_students_9' as survey_table, 4 as edition_id;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  
  OPEN opcoes;  
  
  loop_leitura: LOOP	
    
    
    FETCH opcoes INTO _survey_id, _survey_question, _survey_table, _edition_id;		

	
  	IF done THEN
      LEAVE loop_leitura;
    END IF;

    set @queryCityGroups = '
		insert into representativeness_surveys
		select
			dim_regional_aggregation_id, 
			dim_politic_aggregation_id,
			:survey_id,
			:edition_id,
			f.total_surveys,
			f.total_responses,
			(total_responses - invalid_responses - erase_responses) as \'valid\',
			count(s.id) as num_schools
		from :survey_table as f
		inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
		inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
		inner join waitress_entities.city_group as cg on cg.id = dra.city_group_id
		inner join waitress_entities.city_in_group as cig on cig.city_group_id = cg.id
		inner join school as s on s.city_id = cig.city_id and s.state_id = dra.state_id and s.edition_id = :edition_id
		where f.question_id = :survey_question and dra.city_id = 0 and dra.city_group_id != 0 and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0		
		group by dra.city_group_id;';

    
    set @queryCityGroups = REPLACE(@queryCityGroups, ':survey_id', _survey_id);
    set @queryCityGroups = REPLACE(@queryCityGroups, ':survey_table', _survey_table);
    set @queryCityGroups = REPLACE(@queryCityGroups, ':survey_question', _survey_question);
	set @queryCityGroups = REPLACE(@queryCityGroups, ':edition_id', _edition_id);
	
	insert into log (message) values (@queryCityGroups);
	prepare stmtCities from @queryCityGroups;
	EXECUTE stmtCities;

  
  END LOOP;

  
  CLOSE opcoes;
  

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_fact_proficiency_city_group`(
	_cg_id int,
	_state_id int	
)
BEGIN
    
	INSERT INTO `waitress_dw_prova_brasil`.`dim_regional_aggregation` 
		(`state_id`, `city_id`, `school_id`, `team_id`, `city_group_id`) VALUES 
	    (_state_id, 0, 0, 0, _cg_id);
	
	
	set @query = '
		insert into waitress_dw_prova_brasil.fact_proficiency
		select
		  getDimRegionalAggregationCityGroup(:state_id, :cg_id) as dim_regional_aggregation,
		  getDimPoliticAggregation(f.edition_id, :filter_dependence, 0, f.grade_id, f.discipline_id) as dim_politic_aggregation,
		  cg.state_id as partition_state_id,
		 
		  0, -- enrolled, wil be calculate
		  0, -- presents
		  count(*) as `with_proficiency`,
		  sum(weight) as `with_proficiency_weight`,
		  
		  sum( f.average * weight) / sum(weight)  as average,
		  NULL as std,
		 
		  garcom_provabrasil.provabrasil_media_para_quantitativo( sum( f.average * weight) / sum(weight)  ) as level_quantitative,
		 
		  garcom_provabrasil.provabrasil_media_para_qualitativo(
			garcom_provabrasil.provabrasil_media_para_quantitativo( sum( f.average * weight) / sum(weight)  ), f.discipline_id, f.grade_id
			)  as level_qualitative,
		 
		  -- alunos no nivel adequado/avançado (2, 3)
		  SUM( f.level_optimal * weight ),
		 
		  -- niveis qualitativos absolutos
		  SUM( IF(f.level_qualitative = 0,  weight , 0)) AS qualitative_0,
		  SUM( IF(f.level_qualitative = 1,  weight , 0)) AS qualitative_1,
		  SUM( IF(f.level_qualitative = 2,  weight , 0)) AS qualitative_2,
		  SUM( IF(f.level_qualitative = 3,  weight , 0)) AS qualitative_3,
		 
		  -- niveis quantitativos absolutos
		  
		  SUM( IF(f.level_quantitative = 0,  weight , 0)) AS level_0,  
		  SUM( IF(f.level_quantitative = 1,  weight , 0)) AS level_1,  
		  SUM( IF(f.level_quantitative = 2,  weight , 0)) AS level_2,  
		  SUM( IF(f.level_quantitative = 3,  weight , 0)) AS level_3,  
		  SUM( IF(f.level_quantitative = 4,  weight , 0)) AS level_4,  
		  SUM( IF(f.level_quantitative = 5,  weight , 0)) AS level_5,  
		  SUM( IF(f.level_quantitative = 6,  weight , 0)) AS level_6,  
		  SUM( IF(f.level_quantitative = 7,  weight , 0)) AS level_7,  
		  SUM( IF(f.level_quantitative = 8,  weight , 0)) AS level_8,  
		  SUM( IF(f.level_quantitative = 9,  weight , 0)) AS level_9,  
		  SUM( IF(f.level_quantitative = 10,  weight , 0)) AS level_10,  
		  SUM( IF(f.level_quantitative = 11,  weight , 0)) AS level_11,
		  SUM( IF(f.level_quantitative = 12,  weight , 0)) AS level_12,
		  SUM( IF(f.level_quantitative = 13,  weight , 0)) AS level_13,
		  SUM( IF(f.level_quantitative = 14,  weight , 0)) AS level_14,
		  SUM( IF(f.level_quantitative = 15,  weight , 0)) AS level_15,
			1
		from
		  waitress_dw_prova_brasil_2011.fact_students_score f  	
		  inner join waitress_entities.city_in_group as cig on cig.city_id = f.city_id and cig.city_group_id = :cg_id
		  inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id and cg.id = :cg_id	 
		group by
		  cg.id,
		  :group_by_dependence
		  f.edition_id,		  
		  f.discipline_id,
		  f.grade_id				
';
	set @query = REPLACE(@query, ':state_id', _state_id);
	set @query = REPLACE(@query, ':cg_id', _cg_id);

	
	set @query1 = REPLACE(@query, ':group_by_dependence', 'f.dependence_id,');
	set @query1 = REPLACE(@query1, ':filter_dependence', 'f.dependence_id');
	prepare stmt1 from @query1;
	EXECUTE stmt1;
	
	
	set @query2 = REPLACE(@query, ':group_by_dependence', '');
	set @query2 = REPLACE(@query2, ':filter_dependence', '0');
	prepare stmt2 from @query2;
	EXECUTE stmt2;	
	
	
	set @cg_id = _cg_id;
	insert into waitress_dw_prova_brasil_2011.city_group_result
		select 
			NULL, 
			4,	
			cg.state_id, 
			cg.id,
			cr.dependence_id, 
			cr.localization_id, 
			cr.grade_id, 
			sum(cr.enrolled_census), 
			sum(cr.presents)
		from waitress_dw_prova_brasil_2011.city_result as cr
		inner join waitress_entities.city_in_group as cig on cig.city_id = cr.city_id and cig.city_group_id = @cg_id
		inner join waitress_entities.city_group as cg on cg.id = cig.city_group_id and cg.id = @cg_id
		group by
			cg.id, 
			cr.dependence_id, 
			cr.localization_id, 
			cr.grade_id;
			
		
		update waitress_dw_prova_brasil.fact_proficiency as f
      		inner join waitress_dw_prova_brasil.dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
      		inner join waitress_dw_prova_brasil.dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
      		inner join waitress_dw_prova_brasil_2011.city_group_result as cgr 
       			 on cgr.edition_id = dpa.edition_id 
      			and cgr.grade_id = dpa.grade_id 
      			and cgr.state_id = dra.state_id 
      			and cgr.city_group_id = dra.city_group_id 
      			and cgr.dependence_id = dpa.dependence_id 
      			and cgr.localization_id = 0
			set
				f.enrolled = cgr.enrolled_census, f.presents = cgr.presents
			where dra.city_id = 0 and dra.city_group_id = @cg_id and dpa.edition_id = 4;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_fact_proficiency_city_groups`()
BEGIN
  DECLARE done INT DEFAULT FALSE;      
  DECLARE _dependence VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select dependence.name as dependence 
			from ( select 'all' as name union select 'grouped' ) as dependence;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set @query = '
		insert into fact_proficiency
		select
		  getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
		  getDimPoliticAggregation(f.edition_id, :filter_dependence, 0, f.grade_id, f.discipline_id) as dim_politic_aggregation,
		  cg.state_id as partition_state_id,
		 
		  0, -- enrolled, wil be calculate
		  0, -- presents
		  count(*) as `with_proficiency`,
		  sum(weight) as `with_proficiency_weight`,
		  
		  sum( f.average * weight) / sum(weight)  as average,
		  NULL as std,
		 
		  garcom_provabrasil.provabrasil_media_para_quantitativo( sum( f.average * weight) / sum(weight)  ) as level_quantitative,
		 
		  garcom_provabrasil.provabrasil_media_para_qualitativo(
			garcom_provabrasil.provabrasil_media_para_quantitativo( sum( f.average * weight) / sum(weight)  ), f.discipline_id, f.grade_id
			)  as level_qualitative,
		 
		  -- alunos no nivel adequado/avançado (2, 3)
		  SUM( f.level_optimal * weight ),
		 
		  -- niveis qualitativos absolutos
		  SUM( IF(f.level_qualitative = 0,  weight , 0)) AS qualitative_0,
		  SUM( IF(f.level_qualitative = 1,  weight , 0)) AS qualitative_1,
		  SUM( IF(f.level_qualitative = 2,  weight , 0)) AS qualitative_2,
		  SUM( IF(f.level_qualitative = 3,  weight , 0)) AS qualitative_3,
		 
		  -- niveis quantitativos absolutos
		  
		  SUM( IF(f.level_quantitative = 0,  weight , 0)) AS level_0,  
		  SUM( IF(f.level_quantitative = 1,  weight , 0)) AS level_1,  
		  SUM( IF(f.level_quantitative = 2,  weight , 0)) AS level_2,  
		  SUM( IF(f.level_quantitative = 3,  weight , 0)) AS level_3,  
		  SUM( IF(f.level_quantitative = 4,  weight , 0)) AS level_4,  
		  SUM( IF(f.level_quantitative = 5,  weight , 0)) AS level_5,  
		  SUM( IF(f.level_quantitative = 6,  weight , 0)) AS level_6,  
		  SUM( IF(f.level_quantitative = 7,  weight , 0)) AS level_7,  
		  SUM( IF(f.level_quantitative = 8,  weight , 0)) AS level_8,  
		  SUM( IF(f.level_quantitative = 9,  weight , 0)) AS level_9,  
		  SUM( IF(f.level_quantitative = 10,  weight , 0)) AS level_10,  
		  SUM( IF(f.level_quantitative = 11,  weight , 0)) AS level_11,
		  SUM( IF(f.level_quantitative = 12,  weight , 0)) AS level_12,
		  SUM( IF(f.level_quantitative = 13,  weight , 0)) AS level_13,
		  SUM( IF(f.level_quantitative = 14,  weight , 0)) AS level_14,
		  SUM( IF(f.level_quantitative = 15,  weight , 0)) AS level_15,
		  1  
		from
		  fact_students_score f  	
		  inner join waitress_entities.city_in_group as cig on cig.city_id = f.city_id
		  inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id	 
		group by
		  cg.id,
		  :group_by_dependence
		  f.edition_id,		  
		  f.discipline_id,
		  f.grade_id				
';

	
	if _dependence = 'grouped' then		
		set @query = REPLACE(@query, ':group_by_dependence', 'f.dependence_id,');
		set @query = REPLACE(@query, ':filter_dependence', 'f.dependence_id');

	
	elseif _dependence = 'all' then
		set @query = REPLACE(@query, ':group_by_dependence', '');
		set @query = REPLACE(@query, ':filter_dependence', '0');
		
    end if;

	insert into log (message) values (@query);
	prepare stmt1 from @query;
	EXECUTE stmt1;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_fact_proficiency_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;      
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence 
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set @query = '
		insert into fact_proficiency
		select
		  getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
		  getDimPoliticAggregation(f.edition_id, :filter_dependence, 0, f.grade_id, f.discipline_id) as dim_politic_aggregation,
		  :state_id as partition_state_id,
		 
		  0, -- enrolled, wil be calculate
		  0, -- presents
		  count(*) as `with_proficiency`,
		  sum(weight) as `with_proficiency_weight`,
		  
		  sum( f.average * weight) / sum(weight)  as average,
		  NULL as std,
		 
		  garcom_provabrasil.provabrasil_media_para_quantitativo( sum( f.average * weight) / sum(weight)  ) as level_quantitative,
		 
		  garcom_provabrasil.provabrasil_media_para_qualitativo(
			garcom_provabrasil.provabrasil_media_para_quantitativo( sum( f.average * weight) / sum(weight)  ), f.discipline_id, f.grade_id
			)  as level_qualitative,
		 
		  -- alunos no nivel adequado/avançado (2, 3)
		  SUM( f.level_optimal * weight ),
		 
		  -- niveis qualitativos absolutos
		  SUM( IF(f.level_qualitative = 0,  weight , 0)) AS qualitative_0,
		  SUM( IF(f.level_qualitative = 1,  weight , 0)) AS qualitative_1,
		  SUM( IF(f.level_qualitative = 2,  weight , 0)) AS qualitative_2,
		  SUM( IF(f.level_qualitative = 3,  weight , 0)) AS qualitative_3,
		 
		  -- niveis quantitativos absolutos
		  
		  SUM( IF(f.level_quantitative = 0,  weight , 0)) AS level_0,  
		  SUM( IF(f.level_quantitative = 1,  weight , 0)) AS level_1,  
		  SUM( IF(f.level_quantitative = 2,  weight , 0)) AS level_2,  
		  SUM( IF(f.level_quantitative = 3,  weight , 0)) AS level_3,  
		  SUM( IF(f.level_quantitative = 4,  weight , 0)) AS level_4,  
		  SUM( IF(f.level_quantitative = 5,  weight , 0)) AS level_5,  
		  SUM( IF(f.level_quantitative = 6,  weight , 0)) AS level_6,  
		  SUM( IF(f.level_quantitative = 7,  weight , 0)) AS level_7,  
		  SUM( IF(f.level_quantitative = 8,  weight , 0)) AS level_8,  
		  SUM( IF(f.level_quantitative = 9,  weight , 0)) AS level_9,  
		  SUM( IF(f.level_quantitative = 10,  weight , 0)) AS level_10,  
		  SUM( IF(f.level_quantitative = 11,  weight , 0)) AS level_11,
		  SUM( IF(f.level_quantitative = 12,  weight , 0)) AS level_12,
		  SUM( IF(f.level_quantitative = 13,  weight , 0)) AS level_13,
		  SUM( IF(f.level_quantitative = 14,  weight , 0)) AS level_14,
		  SUM( IF(f.level_quantitative = 15,  weight , 0)) AS level_15  
		from
		  fact_students_score f  		 
		group by
		  :group_by_aggregation
		  :group_by_dependence
		  f.edition_id,		  
		  f.discipline_id,
		  f.grade_id				
';

	
	if _dependence = 'grouped' then		
		set @query = REPLACE(@query, ':group_by_dependence', 'f.dependence_id,');
		set @query = REPLACE(@query, ':filter_dependence', 'f.dependence_id');

	
	elseif _dependence = 'all' then
		set @query = REPLACE(@query, ':group_by_dependence', '');
		set @query = REPLACE(@query, ':filter_dependence', '0');
		
    end if;

	if _aggregation = 'city' then
		set @query = REPLACE(@query, ':filter_dim_regional_aggregation', 'f.state_id, f.city_id, 0, 0');
		set @query = REPLACE(@query, ':state_id', 'f.state_id');
		set @query = REPLACE(@query, ':group_by_aggregation', 'f.city_id,');		

	elseif _aggregation = 'state' then
		set @query = REPLACE(@query, ':filter_dim_regional_aggregation', 'f.state_id, 0, 0, 0');
		set @query = REPLACE(@query, ':state_id', 'f.state_id');
		set @query = REPLACE(@query, ':group_by_aggregation', 'f.state_id,');

	elseif _aggregation = 'brasil' then
		set @query = REPLACE(@query, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @query = REPLACE(@query, ':state_id', '100');
		set @query = REPLACE(@query, ':group_by_aggregation', '');
	end if;	
	
     
	insert into log (message) values (@query);
	prepare stmt1 from @query;
	EXECUTE stmt1;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_representativeness_surveys_one_city_group`(cg_id int)
BEGIN
  DECLARE done INT DEFAULT FALSE;

  
  DECLARE _survey_id INT;
  DECLARE _survey_table VARCHAR(50);
  DECLARE _survey_question int;
  DECLARE _edition_id int;

  
  DECLARE opcoes CURSOR FOR        select 1 as survey_id, 1 as survey_question, 'fact_question_director' as survey_table, 3 as edition_id
								union select 2 as survey_id, 213 as survey_question, 'fact_question_teacher' as survey_table, 3 as edition_id
								union select 4 as survey_id, 378 as survey_question, 'fact_question_students_5' as survey_table, 3 as edition_id
								union select 5 as survey_id, 422 as survey_question, 'fact_question_students_9' as survey_table, 3 as edition_id
								union select 1 as survey_id, 1001 as survey_question, 'fact_question_director' as survey_table, 4 as edition_id
								union select 2 as survey_id, 1004 as survey_question, 'fact_question_teacher' as survey_table, 4 as edition_id
								union select 4 as survey_id, 1003 as survey_question, 'fact_question_students_5' as survey_table, 4 as edition_id
								union select 5 as survey_id, 1005 as survey_question, 'fact_question_students_9' as survey_table, 4 as edition_id;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  
  OPEN opcoes;  
  
  loop_leitura: LOOP	
    
    
    FETCH opcoes INTO _survey_id, _survey_question, _survey_table, _edition_id;		

	
  	IF done THEN
      LEAVE loop_leitura;
    END IF;

    set @queryCityGroups = '
		insert into representativeness_surveys
		select
			dim_regional_aggregation_id, 
			dim_politic_aggregation_id,
			:survey_id,
			:edition_id,
			f.total_surveys,
			f.total_responses,
			(total_responses - invalid_responses - erase_responses) as \'valid\',
			count(s.id) as num_schools
		from :survey_table as f
		inner join dim_regional_aggregation as dra on dra.id = dim_regional_aggregation_id
		inner join dim_politic_aggregation as dpa on dpa.id = dim_politic_aggregation_id
		inner join waitress_entities.city_group as cg on cg.id = dra.city_group_id
		inner join waitress_entities.city_in_group as cig on cig.city_group_id = cg.id
		inner join school as s on s.city_id = cig.city_id and s.state_id = dra.state_id and s.edition_id = :edition_id
		where f.question_id = :survey_question and dra.city_id = 0 and dra.city_group_id = :cg_id and dpa.dependence_id = 0 and dpa.localization_id = 0 and dpa.grade_id = 0		
		group by dra.city_group_id;';

    
    set @queryCityGroups = REPLACE(@queryCityGroups, ':survey_id', _survey_id);
    set @queryCityGroups = REPLACE(@queryCityGroups, ':survey_table', _survey_table);
    set @queryCityGroups = REPLACE(@queryCityGroups, ':survey_question', _survey_question);
	set @queryCityGroups = REPLACE(@queryCityGroups, ':edition_id', _edition_id);
	set @queryCityGroups = REPLACE(@queryCityGroups, ':cg_id', cg_id);
	
	insert into log (message) values (@queryCityGroups);
	prepare stmtCities from @queryCityGroups;
	EXECUTE stmtCities;

  
  END LOOP;

  
  CLOSE opcoes;
  

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_surveys_city_group`(cg_id int)
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _grade VARCHAR(40);
  DECLARE _dependence VARCHAR(40);
  DECLARE _fact_question VARCHAR(60);
  DECLARE _fact_alternative VARCHAR(60);
  DECLARE _origin_table VARCHAR(60);
  DECLARE _survey_id int;

  
  DECLARE opcoes CURSOR FOR 
		select 
			dependence.name as 'dependence', 
			grade.name as 'grade', 
			column_name as 'column', 
			fact_question,
			fact_alternative,
			origin_table,
			survey_id 
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join (
				select 'fact_question_director' as fact_question, 'fact_alternative_director' as fact_alternative, 1 as survey_id, 'survey_director_responses_2011' as origin_table
				union select 'fact_question_teacher', 'fact_alternative_teacher' , 2, 'survey_teacher_responses_2011'
				union select 'fact_question_students_5', 'fact_alternative_students_5' , 4, 'survey_students_responses_2011_5ano'
				union select 'fact_question_students_9', 'fact_alternative_students_9' , 5, 'survey_students_responses_2011_9ano'
			) as tables
			left join ( select 'all' as name union select 'grouped' ) as grade on tables.survey_id = 2
			inner join information_schema.columns 
		 where table_name=tables.origin_table and column_name like 'Q%';


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence, _grade, _coluna, _fact_question, _fact_alternative, _origin_table, _survey_id;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into :fact_question
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from waitress_dw_prova_brasil_2011.:origin_table as sdr
           inner join question as q on q.order = :num and q.survey_id = :survey_id and q.edition_id = 4
			inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id and cig.city_group_id = :cg_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id and cg.id = :cg_id
           group by cg.id :group_by_dependence :group_by_grade;				
';

	set @queryA = '
		insert into :fact_alternative
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          :survey_id as survey_id
        from waitress_dw_prova_brasil_2011.:origin_table as sdr
           inner join question as q on q.order = :num and q.survey_id = :survey_id and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
			inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id and cig.city_group_id = :cg_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id and cg.id = :cg_id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id, :group_by_dependence :group_by_grade :column;	
	';

	
	if _dependence = 'grouped' then		

		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;


	
	if _grade = 'grouped' then		
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', ',sdr.grade_id');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

		set @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
		set @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');

	
	elseif _grade = 'all' or _grade is NULL then
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

		set @queryA = REPLACE(@queryA, ':group_by_grade', '');
		set @queryA = REPLACE(@queryA, ':filter_grade', '0');
		
    end if;

	set @queryQ = REPLACE(@queryQ, ':cg_id', cg_id);
	set @queryQ = REPLACE(@queryQ, ':fact_question', _fact_question);
	set @queryQ = REPLACE(@queryQ, ':origin_table', _origin_table);
	set @queryQ = REPLACE(@queryQ, ':survey_id', _survey_id);
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':cg_id', cg_id);
	set @queryA = REPLACE(@queryA, ':fact_alternative', _fact_alternative);
	set @queryA = REPLACE(@queryA, ':origin_table', _origin_table);
	set @queryA = REPLACE(@queryA, ':survey_id', _survey_id);
	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_director_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select dependence.name as dependence, column_name as 'column'
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_director_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_director_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
		   NULL
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
		    inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
		  group by cg.id :group_by_dependence;				
';

	set @queryA = '
		insert into fact_alternative_director
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          1 as survey_id
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
		    inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id :group_by_dependence , :column;	

	';


	
	if _dependence = 'grouped' then		
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', ',sdr.dependence_id');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;

	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_director_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_director_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
		   NULL
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_aggregation ;				
';

	set @queryA = '
		insert into fact_alternative_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          1 as survey_id
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log3 (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log3 (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_director_city_state_brasil_questoes_com_bug`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_director_responses_2011' and column_name in ('Q_163', 'Q_168', 'Q_173', 'Q_179', 'Q_184', 'Q_189', 'Q_195', 'Q_200', 'Q_205', 'Q_211');

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryA = '
		insert into fact_alternative_director
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          1 as survey_id
        from survey_director_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 1 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_school_student_5`()
BEGIN
  DECLARE coluna varchar(5);
  DECLARE num varchar(3);
  DECLARE colunas_surveys CURSOR FOR select column_name from information_schema.columns 
		where table_name='survey_students_responses_2011_5ano' and column_name like 'Q%';
  
  OPEN colunas_surveys;
  
  loop_leitura: LOOP

    FETCH colunas_surveys INTO coluna;
    set num = SUBSTRING(coluna,3);

    set @query_questions = '
		insert into fact_question_students_5
        select
          getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) as dim_regional_aggregation,
          getDimPoliticAggregation(4, dependence_id, localization_id, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
           group by sdr.state_id, sdr.city_id, sdr.school_id, sdr.dependence_id, sdr.localization_id;
	';

	set @query_alternatives = '
		 insert into fact_alternative_students_5
        select
          getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) as dim_regional_aggregation,
          getDimPoliticAggregation(4, dependence_id, localization_id, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          4 as survey_id
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by sdr.state_id, sdr.city_id, sdr.school_id, :column, dependence_id, sdr.localization_id;
	';


	set @query_questions = REPLACE(@query_questions, ':column', coluna);
	set @query_questions = REPLACE(@query_questions, ':num', num);

	set @query_alternatives = REPLACE(@query_alternatives, ':column', coluna);
	set @query_alternatives = REPLACE(@query_alternatives, ':num', num);

	insert into log (message) values (@query_questions);
	prepare stmt1 from @query_questions;
	EXECUTE stmt1;

	insert into log (message) values (@query_alternatives);
	prepare stmt2 from @query_alternatives;
	EXECUTE stmt2;

  END LOOP;

  CLOSE colunas_surveys;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_school_student_9`()
BEGIN
  DECLARE coluna varchar(5);
  DECLARE num varchar(3);
  DECLARE colunas_surveys CURSOR FOR select column_name from information_schema.columns 
		where table_name='survey_students_responses_2011_9ano' and column_name like 'Q%';
  
  OPEN colunas_surveys;
  
  loop_leitura: LOOP

    FETCH colunas_surveys INTO coluna;
    set num = SUBSTRING(coluna,3);

    set @query_questions = '
		insert into fact_question_students_9
        select
          getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) as dim_regional_aggregation,
          getDimPoliticAggregation(4, dependence_id, localization_id, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_9ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 5 and q.edition_id = 4
           group by sdr.state_id, sdr.city_id, sdr.school_id, sdr.dependence_id, sdr.localization_id;
	';

	set @query_alternatives = '
		 insert into fact_alternative_students_9
        select
          getDimRegionalAggregation(sdr.state_id, sdr.city_id, sdr.school_id, 0) as dim_regional_aggregation,
          getDimPoliticAggregation(4, dependence_id, localization_id, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          5 as survey_id
        from survey_students_responses_2011_9ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 5 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by sdr.state_id, sdr.city_id, sdr.school_id, :column, dependence_id, sdr.localization_id;
	';


	set @query_questions = REPLACE(@query_questions, ':column', coluna);
	set @query_questions = REPLACE(@query_questions, ':num', num);

	set @query_alternatives = REPLACE(@query_alternatives, ':column', coluna);
	set @query_alternatives = REPLACE(@query_alternatives, ':num', num);

	insert into log2 (message) values (@query_questions);
	prepare stmt1 from @query_questions;
	EXECUTE stmt1;

	insert into log2 (message) values (@query_alternatives);
	prepare stmt2 from @query_alternatives;
	EXECUTE stmt2;

  END LOOP;

  CLOSE colunas_surveys;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_student_5_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select dependence.name as dependence, column_name as 'column'
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_students_responses_2011_5ano' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_students_5_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
			 inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
		    group by cg.id :group_by_dependence;				
';

	set @queryA = '
		insert into fact_alternative_students_5_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          4 as survey_id
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
		    inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id, :group_by_dependence :column;	

	';

	
	if _dependence = 'grouped' then		
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_student_5_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_students_responses_2011_5ano' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_students_5
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_aggregation ;				
';

	set @queryA = '
		insert into fact_alternative_students_5
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          4 as survey_id
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_student_5_city_state_brasil_cont`(last_executed INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _cont int;
  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_students_responses_2011_5ano' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  set _cont = 0;
  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_students_5
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_aggregation ;				
';

	set @queryA = '
		insert into fact_alternative_students_5
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          4 as survey_id
        from survey_students_responses_2011_5ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 4 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	 set _cont = _cont + 1;    
    if _cont > last_executed then
		insert into log (message) values (concat(_cont,@queryQ));
		prepare stmt1 from @queryQ;
		
	end if;
	
   
	set _cont = _cont + 1;
	if _cont > last_executed then
		insert into log (message) values (concat(_cont, @queryA));
		prepare stmt2 from @queryA;
		EXECUTE stmt2;
	end if;	

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_student_9_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);

  DECLARE opcoes CURSOR FOR 
		select dependence.name as dependence, column_name as 'column'
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_students_responses_2011_9ano' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_students_9_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_9ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 5 and q.edition_id = 4
			 inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
		    group by cg.id :group_by_dependence;				
';

	set @queryA = '
		insert into fact_alternative_students_9_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          5 as survey_id
        from survey_students_responses_2011_9ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 5 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
		    inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id, :group_by_dependence :column;	

	';

	
	if _dependence = 'grouped' then		
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_student_9_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join information_schema.columns 
		 where table_name='survey_students_responses_2011_9ano' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_students_9
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error
        from survey_students_responses_2011_9ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 5 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_aggregation ;				
';

	set @queryA = '
		insert into fact_alternative_students_9
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, 0, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          5 as survey_id
        from survey_students_responses_2011_9ano as sdr
           inner join question as q on q.order = :num and q.survey_id = 5 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log2 (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log2 (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_teacher_city_group`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _grade VARCHAR(40);
  DECLARE _dependence VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select dependence.name as dependence, grade.name as grade, column_name as 'column'			
			from ( select 'all' as name union select 'grouped' ) as dependence
			inner join ( select 'all' as name union select 'grouped' ) as grade
			inner join information_schema.columns 
		 where table_name='survey_teacher_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _dependence, _grade, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_teacher_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
		   NULL
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
			inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
           group by cg.id :group_by_dependence :group_by_grade;				
';

	set @queryA = '
		insert into fact_alternative_teacher_only_city_group
        select
          getDimRegionalAggregationCityGroup(cg.state_id, cg.id) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          2 as survey_id
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
			inner join waitress_entities.city_in_group as cig on cig.city_id = sdr.city_id
		    inner join waitress_entities.city_group as cg on cig.city_group_id = cg.id
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by cg.id, :group_by_dependence :group_by_grade :column;	

	';


	
	if _dependence = 'grouped' then		

		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', ',sdr.dependence_id');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;


	
	if _grade = 'grouped' then		
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', ',sdr.grade_id');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

		set @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
		set @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');

	
	elseif _grade = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

		set @queryA = REPLACE(@queryA, ':group_by_grade', '');
		set @queryA = REPLACE(@queryA, ':filter_grade', '0');
		
    end if;

	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_teacher_city_state_brasil`()
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _grade VARCHAR(40);
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  
  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, grade.name as grade, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join ( select 'all' as name union select 'grouped' ) as grade
			inner join information_schema.columns 
		 where table_name='survey_teacher_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _grade, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_teacher
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
		   NULL
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_grade :group_by_aggregation ;				
';

	set @queryA = '
		insert into fact_alternative_teacher
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          2 as survey_id
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_grade :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		if _aggregation = 'brasil' and _grade = 'all' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;


	
	if _grade = 'grouped' then		
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_grade', 'sdr.grade_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_grade', 'sdr.grade_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

		set @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
		set @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');

	
	elseif _grade = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

		set @queryA = REPLACE(@queryA, ':group_by_grade', '');
		set @queryA = REPLACE(@queryA, ':filter_grade', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' or _grade = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
	insert into log4 (message) values (@queryQ);
	prepare stmt1 from @queryQ;
	EXECUTE stmt1;

	insert into log4 (message) values (@queryA);
	prepare stmt2 from @queryA;
	EXECUTE stmt2;

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`qedu`@`%` PROCEDURE `calc_survey_teacher_city_state_brasil_cont`(last_executed INT )
BEGIN
  DECLARE done INT DEFAULT FALSE;   

  DECLARE _cont int;
  DECLARE _coluna varchar(5);
  DECLARE _num varchar(3);   
  DECLARE _grade VARCHAR(40);
  DECLARE _dependence VARCHAR(40);
  DECLARE _aggregation VARCHAR(40);

  DECLARE opcoes CURSOR FOR 
		select region.name as aggregation, dependence.name as dependence, grade.name as grade, column_name as 'column'
			from (select 'city' as name union select 'state' union select 'brasil') as region
			inner join ( select 'all' as name union select 'grouped' ) as dependence
			inner join ( select 'all' as name union select 'grouped' ) as grade
			inner join information_schema.columns 
		 where table_name='survey_teacher_responses_2011' and column_name like 'Q%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  set _cont = 0;
  OPEN opcoes;  
  loop_leitura: LOOP
  
    FETCH opcoes INTO _aggregation, _dependence, _grade, _coluna;
    
	IF done THEN
      LEAVE loop_leitura;
    END IF;       

	set _num = SUBSTRING(_coluna,3);

	set @queryQ = '
		insert into fact_question_teacher
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          q.id as question_id,
          count(*) as total_surveys,
    	   sum( is_filled ) as total_responses,
          sum( if(is_filled, :column = \'.\', 0)) as invalid,
          sum( :column = \'*\') as erase,
          0 as sampling_error,
		   NULL
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
            :has_group_by :group_by_dependence :group_by_grade :group_by_aggregation ;				
';

	set @queryA = '
		insert into fact_alternative_teacher
        select
          getDimRegionalAggregation(:filter_dim_regional_aggregation) as dim_regional_aggregation,
          getDimPoliticAggregation(4, :filter_dependence, 0, :filter_grade, 0) as dim_politic_aggregation,
          a.id,
          count(*) as responses,
          2 as survey_id
        from survey_teacher_responses_2011 as sdr
           inner join question as q on q.order = :num and q.survey_id = 2 and q.edition_id = 4
           inner join alternative as a on a.question_id = q.id and a.alternative = :column
        where :column != \'.\' and :column != \'*\' and is_filled = 1
        group by :group_by_dependence :group_by_grade :group_by_aggregation :column;	

	';


	
	if _dependence = 'grouped' then		
		if _aggregation = 'brasil' and _grade = 'all' then
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_dependence', 'sdr.dependence_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', 'sdr.dependence_id');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', 'sdr.dependence_id,');
		set @queryA = REPLACE(@queryA, ':filter_dependence', 'sdr.dependence_id');

	
	elseif _dependence = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_dependence', '');
		set @queryQ = REPLACE(@queryQ, ':filter_dependence', '0');

		set @queryA = REPLACE(@queryA, ':group_by_dependence', '');
		set @queryA = REPLACE(@queryA, ':filter_dependence', '0');
		
    end if;


	
	if _grade = 'grouped' then		
		if _aggregation = 'brasil' then
			set @queryQ = REPLACE(@queryQ, ':group_by_grade', 'sdr.grade_id');
		else
			set @queryQ = REPLACE(@queryQ, ':group_by_grade', 'sdr.grade_id,');
		end if;
		set @queryQ = REPLACE(@queryQ, ':filter_grade', 'sdr.grade_id');

		set @queryA = REPLACE(@queryA, ':group_by_grade', 'sdr.grade_id,');
		set @queryA = REPLACE(@queryA, ':filter_grade', 'sdr.grade_id');

	
	elseif _grade = 'all' then
		set @queryQ = REPLACE(@queryQ, ':group_by_grade', '');
		set @queryQ = REPLACE(@queryQ, ':filter_grade', '0');

		set @queryA = REPLACE(@queryA, ':group_by_grade', '');
		set @queryA = REPLACE(@queryA, ':filter_grade', '0');
		
    end if;



	if _aggregation = 'city' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.city_id');	
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');	

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, sdr.city_id, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.city_id,');	
			

	elseif _aggregation = 'state' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', 'sdr.state_id');
		set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');

		set @queryA= REPLACE(@queryA, ':filter_dim_regional_aggregation', 'sdr.state_id, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', 'sdr.state_id,');

	elseif _aggregation = 'brasil' then
		set @queryQ = REPLACE(@queryQ, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryQ = REPLACE(@queryQ, ':group_by_aggregation', '');
		if _dependence = 'grouped' or _grade = 'grouped' then	
			set @queryQ = REPLACE(@queryQ, ':has_group_by', 'group by ');
		else 
			set @queryQ = REPLACE(@queryQ, ':has_group_by', '');
		end if;

		set @queryA = REPLACE(@queryA, ':filter_dim_regional_aggregation', '100, 0, 0, 0');
		set @queryA = REPLACE(@queryA, ':group_by_aggregation', '');
	end if;	
	
	set @queryQ = REPLACE(@queryQ, ':column', _coluna);
	set @queryQ = REPLACE(@queryQ, ':num', _num);

	set @queryA = REPLACE(@queryA, ':column', _coluna);
	set @queryA = REPLACE(@queryA, ':num', _num);
     
    set _cont = _cont + 1;    
    if _cont > last_executed then
		insert into log4 (message) values (concat(_cont,@queryQ));
		prepare stmt1 from @queryQ;
		
	end if;
	
   
	set _cont = _cont + 1;
	if _cont > last_executed then
		insert into log4 (message) values (concat(_cont, @queryA));
		prepare stmt2 from @queryA;
		EXECUTE stmt2;
	end if;	

  END LOOP;

  CLOSE opcoes;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-19 18:13:32
