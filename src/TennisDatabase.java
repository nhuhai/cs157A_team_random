/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author hainguyen
 */

import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;

public class TennisDatabase {
    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
    static final String DB_URL = "jdbc:mysql://localhost/TENNIS";
    
    //  Database credentials
    static final String USER = "root";
    static final String PASS = "";
    private static Connection conn = null;
    private static Statement statement = null;
    private static PreparedStatement pst = null;
    private static ResultSet rs = null;
    
    public static void connectToDatabase() {
        try {
            Class.forName("com.mysql.jdbc.Driver");

            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch ( ClassNotFoundException classNotFound ) {
            JOptionPane.showMessageDialog( null, 
            "MySQL driver not found", "Driver not found",
            JOptionPane.ERROR_MESSAGE );
            System.exit(1); // terminate application
        } catch(SQLException se) {
            JOptionPane.showMessageDialog( null, se.getMessage(), 
            "Database error", JOptionPane.ERROR_MESSAGE );
            System.exit(1);   // terminate application
        } catch(Exception e) {
            //Handle errors for Class.forName
            JOptionPane.showMessageDialog( null, e.getMessage(), 
            "Class.forName error", JOptionPane.ERROR_MESSAGE );
            System.exit(1);   // terminate application
        }
    }
    
    public static int addMember(String username, String password, String name) 
            throws SQLException {
        String sql = "INSERT INTO Member (username, password, name) VALUES (?, ?, ?)"; 
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, name);
            
            int result = pst.executeUpdate();
            
            return result;
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
            return 0;
        }
    }
    
    public static ArrayList<String> getUserProfile(String username) 
            throws SQLException {
        
        ArrayList<String> currentUser = new ArrayList<>();
        
        String sql = "SELECT * FROM MEMBER WHERE username = \"" + username + "\"";
        statement = conn.createStatement();
        rs = statement.executeQuery(sql);
        
        while(rs.next()) {
            int mId = rs.getInt("mID"); 
            String thisUsername = rs.getString("username");
            String thisPassword = rs.getString("password");
            String name = rs.getString("name");
            String level = Integer.toString(rs.getInt("level"));
            
            currentUser.add(name);
            currentUser.add(level);
        }
        
        return currentUser;
    }
    
    public static Boolean memberExists(String username, String password) 
            throws SQLException {
             
        String sql = "SELECT count(*) AS count FROM MEMBER WHERE username = \"" + username + "\""
                + " and password = \"" + password + "\"" ;
    
        statement = conn.createStatement();
        rs = statement.executeQuery(sql);
        
        int count = 0;
        
        while(rs.next()) {
            count = rs.getInt("count"); 
        }
    
        return count > 0;
    }
}
