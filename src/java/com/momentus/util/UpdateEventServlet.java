package com.momentus.util;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class UpdateEventServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String DB_USER = "system";
    private static final String DB_PASS = "2004";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String action = req.getParameter("action");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                PreparedStatement ps = con.prepareStatement("UPDATE EVENT SET STATUS=? WHERE ID=?");
                ps.setString(1, action);
                ps.setInt(2, id);
                ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
        }

        resp.setContentType("text/plain");
        resp.getWriter().print("SUCCESS");
    }
}
