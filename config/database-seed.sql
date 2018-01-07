-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: craft
-- ------------------------------------------------------
-- Server version	5.7.20

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
-- Table structure for table `assetindexdata`
--

DROP TABLE IF EXISTS `assetindexdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `inProgress` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assetindexdata_sessionId_volumeId_idx` (`sessionId`,`volumeId`),
  KEY `assetindexdata_volumeId_idx` (`volumeId`),
  CONSTRAINT `assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetindexdata`
--

LOCK TABLES `assetindexdata` WRITE;
/*!40000 ALTER TABLE `assetindexdata` DISABLE KEYS */;
/*!40000 ALTER TABLE `assetindexdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(13) DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assets_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `assets_folderId_idx` (`folderId`),
  KEY `assets_volumeId_idx` (`volumeId`),
  CONSTRAINT `assets_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assettransformindex`
--

DROP TABLE IF EXISTS `assettransformindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetId` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) NOT NULL DEFAULT '0',
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assettransformindex_volumeId_assetId_location_idx` (`volumeId`,`assetId`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assettransformindex`
--

LOCK TABLES `assettransformindex` WRITE;
/*!40000 ALTER TABLE `assettransformindex` DISABLE KEYS */;
/*!40000 ALTER TABLE `assettransformindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assettransforms`
--

DROP TABLE IF EXISTS `assettransforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `mode` enum('stretch','fit','crop') NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') NOT NULL DEFAULT 'center-center',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `interlace` enum('none','line','plane','partition') NOT NULL DEFAULT 'none',
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assettransforms`
--

LOCK TABLES `assettransforms` WRITE;
/*!40000 ALTER TABLE `assettransforms` DISABLE KEYS */;
/*!40000 ALTER TABLE `assettransforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `categories_groupId_idx` (`groupId`),
  CONSTRAINT `categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categories_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorygroups`
--

DROP TABLE IF EXISTS `categorygroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `categorygroups_handle_unq_idx` (`handle`),
  KEY `categorygroups_structureId_idx` (`structureId`),
  KEY `categorygroups_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorygroups`
--

LOCK TABLES `categorygroups` WRITE;
/*!40000 ALTER TABLE `categorygroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorygroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorygroups_sites`
--

DROP TABLE IF EXISTS `categorygroups_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorygroups_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_sites_groupId_siteId_unq_idx` (`groupId`,`siteId`),
  KEY `categorygroups_sites_siteId_idx` (`siteId`),
  CONSTRAINT `categorygroups_sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categorygroups_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorygroups_sites`
--

LOCK TABLES `categorygroups_sites` WRITE;
/*!40000 ALTER TABLE `categorygroups_sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorygroups_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `content_siteId_idx` (`siteId`),
  KEY `content_title_idx` (`title`),
  CONSTRAINT `content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content`
--

LOCK TABLES `content` WRITE;
/*!40000 ALTER TABLE `content` DISABLE KEYS */;
INSERT INTO `content` VALUES (1,1,1,NULL,'2018-01-06 11:01:32','2018-01-06 11:01:32','5a89bcd3-6f58-4d32-8b6e-6e4765c0c82d');
/*!40000 ALTER TABLE `content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_assetindexdata`
--

DROP TABLE IF EXISTS `craft_assetindexdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `inProgress` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_assetindexdata_sessionId_volumeId_idx` (`sessionId`,`volumeId`),
  KEY `craft_assetindexdata_volumeId_idx` (`volumeId`),
  CONSTRAINT `craft_assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `craft_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_assetindexdata`
--

LOCK TABLES `craft_assetindexdata` WRITE;
/*!40000 ALTER TABLE `craft_assetindexdata` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_assetindexdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_assets`
--

DROP TABLE IF EXISTS `craft_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(13) DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assets_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `craft_assets_folderId_idx` (`folderId`),
  KEY `craft_assets_volumeId_idx` (`volumeId`),
  CONSTRAINT `craft_assets_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `craft_volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_assets_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_assets_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `craft_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_assets`
--

LOCK TABLES `craft_assets` WRITE;
/*!40000 ALTER TABLE `craft_assets` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_assettransformindex`
--

DROP TABLE IF EXISTS `craft_assettransformindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetId` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) NOT NULL DEFAULT '0',
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_assettransformindex_volumeId_assetId_location_idx` (`volumeId`,`assetId`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_assettransformindex`
--

LOCK TABLES `craft_assettransformindex` WRITE;
/*!40000 ALTER TABLE `craft_assettransformindex` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_assettransformindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_assettransforms`
--

DROP TABLE IF EXISTS `craft_assettransforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `mode` enum('stretch','fit','crop') NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') NOT NULL DEFAULT 'center-center',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `interlace` enum('none','line','plane','partition') NOT NULL DEFAULT 'none',
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `craft_assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_assettransforms`
--

LOCK TABLES `craft_assettransforms` WRITE;
/*!40000 ALTER TABLE `craft_assettransforms` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_assettransforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_categories`
--

DROP TABLE IF EXISTS `craft_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_categories_groupId_idx` (`groupId`),
  CONSTRAINT `craft_categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_categories_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_categories`
--

LOCK TABLES `craft_categories` WRITE;
/*!40000 ALTER TABLE `craft_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_categorygroups`
--

DROP TABLE IF EXISTS `craft_categorygroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `craft_categorygroups_handle_unq_idx` (`handle`),
  KEY `craft_categorygroups_structureId_idx` (`structureId`),
  KEY `craft_categorygroups_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `craft_categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `craft_structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_categorygroups`
--

LOCK TABLES `craft_categorygroups` WRITE;
/*!40000 ALTER TABLE `craft_categorygroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_categorygroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_categorygroups_sites`
--

DROP TABLE IF EXISTS `craft_categorygroups_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_categorygroups_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_categorygroups_sites_groupId_siteId_unq_idx` (`groupId`,`siteId`),
  KEY `craft_categorygroups_sites_siteId_idx` (`siteId`),
  CONSTRAINT `craft_categorygroups_sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_categorygroups_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_categorygroups_sites`
--

LOCK TABLES `craft_categorygroups_sites` WRITE;
/*!40000 ALTER TABLE `craft_categorygroups_sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_categorygroups_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_content`
--

DROP TABLE IF EXISTS `craft_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `craft_content_siteId_idx` (`siteId`),
  KEY `craft_content_title_idx` (`title`),
  CONSTRAINT `craft_content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_content`
--

LOCK TABLES `craft_content` WRITE;
/*!40000 ALTER TABLE `craft_content` DISABLE KEYS */;
INSERT INTO `craft_content` VALUES (1,1,1,NULL,'2018-01-06 10:45:38','2018-01-06 10:45:38','c6708e73-1048-4706-b336-1937ffd30a63');
/*!40000 ALTER TABLE `craft_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_craftidtokens`
--

DROP TABLE IF EXISTS `craft_craftidtokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_craftidtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `accessToken` text NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_craftidtokens_userId_fk` (`userId`),
  CONSTRAINT `craft_craftidtokens_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_craftidtokens`
--

LOCK TABLES `craft_craftidtokens` WRITE;
/*!40000 ALTER TABLE `craft_craftidtokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_craftidtokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_deprecationerrors`
--

DROP TABLE IF EXISTS `craft_deprecationerrors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `fingerprint` varchar(255) NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `traces` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_deprecationerrors`
--

LOCK TABLES `craft_deprecationerrors` WRITE;
/*!40000 ALTER TABLE `craft_deprecationerrors` DISABLE KEYS */;
INSERT INTO `craft_deprecationerrors` VALUES (1,'environmentVariables','/data/craft/vendor/craftcms/cms/src/services/Config.php:102','2018-01-06 10:53:54','/data/craft/vendor/craftcms/cms/src/services/Config.php',102,'The environmentVariables config setting has been renamed to aliases.','[{\"objectClass\":\"craft\\\\services\\\\Deprecator\",\"file\":\"/data/craft/vendor/craftcms/cms/src/config/GeneralConfig.php\",\"line\":776,\"class\":\"craft\\\\services\\\\Deprecator\",\"method\":\"log\",\"args\":\"\\\"environmentVariables\\\", \\\"The environmentVariables config setting has been renamed to alia...\\\"\"},{\"objectClass\":\"craft\\\\config\\\\GeneralConfig\",\"file\":\"/data/craft/vendor/craftcms/cms/src/services/Config.php\",\"line\":102,\"class\":\"craft\\\\config\\\\GeneralConfig\",\"method\":\"__construct\",\"args\":\"[\\\"tablePrefix\\\" => \\\"craft\\\", \\\"siteUrl\\\" => \\\"//localhost\\\", \\\"environmentVariables\\\" => [\\\"baseUrl\\\" => \\\"//localhost\\\", \\\"assetsBaseUrl\\\" => 0], \\\"defaultWeekStartDay\\\" => 0, ...]\"},{\"objectClass\":\"craft\\\\services\\\\Config\",\"file\":\"/data/craft/vendor/craftcms/cms/src/services/Config.php\",\"line\":148,\"class\":\"craft\\\\services\\\\Config\",\"method\":\"getConfigSettings\",\"args\":\"\\\"general\\\"\"},{\"objectClass\":\"craft\\\\services\\\\Config\",\"file\":\"/data/craft/vendor/craftcms/cms/src/config/app/web.php\",\"line\":19,\"class\":\"craft\\\\services\\\\Config\",\"method\":\"getGeneral\",\"args\":null},{\"objectClass\":null,\"file\":null,\"line\":null,\"class\":null,\"method\":\"{closure}\",\"args\":null},{\"objectClass\":null,\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":501,\"class\":null,\"method\":\"call_user_func_array\",\"args\":\"Closure, []\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/BaseYii.php\",\"line\":351,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"invoke\",\"args\":\"Closure, []\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/yiisoft/yii2/di/ServiceLocator.php\",\"line\":137,\"class\":\"yii\\\\BaseYii\",\"method\":\"createObject\",\"args\":\"Closure\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Module.php\",\"line\":724,\"class\":\"yii\\\\di\\\\ServiceLocator\",\"method\":\"get\",\"args\":\"\\\"request\\\", true\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/web/Application.php\",\"line\":160,\"class\":\"yii\\\\base\\\\Module\",\"method\":\"get\",\"args\":\"\\\"request\\\"\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/web/Application.php\",\"line\":65,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"getRequest\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Application.php\",\"line\":273,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"bootstrap\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/craftcms/cms/src/web/Application.php\",\"line\":85,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"init\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/BaseObject.php\",\"line\":108,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"init\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Application.php\",\"line\":206,\"class\":\"yii\\\\base\\\\BaseObject\",\"method\":\"__construct\",\"args\":\"[\\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", \\\"name\\\" => \\\"Craft CMS\\\", ...]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/craftcms/cms/src/web/Application.php\",\"line\":75,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"__construct\",\"args\":\"[\\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", \\\"name\\\" => \\\"Craft CMS\\\", ...]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":null,\"line\":null,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"__construct\",\"args\":\"[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":\"ReflectionClass\",\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":381,\"class\":\"ReflectionClass\",\"method\":\"newInstanceArgs\",\"args\":\"[[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]]\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":156,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"build\",\"args\":\"\\\"craft\\\\web\\\\Application\\\", [], [\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/BaseYii.php\",\"line\":349,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"get\",\"args\":\"\\\"craft\\\\web\\\\Application\\\", [], [\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/craftcms/cms/bootstrap/bootstrap.php\",\"line\":243,\"class\":\"yii\\\\BaseYii\",\"method\":\"createObject\",\"args\":\"[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/craftcms/cms/bootstrap/web.php\",\"line\":42,\"class\":null,\"method\":\"require\",\"args\":\"\\\"/data/craft/vendor/craftcms/cms/bootstrap/bootstrap.php\\\"\"},{\"objectClass\":null,\"file\":\"/data/craft/web/index.php\",\"line\":20,\"class\":null,\"method\":\"require\",\"args\":\"\\\"/data/craft/vendor/craftcms/cms/bootstrap/web.php\\\"\"}]','2018-01-06 10:53:54','2018-01-06 10:53:54','9cf025ba-0fe8-4fdd-aa81-632a35db7494'),(2,'validation.key','/data/craft/vendor/craftcms/cms/src/services/Config.php:148','2018-01-06 10:53:54','/data/craft/vendor/craftcms/cms/src/services/Config.php',148,'The auto-generated validation key stored at /data/craft/storage/runtime/validation.key has been deprecated. Copy its value to the “securityKey” config setting in config/general.php.','[{\"objectClass\":\"craft\\\\services\\\\Deprecator\",\"file\":\"/data/craft/vendor/craftcms/cms/src/services/Config.php\",\"line\":120,\"class\":\"craft\\\\services\\\\Deprecator\",\"method\":\"log\",\"args\":\"\\\"validation.key\\\", \\\"The auto-generated validation key stored at /data/craft/storage/...\\\"\"},{\"objectClass\":\"craft\\\\services\\\\Config\",\"file\":\"/data/craft/vendor/craftcms/cms/src/services/Config.php\",\"line\":148,\"class\":\"craft\\\\services\\\\Config\",\"method\":\"getConfigSettings\",\"args\":\"\\\"general\\\"\"},{\"objectClass\":\"craft\\\\services\\\\Config\",\"file\":\"/data/craft/vendor/craftcms/cms/src/config/app/web.php\",\"line\":19,\"class\":\"craft\\\\services\\\\Config\",\"method\":\"getGeneral\",\"args\":null},{\"objectClass\":null,\"file\":null,\"line\":null,\"class\":null,\"method\":\"{closure}\",\"args\":null},{\"objectClass\":null,\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":501,\"class\":null,\"method\":\"call_user_func_array\",\"args\":\"Closure, []\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/BaseYii.php\",\"line\":351,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"invoke\",\"args\":\"Closure, []\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/yiisoft/yii2/di/ServiceLocator.php\",\"line\":137,\"class\":\"yii\\\\BaseYii\",\"method\":\"createObject\",\"args\":\"Closure\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Module.php\",\"line\":724,\"class\":\"yii\\\\di\\\\ServiceLocator\",\"method\":\"get\",\"args\":\"\\\"request\\\", true\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/web/Application.php\",\"line\":160,\"class\":\"yii\\\\base\\\\Module\",\"method\":\"get\",\"args\":\"\\\"request\\\"\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/web/Application.php\",\"line\":65,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"getRequest\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Application.php\",\"line\":273,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"bootstrap\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/craftcms/cms/src/web/Application.php\",\"line\":85,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"init\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/BaseObject.php\",\"line\":108,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"init\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Application.php\",\"line\":206,\"class\":\"yii\\\\base\\\\BaseObject\",\"method\":\"__construct\",\"args\":\"[\\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", \\\"name\\\" => \\\"Craft CMS\\\", ...]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/craftcms/cms/src/web/Application.php\",\"line\":75,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"__construct\",\"args\":\"[\\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", \\\"name\\\" => \\\"Craft CMS\\\", ...]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":null,\"line\":null,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"__construct\",\"args\":\"[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":\"ReflectionClass\",\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":381,\"class\":\"ReflectionClass\",\"method\":\"newInstanceArgs\",\"args\":\"[[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]]\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":156,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"build\",\"args\":\"\\\"craft\\\\web\\\\Application\\\", [], [\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/BaseYii.php\",\"line\":349,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"get\",\"args\":\"\\\"craft\\\\web\\\\Application\\\", [], [\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/craftcms/cms/bootstrap/bootstrap.php\",\"line\":243,\"class\":\"yii\\\\BaseYii\",\"method\":\"createObject\",\"args\":\"[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/craftcms/cms/bootstrap/web.php\",\"line\":42,\"class\":null,\"method\":\"require\",\"args\":\"\\\"/data/craft/vendor/craftcms/cms/bootstrap/bootstrap.php\\\"\"},{\"objectClass\":null,\"file\":\"/data/craft/web/index.php\",\"line\":20,\"class\":null,\"method\":\"require\",\"args\":\"\\\"/data/craft/vendor/craftcms/cms/bootstrap/web.php\\\"\"}]','2018-01-06 10:53:54','2018-01-06 10:53:54','cdb64775-cb78-4fef-b7c3-5df7dbf76ade');
/*!40000 ALTER TABLE `craft_deprecationerrors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_elementindexsettings`
--

DROP TABLE IF EXISTS `craft_elementindexsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_elementindexsettings`
--

LOCK TABLES `craft_elementindexsettings` WRITE;
/*!40000 ALTER TABLE `craft_elementindexsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_elementindexsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_elements`
--

DROP TABLE IF EXISTS `craft_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_elements_fieldLayoutId_idx` (`fieldLayoutId`),
  KEY `craft_elements_type_idx` (`type`),
  KEY `craft_elements_enabled_idx` (`enabled`),
  KEY `craft_elements_archived_dateCreated_idx` (`archived`,`dateCreated`),
  CONSTRAINT `craft_elements_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_elements`
--

LOCK TABLES `craft_elements` WRITE;
/*!40000 ALTER TABLE `craft_elements` DISABLE KEYS */;
INSERT INTO `craft_elements` VALUES (1,NULL,'craft\\elements\\User',1,0,'2018-01-06 10:45:38','2018-01-06 10:45:38','a7ceb33b-4692-4003-8120-a85cba574913');
/*!40000 ALTER TABLE `craft_elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_elements_sites`
--

DROP TABLE IF EXISTS `craft_elements_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_elements_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_elements_sites_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  UNIQUE KEY `craft_elements_sites_uri_siteId_unq_idx` (`uri`,`siteId`),
  KEY `craft_elements_sites_siteId_idx` (`siteId`),
  KEY `craft_elements_sites_slug_siteId_idx` (`slug`,`siteId`),
  KEY `craft_elements_sites_enabled_idx` (`enabled`),
  CONSTRAINT `craft_elements_sites_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_elements_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_elements_sites`
--

LOCK TABLES `craft_elements_sites` WRITE;
/*!40000 ALTER TABLE `craft_elements_sites` DISABLE KEYS */;
INSERT INTO `craft_elements_sites` VALUES (1,1,1,NULL,NULL,1,'2018-01-06 10:45:38','2018-01-06 10:45:38','0713f203-28fe-4b25-9f5a-7ac3a482eccf');
/*!40000 ALTER TABLE `craft_elements_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_entries`
--

DROP TABLE IF EXISTS `craft_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_entries_postDate_idx` (`postDate`),
  KEY `craft_entries_expiryDate_idx` (`expiryDate`),
  KEY `craft_entries_authorId_idx` (`authorId`),
  KEY `craft_entries_sectionId_idx` (`sectionId`),
  KEY `craft_entries_typeId_idx` (`typeId`),
  CONSTRAINT `craft_entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entries_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `craft_entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_entries`
--

LOCK TABLES `craft_entries` WRITE;
/*!40000 ALTER TABLE `craft_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_entrydrafts`
--

DROP TABLE IF EXISTS `craft_entrydrafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_entrydrafts_sectionId_idx` (`sectionId`),
  KEY `craft_entrydrafts_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `craft_entrydrafts_siteId_idx` (`siteId`),
  KEY `craft_entrydrafts_creatorId_idx` (`creatorId`),
  CONSTRAINT `craft_entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `craft_entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entrydrafts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_entrydrafts`
--

LOCK TABLES `craft_entrydrafts` WRITE;
/*!40000 ALTER TABLE `craft_entrydrafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_entrydrafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_entrytypes`
--

DROP TABLE IF EXISTS `craft_entrytypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `hasTitleField` tinyint(1) NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) DEFAULT 'Title',
  `titleFormat` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `craft_entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `craft_entrytypes_sectionId_idx` (`sectionId`),
  KEY `craft_entrytypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `craft_entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_entrytypes`
--

LOCK TABLES `craft_entrytypes` WRITE;
/*!40000 ALTER TABLE `craft_entrytypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_entrytypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_entryversions`
--

DROP TABLE IF EXISTS `craft_entryversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `siteId` int(11) NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_entryversions_sectionId_idx` (`sectionId`),
  KEY `craft_entryversions_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `craft_entryversions_siteId_idx` (`siteId`),
  KEY `craft_entryversions_creatorId_idx` (`creatorId`),
  CONSTRAINT `craft_entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `craft_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `craft_entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entryversions_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_entryversions`
--

LOCK TABLES `craft_entryversions` WRITE;
/*!40000 ALTER TABLE `craft_entryversions` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_entryversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_fieldgroups`
--

DROP TABLE IF EXISTS `craft_fieldgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_fieldgroups`
--

LOCK TABLES `craft_fieldgroups` WRITE;
/*!40000 ALTER TABLE `craft_fieldgroups` DISABLE KEYS */;
INSERT INTO `craft_fieldgroups` VALUES (1,'Common','2018-01-06 10:45:38','2018-01-06 10:45:38','481737ce-97a0-447e-9276-78f8106ee187');
/*!40000 ALTER TABLE `craft_fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_fieldlayoutfields`
--

DROP TABLE IF EXISTS `craft_fieldlayoutfields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `craft_fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `craft_fieldlayoutfields_tabId_idx` (`tabId`),
  KEY `craft_fieldlayoutfields_fieldId_idx` (`fieldId`),
  CONSTRAINT `craft_fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `craft_fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_fieldlayoutfields`
--

LOCK TABLES `craft_fieldlayoutfields` WRITE;
/*!40000 ALTER TABLE `craft_fieldlayoutfields` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_fieldlayoutfields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_fieldlayouts`
--

DROP TABLE IF EXISTS `craft_fieldlayouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_fieldlayouts`
--

LOCK TABLES `craft_fieldlayouts` WRITE;
/*!40000 ALTER TABLE `craft_fieldlayouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_fieldlayouttabs`
--

DROP TABLE IF EXISTS `craft_fieldlayouttabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `craft_fieldlayouttabs_layoutId_idx` (`layoutId`),
  CONSTRAINT `craft_fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_fieldlayouttabs`
--

LOCK TABLES `craft_fieldlayouttabs` WRITE;
/*!40000 ALTER TABLE `craft_fieldlayouttabs` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_fieldlayouttabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_fields`
--

DROP TABLE IF EXISTS `craft_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(64) NOT NULL,
  `context` varchar(255) NOT NULL DEFAULT 'global',
  `instructions` text,
  `translationMethod` varchar(255) NOT NULL DEFAULT 'none',
  `translationKeyFormat` text,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `craft_fields_groupId_idx` (`groupId`),
  KEY `craft_fields_context_idx` (`context`),
  CONSTRAINT `craft_fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_fields`
--

LOCK TABLES `craft_fields` WRITE;
/*!40000 ALTER TABLE `craft_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_globalsets`
--

DROP TABLE IF EXISTS `craft_globalsets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_globalsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `craft_globalsets_handle_unq_idx` (`handle`),
  KEY `craft_globalsets_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `craft_globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_globalsets`
--

LOCK TABLES `craft_globalsets` WRITE;
/*!40000 ALTER TABLE `craft_globalsets` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_globalsets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_info`
--

DROP TABLE IF EXISTS `craft_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(50) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `edition` smallint(6) unsigned NOT NULL,
  `timezone` varchar(30) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `on` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `fieldVersion` char(12) NOT NULL DEFAULT '000000000000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_info`
--

LOCK TABLES `craft_info` WRITE;
/*!40000 ALTER TABLE `craft_info` DISABLE KEYS */;
INSERT INTO `craft_info` VALUES (1,'3.0.0-RC4','3.0.77',0,'America/Los_Angeles','Welance',1,0,'qBcL4SzzQnyf','2018-01-06 10:45:38','2018-01-06 10:45:38','3b024ed2-a858-41bc-8843-54e737fd3577');
/*!40000 ALTER TABLE `craft_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_matrixblocks`
--

DROP TABLE IF EXISTS `craft_matrixblocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_matrixblocks_ownerId_idx` (`ownerId`),
  KEY `craft_matrixblocks_fieldId_idx` (`fieldId`),
  KEY `craft_matrixblocks_typeId_idx` (`typeId`),
  KEY `craft_matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `craft_matrixblocks_ownerSiteId_idx` (`ownerSiteId`),
  CONSTRAINT `craft_matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `craft_matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_matrixblocks`
--

LOCK TABLES `craft_matrixblocks` WRITE;
/*!40000 ALTER TABLE `craft_matrixblocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_matrixblocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_matrixblocktypes`
--

DROP TABLE IF EXISTS `craft_matrixblocktypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `craft_matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `craft_matrixblocktypes_fieldId_idx` (`fieldId`),
  KEY `craft_matrixblocktypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `craft_matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_matrixblocktypes`
--

LOCK TABLES `craft_matrixblocktypes` WRITE;
/*!40000 ALTER TABLE `craft_matrixblocktypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_matrixblocktypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_migrations`
--

DROP TABLE IF EXISTS `craft_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `type` enum('app','plugin','content') NOT NULL DEFAULT 'app',
  `name` varchar(255) NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_migrations_pluginId_idx` (`pluginId`),
  KEY `craft_migrations_type_pluginId_idx` (`type`,`pluginId`),
  CONSTRAINT `craft_migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `craft_plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_migrations`
--

LOCK TABLES `craft_migrations` WRITE;
/*!40000 ALTER TABLE `craft_migrations` DISABLE KEYS */;
INSERT INTO `craft_migrations` VALUES (1,NULL,'app','Install','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','ead72198-fc0d-4e77-bf99-e2aabaa1763b'),(2,NULL,'app','m150403_183908_migrations_table_changes','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','59c18352-c1fc-4d41-8bd6-d6f95691a379'),(3,NULL,'app','m150403_184247_plugins_table_changes','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','6ba66dab-059a-4dc1-88a3-db4e78e825e1'),(4,NULL,'app','m150403_184533_field_version','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','61028920-cba3-41aa-8cbe-f3b257e983f6'),(5,NULL,'app','m150403_184729_type_columns','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','53d76331-bc76-4488-9339-eddfdd7088da'),(6,NULL,'app','m150403_185142_volumes','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','8feb28c3-b488-4179-9b08-527a970f0658'),(7,NULL,'app','m150428_231346_userpreferences','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','84dab8b3-ae0e-4d90-adc7-c0aa7a0390d8'),(8,NULL,'app','m150519_150900_fieldversion_conversion','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','f10b79bf-0978-47e5-8e86-a1a35de0be82'),(9,NULL,'app','m150617_213829_update_email_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','4a181922-6165-4d88-8351-7ae1074f8bfd'),(10,NULL,'app','m150721_124739_templatecachequeries','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','409943ee-4359-47ee-8352-694190ba8902'),(11,NULL,'app','m150724_140822_adjust_quality_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','97e8e2d0-3292-4bf8-9898-5131e525d8ab'),(12,NULL,'app','m150815_133521_last_login_attempt_ip','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','d42db48b-04e5-47f4-999a-a31e4ab59b07'),(13,NULL,'app','m151002_095935_volume_cache_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','ae3d7603-5573-47e7-9b06-d6debf38490e'),(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','80921674-d3df-47f7-82b2-336e49334a8a'),(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','a9d592a3-7d9c-46a7-a759-515ac6916cfc'),(16,NULL,'app','m151209_000000_move_logo','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','bbe13a5f-a872-49fd-bcee-934691e8337d'),(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','6ff39910-4631-4949-9722-d248718e3bd6'),(18,NULL,'app','m151215_000000_rename_asset_permissions','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','563c7d4c-99b1-4f5d-a103-d4912bed967f'),(19,NULL,'app','m160707_000001_rename_richtext_assetsource_setting','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','f140c964-2fb2-4ba9-92e1-85463b75491a'),(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','183e1e67-32ad-41a2-89ee-43edd594a9a1'),(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','c64a686e-7198-43db-bef0-36080f1f1c25'),(22,NULL,'app','m160727_194637_column_cleanup','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','eace0718-2ba5-4542-b774-e2ac0242a5d6'),(23,NULL,'app','m160804_110002_userphotos_to_assets','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','6683b53f-0251-4cf3-846e-edcffebf9566'),(24,NULL,'app','m160807_144858_sites','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','ca928dfd-ae0b-478d-b1af-d8ab7c91924c'),(25,NULL,'app','m160829_000000_pending_user_content_cleanup','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','368ce27e-dd06-4504-9470-45873fc3bf25'),(26,NULL,'app','m160830_000000_asset_index_uri_increase','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','897a7bf9-aa33-4c99-b490-321b6189fcf1'),(27,NULL,'app','m160912_230520_require_entry_type_id','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','d66e73c4-e065-4005-b7da-8dbf360bd0d5'),(28,NULL,'app','m160913_134730_require_matrix_block_type_id','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','82b98e62-72e7-4057-846d-326a8c24ceec'),(29,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','b60fb299-8d13-4e7a-a2e7-cc41db688136'),(30,NULL,'app','m160920_231045_usergroup_handle_title_unique','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','2cb5fdd1-0cd0-4fbb-820a-195af00520cb'),(31,NULL,'app','m160925_113941_route_uri_parts','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','daf23678-889d-43a1-9007-f54867fa6cda'),(32,NULL,'app','m161006_205918_schemaVersion_not_null','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','71413a95-c048-47b6-9096-4f1b3e2572af'),(33,NULL,'app','m161007_130653_update_email_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','911f852d-f2b8-40f6-97f8-4cd6172f1c7a'),(34,NULL,'app','m161013_175052_newParentId','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','bccc6438-8d6f-40f4-9b93-815e8d3b59aa'),(35,NULL,'app','m161021_102916_fix_recent_entries_widgets','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','9ed7b37e-11ec-499d-b546-d8b09941cd06'),(36,NULL,'app','m161021_182140_rename_get_help_widget','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','4875a924-138f-49b8-878f-6e74325b1c30'),(37,NULL,'app','m161025_000000_fix_char_columns','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','eb3efb98-c1d7-4767-816d-6af8e5621995'),(38,NULL,'app','m161029_124145_email_message_languages','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','957475d2-6626-496d-9781-56ef221b8ede'),(39,NULL,'app','m161108_000000_new_version_format','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','b6434c0c-b172-47c1-a49e-480fb87cb4d1'),(40,NULL,'app','m161109_000000_index_shuffle','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','b2effc79-b002-420c-8268-bb7b14786053'),(41,NULL,'app','m161122_185500_no_craft_app','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','64cf9095-d577-4581-83a4-4369e6e3db3b'),(42,NULL,'app','m161125_150752_clear_urlmanager_cache','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','23c521c6-dc53-4b54-93bf-e07831eae063'),(43,NULL,'app','m161220_000000_volumes_hasurl_notnull','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','b9f563fc-a3c6-4723-b574-37bd68bdeeca'),(44,NULL,'app','m170114_161144_udates_permission','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','a8a7d024-6ee9-4126-a900-413f947afd5e'),(45,NULL,'app','m170120_000000_schema_cleanup','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','136cce23-cbc5-4bb2-9c19-c2a43118128c'),(46,NULL,'app','m170126_000000_assets_focal_point','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','4de58054-a340-49f6-8344-1d615472bec7'),(47,NULL,'app','m170206_142126_system_name','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','72e23c6e-2a35-4421-af00-efbd5f8c815b'),(48,NULL,'app','m170217_044740_category_branch_limits','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','d03eca6a-243d-4b35-be36-4a8c7974c201'),(49,NULL,'app','m170217_120224_asset_indexing_columns','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','8d4654c3-cc70-4f07-8d34-18958ed52ec7'),(50,NULL,'app','m170223_224012_plain_text_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','4a694c7d-1bb8-406b-ab59-d02006647ecd'),(51,NULL,'app','m170227_120814_focal_point_percentage','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','04e724bb-0007-4878-8ebf-0ff03eea7de0'),(52,NULL,'app','m170228_171113_system_messages','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','d8de8326-07a1-49ef-bec8-26b6db4353c9'),(53,NULL,'app','m170303_140500_asset_field_source_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','ff10bcea-ddd2-4ff2-88ac-3142122efd96'),(54,NULL,'app','m170306_150500_asset_temporary_uploads','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','44ad8bd9-0320-4f59-a581-f5fea2aa22f8'),(55,NULL,'app','m170414_162429_rich_text_config_setting','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','955ac7a6-4709-46af-9e1c-db1b173aec66'),(56,NULL,'app','m170523_190652_element_field_layout_ids','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','abfc9fc8-e11c-4396-9923-6fc6756181c5'),(57,NULL,'app','m170612_000000_route_index_shuffle','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','0b206639-608c-4b9a-b214-b86a3e07b792'),(58,NULL,'app','m170621_195237_format_plugin_handles','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','55850c82-6e46-4c63-b512-7bf3ee9b84d5'),(59,NULL,'app','m170630_161028_deprecation_changes','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','3a3ed072-f7c1-4ac3-8759-2c15a08d3b25'),(60,NULL,'app','m170703_181539_plugins_table_tweaks','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','4ba62856-77f9-44d0-aba8-a32e60d83035'),(61,NULL,'app','m170704_134916_sites_tables','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','26e5ccd5-8066-4d65-ab43-8d39fab4ee78'),(62,NULL,'app','m170706_183216_rename_sequences','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','01184778-fb76-4a09-b939-ccbaf8ee6ab5'),(63,NULL,'app','m170707_094758_delete_compiled_traits','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','9be2c013-05e0-4db5-b015-399693573052'),(64,NULL,'app','m170731_190138_drop_asset_packagist','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','163ce3bd-de77-444a-9c4d-5dc4c9bd132d'),(65,NULL,'app','m170810_201318_create_queue_table','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','bd74ffab-4838-4ec3-8348-07325cc5634f'),(66,NULL,'app','m170816_133741_delete_compiled_behaviors','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','c5362bf0-5fbd-454d-8e4b-57cbeeee476d'),(67,NULL,'app','m170821_180624_deprecation_line_nullable','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','f26ba292-65cc-4345-8620-9812c4b2dece'),(68,NULL,'app','m170903_192801_longblob_for_queue_jobs','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','07ea5934-98f3-4e88-8f58-41d13e5d63c5'),(69,NULL,'app','m170914_204621_asset_cache_shuffle','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','03290ee0-4e89-4450-aa9e-f35ced5b033c'),(70,NULL,'app','m171011_214115_site_groups','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','465e4511-7587-43ce-9af3-fbe17eaf4462'),(71,NULL,'app','m171012_151440_primary_site','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','5976ad43-bc4e-4e47-974f-ca44acf5dd10'),(72,NULL,'app','m171013_142500_transform_interlace','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','8218f710-4254-40b4-b0ec-99fcc54dbddb'),(73,NULL,'app','m171016_092553_drop_position_select','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','500b322d-4118-47a1-aae0-24479406ff2b'),(74,NULL,'app','m171016_221244_less_strict_translation_method','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','e4f1d919-8fe0-4d3e-8ad1-c9996369e6c4'),(75,NULL,'app','m171107_000000_assign_group_permissions','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','f8441b85-13f5-42e8-9355-36ff2f2c6275'),(76,NULL,'app','m171117_000001_templatecache_index_tune','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','0f58c669-46c1-4c2d-8f92-7ff4069aba8e'),(77,NULL,'app','m171126_105927_disabled_plugins','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','266a7f73-8fec-40c3-9fa3-44b38b3107c4'),(78,NULL,'app','m171130_214407_craftidtokens_table','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','2fbff640-803b-4105-9a8f-0566e65145e0'),(79,NULL,'app','m171202_004225_update_email_settings','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','50dab8e6-2629-448c-91c6-58611e2ad957'),(80,NULL,'app','m171204_000001_templatecache_index_tune_deux','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','8228f1fa-b833-41a5-b65e-107a42c1545b'),(81,NULL,'app','m171205_130908_remove_craftidtokens_refreshtoken_column','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','bba5a409-7550-4898-963d-839b4daa3cc3'),(82,NULL,'app','m171210_142046_fix_db_routes','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','648249ee-da84-4768-93d2-86de193e705d'),(83,NULL,'app','m171218_143135_longtext_query_column','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','0594a436-fce8-4b59-ae25-68c35b586272'),(84,NULL,'app','m171231_055546_environment_variables_to_aliases','2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','4dea9f8d-9a46-4ddc-9eb1-2f750ea9fd46');
/*!40000 ALTER TABLE `craft_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_plugins`
--

DROP TABLE IF EXISTS `craft_plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `schemaVersion` varchar(255) NOT NULL,
  `licenseKey` char(24) DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','unknown') NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_plugins_handle_unq_idx` (`handle`),
  KEY `craft_plugins_enabled_idx` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_plugins`
--

LOCK TABLES `craft_plugins` WRITE;
/*!40000 ALTER TABLE `craft_plugins` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_queue`
--

DROP TABLE IF EXISTS `craft_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` longblob NOT NULL,
  `description` text,
  `timePushed` int(11) NOT NULL,
  `ttr` int(11) NOT NULL,
  `delay` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) unsigned NOT NULL DEFAULT '1024',
  `dateReserved` datetime DEFAULT NULL,
  `timeUpdated` int(11) DEFAULT NULL,
  `progress` smallint(6) NOT NULL DEFAULT '0',
  `attempt` int(11) DEFAULT NULL,
  `fail` tinyint(1) DEFAULT '0',
  `dateFailed` datetime DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`id`),
  KEY `craft_queue_fail_timeUpdated_timePushed_idx` (`fail`,`timeUpdated`,`timePushed`),
  KEY `craft_queue_fail_timeUpdated_delay_idx` (`fail`,`timeUpdated`,`delay`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_queue`
--

LOCK TABLES `craft_queue` WRITE;
/*!40000 ALTER TABLE `craft_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_relations`
--

DROP TABLE IF EXISTS `craft_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceSiteId` int(11) DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_relations_fieldId_sourceId_sourceSiteId_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceSiteId`,`targetId`),
  KEY `craft_relations_sourceId_idx` (`sourceId`),
  KEY `craft_relations_targetId_idx` (`targetId`),
  KEY `craft_relations_sourceSiteId_idx` (`sourceSiteId`),
  CONSTRAINT `craft_relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_relations_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_relations`
--

LOCK TABLES `craft_relations` WRITE;
/*!40000 ALTER TABLE `craft_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_routes`
--

DROP TABLE IF EXISTS `craft_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) DEFAULT NULL,
  `uriParts` varchar(255) NOT NULL,
  `uriPattern` varchar(255) NOT NULL,
  `template` varchar(500) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_routes_uriPattern_idx` (`uriPattern`),
  KEY `craft_routes_siteId_idx` (`siteId`),
  CONSTRAINT `craft_routes_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_routes`
--

LOCK TABLES `craft_routes` WRITE;
/*!40000 ALTER TABLE `craft_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_searchindex`
--

DROP TABLE IF EXISTS `craft_searchindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `craft_searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_searchindex`
--

LOCK TABLES `craft_searchindex` WRITE;
/*!40000 ALTER TABLE `craft_searchindex` DISABLE KEYS */;
INSERT INTO `craft_searchindex` VALUES (1,'username',0,1,' admin '),(1,'firstname',0,1,''),(1,'lastname',0,1,''),(1,'fullname',0,1,''),(1,'email',0,1,' admin welance de '),(1,'slug',0,1,'');
/*!40000 ALTER TABLE `craft_searchindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_sections`
--

DROP TABLE IF EXISTS `craft_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` enum('single','channel','structure') NOT NULL DEFAULT 'channel',
  `enableVersioning` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_sections_handle_unq_idx` (`handle`),
  UNIQUE KEY `craft_sections_name_unq_idx` (`name`),
  KEY `craft_sections_structureId_idx` (`structureId`),
  CONSTRAINT `craft_sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `craft_structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_sections`
--

LOCK TABLES `craft_sections` WRITE;
/*!40000 ALTER TABLE `craft_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_sections_sites`
--

DROP TABLE IF EXISTS `craft_sections_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_sections_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `enabledByDefault` tinyint(1) NOT NULL DEFAULT '1',
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_sections_sites_sectionId_siteId_unq_idx` (`sectionId`,`siteId`),
  KEY `craft_sections_sites_siteId_idx` (`siteId`),
  CONSTRAINT `craft_sections_sites_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_sections_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_sections_sites`
--

LOCK TABLES `craft_sections_sites` WRITE;
/*!40000 ALTER TABLE `craft_sections_sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_sections_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_sessions`
--

DROP TABLE IF EXISTS `craft_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_sessions_uid_idx` (`uid`),
  KEY `craft_sessions_token_idx` (`token`),
  KEY `craft_sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `craft_sessions_userId_idx` (`userId`),
  CONSTRAINT `craft_sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_sessions`
--

LOCK TABLES `craft_sessions` WRITE;
/*!40000 ALTER TABLE `craft_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_shunnedmessages`
--

DROP TABLE IF EXISTS `craft_shunnedmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `craft_shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_shunnedmessages`
--

LOCK TABLES `craft_shunnedmessages` WRITE;
/*!40000 ALTER TABLE `craft_shunnedmessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_shunnedmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_sitegroups`
--

DROP TABLE IF EXISTS `craft_sitegroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_sitegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_sitegroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_sitegroups`
--

LOCK TABLES `craft_sitegroups` WRITE;
/*!40000 ALTER TABLE `craft_sitegroups` DISABLE KEYS */;
INSERT INTO `craft_sitegroups` VALUES (1,'Welance','2018-01-06 10:45:38','2018-01-06 10:45:38','870e5735-c1d1-4a04-a2fb-3dbd8ada2874');
/*!40000 ALTER TABLE `craft_sitegroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_sites`
--

DROP TABLE IF EXISTS `craft_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `language` varchar(12) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '0',
  `baseUrl` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_sites_handle_unq_idx` (`handle`),
  KEY `craft_sites_sortOrder_idx` (`sortOrder`),
  KEY `craft_sites_groupId_fk` (`groupId`),
  CONSTRAINT `craft_sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_sitegroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_sites`
--

LOCK TABLES `craft_sites` WRITE;
/*!40000 ALTER TABLE `craft_sites` DISABLE KEYS */;
INSERT INTO `craft_sites` VALUES (1,1,1,'Welance','default','en',1,'http://localhost/',1,'2018-01-06 10:45:38','2018-01-06 10:45:38','0bc2a283-1c6d-41b9-994a-1448225b6c9b');
/*!40000 ALTER TABLE `craft_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_structureelements`
--

DROP TABLE IF EXISTS `craft_structureelements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `craft_structureelements_root_idx` (`root`),
  KEY `craft_structureelements_lft_idx` (`lft`),
  KEY `craft_structureelements_rgt_idx` (`rgt`),
  KEY `craft_structureelements_level_idx` (`level`),
  KEY `craft_structureelements_elementId_idx` (`elementId`),
  CONSTRAINT `craft_structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `craft_structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_structureelements`
--

LOCK TABLES `craft_structureelements` WRITE;
/*!40000 ALTER TABLE `craft_structureelements` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_structureelements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_structures`
--

DROP TABLE IF EXISTS `craft_structures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_structures`
--

LOCK TABLES `craft_structures` WRITE;
/*!40000 ALTER TABLE `craft_structures` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_structures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_systemmessages`
--

DROP TABLE IF EXISTS `craft_systemmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_systemmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_systemmessages_key_language_unq_idx` (`key`,`language`),
  KEY `craft_systemmessages_language_idx` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_systemmessages`
--

LOCK TABLES `craft_systemmessages` WRITE;
/*!40000 ALTER TABLE `craft_systemmessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_systemmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_systemsettings`
--

DROP TABLE IF EXISTS `craft_systemsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_systemsettings`
--

LOCK TABLES `craft_systemsettings` WRITE;
/*!40000 ALTER TABLE `craft_systemsettings` DISABLE KEYS */;
INSERT INTO `craft_systemsettings` VALUES (1,'email','{\"fromEmail\":\"admin@welance.de\",\"fromName\":\"Welance\",\"transportType\":\"craft\\\\mail\\\\transportadapters\\\\Sendmail\"}','2018-01-06 10:45:39','2018-01-06 10:45:39','4596af65-bb42-47eb-9f6c-4cd7ac36b34a');
/*!40000 ALTER TABLE `craft_systemsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_taggroups`
--

DROP TABLE IF EXISTS `craft_taggroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `craft_taggroups_handle_unq_idx` (`handle`),
  KEY `craft_taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_taggroups`
--

LOCK TABLES `craft_taggroups` WRITE;
/*!40000 ALTER TABLE `craft_taggroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_taggroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_tags`
--

DROP TABLE IF EXISTS `craft_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_tags_groupId_idx` (`groupId`),
  CONSTRAINT `craft_tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_tags_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_tags`
--

LOCK TABLES `craft_tags` WRITE;
/*!40000 ALTER TABLE `craft_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_templatecacheelements`
--

DROP TABLE IF EXISTS `craft_templatecacheelements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `craft_templatecacheelements_cacheId_idx` (`cacheId`),
  KEY `craft_templatecacheelements_elementId_idx` (`elementId`),
  CONSTRAINT `craft_templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `craft_templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_templatecacheelements`
--

LOCK TABLES `craft_templatecacheelements` WRITE;
/*!40000 ALTER TABLE `craft_templatecacheelements` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_templatecacheelements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_templatecachequeries`
--

DROP TABLE IF EXISTS `craft_templatecachequeries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_templatecachequeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `query` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `craft_templatecachequeries_cacheId_idx` (`cacheId`),
  KEY `craft_templatecachequeries_type_idx` (`type`),
  CONSTRAINT `craft_templatecachequeries_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `craft_templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_templatecachequeries`
--

LOCK TABLES `craft_templatecachequeries` WRITE;
/*!40000 ALTER TABLE `craft_templatecachequeries` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_templatecachequeries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_templatecaches`
--

DROP TABLE IF EXISTS `craft_templatecaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) NOT NULL,
  `cacheKey` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `craft_templatecaches_cacheKey_siteId_expiryDate_path_idx` (`cacheKey`,`siteId`,`expiryDate`,`path`),
  KEY `craft_templatecaches_cacheKey_siteId_expiryDate_idx` (`cacheKey`,`siteId`,`expiryDate`),
  KEY `craft_templatecaches_siteId_idx` (`siteId`),
  CONSTRAINT `craft_templatecaches_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `craft_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_templatecaches`
--

LOCK TABLES `craft_templatecaches` WRITE;
/*!40000 ALTER TABLE `craft_templatecaches` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_templatecaches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_tokens`
--

DROP TABLE IF EXISTS `craft_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) NOT NULL,
  `route` text,
  `usageLimit` smallint(6) unsigned DEFAULT NULL,
  `usageCount` smallint(6) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_tokens_token_unq_idx` (`token`),
  KEY `craft_tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_tokens`
--

LOCK TABLES `craft_tokens` WRITE;
/*!40000 ALTER TABLE `craft_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_usergroups`
--

DROP TABLE IF EXISTS `craft_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_usergroups_handle_unq_idx` (`handle`),
  UNIQUE KEY `craft_usergroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_usergroups`
--

LOCK TABLES `craft_usergroups` WRITE;
/*!40000 ALTER TABLE `craft_usergroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_usergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_usergroups_users`
--

DROP TABLE IF EXISTS `craft_usergroups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `craft_usergroups_users_userId_idx` (`userId`),
  CONSTRAINT `craft_usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_usergroups_users`
--

LOCK TABLES `craft_usergroups_users` WRITE;
/*!40000 ALTER TABLE `craft_usergroups_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_usergroups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_userpermissions`
--

DROP TABLE IF EXISTS `craft_userpermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_userpermissions`
--

LOCK TABLES `craft_userpermissions` WRITE;
/*!40000 ALTER TABLE `craft_userpermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_userpermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_userpermissions_usergroups`
--

DROP TABLE IF EXISTS `craft_userpermissions_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `craft_userpermissions_usergroups_groupId_idx` (`groupId`),
  CONSTRAINT `craft_userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `craft_userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_userpermissions_usergroups`
--

LOCK TABLES `craft_userpermissions_usergroups` WRITE;
/*!40000 ALTER TABLE `craft_userpermissions_usergroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_userpermissions_usergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_userpermissions_users`
--

DROP TABLE IF EXISTS `craft_userpermissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `craft_userpermissions_users_userId_idx` (`userId`),
  CONSTRAINT `craft_userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `craft_userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_userpermissions_users`
--

LOCK TABLES `craft_userpermissions_users` WRITE;
/*!40000 ALTER TABLE `craft_userpermissions_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_userpermissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_userpreferences`
--

DROP TABLE IF EXISTS `craft_userpreferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `craft_userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_userpreferences`
--

LOCK TABLES `craft_userpreferences` WRITE;
/*!40000 ALTER TABLE `craft_userpreferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_userpreferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_users`
--

DROP TABLE IF EXISTS `craft_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `photoId` int(11) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `client` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `pending` tinyint(1) NOT NULL DEFAULT '0',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIp` varchar(45) DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` smallint(6) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `verificationCode` varchar(255) DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) DEFAULT NULL,
  `passwordResetRequired` tinyint(1) NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_users_username_unq_idx` (`username`),
  UNIQUE KEY `craft_users_email_unq_idx` (`email`),
  KEY `craft_users_uid_idx` (`uid`),
  KEY `craft_users_verificationCode_idx` (`verificationCode`),
  KEY `craft_users_photoId_fk` (`photoId`),
  CONSTRAINT `craft_users_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_users_photoId_fk` FOREIGN KEY (`photoId`) REFERENCES `craft_assets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_users`
--

LOCK TABLES `craft_users` WRITE;
/*!40000 ALTER TABLE `craft_users` DISABLE KEYS */;
INSERT INTO `craft_users` VALUES (1,'admin',NULL,NULL,NULL,'admin@welance.de','$2y$13$4O6Pev6fmlJuY7bgy5ptBuLenS9JXt0BFMFCr7Om7B68v0RxF2Sp6',1,0,0,0,0,0,'2018-01-06 10:45:39','172.31.0.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2018-01-06 10:45:39','2018-01-06 10:45:39','2018-01-06 10:45:39','88448d84-53c0-4ccd-950f-603962ca3bdd');
/*!40000 ALTER TABLE `craft_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_volumefolders`
--

DROP TABLE IF EXISTS `craft_volumefolders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_volumefolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_volumefolders_name_parentId_volumeId_unq_idx` (`name`,`parentId`,`volumeId`),
  KEY `craft_volumefolders_parentId_idx` (`parentId`),
  KEY `craft_volumefolders_volumeId_idx` (`volumeId`),
  CONSTRAINT `craft_volumefolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `craft_volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_volumefolders_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `craft_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_volumefolders`
--

LOCK TABLES `craft_volumefolders` WRITE;
/*!40000 ALTER TABLE `craft_volumefolders` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_volumefolders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_volumes`
--

DROP TABLE IF EXISTS `craft_volumes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_volumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `url` varchar(255) DEFAULT NULL,
  `settings` text,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_volumes_name_unq_idx` (`name`),
  UNIQUE KEY `craft_volumes_handle_unq_idx` (`handle`),
  KEY `craft_volumes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `craft_volumes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_volumes`
--

LOCK TABLES `craft_volumes` WRITE;
/*!40000 ALTER TABLE `craft_volumes` DISABLE KEYS */;
/*!40000 ALTER TABLE `craft_volumes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craft_widgets`
--

DROP TABLE IF EXISTS `craft_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craft_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_widgets_userId_idx` (`userId`),
  CONSTRAINT `craft_widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craft_widgets`
--

LOCK TABLES `craft_widgets` WRITE;
/*!40000 ALTER TABLE `craft_widgets` DISABLE KEYS */;
INSERT INTO `craft_widgets` VALUES (1,1,'craft\\widgets\\RecentEntries',1,0,'{\"section\":\"*\",\"siteId\":\"1\",\"limit\":10}',1,'2018-01-06 10:45:40','2018-01-06 10:45:40','ec7e900b-ce9c-40dc-a438-dec7e3143901'),(2,1,'craft\\widgets\\CraftSupport',2,0,'[]',1,'2018-01-06 10:45:40','2018-01-06 10:45:40','6a09f2ad-986f-41de-b770-d254601d7c5c'),(3,1,'craft\\widgets\\Updates',3,0,'[]',1,'2018-01-06 10:45:40','2018-01-06 10:45:40','04e973ae-be93-4259-b52e-f812cc6a65e6'),(4,1,'craft\\widgets\\Feed',4,0,'{\"url\":\"https://craftcms.com/news.rss\",\"title\":\"Craft News\",\"limit\":5}',1,'2018-01-06 10:45:40','2018-01-06 10:45:40','c85b7b24-a063-4b50-bdb5-8fdfadd35e19');
/*!40000 ALTER TABLE `craft_widgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `craftidtokens`
--

DROP TABLE IF EXISTS `craftidtokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craftidtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `accessToken` text NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craftidtokens_userId_fk` (`userId`),
  CONSTRAINT `craftidtokens_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `craftidtokens`
--

LOCK TABLES `craftidtokens` WRITE;
/*!40000 ALTER TABLE `craftidtokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `craftidtokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deprecationerrors`
--

DROP TABLE IF EXISTS `deprecationerrors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `fingerprint` varchar(255) NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `traces` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deprecationerrors`
--

LOCK TABLES `deprecationerrors` WRITE;
/*!40000 ALTER TABLE `deprecationerrors` DISABLE KEYS */;
INSERT INTO `deprecationerrors` VALUES (1,'environmentVariables','/data/craft/vendor/craftcms/cms/src/services/Config.php:102','2018-01-06 15:05:29','/data/craft/vendor/craftcms/cms/src/services/Config.php',102,'The environmentVariables config setting has been renamed to aliases.','[{\"objectClass\":\"craft\\\\services\\\\Deprecator\",\"file\":\"/data/craft/vendor/craftcms/cms/src/config/GeneralConfig.php\",\"line\":776,\"class\":\"craft\\\\services\\\\Deprecator\",\"method\":\"log\",\"args\":\"\\\"environmentVariables\\\", \\\"The environmentVariables config setting has been renamed to alia...\\\"\"},{\"objectClass\":\"craft\\\\config\\\\GeneralConfig\",\"file\":\"/data/craft/vendor/craftcms/cms/src/services/Config.php\",\"line\":102,\"class\":\"craft\\\\config\\\\GeneralConfig\",\"method\":\"__construct\",\"args\":\"[\\\"defaultWeekStartDay\\\" => 1, \\\"enableCsrfProtection\\\" => true, \\\"omitScriptNameInUrls\\\" => true, \\\"cpTrigger\\\" => \\\"admin\\\", ...]\"},{\"objectClass\":\"craft\\\\services\\\\Config\",\"file\":\"/data/craft/vendor/craftcms/cms/src/services/Config.php\",\"line\":148,\"class\":\"craft\\\\services\\\\Config\",\"method\":\"getConfigSettings\",\"args\":\"\\\"general\\\"\"},{\"objectClass\":\"craft\\\\services\\\\Config\",\"file\":\"/data/craft/vendor/craftcms/cms/src/config/app/web.php\",\"line\":19,\"class\":\"craft\\\\services\\\\Config\",\"method\":\"getGeneral\",\"args\":null},{\"objectClass\":null,\"file\":null,\"line\":null,\"class\":null,\"method\":\"{closure}\",\"args\":null},{\"objectClass\":null,\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":501,\"class\":null,\"method\":\"call_user_func_array\",\"args\":\"Closure, []\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/BaseYii.php\",\"line\":351,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"invoke\",\"args\":\"Closure, []\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/yiisoft/yii2/di/ServiceLocator.php\",\"line\":137,\"class\":\"yii\\\\BaseYii\",\"method\":\"createObject\",\"args\":\"Closure\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Module.php\",\"line\":724,\"class\":\"yii\\\\di\\\\ServiceLocator\",\"method\":\"get\",\"args\":\"\\\"request\\\", true\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/web/Application.php\",\"line\":160,\"class\":\"yii\\\\base\\\\Module\",\"method\":\"get\",\"args\":\"\\\"request\\\"\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/web/Application.php\",\"line\":65,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"getRequest\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Application.php\",\"line\":273,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"bootstrap\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/craftcms/cms/src/web/Application.php\",\"line\":85,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"init\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/BaseObject.php\",\"line\":108,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"init\",\"args\":null},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/yiisoft/yii2/base/Application.php\",\"line\":206,\"class\":\"yii\\\\base\\\\BaseObject\",\"method\":\"__construct\",\"args\":\"[\\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", \\\"name\\\" => \\\"Craft CMS\\\", ...]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/data/craft/vendor/craftcms/cms/src/web/Application.php\",\"line\":75,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"__construct\",\"args\":\"[\\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", \\\"name\\\" => \\\"Craft CMS\\\", ...]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":null,\"line\":null,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"__construct\",\"args\":\"[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":\"ReflectionClass\",\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":381,\"class\":\"ReflectionClass\",\"method\":\"newInstanceArgs\",\"args\":\"[[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]]\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/di/Container.php\",\"line\":156,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"build\",\"args\":\"\\\"craft\\\\web\\\\Application\\\", [], [\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":\"yii\\\\di\\\\Container\",\"file\":\"/data/craft/vendor/yiisoft/yii2/BaseYii.php\",\"line\":349,\"class\":\"yii\\\\di\\\\Container\",\"method\":\"get\",\"args\":\"\\\"craft\\\\web\\\\Application\\\", [], [\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/craftcms/cms/bootstrap/bootstrap.php\",\"line\":243,\"class\":\"yii\\\\BaseYii\",\"method\":\"createObject\",\"args\":\"[\\\"vendorPath\\\" => \\\"/data/craft/vendor\\\", \\\"env\\\" => \\\".dev\\\", \\\"components\\\" => [\\\"config\\\" => craft\\\\services\\\\Config, \\\"api\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Api\\\"], \\\"assets\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\Assets\\\"], \\\"assetIndexer\\\" => [\\\"class\\\" => \\\"craft\\\\services\\\\AssetIndexer\\\"], ...], \\\"id\\\" => \\\"CraftCMS\\\", ...]\"},{\"objectClass\":null,\"file\":\"/data/craft/vendor/craftcms/cms/bootstrap/web.php\",\"line\":42,\"class\":null,\"method\":\"require\",\"args\":\"\\\"/data/craft/vendor/craftcms/cms/bootstrap/bootstrap.php\\\"\"},{\"objectClass\":null,\"file\":\"/data/craft/web/index.php\",\"line\":20,\"class\":null,\"method\":\"require\",\"args\":\"\\\"/data/craft/vendor/craftcms/cms/bootstrap/web.php\\\"\"}]','2018-01-06 15:05:29','2018-01-06 15:05:29','be507f3d-97b9-410b-8543-e041fb9f5293');
/*!40000 ALTER TABLE `deprecationerrors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elementindexsettings`
--

DROP TABLE IF EXISTS `elementindexsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elementindexsettings`
--

LOCK TABLES `elementindexsettings` WRITE;
/*!40000 ALTER TABLE `elementindexsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `elementindexsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elements`
--

DROP TABLE IF EXISTS `elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `elements_fieldLayoutId_idx` (`fieldLayoutId`),
  KEY `elements_type_idx` (`type`),
  KEY `elements_enabled_idx` (`enabled`),
  KEY `elements_archived_dateCreated_idx` (`archived`,`dateCreated`),
  CONSTRAINT `elements_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elements`
--

LOCK TABLES `elements` WRITE;
/*!40000 ALTER TABLE `elements` DISABLE KEYS */;
INSERT INTO `elements` VALUES (1,NULL,'craft\\elements\\User',1,0,'2018-01-06 11:01:32','2018-01-06 11:01:32','75b80b1e-bc64-4a81-a2e1-04dc6da09e0c');
/*!40000 ALTER TABLE `elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elements_sites`
--

DROP TABLE IF EXISTS `elements_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elements_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elements_sites_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  UNIQUE KEY `elements_sites_uri_siteId_unq_idx` (`uri`,`siteId`),
  KEY `elements_sites_siteId_idx` (`siteId`),
  KEY `elements_sites_slug_siteId_idx` (`slug`,`siteId`),
  KEY `elements_sites_enabled_idx` (`enabled`),
  CONSTRAINT `elements_sites_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `elements_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elements_sites`
--

LOCK TABLES `elements_sites` WRITE;
/*!40000 ALTER TABLE `elements_sites` DISABLE KEYS */;
INSERT INTO `elements_sites` VALUES (1,1,1,NULL,NULL,1,'2018-01-06 11:01:32','2018-01-06 11:01:32','628fac09-b7de-4caf-8011-ae6282e155bf');
/*!40000 ALTER TABLE `elements_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entries`
--

DROP TABLE IF EXISTS `entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entries_postDate_idx` (`postDate`),
  KEY `entries_expiryDate_idx` (`expiryDate`),
  KEY `entries_authorId_idx` (`authorId`),
  KEY `entries_sectionId_idx` (`sectionId`),
  KEY `entries_typeId_idx` (`typeId`),
  CONSTRAINT `entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entries`
--

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrydrafts`
--

DROP TABLE IF EXISTS `entrydrafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entrydrafts_sectionId_idx` (`sectionId`),
  KEY `entrydrafts_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entrydrafts_siteId_idx` (`siteId`),
  KEY `entrydrafts_creatorId_idx` (`creatorId`),
  CONSTRAINT `entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrydrafts`
--

LOCK TABLES `entrydrafts` WRITE;
/*!40000 ALTER TABLE `entrydrafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `entrydrafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrytypes`
--

DROP TABLE IF EXISTS `entrytypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `hasTitleField` tinyint(1) NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) DEFAULT 'Title',
  `titleFormat` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `entrytypes_sectionId_idx` (`sectionId`),
  KEY `entrytypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrytypes`
--

LOCK TABLES `entrytypes` WRITE;
/*!40000 ALTER TABLE `entrytypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `entrytypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entryversions`
--

DROP TABLE IF EXISTS `entryversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `siteId` int(11) NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entryversions_sectionId_idx` (`sectionId`),
  KEY `entryversions_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entryversions_siteId_idx` (`siteId`),
  KEY `entryversions_creatorId_idx` (`creatorId`),
  CONSTRAINT `entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entryversions`
--

LOCK TABLES `entryversions` WRITE;
/*!40000 ALTER TABLE `entryversions` DISABLE KEYS */;
/*!40000 ALTER TABLE `entryversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldgroups`
--

DROP TABLE IF EXISTS `fieldgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldgroups`
--

LOCK TABLES `fieldgroups` WRITE;
/*!40000 ALTER TABLE `fieldgroups` DISABLE KEYS */;
INSERT INTO `fieldgroups` VALUES (1,'Common','2018-01-06 11:01:32','2018-01-06 11:01:32','079312b4-93af-40dd-bb0e-6de978f17358');
/*!40000 ALTER TABLE `fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayoutfields`
--

DROP TABLE IF EXISTS `fieldlayoutfields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayoutfields_tabId_idx` (`tabId`),
  KEY `fieldlayoutfields_fieldId_idx` (`fieldId`),
  CONSTRAINT `fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayoutfields`
--

LOCK TABLES `fieldlayoutfields` WRITE;
/*!40000 ALTER TABLE `fieldlayoutfields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayoutfields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayouts`
--

DROP TABLE IF EXISTS `fieldlayouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayouts`
--

LOCK TABLES `fieldlayouts` WRITE;
/*!40000 ALTER TABLE `fieldlayouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayouttabs`
--

DROP TABLE IF EXISTS `fieldlayouttabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayouttabs_layoutId_idx` (`layoutId`),
  CONSTRAINT `fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayouttabs`
--

LOCK TABLES `fieldlayouttabs` WRITE;
/*!40000 ALTER TABLE `fieldlayouttabs` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayouttabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(64) NOT NULL,
  `context` varchar(255) NOT NULL DEFAULT 'global',
  `instructions` text,
  `translationMethod` varchar(255) NOT NULL DEFAULT 'none',
  `translationKeyFormat` text,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `fields_groupId_idx` (`groupId`),
  KEY `fields_context_idx` (`context`),
  CONSTRAINT `fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `globalsets`
--

DROP TABLE IF EXISTS `globalsets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `globalsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `globalsets_handle_unq_idx` (`handle`),
  KEY `globalsets_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `globalsets`
--

LOCK TABLES `globalsets` WRITE;
/*!40000 ALTER TABLE `globalsets` DISABLE KEYS */;
/*!40000 ALTER TABLE `globalsets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `info`
--

DROP TABLE IF EXISTS `info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(50) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `edition` smallint(6) unsigned NOT NULL,
  `timezone` varchar(30) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `on` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `fieldVersion` char(12) NOT NULL DEFAULT '000000000000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `info`
--

LOCK TABLES `info` WRITE;
/*!40000 ALTER TABLE `info` DISABLE KEYS */;
INSERT INTO `info` VALUES (1,'3.0.0-RC4','3.0.77',0,'America/Los_Angeles','Welance',1,0,'pqQsw9JxT6Ll','2018-01-06 11:01:32','2018-01-06 11:01:32','e5b5a752-ac3c-4d3f-a43d-c3f896492fe7');
/*!40000 ALTER TABLE `info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matrixblocks`
--

DROP TABLE IF EXISTS `matrixblocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `matrixblocks_ownerId_idx` (`ownerId`),
  KEY `matrixblocks_fieldId_idx` (`fieldId`),
  KEY `matrixblocks_typeId_idx` (`typeId`),
  KEY `matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `matrixblocks_ownerSiteId_idx` (`ownerSiteId`),
  CONSTRAINT `matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matrixblocks`
--

LOCK TABLES `matrixblocks` WRITE;
/*!40000 ALTER TABLE `matrixblocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `matrixblocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matrixblocktypes`
--

DROP TABLE IF EXISTS `matrixblocktypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `matrixblocktypes_fieldId_idx` (`fieldId`),
  KEY `matrixblocktypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matrixblocktypes`
--

LOCK TABLES `matrixblocktypes` WRITE;
/*!40000 ALTER TABLE `matrixblocktypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `matrixblocktypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `type` enum('app','plugin','content') NOT NULL DEFAULT 'app',
  `name` varchar(255) NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `migrations_pluginId_idx` (`pluginId`),
  KEY `migrations_type_pluginId_idx` (`type`,`pluginId`),
  CONSTRAINT `migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,NULL,'app','Install','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','4ab4d25c-9e27-4bc5-a98d-176fe74554db'),(2,NULL,'app','m150403_183908_migrations_table_changes','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','dcad3810-d288-46c2-87b6-8aba6f49a048'),(3,NULL,'app','m150403_184247_plugins_table_changes','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','13aac8e7-d2c0-4ec3-af9d-ea8619f67593'),(4,NULL,'app','m150403_184533_field_version','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','46faf64a-d558-4f80-8fab-e65c5936d461'),(5,NULL,'app','m150403_184729_type_columns','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','2c60c82c-a49e-4b1f-ba1a-c66be10c2d04'),(6,NULL,'app','m150403_185142_volumes','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','6af6208d-dfba-4ebc-8021-7371a08a8e66'),(7,NULL,'app','m150428_231346_userpreferences','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','b1ced544-e9c8-4305-8a8c-d988684a8bec'),(8,NULL,'app','m150519_150900_fieldversion_conversion','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','a1df7ec3-e3e6-440d-9459-f668e2515716'),(9,NULL,'app','m150617_213829_update_email_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ace1fa25-450f-43b1-9cea-8b270e226bf9'),(10,NULL,'app','m150721_124739_templatecachequeries','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','6af1c548-f5cd-47eb-abaf-a5b55deb00e6'),(11,NULL,'app','m150724_140822_adjust_quality_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ea8fbe91-2192-4135-9a59-4481de700c23'),(12,NULL,'app','m150815_133521_last_login_attempt_ip','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','8c6ef590-c201-4cc8-9e7c-bdaca4200196'),(13,NULL,'app','m151002_095935_volume_cache_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','33510927-8100-41ae-a6c6-1e2d9da6ba52'),(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','b484abc6-885b-4ac8-a58a-a79270f00fb4'),(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','04308abd-8584-42a1-9acb-7b912d9a8b13'),(16,NULL,'app','m151209_000000_move_logo','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','23e04a19-290d-4cab-bc81-775b4766feb8'),(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','504dda2a-78c4-46e9-be82-2edd55bdd168'),(18,NULL,'app','m151215_000000_rename_asset_permissions','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','69138e7d-9d91-426c-bfa8-c08d10ec3836'),(19,NULL,'app','m160707_000001_rename_richtext_assetsource_setting','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','b1cd8de8-c6f9-4836-b6cd-d8bd42f75fcf'),(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','39032eae-43c4-46c2-974f-a08e183ba674'),(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','7fad97b0-34ae-43d4-ade4-a976678da9e2'),(22,NULL,'app','m160727_194637_column_cleanup','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','55bad233-37e6-4f20-b3c9-9b7847d17b51'),(23,NULL,'app','m160804_110002_userphotos_to_assets','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','cd59acfc-dba4-4d51-bc84-303d67e0f0a5'),(24,NULL,'app','m160807_144858_sites','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','08c335c9-9516-49a5-b93b-6168066b3046'),(25,NULL,'app','m160829_000000_pending_user_content_cleanup','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','f45f5568-ce59-4e71-a254-39f32a004854'),(26,NULL,'app','m160830_000000_asset_index_uri_increase','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','7b392d43-3f3a-4b84-a40f-3712bbbe6440'),(27,NULL,'app','m160912_230520_require_entry_type_id','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','13b0fe26-efe3-4678-88e0-6c2ef5c5c122'),(28,NULL,'app','m160913_134730_require_matrix_block_type_id','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','92d6ac6b-159a-450f-9210-fb377ffa0f31'),(29,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','e332f002-7308-4b7d-9176-f4f397529e55'),(30,NULL,'app','m160920_231045_usergroup_handle_title_unique','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','1f0fb515-1b1f-41f3-a02a-92d049cfa930'),(31,NULL,'app','m160925_113941_route_uri_parts','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','744d085b-7e22-4d99-9f99-6e4652d9476e'),(32,NULL,'app','m161006_205918_schemaVersion_not_null','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','14270e46-7348-4024-8cb2-2bdf8ef11d1c'),(33,NULL,'app','m161007_130653_update_email_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','3616d000-9dbe-45e7-a556-a95b531a5dd0'),(34,NULL,'app','m161013_175052_newParentId','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','e392fd12-fd32-495d-ba22-c4a69689de60'),(35,NULL,'app','m161021_102916_fix_recent_entries_widgets','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','b1062414-1921-4279-bd62-1dadbc6e0bec'),(36,NULL,'app','m161021_182140_rename_get_help_widget','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ef06f3d8-d322-4b7a-98dd-0695aab14017'),(37,NULL,'app','m161025_000000_fix_char_columns','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','07288c48-4282-4889-827b-a2de145c00d1'),(38,NULL,'app','m161029_124145_email_message_languages','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','db2c02ea-d28d-4d92-811c-292af194dd4a'),(39,NULL,'app','m161108_000000_new_version_format','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','75d93cf9-9b83-4e19-afd0-8bd3f4a210f6'),(40,NULL,'app','m161109_000000_index_shuffle','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','2a2bfd3d-f38d-4c1f-bb98-7edb4e76726a'),(41,NULL,'app','m161122_185500_no_craft_app','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','4feb74fd-d253-4bd0-89a7-72f6a04b564c'),(42,NULL,'app','m161125_150752_clear_urlmanager_cache','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','e11e1a07-7bc6-4b1e-8e9e-77367610042f'),(43,NULL,'app','m161220_000000_volumes_hasurl_notnull','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','a6591ffc-d8d3-4dae-8eea-30be9fe3ca50'),(44,NULL,'app','m170114_161144_udates_permission','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','b1ffb1f7-4be6-4ae6-ba5b-e5c2d8efe133'),(45,NULL,'app','m170120_000000_schema_cleanup','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','3a29167d-a026-487c-be2b-027eb8673452'),(46,NULL,'app','m170126_000000_assets_focal_point','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','4e2649e0-ff54-426e-be31-75bba19ec949'),(47,NULL,'app','m170206_142126_system_name','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','bacd9262-6540-4fca-a027-3c4714b0e550'),(48,NULL,'app','m170217_044740_category_branch_limits','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','80ffd564-46b0-4873-a304-a23ff31ae8eb'),(49,NULL,'app','m170217_120224_asset_indexing_columns','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','720fd77a-70c4-4b02-a841-ada3aa3bb911'),(50,NULL,'app','m170223_224012_plain_text_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','4ccc918a-0969-4ee4-b73e-88287a6481af'),(51,NULL,'app','m170227_120814_focal_point_percentage','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','0c4e33f0-c4c0-452e-b25d-20a699f74ebb'),(52,NULL,'app','m170228_171113_system_messages','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','a90d84dd-7a56-4982-818c-55ddd0cb4702'),(53,NULL,'app','m170303_140500_asset_field_source_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','3d0bff95-1202-4bc7-9271-129972c5ed3b'),(54,NULL,'app','m170306_150500_asset_temporary_uploads','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','f372cd6a-fccc-40fd-b47a-6c5a96e5625d'),(55,NULL,'app','m170414_162429_rich_text_config_setting','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','c2048be2-8e29-4016-bc01-0e1be2f6c71d'),(56,NULL,'app','m170523_190652_element_field_layout_ids','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','3ab952c6-71b1-41b2-9194-20c501f6719e'),(57,NULL,'app','m170612_000000_route_index_shuffle','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','be65274b-ce2e-477a-83f7-70e720343669'),(58,NULL,'app','m170621_195237_format_plugin_handles','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','db87d09e-0f7b-4e10-b920-121c8e8aea8c'),(59,NULL,'app','m170630_161028_deprecation_changes','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ed976f22-5682-46b3-9f2d-833006d4fead'),(60,NULL,'app','m170703_181539_plugins_table_tweaks','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','5ee8e09f-e35d-4dc0-943c-7a46e5787257'),(61,NULL,'app','m170704_134916_sites_tables','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','06d9d253-cfb1-4f34-8b4d-6699b7b0b261'),(62,NULL,'app','m170706_183216_rename_sequences','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','d6402730-74c3-4a12-a21c-20b135e701d3'),(63,NULL,'app','m170707_094758_delete_compiled_traits','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','9cc58425-9c4d-4509-a868-c08789b04431'),(64,NULL,'app','m170731_190138_drop_asset_packagist','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','e7d5675f-3607-4773-ac7e-b7b2a7a7dba9'),(65,NULL,'app','m170810_201318_create_queue_table','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','7a1b9681-7bf4-4db2-84b6-e15f108c2b60'),(66,NULL,'app','m170816_133741_delete_compiled_behaviors','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ee081c9c-4f37-4b17-87f7-08a0804c959c'),(67,NULL,'app','m170821_180624_deprecation_line_nullable','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','a18e8ea0-8313-44de-b887-cbc8eb2105c1'),(68,NULL,'app','m170903_192801_longblob_for_queue_jobs','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','23d05aab-12f5-444d-8289-2b3379002716'),(69,NULL,'app','m170914_204621_asset_cache_shuffle','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','d197462d-7295-4d9a-ba4b-dc231253baeb'),(70,NULL,'app','m171011_214115_site_groups','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','65ca5352-db16-4aff-8fc2-13b638dbcb05'),(71,NULL,'app','m171012_151440_primary_site','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','18e04050-0c2c-47c1-b3e4-d5d1aa3c68b4'),(72,NULL,'app','m171013_142500_transform_interlace','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','7e0c6d96-50cf-46dd-850d-99ff05267a72'),(73,NULL,'app','m171016_092553_drop_position_select','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','a1908cb8-e834-441b-9157-ac7359881886'),(74,NULL,'app','m171016_221244_less_strict_translation_method','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ee739a4f-b8e7-4724-be97-11734ab34aeb'),(75,NULL,'app','m171107_000000_assign_group_permissions','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','ac3aeb9b-6ba9-4cd6-8f06-f43f29633989'),(76,NULL,'app','m171117_000001_templatecache_index_tune','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','a993ec45-7ae1-4861-926d-9073d4c4968f'),(77,NULL,'app','m171126_105927_disabled_plugins','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','afe8ce14-6917-41d9-b02c-e4da1430f7d1'),(78,NULL,'app','m171130_214407_craftidtokens_table','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','44260ac7-3099-4471-8a95-fc86b337d3a5'),(79,NULL,'app','m171202_004225_update_email_settings','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','dbda859d-f022-40d3-828f-1430a4e9d840'),(80,NULL,'app','m171204_000001_templatecache_index_tune_deux','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','37cff6de-83a7-41f7-a2e5-21e00d8f1a4a'),(81,NULL,'app','m171205_130908_remove_craftidtokens_refreshtoken_column','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','79f8ba8c-a4de-4d0a-a311-8a944082789d'),(82,NULL,'app','m171210_142046_fix_db_routes','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','db81049f-ec78-4751-8c9d-9aeb3bf1db07'),(83,NULL,'app','m171218_143135_longtext_query_column','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','5247c176-9fa1-413b-8c76-e971b906ee82'),(84,NULL,'app','m171231_055546_environment_variables_to_aliases','2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','d362179d-bfce-43de-a851-de273c852bdf');
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins`
--

DROP TABLE IF EXISTS `plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `schemaVersion` varchar(255) NOT NULL,
  `licenseKey` char(24) DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','unknown') NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `plugins_handle_unq_idx` (`handle`),
  KEY `plugins_enabled_idx` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins`
--

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queue`
--

DROP TABLE IF EXISTS `queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` longblob NOT NULL,
  `description` text,
  `timePushed` int(11) NOT NULL,
  `ttr` int(11) NOT NULL,
  `delay` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) unsigned NOT NULL DEFAULT '1024',
  `dateReserved` datetime DEFAULT NULL,
  `timeUpdated` int(11) DEFAULT NULL,
  `progress` smallint(6) NOT NULL DEFAULT '0',
  `attempt` int(11) DEFAULT NULL,
  `fail` tinyint(1) DEFAULT '0',
  `dateFailed` datetime DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`id`),
  KEY `queue_fail_timeUpdated_timePushed_idx` (`fail`,`timeUpdated`,`timePushed`),
  KEY `queue_fail_timeUpdated_delay_idx` (`fail`,`timeUpdated`,`delay`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queue`
--

LOCK TABLES `queue` WRITE;
/*!40000 ALTER TABLE `queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relations`
--

DROP TABLE IF EXISTS `relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceSiteId` int(11) DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `relations_fieldId_sourceId_sourceSiteId_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceSiteId`,`targetId`),
  KEY `relations_sourceId_idx` (`sourceId`),
  KEY `relations_targetId_idx` (`targetId`),
  KEY `relations_sourceSiteId_idx` (`sourceSiteId`),
  CONSTRAINT `relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relations`
--

LOCK TABLES `relations` WRITE;
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) DEFAULT NULL,
  `uriParts` varchar(255) NOT NULL,
  `uriPattern` varchar(255) NOT NULL,
  `template` varchar(500) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `routes_uriPattern_idx` (`uriPattern`),
  KEY `routes_siteId_idx` (`siteId`),
  CONSTRAINT `routes_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `searchindex`
--

DROP TABLE IF EXISTS `searchindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `searchindex`
--

LOCK TABLES `searchindex` WRITE;
/*!40000 ALTER TABLE `searchindex` DISABLE KEYS */;
INSERT INTO `searchindex` VALUES (1,'username',0,1,' admin '),(1,'firstname',0,1,''),(1,'lastname',0,1,''),(1,'fullname',0,1,''),(1,'email',0,1,' admin welance de '),(1,'slug',0,1,'');
/*!40000 ALTER TABLE `searchindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` enum('single','channel','structure') NOT NULL DEFAULT 'channel',
  `enableVersioning` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_handle_unq_idx` (`handle`),
  UNIQUE KEY `sections_name_unq_idx` (`name`),
  KEY `sections_structureId_idx` (`structureId`),
  CONSTRAINT `sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections_sites`
--

DROP TABLE IF EXISTS `sections_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sections_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `enabledByDefault` tinyint(1) NOT NULL DEFAULT '1',
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_sites_sectionId_siteId_unq_idx` (`sectionId`,`siteId`),
  KEY `sections_sites_siteId_idx` (`siteId`),
  CONSTRAINT `sections_sites_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sections_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections_sites`
--

LOCK TABLES `sections_sites` WRITE;
/*!40000 ALTER TABLE `sections_sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sections_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sessions_uid_idx` (`uid`),
  KEY `sessions_token_idx` (`token`),
  KEY `sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `sessions_userId_idx` (`userId`),
  CONSTRAINT `sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shunnedmessages`
--

DROP TABLE IF EXISTS `shunnedmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shunnedmessages`
--

LOCK TABLES `shunnedmessages` WRITE;
/*!40000 ALTER TABLE `shunnedmessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `shunnedmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitegroups`
--

DROP TABLE IF EXISTS `sitegroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sitegroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitegroups`
--

LOCK TABLES `sitegroups` WRITE;
/*!40000 ALTER TABLE `sitegroups` DISABLE KEYS */;
INSERT INTO `sitegroups` VALUES (1,'Welance','2018-01-06 11:01:32','2018-01-06 11:01:32','2d2ff61c-2b5d-435f-9d2b-4f492f40b2b7');
/*!40000 ALTER TABLE `sitegroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `language` varchar(12) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '0',
  `baseUrl` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sites_handle_unq_idx` (`handle`),
  KEY `sites_sortOrder_idx` (`sortOrder`),
  KEY `sites_groupId_fk` (`groupId`),
  CONSTRAINT `sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `sitegroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,1,1,'Welance','default','en-US',1,'http://localhost/',1,'2018-01-06 11:01:32','2018-01-06 11:01:32','896baf42-86b2-4dbc-8bdc-0f02573a5cf9');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structureelements`
--

DROP TABLE IF EXISTS `structureelements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `structureelements_root_idx` (`root`),
  KEY `structureelements_lft_idx` (`lft`),
  KEY `structureelements_rgt_idx` (`rgt`),
  KEY `structureelements_level_idx` (`level`),
  KEY `structureelements_elementId_idx` (`elementId`),
  CONSTRAINT `structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `structureelements`
--

LOCK TABLES `structureelements` WRITE;
/*!40000 ALTER TABLE `structureelements` DISABLE KEYS */;
/*!40000 ALTER TABLE `structureelements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structures`
--

DROP TABLE IF EXISTS `structures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `structures`
--

LOCK TABLES `structures` WRITE;
/*!40000 ALTER TABLE `structures` DISABLE KEYS */;
/*!40000 ALTER TABLE `structures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `systemmessages`
--

DROP TABLE IF EXISTS `systemmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `systemmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemmessages_key_language_unq_idx` (`key`,`language`),
  KEY `systemmessages_language_idx` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systemmessages`
--

LOCK TABLES `systemmessages` WRITE;
/*!40000 ALTER TABLE `systemmessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `systemmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `systemsettings`
--

DROP TABLE IF EXISTS `systemsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systemsettings`
--

LOCK TABLES `systemsettings` WRITE;
/*!40000 ALTER TABLE `systemsettings` DISABLE KEYS */;
INSERT INTO `systemsettings` VALUES (1,'email','{\"fromEmail\":\"admin@welance.de\",\"fromName\":\"Welance\",\"transportType\":\"craft\\\\mail\\\\transportadapters\\\\Sendmail\"}','2018-01-06 11:01:32','2018-01-06 11:01:32','ab66ef5b-63d8-44d3-b2e9-842dc51e335d');
/*!40000 ALTER TABLE `systemsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggroups`
--

DROP TABLE IF EXISTS `taggroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `taggroups_handle_unq_idx` (`handle`),
  KEY `taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taggroups`
--

LOCK TABLES `taggroups` WRITE;
/*!40000 ALTER TABLE `taggroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `taggroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tags_groupId_idx` (`groupId`),
  CONSTRAINT `tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tags_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templatecacheelements`
--

DROP TABLE IF EXISTS `templatecacheelements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `templatecacheelements_cacheId_idx` (`cacheId`),
  KEY `templatecacheelements_elementId_idx` (`elementId`),
  CONSTRAINT `templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templatecacheelements`
--

LOCK TABLES `templatecacheelements` WRITE;
/*!40000 ALTER TABLE `templatecacheelements` DISABLE KEYS */;
/*!40000 ALTER TABLE `templatecacheelements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templatecachequeries`
--

DROP TABLE IF EXISTS `templatecachequeries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `templatecachequeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `query` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecachequeries_cacheId_idx` (`cacheId`),
  KEY `templatecachequeries_type_idx` (`type`),
  CONSTRAINT `templatecachequeries_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templatecachequeries`
--

LOCK TABLES `templatecachequeries` WRITE;
/*!40000 ALTER TABLE `templatecachequeries` DISABLE KEYS */;
/*!40000 ALTER TABLE `templatecachequeries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templatecaches`
--

DROP TABLE IF EXISTS `templatecaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) NOT NULL,
  `cacheKey` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_path_idx` (`cacheKey`,`siteId`,`expiryDate`,`path`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_idx` (`cacheKey`,`siteId`,`expiryDate`),
  KEY `templatecaches_siteId_idx` (`siteId`),
  CONSTRAINT `templatecaches_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templatecaches`
--

LOCK TABLES `templatecaches` WRITE;
/*!40000 ALTER TABLE `templatecaches` DISABLE KEYS */;
/*!40000 ALTER TABLE `templatecaches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) NOT NULL,
  `route` text,
  `usageLimit` smallint(6) unsigned DEFAULT NULL,
  `usageCount` smallint(6) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokens_token_unq_idx` (`token`),
  KEY `tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usergroups`
--

DROP TABLE IF EXISTS `usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_handle_unq_idx` (`handle`),
  UNIQUE KEY `usergroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usergroups`
--

LOCK TABLES `usergroups` WRITE;
/*!40000 ALTER TABLE `usergroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `usergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usergroups_users`
--

DROP TABLE IF EXISTS `usergroups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `usergroups_users_userId_idx` (`userId`),
  CONSTRAINT `usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usergroups_users`
--

LOCK TABLES `usergroups_users` WRITE;
/*!40000 ALTER TABLE `usergroups_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `usergroups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userpermissions`
--

DROP TABLE IF EXISTS `userpermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userpermissions`
--

LOCK TABLES `userpermissions` WRITE;
/*!40000 ALTER TABLE `userpermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `userpermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userpermissions_usergroups`
--

DROP TABLE IF EXISTS `userpermissions_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `userpermissions_usergroups_groupId_idx` (`groupId`),
  CONSTRAINT `userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userpermissions_usergroups`
--

LOCK TABLES `userpermissions_usergroups` WRITE;
/*!40000 ALTER TABLE `userpermissions_usergroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `userpermissions_usergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userpermissions_users`
--

DROP TABLE IF EXISTS `userpermissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `userpermissions_users_userId_idx` (`userId`),
  CONSTRAINT `userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userpermissions_users`
--

LOCK TABLES `userpermissions_users` WRITE;
/*!40000 ALTER TABLE `userpermissions_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `userpermissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userpreferences`
--

DROP TABLE IF EXISTS `userpreferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userpreferences`
--

LOCK TABLES `userpreferences` WRITE;
/*!40000 ALTER TABLE `userpreferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `userpreferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `photoId` int(11) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `client` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `pending` tinyint(1) NOT NULL DEFAULT '0',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIp` varchar(45) DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` smallint(6) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `verificationCode` varchar(255) DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) DEFAULT NULL,
  `passwordResetRequired` tinyint(1) NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unq_idx` (`username`),
  UNIQUE KEY `users_email_unq_idx` (`email`),
  KEY `users_uid_idx` (`uid`),
  KEY `users_verificationCode_idx` (`verificationCode`),
  KEY `users_photoId_fk` (`photoId`),
  CONSTRAINT `users_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_photoId_fk` FOREIGN KEY (`photoId`) REFERENCES `assets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin',NULL,NULL,NULL,'admin@welance.de','$2y$13$MJ6rBov3twGWfh216s4q3ODKW.YL43WC1eiA0uKiBJXWfbEH4se2K',1,0,0,0,0,0,'2018-01-06 11:01:32','172.31.0.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2018-01-06 11:01:32','2018-01-06 11:01:32','2018-01-06 11:01:32','fff7aaf1-6dc8-47a2-91f7-ee43b405ff05');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volumefolders`
--

DROP TABLE IF EXISTS `volumefolders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `volumefolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumefolders_name_parentId_volumeId_unq_idx` (`name`,`parentId`,`volumeId`),
  KEY `volumefolders_parentId_idx` (`parentId`),
  KEY `volumefolders_volumeId_idx` (`volumeId`),
  CONSTRAINT `volumefolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `volumefolders_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volumefolders`
--

LOCK TABLES `volumefolders` WRITE;
/*!40000 ALTER TABLE `volumefolders` DISABLE KEYS */;
/*!40000 ALTER TABLE `volumefolders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volumes`
--

DROP TABLE IF EXISTS `volumes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `volumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `url` varchar(255) DEFAULT NULL,
  `settings` text,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumes_name_unq_idx` (`name`),
  UNIQUE KEY `volumes_handle_unq_idx` (`handle`),
  KEY `volumes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `volumes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volumes`
--

LOCK TABLES `volumes` WRITE;
/*!40000 ALTER TABLE `volumes` DISABLE KEYS */;
/*!40000 ALTER TABLE `volumes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `widgets`
--

DROP TABLE IF EXISTS `widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `widgets_userId_idx` (`userId`),
  CONSTRAINT `widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widgets`
--

LOCK TABLES `widgets` WRITE;
/*!40000 ALTER TABLE `widgets` DISABLE KEYS */;
INSERT INTO `widgets` VALUES (1,1,'craft\\widgets\\RecentEntries',1,0,'{\"section\":\"*\",\"siteId\":\"1\",\"limit\":10}',1,'2018-01-06 11:01:33','2018-01-06 11:01:33','f6e8a863-d657-4e8e-b266-9f0ed2524682'),(2,1,'craft\\widgets\\CraftSupport',2,0,'[]',1,'2018-01-06 11:01:33','2018-01-06 11:01:33','c1d67fa6-8ad4-482d-8ec8-a70cd5e5becb'),(3,1,'craft\\widgets\\Updates',3,0,'[]',1,'2018-01-06 11:01:33','2018-01-06 11:01:33','55cf797e-5027-46f3-b0fb-aa782fa4637c'),(4,1,'craft\\widgets\\Feed',4,0,'{\"url\":\"https://craftcms.com/news.rss\",\"title\":\"Craft News\",\"limit\":5}',1,'2018-01-06 11:01:33','2018-01-06 11:01:33','850b2458-1ad1-4960-a538-a934f3a318a9');
/*!40000 ALTER TABLE `widgets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-06 15:05:56
