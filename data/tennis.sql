-- DROP DATABASE IF EXISTS TENNIS;
CREATE DATABASE TENNIS;
USE TENNIS; 

-- Schema:
-- MEMBER (username, password, name, level)
DROP TABLE IF EXISTS MEMBER;
CREATE TABLE MEMBER (
	username VARCHAR(50),
	password VARCHAR(50),
	name VARCHAR(50),
	level INT DEFAULT 0,
	PRIMARY KEY(username)
);

-- COURT (cID, inside, VIP, pricePerHour)
DROP TABLE IF EXISTS COURT;
CREATE TABLE COURT (
	cID INT,
	inside BOOLEAN DEFAULT FALSE,
	VIP BOOLEAN DEFAULT FALSE,
	pricePerHour INT,
	PRIMARY KEY(cID)
);

-- RESERVATION (username, cID, reserveDate, reserveTime, paid)
DROP TABLE IF EXISTS RESERVATION;
CREATE TABLE RESERVATION (
	username VARCHAR(50),
	cID INT,
	reserveDate DATE DEFAULT '0000-00-00',
	reserveTime INT,
	paid BOOLEAN DEFAULT FALSE,
	PRIMARY KEY(username,cID,reserveDate,reserveTime)
);

-- EQUIPMENT (username, borrowDate, numRacket, returned)
DROP TABLE IF EXISTS EQUIPMENT;
CREATE TABLE EQUIPMENT (
	username VARCHAR(50),
	borrowDate DATE DEFAULT '0000-00-00',
	numRacket INT,
	returned BOOLEAN DEFAULT FALSE,
	PRIMARY KEY(username,borrowDate)
);

-- DISCOUNT (level, percent)
DROP TABLE IF EXISTS DISCOUNT;
CREATE TABLE DISCOUNT (
	level INT,
	percent INT,
	PRIMARY KEY(level)
);

--LOAD DATA LOCAL INFILE 'member.txt' INTO TABLE MEMBER;
--LOAD DATA LOCAL INFILE 'court.txt' INTO TABLE COURT;
--LOAD DATA LOCAL INFILE 'reservation.txt' INTO TABLE RESERVATION;
--LOAD DATA LOCAL INFILE 'equipment.txt' INTO TABLE EQUIPMENT;
--LOAD DATA LOCAL INFILE 'discount.txt' INTO TABLE DISCOUNT;
