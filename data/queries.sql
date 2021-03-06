-- 1. Sign up
-- public static int addMember(String username, String password, String name)
String sql = "INSERT INTO Member (username, password, name) VALUES (?, ?, ?)";

-- 2. Sign in
-- public static Boolean memberExists(String username, String password) 
String sql = "SELECT count(*) AS count FROM MEMBER WHERE username = \"" + username + "\""
                + " and password = \"" + password + "\"" ;

-- 3. Retrieve Userprofile
-- public static ArrayList<String> getUserProfile(String username)
String sql = "SELECT * FROM MEMBER WHERE username = \"" + username + "\"";

-- 4. Reserve Court
-- public static int reserveCourt(String username, int courtID, Date reserveDate, int reserveTime)
String sql = "INSERT INTO RESERVATION (username, cID, reserveDate, reserveTime) VALUES (?, ?, ?, ?)";

-- 5. Reserve Equipment
-- public static int reserveEquipment(String username, Date reserveDate, int numberBrackets, boolean returned)
String sql = "INSERT INTO EQUIPMENT (username, borrowDate, numRacket, returned) VALUES (?, ?, ?, ?)";

-- 6. Retrieve Reservation
-- public static ArrayList<String> getReservation(String username)
String sql = "SELECT * FROM RESERVATION where username = ?";

-- 7. Get Avai Courts For Date and Time
-- public static ArrayList<String> getAvailableCourtsForDateAndTime(String date, String time)
String sql = "SELECT distinct(cID) FROM RESERVATION where reserveDate = ? and reserveTime = ?";

-- 8. Delete Reservation
-- public static void deleteReservation(String username, String date, String time, String courtID)
String sql = "DELETE FROM RESERVATION where username = ? and reserveDate = ? and reserveTime = ? and cID = ?";

-- Stored Proc -- Transactions -- Archive relations
DROP PROCEDURE IF EXISTS ArchiveMember;
DELIMITER //
CREATE PROCEDURE ArchiveMember(IN cutoffDate DATE) 
BEGIN
	Insert into MEMBER_ARCHIVED(username, password, name, level, updatedAt) values (Member.username, Member.password, Member.name, Member.level, Member.updatedAt)
	where Member.updatedAt == DATE
END//
DELIMITER ;

-- Trigger -- Delete reservations when delete court
CREATE TRIGGER DELETE_COURT_TRIGGER
AFTER DELETE ON COURT
FOR EACH ROW
BEGIN
	DELETE FROM RESERVATION
	WHERE cID = old.cID
END;


-- Trigger #3
DROP TRIGGER IF EXISTS INSERT_SAME_USERNAME_TO_MEMBER_ARCHIVED_TRIGGER;
DELIMITER //
CREATE TRIGGER INSERT_SAME_USERNAME_TO_MEMBER_ARCHIVED_TRIGGER
BEFORE INSERT ON MEMBER_ARCHIVED
FOR EACH ROW
BEGIN
	DELETE FROM MEMBER_ARCHIVED WHERE username = NEW.username;
END//
DELIMITER ;
