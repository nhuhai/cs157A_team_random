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



