package com.momentus.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL  = "jdbc:oracle:thin:@localhost:1521:xe"; 
    private static final String USER = "system";   
    private static final String PASS = "2004";   

    public static Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.OracleDriver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    
    public static void main(String[] args) {
        try (Connection con = getConnection()) {
            System.out.println("✅ Connected to Oracle: " + con);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
