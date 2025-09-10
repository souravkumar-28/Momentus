package com.momentus.util;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;


public class ConfirmBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.getWriter().write("Please login first");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        int userId = -1;
        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try (Connection con = DBConnection.getConnection()) {
            // Get USER_ID
            PreparedStatement ps = con.prepareStatement("SELECT USER_ID FROM USERS WHERE EMAIL = ?");
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) userId = rs.getInt("USER_ID");
            rs.close();
            ps.close();

            // Insert booking (ID + BOOKING_DATE handled by trigger)
            ps = con.prepareStatement("INSERT INTO BOOKING(USER_ID, EVENT_ID, PAYMENT_STATUS) VALUES (?, ?, ?)");
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ps.setString(3, "Completed"); // simulated payment
            ps.executeUpdate();
            ps.close();

            response.getWriter().write("Booking Confirmed!");
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
