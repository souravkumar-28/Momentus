package com.momentus.util;


import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;


public class CancelBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) { resp.sendRedirect("login.html"); return; }

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE BOOKING SET PAYMENT_STATUS = ? WHERE ID = ?")) {
            ps.setString(1, "CANCELLED");
            ps.setInt(2, bookingId);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                resp.sendRedirect("MyBookingsServlet");
            } else {
                resp.getWriter().println("Unable to cancel booking. <a href='MyBookingsServlet'>Back</a>");
            }
        } catch (SQLException ex) {
            resp.getWriter().println("Server error. <a href='MyBookingsServlet'>Back</a>");
        } catch (Exception ex) {
            Logger.getLogger(CancelBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
