package com.momentus.util;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;


public class BookEventServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            resp.sendRedirect("login.html?msg=Please login first");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        int eventId = Integer.parseInt(req.getParameter("eventId"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // Step 1: Get USER_ID from USERS table using EMAIL
            int userId = -1;
            String userSql = "SELECT USER_ID FROM USERS WHERE EMAIL = ?";
            ps = con.prepareStatement(userSql);
            ps.setString(1, userEmail);
            rs = ps.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("USER_ID");
            }
            rs.close();
            ps.close();

            if (userId == -1) {
                resp.sendRedirect("userdashboard.jsp?msg=User not found in DB");
                return;
            }

            // Step 2: Insert booking into BOOKING table
            String sql = "INSERT INTO BOOKING (ID, USER_ID, EVENT_ID, PAYMENT_STATUS, BOOKING_DATE) " +
                         "VALUES (BOOKING_SEQ.NEXTVAL, ?, ?, 'PENDING', SYSDATE)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, eventId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                resp.sendRedirect("myBookings.jsp?msg=Booking successful");
            } else {
                resp.sendRedirect("userdashboard.jsp?msg=Booking failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("userdashboard.jsp?msg=Server error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
