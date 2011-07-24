CREATE DATABASE `cmanage`; 
USE `cmanage`;

CREATE TABLE `swVersions` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `shortname` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1

CREATE TABLE `sensatronic_em1` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `sensor` varchar(128) DEFAULT NULL,
  `value` float(5,1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1


# Added 7-24-11

CREATE TABLE `alerts` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `userid` int(128) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1

CREATE TABLE `alerts` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `userid` int(128) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1


