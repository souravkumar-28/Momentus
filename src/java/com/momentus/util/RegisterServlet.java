package com.momentus.util;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        
        System.out.println("🚀 RegisterServlet CALLED");

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        System.out.println("👉 Received Data: " + name + " | " + email + " | " + role);

        try (Connection con = DBConnection.getConnection()) {
            System.out.println("✅ DB Connection Successful!");

            
            try (PreparedStatement chk = con.prepareStatement("SELECT 1 FROM users WHERE email=?")) {
                chk.setString(1, email);
                if (chk.executeQuery().next()) {
                    System.out.println("⚠️ Email already exists: " + email);
                    resp.sendRedirect("signup.html?msg=Email+already+exists");
                    return;
                }
            }

            
            String sql = "INSERT INTO users(user_id, name, email, password, role) VALUES (user_seq.NEXTVAL, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, role);

                int rows = ps.executeUpdate();
                System.out.println("✅ Rows inserted = " + rows);

                if (rows > 0) {
                    resp.sendRedirect("signup.html?msg=Registered+successfully");
                } else {
                    resp.sendRedirect("login.html?msg=Registration+failed");
                }
            }

        } catch (Exception e) {
            System.out.println("❌ Exception in RegisterServlet:");
            e.printStackTrace();
            resp.sendRedirect("signup.html?msg=Server+error");
        }
    }
}
