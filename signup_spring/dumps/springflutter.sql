-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: springflutter
-- ------------------------------------------------------
-- Server version	8.0.37

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
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'Dhanmondi','Dhaka'),(2,'Bonani','Dhaka'),(6,'Gulshan','Dhaka');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoryname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'efw'),(2,'egyettttttttttttttt'),(4,'wsds'),(5,'fdxfvs44444411111'),(8,'rgsd'),(9,'edsas'),(11,'asd');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `cell` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `expiry_date` date DEFAULT NULL,
  `manufacture_date` date DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `quantity` int NOT NULL,
  `stock` int NOT NULL,
  `unitprice` int NOT NULL,
  `branch_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7yh1cmuib7hnrbu4ntka4v7ro` (`branch_id`),
  KEY `FKowomku74u72o6h8q0khj7id8q` (`category_id`),
  KEY `FKhiwr0cl8fpxh1xm9y17wo5up0` (`supplier_id`),
  CONSTRAINT `FK7yh1cmuib7hnrbu4ntka4v7ro` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `FKhiwr0cl8fpxh1xm9y17wo5up0` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `FKowomku74u72o6h8q0khj7id8q` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (2,'2024-10-09','2024-09-01','wrdaw','wrdaw_18bf9d52-3efd-45fa-a1bd-2393114af66b',0,41,15,1,1,1),(3,'2024-10-09','2024-09-01','ettfgg','ettfgg_5eea8216-beb8-4035-b844-86f61d2bd8a7',0,42,80,1,1,1),(4,'2024-10-09','2024-09-01','w3rfqwt','w3rfqwt_df357178-98a4-4031-af38-01c66a4f0228',0,42,50,1,1,1),(5,'2024-10-09','2024-09-01','retf','retf_3393f3e8-40e7-41ad-8794-d8e300f5eaf7',0,43,10,1,1,1),(6,'2024-10-09','2024-09-01','wwswarwrfwrf','wwswarwrfwrf_cd592929-380c-4c17-af02-a964b39368fd',0,46,20,2,1,1);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customername` varchar(255) DEFAULT NULL,
  `discount` float NOT NULL,
  `quantity` int NOT NULL,
  `salesdate` date DEFAULT NULL,
  `totalprice` int NOT NULL,
  `sales_details_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKb6pnjoyoc51ead5sdtsixkuht` (`sales_details_id`),
  CONSTRAINT `FKb6pnjoyoc51ead5sdtsixkuht` FOREIGN KEY (`sales_details_id`) REFERENCES `sales_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (6,'Oppo',0,0,'2024-11-02',75,NULL),(7,NULL,0,0,NULL,0,NULL),(8,NULL,0,0,NULL,0,NULL),(9,'gushu',0,0,'2024-11-02',290,NULL),(10,'tyu',0,0,'2024-11-02',260,NULL),(11,NULL,0,0,NULL,0,NULL),(12,NULL,0,0,NULL,0,NULL),(13,NULL,0,0,NULL,0,NULL);
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_details`
--

DROP TABLE IF EXISTS `sales_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `discount` float NOT NULL,
  `quantity` int NOT NULL,
  `total_price` float NOT NULL,
  `unit_price` float NOT NULL,
  `product_id` int NOT NULL,
  `sales_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKfro6i33ctcc7us92q7j85j41m` (`product_id`),
  KEY `FK9k57fsnt2gom2tvbrft8p9q0x` (`sales_id`),
  CONSTRAINT `FK9k57fsnt2gom2tvbrft8p9q0x` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`),
  CONSTRAINT `FKfro6i33ctcc7us92q7j85j41m` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_details`
--

LOCK TABLES `sales_details` WRITE;
/*!40000 ALTER TABLE `sales_details` DISABLE KEYS */;
INSERT INTO `sales_details` VALUES (1,0,5,75,15,2,6),(2,0,2,160,80,3,9),(3,0,3,30,10,5,9),(4,0,2,100,50,4,9),(5,0,2,160,80,3,10),(6,0,2,100,50,4,10);
/*!40000 ALTER TABLE `sales_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_product`
--

DROP TABLE IF EXISTS `sales_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_product` (
  `sales_id` int NOT NULL,
  `product_id` int NOT NULL,
  KEY `FK7dl4fmr89kvli7uaj1u19306i` (`product_id`),
  KEY `FK18ebowds3h9totm6kall9ovbh` (`sales_id`),
  CONSTRAINT `FK18ebowds3h9totm6kall9ovbh` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`),
  CONSTRAINT `FK7dl4fmr89kvli7uaj1u19306i` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_product`
--

LOCK TABLES `sales_product` WRITE;
/*!40000 ALTER TABLE `sales_product` DISABLE KEYS */;
INSERT INTO `sales_product` VALUES (6,2),(9,3),(9,5),(9,4),(10,3),(10,4);
/*!40000 ALTER TABLE `sales_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `cell` int NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'wdr',123,'ergtye@gr.yt','ryr=========='),(5,'ttgyrt',86756,'ryy@eww.jtg','tewrw');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_logged_out` bit(1) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKj8rfw4x0wjjyibfqq566j4qng` (`user_id`),
  CONSTRAINT `FKj8rfw4x0wjjyibfqq566j4qng` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES (1,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMDQ2MDQwLCJleHAiOjE3MzAxMzI0NDB9.DjuYFPLBUegz3p15FCt-pwZz6U2Gh8DP7nsrD99hhck0nx1iiEttRYjB2oiKSQRs',1),(2,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMDQ2MTU3LCJleHAiOjE3MzAxMzI1NTd9.Nn2IL5CV-2aRIP78k7NyTwiGIblvw7_ZJRJEWW0hRe-CIWWhhm5WikMqcTR1xQbo',1),(3,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMDUzMDY1LCJleHAiOjE3MzAxMzk0NjV9.yuBPPL1hMzgBkioqtag5WcRR8CnvsXRGpYq8rX7BdtE8btOlGKUV3htmRpRNby1i',1),(4,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMDUzMTYwLCJleHAiOjE3MzAxMzk1NjB9.pxnwzPyhHhds20xYJJ4G7LRGUb4A_XfF-ZltZv_jOMU99aySzrHAp4SCWARRAzgs',1),(5,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMDg1MTIxLCJleHAiOjE3MzAxNzE1MjF9.EZBG6jPmXtk40eIV5Ojp-EQ1jiOM9DRmssONX5eu-qt2mDGsgcuUPpm9uCeoRwnw',1),(6,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMjIwMzc3LCJleHAiOjE3MzAzMDY3Nzd9.lkSdy8qX88Uy4GUCblrVlZZk6cXhyT7XWecpknu2zMAskIPWQjeXnjOofB8fbpJq',1),(7,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMjY5MzgzLCJleHAiOjE3MzAzNTU3ODN9.c0VUEXLtBG4rVWJFHWocNbDZXk1GcbY-IJzB7D2Yf_rKzgrMm-YbNRb_FHuk92aM',1),(8,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMjcwOTExLCJleHAiOjE3MzAzNTczMTF9.lBqzmA7pQt_FMNtTzfmXGohtHGo9pYoS-e3rNSa8B_ChDv6G-c_FN-D6GMq-_ia0',1),(9,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMjcxMDk5LCJleHAiOjE3MzAzNTc0OTl9.Fmc-DmMLNkWNnj7GlltytBFixra_i-7ZiQxWto7YNx5wtYYy894YIKDlX7RqgDb0',1),(10,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMjcxMjc1LCJleHAiOjE3MzAzNTc2NzV9.hn92svLcJ31y7zijcvG4og30Z3HnYnm6N0mfaoqzLT8Y56o0lglnDnIyP--tySWp',1),(11,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMjcxODczLCJleHAiOjE3MzAzNTgyNzN9.KjNfHgN7fh57UpRusVOiZG7EfPTEgmqwOV5DQwchkh9KFfQMqIQAet55s4AB0LnZ',1),(12,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IlVTRVIiLCJpYXQiOjE3MzAzOTIxMjgsImV4cCI6MTczMDQ3ODUyOH0.DARw7ZP60M7Vk_MLtu4VOW5zi1a7UyhkuTSufYoBOQbupAzWRT-SSGE8mb9EFaMe',2),(13,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiVVNFUiIsImlhdCI6MTczMDM5MjIwOSwiZXhwIjoxNzMwNDc4NjA5fQ.zw8dRCSvzQSL8JNtmZS1wTPxuMq5UKwoyhPlMeY5p0_XGNzxnGVuC-DyuOWjL8Vd',3),(14,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkyMzM3LCJleHAiOjE3MzA0Nzg3Mzd9.GolURx8NWyQmyrwpThqLWY6GXLUra4ZGcfcCadkasoA5-N5QgkXdZ10zvjJPVg6V',2),(15,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyMzc1LCJleHAiOjE3MzA0Nzg3NzV9.eBSGT77NjnTpvsCvmz3txlCZWql1UI3EekeoUAsx1ZSwC6X2idY5VLsZKMvmV89p',1),(16,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiUEhBUk1BQ0lTVCIsImlhdCI6MTczMDM5MjQxMSwiZXhwIjoxNzMwNDc4ODExfQ.7t0rENspzS1ZmagZYMx9l4QPivKs1BzQJ0oszFyRvbc2hOpkfzGiDku11FObVkbC',3),(17,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiUEhBUk1BQ0lTVCIsImlhdCI6MTczMDM5MjQyMiwiZXhwIjoxNzMwNDc4ODIyfQ.05t21WJlBr1kcq1lSozY7TwccoWyP8vp-Ir6j9sWMz8tt_lY-LFBoTyYAmQqZsN1',3),(18,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiUEhBUk1BQ0lTVCIsImlhdCI6MTczMDM5MjQyMywiZXhwIjoxNzMwNDc4ODIzfQ.hnbrcPgSnDtaCaa4bcfdG49oAhdC8WGpOZ8C1quf-YbNmKXRo7hhLih4qyiBSqWH',3),(19,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiUEhBUk1BQ0lTVCIsImlhdCI6MTczMDM5MjYwMSwiZXhwIjoxNzMwNDc5MDAxfQ.KpmdK9QGGfcAGntHlMXh-OQYqzIcNQpjZ98EASXY2V6D8xopsFi2zW3fbSydwAem',3),(20,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyNzIzLCJleHAiOjE3MzA0NzkxMjN9.Vu5T61WUBIwzEnpFdUZhGcD4thONlDG3UGeZwppdDM4hIJZQbLeM_4pILxT10nM-',1),(21,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyNzkxLCJleHAiOjE3MzA0NzkxOTF9.R5mnYco02qDvhN0gmhZqTxFELkm26VE4puomy-sVCG3eivXVm6oHziFEOnoYIrtV',1),(22,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyODc0LCJleHAiOjE3MzA0NzkyNzR9.2lpOHNrDmDFCG9HIk4CcNTL1QqcMzDeV8KrEf1nIyNHGtEqwbkSoHm_Z3xiVPZg8',1),(23,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyODc2LCJleHAiOjE3MzA0NzkyNzZ9.3YV5CpqrADO0GT0wjgttG1vyRRrvsMJUdK34tfysv-TfpfFYnwb3Eqpjlh6_iAph',1),(24,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyODc3LCJleHAiOjE3MzA0NzkyNzd9.V4TTMA2jGTfVyClfDmVP8TxIhDzRY3Aj2MdgVgBnRDrVxsf30ry5CDzR_kuPjPFF',1),(25,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyODc3LCJleHAiOjE3MzA0NzkyNzd9.V4TTMA2jGTfVyClfDmVP8TxIhDzRY3Aj2MdgVgBnRDrVxsf30ry5CDzR_kuPjPFF',1),(26,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyODc3LCJleHAiOjE3MzA0NzkyNzd9.V4TTMA2jGTfVyClfDmVP8TxIhDzRY3Aj2MdgVgBnRDrVxsf30ry5CDzR_kuPjPFF',1),(27,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjdnZ2YmpqNzU1QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzkyODg1LCJleHAiOjE3MzA0NzkyODV9.B7Hg0Ay2wOg7qDWKzeI4v_VHSv1pVnlnzuYrlVATeEWnp77GgTUqAcqf-R-Jqbvr',1),(28,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMDA2LCJleHAiOjE3MzA0Nzk0MDZ9.N6_E8XewDIgrtV_P3olR9rAu8CUPD_zsgH6szsywRkOG59ROmCSZRhz-KsmYxpXr',2),(29,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMDA3LCJleHAiOjE3MzA0Nzk0MDd9.qVg70CG9HX_XbxdLd1d3V-mhCNplZUufuCvk-CSODf43SWVKK7ExInUufQNqAWl1',2),(30,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMDA4LCJleHAiOjE3MzA0Nzk0MDh9.RehBrwAA3O_fqM2Bcu4lV5zmqTB3nkYrWQmkV9u-2HvIoMDkKztS4BMDqsXZ0ZX7',2),(31,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMDA4LCJleHAiOjE3MzA0Nzk0MDh9.RehBrwAA3O_fqM2Bcu4lV5zmqTB3nkYrWQmkV9u-2HvIoMDkKztS4BMDqsXZ0ZX7',2),(32,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiUEhBUk1BQ0lTVCIsImlhdCI6MTczMDM5MzA1MCwiZXhwIjoxNzMwNDc5NDUwfQ.P4wAT_I-61V5uD9xBSmMXb4f6YeHQZxuWutQ61lHKYLEu14cySGdhu-n0QryzRBk',3),(33,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZHRvd2hpZHVsYTQ2MEBnbWFpbC5jb20iLCJyb2xlIjoiUEhBUk1BQ0lTVCIsImlhdCI6MTczMDM5MzIwNiwiZXhwIjoxNzMwNDc5NjA2fQ.7TyeIW_tuI38bGwOEFhCKuHsnfS_1St08_IfUSBHM4ELXev3j0WsCyn_hRM9MylX',3),(34,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjkxLCJleHAiOjE3MzA0Nzk2OTF9.Dj_-SOuBWjcwfBf9LZmMhLTfHOu6wayfXOaJ62sxs9mWEBkCEKRvAIrLhmAGPet0',2),(35,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjk3LCJleHAiOjE3MzA0Nzk2OTd9.pUXEsNsNMDsUry8bvcy9Q3nCSd0GWhkLxlHzX2szqMXEhR3ri55HAwpsa8smc0Zc',2),(36,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjk4LCJleHAiOjE3MzA0Nzk2OTh9.1nIqnn4y1fVgMhTfVfmlVpDTU_haJRhetAeRTx_FeO4UKAran_xfGq0MGm0bDaS6',2),(37,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjk4LCJleHAiOjE3MzA0Nzk2OTh9.1nIqnn4y1fVgMhTfVfmlVpDTU_haJRhetAeRTx_FeO4UKAran_xfGq0MGm0bDaS6',2),(38,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjk4LCJleHAiOjE3MzA0Nzk2OTh9.1nIqnn4y1fVgMhTfVfmlVpDTU_haJRhetAeRTx_FeO4UKAran_xfGq0MGm0bDaS6',2),(39,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjk5LCJleHAiOjE3MzA0Nzk2OTl9.m8ZDiI_ezTmTaEBcRQDMd2DDqcwwiZ1A12qhnQ4bFnRIwNmNjxIZJ9JXIlhyilsR',2),(40,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzMjk5LCJleHAiOjE3MzA0Nzk2OTl9.m8ZDiI_ezTmTaEBcRQDMd2DDqcwwiZ1A12qhnQ4bFnRIwNmNjxIZJ9JXIlhyilsR',2),(41,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwMzkzNDAzLCJleHAiOjE3MzA0Nzk4MDN9.EANlbbJQifvnxzJ_gfNv0U4DpNj3CiNMtq0XQJTos4r0puWDk6ZlIF-Uy1fXn8Dc',2),(42,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwNTE3MDI5LCJleHAiOjE3MzA2MDM0Mjl9.oKtUxzRoyDolhYobMuIZXcCc6kAks0XT2AwrvHSSVRz1PxmhzN-6PYKqiLyjgzO9',2),(43,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwNTI1MDc5LCJleHAiOjE3MzA2MTE0Nzl9.-VboWmTD0N-0MpPuectH166v4sLbWZ1Teouvh9WU-FowBy68r2gJL-owIdSwScIH',2),(44,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhbGFtbWR0b3doaWR1bDlAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzMwNTI1Mzc5LCJleHAiOjE3MzA2MTE3Nzl9.az0YLFFiydS9CUKRGyvnloyDhwstk_CvTDY1tV1LBuJpMK2AVLNrCIxkAHl11RIM',2);
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cell` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','PHARMACIST','USER') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  UNIQUE KEY `UK3wfgv34acy32imea493ekogs5` (`cell`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,_binary '','efgts','48945','2024-10-31','cvvvbjj755@gmail.com','Male',NULL,'Towhid','$2a$10$raCbLKrIOaXhsrDn5.LJqOmqOPcPUJgIbXiqpOB9eniYq1j7GJfaq','USER'),(2,_binary '','rtyr','663546','2024-10-14','alammdtowhidul9@gmail.com','Male',NULL,'gtse','$2a$10$UPn9fJXNbxpwjps9ha68k.6juI4r.GIuBP4fYhClYDD59zYSuRdlW','ADMIN'),(3,_binary '','fws','484525','2024-10-02','mdtowhidula460@gmail.com','Male',NULL,'gewyrfg','$2a$10$DJP25XTo1nwwnSp3dFECS.u63ne/XhYA0Lw1gXszSGQrYR4q9nWSK','PHARMACIST');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-02 13:30:48
