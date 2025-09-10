package com.momentus.util;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class OrganizerServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String DB_USER = "system";
    private static final String DB_PASS = "2004";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                if ("add".equalsIgnoreCase(action)) {
                    String sql = "INSERT INTO EVENT (ID, TITLE, DESCRIPTION, AMOUNT, EVENT_DATE, LOCATION, STATUS) VALUES (EVENT_SEQ.NEXTVAL, ?, ?, ?, ?, ?, 'PENDING')";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, req.getParameter("title"));
                    ps.setString(2, req.getParameter("description"));
                    ps.setInt(3, Integer.parseInt(req.getParameter("amount")));
                    ps.setDate(4, java.sql.Date.valueOf(req.getParameter("date")));
                    ps.setString(5, req.getParameter("location"));
                    ps.executeUpdate();
                    
                } else if ("update".equalsIgnoreCase(action)) {
                    String sql = "UPDATE EVENT SET TITLE=?, DESCRIPTION=?, AMOUNT=?, EVENT_DATE=?, LOCATION=? WHERE ID=?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, req.getParameter("title"));
                    ps.setString(2, req.getParameter("description"));
                    ps.setInt(3, Integer.parseInt(req.getParameter("amount")));
                    ps.setDate(4, java.sql.Date.valueOf(req.getParameter("date")));
                    ps.setString(5, req.getParameter("location"));
                    ps.setInt(6, Integer.parseInt(req.getParameter("id")));
                    ps.executeUpdate();
                    
                } else if ("delete".equalsIgnoreCase(action)) {
                    String sql = "DELETE FROM EVENT WHERE ID=?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(req.getParameter("id")));
                    ps.executeUpdate();
                    
                } else if ("list".equalsIgnoreCase(action)) {
                    JSONArray eventsArray = new JSONArray();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM EVENT ORDER BY ID DESC");
                    while (rs.next()) {
                        JSONObject ev = new JSONObject();
                        ev.put("id", rs.getInt("ID"));
                        ev.put("title", rs.getString("TITLE"));
                        ev.put("description", rs.getString("DESCRIPTION"));
                        ev.put("amount", rs.getInt("AMOUNT"));
                        ev.put("date", rs.getDate("EVENT_DATE").toString());
                        ev.put("location", rs.getString("LOCATION"));
                        ev.put("status", rs.getString("STATUS"));
                        eventsArray.put(ev);
                    }
                    out.print(eventsArray.toString());
                    out.flush();
                    con.close();
                    return;
                }
            }
            JSONObject success = new JSONObject();
            success.put("status", "success");
            out.print(success.toString());

        } catch (ClassNotFoundException | NumberFormatException | SQLException | JSONException e) {
            JSONObject error = new JSONObject();
            error.put("status", "error");
            out.print(error.toString());
        }
    }
}
