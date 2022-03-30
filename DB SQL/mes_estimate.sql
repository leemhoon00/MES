-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: 192.168.0.115    Database: mes
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `estimate`
--

DROP TABLE IF EXISTS `estimate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estimate` (
  `et_id` varchar(45) NOT NULL,
  `degree` int NOT NULL,
  `et_com_id` varchar(45) DEFAULT NULL,
  `et_price` int DEFAULT NULL,
  `et_explain` varchar(1024) DEFAULT NULL,
  `et_date` datetime DEFAULT NULL,
  PRIMARY KEY (`et_id`,`degree`),
  KEY `et_com_id_idx` (`et_com_id`),
  CONSTRAINT `et_com_id` FOREIGN KEY (`et_com_id`) REFERENCES `company` (`com_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estimate`
--

LOCK TABLES `estimate` WRITE;
/*!40000 ALTER TABLE `estimate` DISABLE KEYS */;
INSERT INTO `estimate` VALUES ('1',2,'디팜스',300000,'ㄴㄷ','2022-01-11 11:00:00'),('1',3,'디팜스',300000,'ㄴㄷ','2022-02-04 13:48:42'),('53',1,'삼성전기',200000,'테스트','2022-02-22 11:00:00'),('53',2,'삼성전기',200000,'테스트','2022-02-03 17:38:38'),('53',3,'삼성전기',3333,'테스트','2022-02-03 17:47:06'),('53',4,'삼성전기',3333,'테스트','2022-02-04 10:46:50'),('53',5,'삼성전기',3333,'테스트','2022-02-07 13:01:03'),('53',6,'삼성전기',3333,'테스트','2022-02-07 13:02:47'),('53',7,'삼성전기',3333,'테스트','2022-02-07 13:06:41'),('53',8,'삼성전기',3333,'테스트','2022-02-07 16:11:33'),('53',9,'삼성전기',3333,'테스트','2022-02-09 12:10:20'),('54',1,'재영',124124214,'dafsfasd','2022-02-04 14:21:03'),('54',2,'재영',124124214,'dafsfasd','2022-02-04 14:48:34'),('54',3,'재영',124124214,'dafsfasd','2022-02-07 10:18:35'),('54',4,'재영',124124214,'dafsfasd','2022-02-07 10:47:34'),('54',5,'재영',124124214,'dafsfasd','2022-02-07 10:55:31'),('54',6,'재영',124124214,'dafsfasd','2022-02-07 13:05:32'),('54',7,'재영',124124214,'dafsfasd','2022-02-07 13:09:37'),('54',8,'재영',124124214,'dafsfasd','2022-02-07 15:59:03'),('54',9,'재영',124124214,'dafsfasd','2022-02-07 15:59:14'),('54',10,'재영',124124214,'dafsfasd','2022-02-07 16:00:58'),('54',11,'재영',124124214,'dafsfasd','2022-02-07 16:06:36'),('54',12,'재영',124124214,'dafsfasd','2022-02-07 16:07:57'),('54',13,'재영',124124214,'dafsfasd','2022-02-07 16:08:12'),('54',14,'재영',124124214,'dafsfasd','2022-02-07 16:08:25'),('54',15,'재영',124124214,'dafsfasd','2022-02-07 16:08:52'),('54',16,'재영',124124214,'dafsfasd','2022-02-07 16:11:42'),('54',17,'재영',124124214,'dafsfasd','2022-02-07 16:12:22'),('54',18,'재영',21,'dafsfasd','2022-02-07 16:14:08'),('54',19,'재영',21,'dafsfasd','2022-02-07 16:14:31'),('54',20,'재영',21,'dafsfasd','2022-02-07 16:14:46'),('54',21,'재영',522,'dafsfasd','2022-02-07 16:16:44'),('54',22,'재영',522,'dafsfasd','2022-02-07 16:25:23'),('54',23,'재영',21,'dafsfasd','2022-02-07 17:42:01'),('54',24,'재영',21,'dafsfasd','2022-02-07 17:45:09'),('54',25,'재영',21,'dafsfasd','2022-02-07 17:46:27'),('54',26,'재영',21,'dafsfasd','2022-02-07 17:47:19'),('54',27,'재영',21,'dafsfasd','2022-02-08 15:48:50'),('54',28,'재영',21,'dafsfasd','2022-02-08 15:50:14'),('55',1,'디팜스',555,'55','2022-02-08 15:54:19'),('56',1,'삼성전기',111111,'ㅈㄷㄹㅈㄷㄱㄹㅈㄷ','2022-02-08 17:57:47'),('56',2,'삼성전기',111111,'ㅈㄷㄹㅈㄷㄱㄹㅈㄷ','2022-02-08 17:57:59'),('56',3,'삼성전기',111111,'ㅈㄷㄹㅈㄷㄱㄹㅈㄷ','2022-02-08 18:00:11'),('56',4,'삼성전기',111111,'ㅈㄷㄹㅈㄷㄱㄹㅈㄷ','2022-02-09 14:06:44'),('56',5,'삼성전기',111111,'ㅈㄷㄹㅈㄷㄱㄹㅈㄷ','2022-02-09 14:07:03'),('57',1,'디팜스',33,'33','2022-02-09 10:59:13'),('58',1,'디팜스',55,'55','2022-02-09 10:59:21'),('59',1,'디팜스',5,'6','2022-02-09 10:59:43'),('60',1,'디팜스',3,'2','2022-02-09 10:59:46'),('61',1,'디팜스',6,'3','2022-02-09 10:59:50'),('62',1,'디팜스',3,'3','2022-02-09 11:06:26'),('62',2,'디팜스',3,'3','2022-02-09 11:07:28'),('63',1,'중앙정공',124124,'sfdadfsa','2022-02-09 15:55:29'),('63',2,'중앙정공',124124,'sfdadfsa','2022-02-11 10:28:59'),('63',3,'중앙정공',124124,'sfdadfsa','2022-02-11 10:29:16'),('63',4,'중앙정공',124124,'sfdadfsa','2022-02-11 10:29:23'),('63',5,'중앙정공',124124,'sfdadfsa','2022-02-11 10:29:29'),('63',6,'중앙정공',124124,'sfdadfsa','2022-02-11 10:29:34'),('64',1,'(주)유진상사',3534,'ㅇㄻㄴㄹ','2022-02-11 10:33:30'),('64',2,'(주)유진상사',3534,'ㅇㄻㄴㄹ','2022-02-11 10:33:46'),('64',3,'(주)유진상사',3534,'ㅇㄻㄴㄹ','2022-02-22 16:55:20'),('65',1,'(주)유진상사',444,'555','2022-02-11 10:33:54'),('66',1,'(주)유진상사',34545,'ㄻㄴㅇ','2022-02-11 10:36:22'),('66',2,'(주)유진상사',34545,'ㄻㄴㅇ','2022-02-11 10:49:25'),('66',3,'(주)유진상사',34545,'ㄻㄴㅇ','2022-02-11 10:49:33'),('67',1,'디팜스',35435,'ㅁㄴㅇㄹ','2022-02-11 13:57:52'),('68',1,'디팜스',453,'ㄴㅁㅇㄹ','2022-02-11 13:57:57'),('69',1,'디팜스',44,'ㄹㅍ','2022-02-11 13:58:07'),('69',2,'디팜스',44,'ㄹㅍ','2022-02-11 14:09:05'),('69',3,'디팜스',44,'ㄹㅍ','2022-02-11 15:28:49'),('69',4,'디팜스',44,'ㄹㅍ','2022-02-22 16:58:23'),('70',1,'(주)유진상사',32523,'ㅁㄴㄹ','2022-02-11 14:20:37'),('70',2,'(주)유진상사',32523,'ㅁㄴㄹ','2022-02-11 14:20:45'),('70',3,'(주)유진상사',32523,'ㅁㄴㄹ','2022-02-11 14:20:49'),('70',4,'디팜스',32523,'ㅁㄴㄹ','2022-02-11 15:12:16'),('70',5,'삼성전기',32523,'ㅁㄴㄹ','2022-02-11 15:12:33'),('70',6,'삼성전기',32523,'explain','2022-02-11 15:13:21'),('70',7,'삼성전기',32523,'explain','2022-02-11 15:14:27'),('70',8,'삼성전기',32523,'explain','2022-02-16 13:23:37'),('70',9,'삼성전기',32523,'explain','2022-02-16 18:18:45'),('70',10,'삼성전기',32523,'explain','2022-02-16 18:19:00'),('70',11,'삼성전기',32523,'explain\r\na','2022-02-18 17:50:58'),('70',12,'삼성전기',32523,'explain\r\na\r\nㅁㅇㅁㅇ','2022-02-21 12:24:44'),('70',13,'삼성전기',32523,'explain\r\na\r\nㅁㅇㅁㅇ','2022-02-22 16:55:07'),('70',14,'삼성전기',32523,'explain\r\na\r\nㅁㅇㅁㅇ','2022-02-22 16:57:40'),('71',1,'(주)유진전자',22,'ㅇㄹ','2022-02-22 17:04:06'),('71',2,'(주)유진전자',22,'ㅇㄹ','2022-02-22 17:04:12'),('71',3,'(주)유진전자',22,'ㅇㄹ','2022-02-22 17:07:41'),('71',4,'(주)유진전자',22,'ㅇㄹ','2022-02-22 17:09:19'),('71',5,'(주)유진전자',22,'ㅇㄹ\r\n1051','2022-02-28 12:30:28'),('72',1,'(주)유진상사',22,'','2022-02-22 17:04:52'),('72',2,'(주)유진상사',22,'','2022-02-22 17:05:00'),('72',3,'(주)유진상사',22,'','2022-02-22 17:05:04'),('72',4,'(주)유진상사',22,'','2022-02-22 17:05:55'),('72',5,'(주)유진전자',22,'','2022-02-22 17:07:02'),('72',6,'(주)유진전자',22,'','2022-02-22 17:07:21'),('72',7,'TEST1',22,'','2022-02-22 17:43:16'),('73',1,'(주)유진상사',55,'ㅎㅎ','2022-02-22 17:11:05'),('73',2,'(주)유진상사',55,'ㅎㅎ','2022-02-22 17:14:21'),('73',3,'(주)유진상사',55,'ㅎㅎ','2022-02-22 17:28:03'),('73',4,'(주)유진상사',55,'ㅎㅎ','2022-02-22 17:39:27'),('73',5,'(주)유진상사',55,'ㅎㅎ\r\n\r\nㄹ홇','2022-02-28 12:31:32'),('73',6,'(주)유진상사',55,'ㅎㅎ\r\n\r\nㄹ홇!@#ㅇ어량','2022-02-28 12:31:56'),('74',1,'(주)유진상사',11,'11','2022-02-22 17:11:11'),('74',2,'(주)유진상사',11,'11','2022-02-22 17:15:20'),('74',3,'(주)유진상사',11,'11','2022-02-22 17:41:54'),('75',1,'(주)유진전자',33,'','2022-02-22 17:40:57'),('76',1,'(주)유진상사',3333,'ㄴㅇ','2022-02-22 19:02:18'),('76',2,'(주)유진상사',3333,'ㄴㅇ','2022-02-23 11:23:50'),('76',3,'(주)유진상사',333,'ㄴㅇ','2022-02-23 11:23:57'),('76',4,'(주)유진상사',333,'ㄴㅇ','2022-02-28 10:56:19'),('76',5,'(주)유진상사',333,'ㄴㅇ\r\n15151','2022-02-28 12:30:44'),('76',6,'(주)유진상사',333,'ㄴㅇ\r\n15151\r\nㅗㅗㅗㅗ','2022-02-28 12:31:11');
/*!40000 ALTER TABLE `estimate` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-28 16:10:12