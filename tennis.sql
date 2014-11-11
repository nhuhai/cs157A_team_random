DROP DATABASE IF EXISTS TENNIS;
CREATE DATABASE TENNIS;
USE TENNIS; 

-- Schema:
-- MEMBER (mID, name, level)
-- COURT (cID, inside, VIP, pricePerHour)
-- RESERVATION (mID, cID, reserveDate, reserveTime, paid)
-- EQUIPMENT (mID, borrowDate, numRacket, returned)
-- DISCOUNT (level, percent)

-- MEMBER (mID, name, level)
DROP TABLE IF EXISTS MEMBER;
CREATE TABLE MEMBER (
	mID INT,
	name VARCHAR(50),
	level INT,
	PRIMARY KEY(mID)
);

-- COURT (cID, inside, VIP, pricePerHour)
DROP TABLE IF EXISTS COURT;
CREATE TABLE COURT (
	cID INT,
	inside BOOLEAN DEFAULT FALSE, -- ?
	VIP BOOLEAN DEFAULT FALSE, -- ?
	pricePerHour INT,
	PRIMARY KEY(cID)
);

-- RESERVATION (mID, cID, reserveDate, reserveTime, paid)
DROP TABLE IF EXISTS RESERVATION;
CREATE TABLE RESERVATION (
	mID INT,
	cID INT,
	reserveDate DATE DEFAULT '0000-00-00',
	reserveTime INT,
	paid BOOLEAN DEFAULT FALSE,
	PRIMARY KEY(mID,cID,reserveDate,reserveTime)
);

-- EQUIPMENT (mID, borrowDate, numRacket, returned)
DROP TABLE IF EXISTS EQUIPMENT;
CREATE TABLE EQUIPMENT (
	mID INT,
	borrowDate DATE DEFAULT '0000-00-00',
	numRacket INT,
	returned BOOLEAN DEFAULT FALSE,
	PRIMARY KEY(mID,borrowDate)
);

-- DISCOUNT (level, percent)
DROP TABLE IF EXISTS DISCOUNT;
CREATE TABLE DISCOUNT (
	level INT,
	percent INT,
	PRIMARY KEY(level)
);

-- Please do NOT use absolute path for the files!!!
LOAD DATA LOCAL INFILE 'member.txt' INTO TABLE MEMBER;
--LOAD DATA LOCAL INFILE 'court.txt' INTO TABLE COURT;
--LOAD DATA LOCAL INFILE 'reservation.txt' INTO TABLE RESERVATION;
--LOAD DATA LOCAL INFILE 'equipment.txt' INTO TABLE EQUIPMENT;
LOAD DATA LOCAL INFILE 'discount.txt' INTO TABLE DISCOUNT;