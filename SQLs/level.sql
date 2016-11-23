-- MySQL dump 10.13  Distrib 5.6.23, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: provabrasil_2013
-- ------------------------------------------------------
-- Server version	5.6.23-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `level`
--

DROP TABLE IF EXISTS `level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `level` (
  `level_quantitative` int(11) unsigned NOT NULL,
  `level_qualitative` int(11) unsigned NOT NULL,
  `min` int(11) unsigned NOT NULL,
  `max` int(11) unsigned NOT NULL,
  `grade_id` tinyint(2) unsigned NOT NULL,
  `discipline_id` tinyint(3) unsigned NOT NULL,
  `level_quantitative_field` varchar(50) NOT NULL,
  `level_quantitative_name` varchar(50) NOT NULL,
  `level_qualitative_name` varchar(50) NOT NULL,
  UNIQUE KEY `min_max_grade_id_discipline_id` (`grade_id`,`discipline_id`,`min`,`max`),
  KEY `discipline` (`discipline_id`),
  KEY `min_max` (`min`,`max`),
  CONSTRAINT `discipline` FOREIGN KEY (`discipline_id`) REFERENCES `waitress_entities`.`discipline` (`id`),
  CONSTRAINT `grade` FOREIGN KEY (`grade_id`) REFERENCES `waitress_entities`.`grade` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `level`
--

LOCK TABLES `level` WRITE;
/*!40000 ALTER TABLE `level` DISABLE KEYS */;
INSERT INTO `level` VALUES (0,0,0,150,5,1,'ate_nivel_1_LP5','Até Nível 1','Insuficiente'),(2,1,150,175,5,1,'nivel_2_LP5','Nível 2','Básico'),(3,1,175,200,5,1,'nivel_3_LP5','Nível 3','Básico'),(4,2,200,225,5,1,'nivel_4_LP5','Nível 4','Proficiente'),(5,2,225,250,5,1,'nivel_5_LP5','Nível 5','Proficiente'),(6,3,250,275,5,1,'nivel_6_LP5','Nível 6','Avançado'),(7,3,275,300,5,1,'nivel_7_LP5','Nível 7','Avançado'),(8,3,300,325,5,1,'nivel_8_LP5','Nível 8','Avançado'),(9,3,325,350,5,1,'nivel_9_LP5','Nível 9','Avançado'),(0,0,0,125,5,2,'nivel_0_MT5','Abaixo do Nível 1','Insuficiente'),(1,0,125,150,5,2,'nivel_1_MT5','Nível 1','Insuficiente'),(2,0,150,175,5,2,'nivel_2_MT5','Nível 2','Insuficiente'),(3,1,175,200,5,2,'nivel_3_MT5','Nível 3','Básico'),(4,1,200,225,5,2,'nivel_4_MT5','Nível 4','Básico'),(5,2,225,250,5,2,'nivel_5_MT5','Nível 5','Proficiente'),(6,2,250,275,5,2,'nivel_6_MT5','Nível 6','Proficiente'),(7,3,275,300,5,2,'nivel_7_MT5','Nível 7','Avançado'),(8,3,300,325,5,2,'nivel_8_MT5','Nível 8','Avançado'),(9,3,325,350,5,2,'nivel_9_MT5','Nível 9','Avançado'),(10,3,350,375,5,2,'nivel_10_MT5','Nível 10','Avançado'),(0,0,0,200,9,1,'nivel_0_LP9','Abaixo do Nível 1','Insuficiente'),(1,1,200,225,9,1,'nivel_1_LP9','Nível 1','Básico'),(2,1,225,250,9,1,'nivel_2_LP9','Nível 2','Básico'),(3,1,250,275,9,1,'nivel_3_LP9','Nível 3','Básico'),(4,2,275,300,9,1,'nivel_4_LP9','Nível 4','Proficiente'),(5,2,300,325,9,1,'nivel_5_LP9','Nível 5','Proficiente'),(6,3,325,350,9,1,'nivel_6_LP9','Nível 6','Avançado'),(7,3,350,375,9,1,'nivel_7_LP9','Nível 7','Avançado'),(8,3,375,400,9,1,'nivel_8_LP9','Nível 8','Avançado'),(0,0,0,200,9,2,'nivel_0_MT9','Abaixo do Nível 1','Insuficiente'),(1,0,200,225,9,2,'nivel_1_MT9','Nível 1','Insuficiente'),(2,1,225,250,9,2,'nivel_2_MT9','Nível 2','Básico'),(3,1,250,275,9,2,'nivel_3_MT9','Nível 3','Básico'),(4,1,275,300,9,2,'nivel_4_MT9','Nível 4','Básico'),(5,2,300,325,9,2,'nivel_5_MT9','Nível 5','Proficiente'),(6,2,325,350,9,2,'nivel_6_MT9','Nível 6','Proficiente'),(7,3,350,375,9,2,'nivel_7_MT9','Nível 7','Avançado'),(8,3,375,400,9,2,'nivel_8_MT9','Nível 8','Avançado'),(9,3,400,425,9,2,'nivel_9_MT9','Nível 9','Avançado');
/*!40000 ALTER TABLE `level` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-02-11 17:27:00
