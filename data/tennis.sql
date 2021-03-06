DROP DATABASE IF EXISTS TENNIS;
CREATE DATABASE TENNIS;
USE TENNIS; 

-- Schema:
-- MEMBER (username, password, name, level)
DROP TABLE IF EXISTS MEMBER;
CREATE TABLE MEMBER (
	username VARCHAR(50),
	password VARCHAR(50),
	name VARCHAR(50),
	level INT DEFAULT 0 REFERENCES DISCOUNT(level),
	updatedAt DATE DEFAULT '0000-00-00',
	PRIMARY KEY(username)
);

DROP TABLE IF EXISTS MEMBER_ARCHIVED;
CREATE TABLE MEMBER_ARCHIVED (
	username VARCHAR(50),
	password VARCHAR(50),
	name VARCHAR(50),
	level INT DEFAULT 0,
	updatedAt DATE DEFAULT '0000-00-00'
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
	updatedAt DATE DEFAULT '0000-00-00',
	PRIMARY KEY(username,cID,reserveDate,reserveTime),
	FOREIGN KEY(username) REFERENCES MEMBER(username) ON DELETE CASCADE
);

DROP TABLE IF EXISTS RESERVATION_ARCHIVED;
CREATE TABLE RESERVATION_ARCHIVED (
	username VARCHAR(50),
	cID INT,
	reserveDate DATE DEFAULT '0000-00-00',
	reserveTime INT,
	paid BOOLEAN DEFAULT FALSE,
	updatedAt DATE DEFAULT '0000-00-00'
);

-- EQUIPMENT (username, borrowDate, numRacket, returned)
DROP TABLE IF EXISTS EQUIPMENT;
CREATE TABLE EQUIPMENT (
	username VARCHAR(50),
	borrowDate DATE DEFAULT '0000-00-00',
	numRacket INT,
	returned BOOLEAN DEFAULT FALSE,
	updatedAt DATE DEFAULT '0000-00-00',
	PRIMARY KEY(username,borrowDate),
	FOREIGN KEY(username) REFERENCES MEMBER(username) ON DELETE CASCADE
);

DROP TABLE IF EXISTS EQUIPMENT_ARCHIVED;
CREATE TABLE EQUIPMENT_ARCHIVED (
	username VARCHAR(50),
	borrowDate DATE DEFAULT '0000-00-00',
	numRacket INT,
	returned BOOLEAN DEFAULT FALSE,
	updatedAt DATE DEFAULT '0000-00-00'
);

-- DISCOUNT (level, percent)
DROP TABLE IF EXISTS DISCOUNT;
CREATE TABLE DISCOUNT (
	level INT,
	percent INT,
	PRIMARY KEY(level)
);

-- Trigger #1
DROP TRIGGER IF EXISTS DELETE_COURT_TRIGGER;
DELIMITER //
CREATE TRIGGER DELETE_COURT_TRIGGER
AFTER DELETE ON COURT
FOR EACH ROW
BEGIN
	DELETE FROM RESERVATION
	WHERE RESERVATION.cID = OLD.cID;
END//
DELIMITER ;

-- Trigger #2
DROP TRIGGER IF EXISTS MAX_THREE_RESERVATIONS_PER_DAY_TRIGGER;
DELIMITER //
CREATE TRIGGER MAX_THREE_RESERVATIONS_PER_DAY_TRIGGER
BEFORE INSERT ON RESERVATION 
FOR EACH ROW
BEGIN
	DECLARE msg VARCHAR(255);
	IF (SELECT COUNT(*) AS count 
		FROM RESERVATION 
		WHERE reserveDate = new.reserveDate 
		GROUP BY username 
		HAVING count >= 3) 
		IS NOT NULL THEN
			SET msg = 'Error. You cannot reserve more than 3 times on the same day.';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
	END IF;
END//
DELIMITER ;

-- Stored-Procedure #1
DROP PROCEDURE IF EXISTS ArchiveMember;
DELIMITER //
CREATE PROCEDURE ArchiveMember(IN cutoffDate DATE)
BEGIN
	START TRANSACTION;
	INSERT INTO MEMBER_ARCHIVED SELECT * FROM MEMBER WHERE updatedAt < cutoffDate;
	COMMIT;
END//
DELIMITER ; 
-- CALL ArchiveMember('2010-12-25');

-- Stored-Procedure #2
DROP PROCEDURE IF EXISTS ArchiveReservation;
DELIMITER //
CREATE PROCEDURE ArchiveReservation(IN cutoffDate DATE)
BEGIN
	START TRANSACTION;
	INSERT INTO RESERVATION_ARCHIVED SELECT * FROM RESERVATION WHERE updatedAt < cutoffDate;
	COMMIT;
END//
DELIMITER ; 
CALL ArchiveReservation('2010-12-25');

-- Stored-Procedure #3
DROP PROCEDURE IF EXISTS ArchiveEquipment;
DELIMITER //
CREATE PROCEDURE ArchiveEquipment(IN cutoffDate DATE)
BEGIN
	START TRANSACTION;
	INSERT INTO EQUIPMENT_ARCHIVED SELECT * FROM EQUIPMENT WHERE updatedAt < cutoffDate;
	COMMIT;
END//
DELIMITER ; 

-- LOAD DATA LOCAL INFILE 'court.txt' INTO TABLE COURT;
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (1, 0, 0, 10);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (2, 1, 0, 15);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (3, 0, 1, 20);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (4, 1, 1, 30);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (5, 0, 0, 10);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (6, 1, 0, 15);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (7, 0, 1, 20);
INSERT INTO COURT(cID, inside, VIP, pricePerHour) VALUES (8, 1, 1, 30);

-- LOAD DATA LOCAL INFILE 'discount.txt' INTO TABLE DISCOUNT;
INSERT INTO DISCOUNT(level, percent) VALUES (1, 5);
INSERT INTO DISCOUNT(level, percent) VALUES (2, 10);
INSERT INTO DISCOUNT(level, percent) VALUES (3, 15);
INSERT INTO DISCOUNT(level, percent) VALUES (4, 20);
INSERT INTO DISCOUNT(level, percent) VALUES (5, 25);

INSERT INTO MEMBER(username, password, name, level, updatedAt) VALUES('manager', '123', 'MANAGER', 0, '2010-12-01');
INSERT INTO MEMBER(username, password, name, level, updatedAt) VALUES('abc', 'abc', 'ABC', 0, '2010-12-01');
INSERT INTO MEMBER(username, password, name, level, updatedAt) VALUES('def', 'def', 'DEF', 0, '2010-12-14');
INSERT INTO MEMBER(username, password, name, level, updatedAt) VALUES('ghi', 'ghi', 'GHI', 0, '2010-12-25');
INSERT INTO MEMBER(username, password, name, level, updatedAt) VALUES('archive', '123', 'Test Archive', 0, '2010-12-25');

INSERT INTO RESERVATION (username, cID, reserveDate, reserveTime, updatedAt) VALUES ('archive', 1, '2013-1-13', 9, '2010-12-25');
INSERT INTO RESERVATION (username, cID, reserveDate, reserveTime, updatedAt) VALUES ('archive', 2, '2013-1-13', 9, '2010-12-25');
INSERT INTO RESERVATION (username, cID, reserveDate, reserveTime, updatedAt) VALUES ('archive', 3, '2013-1-13', 9, '2010-12-25');
INSERT INTO RESERVATION (username, cID, reserveDate, reserveTime, updatedAt) VALUES ('archive', 3, '2013-1-14', 9, '2010-12-25');

INSERT INTO EQUIPMENT (username, borrowDate, numRacket, returned, updatedAt) VALUES ('archive', '2013-1-1', 2, 1, '2012-5-5');
INSERT INTO EQUIPMENT (username, borrowDate, numRacket, returned, updatedAt) VALUES ('archive', '2013-1-3', 2, 1, '2012-5-7');
INSERT INTO EQUIPMENT (username, borrowDate, numRacket, returned, updatedAt) VALUES ('archive', '2010-1-5', 2, 0, '2013-5-9');