package com.momentus.util;



import com.momentus.model.BookingView;
import com.momentus.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class MyBookingsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) { resp.sendRedirect("login.html"); return; }

        int userId = ((Number) session.getAttribute("userId")).intValue();
        List<BookingView> list = new ArrayList<>();
        String sql = "SELECT b.ID AS BOOKING_ID, b.PAYMENT_STATUS, b.BOOKING_DATE, e.ID AS EV_ID, e.TITLE, e.EVENT_DATE " +
                     "FROM BOOKING b JOIN EVENT e ON b.EVENT_ID = e.ID WHERE b.USER_ID = ? ORDER BY b.BOOKING_DATE DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingView bv = new BookingView();
                    bv.setBookingId(rs.getInt("BOOKING_ID"));
                    bv.setEventId(rs.getInt("EV_ID"));
                    bv.setEventTitle(rs.getString("TITLE"));
                    bv.setEventDate(rs.getDate("EVENT_DATE"));
                    bv.setPaymentStatus(rs.getString("PAYMENT_STATUS"));
                    bv.setBookingDate(rs.getDate("BOOKING_DATE"));
                    list.add(bv);
                }
            }
        } catch (SQLException ex) { ex.printStackTrace(); } catch (Exception ex) {
            Logger.getLogger(MyBookingsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        req.setAttribute("bookings", list);
        req.getRequestDispatcher("myBookings.jsp").forward(req, resp);
    }
}
