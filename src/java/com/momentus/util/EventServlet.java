package com.momentus.util;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class EventServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String DB_USER = "system";
    private static final String DB_PASS = "2004";

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM EVENT");

            StringBuilder json = new StringBuilder();
            json.append("[");

            while (rs.next()) {
                json.append("{")
                    .append("\"id\":").append(rs.getInt("ID")).append(",")
                    .append("\"title\":\"").append(rs.getString("TITLE")).append("\",")
                    .append("\"description\":\"").append(rs.getString("DESCRIPTION")).append("\",")
                    .append("\"amount\":").append(rs.getInt("AMOUNT")).append(",")
                    .append("\"eventDate\":\"").append(rs.getDate("EVENT_DATE")).append("\",")
                    .append("\"location\":\"").append(rs.getString("LOCATION")).append("\",")
                    .append("\"status\":\"").append(rs.getString("STATUS")).append("\"")
                    .append("},");
            }

            if (json.charAt(json.length() - 1) == ',') {
                json.deleteCharAt(json.length() - 1); // last comma हटाना
            }
            json.append("]");

            out.print(json.toString());
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}
