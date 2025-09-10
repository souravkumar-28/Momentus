package com.momentus.util;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final String ADMIN_EMAIL = "admin@momentus.com";
    private static final String ADMIN_PASSWORD = "admin123";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {

            
            if (ADMIN_EMAIL.equalsIgnoreCase(email) && ADMIN_PASSWORD.equals(password)) {
                HttpSession session = req.getSession(true);
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", "admin");
                resp.sendRedirect("admin.html");
                return;
            }

            
            String sql = "SELECT password, role FROM users WHERE email=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        resp.sendRedirect("login.html?msg=User not registered");
                        return;
                    }

                    String dbPassword = rs.getString("password");
                    String role = rs.getString("role");

                    if (!dbPassword.equals(password)) {
                        resp.sendRedirect("login.html?msg=Invalid password");
                        return;
                    }

                    HttpSession session = req.getSession(true);
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userRole", role);

                    
                    if ("organizer".equalsIgnoreCase(role)) {
                        resp.sendRedirect("organizerdashboard.html");
                    } else {
                        resp.sendRedirect("userdashboard.jsp");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login.html?msg=Server error");
        }
    }
}
