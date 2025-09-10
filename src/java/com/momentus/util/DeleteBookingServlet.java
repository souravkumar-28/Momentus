package com.momentus.util;

import com.momentus.util.DBConnection;

import javax.servlet.ServletException;

import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;


public class DeleteBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html?msg=Please login first");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect("myBookings.jsp?msg=Invalid booking ID");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);

        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM BOOKING WHERE ID = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("myBookings.jsp?msg=Booking deleted successfully");
                } else {
                    response.sendRedirect("myBookings.jsp?msg=Booking not found");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myBookings.jsp?msg=Error deleting booking");
        }
    }
}
