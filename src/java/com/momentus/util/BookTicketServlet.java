package com.momentus.util;

import com.momentus.model.Event;
import com.momentus.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;


public class BookTicketServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.html"); return;
        }
        int eventId = Integer.parseInt(req.getParameter("eventId"));

        Event ev = null;
        String sql = "SELECT ID, TITLE, AMOUNT, EVENT_DATE FROM EVENT WHERE ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ev = new Event();
                    ev.setId(rs.getInt("ID"));
                    ev.setTitle(rs.getString("TITLE"));
                    ev.setAmount(rs.getDouble("AMOUNT"));
                    ev.setEventDate(rs.getDate("EVENT_DATE"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(BookTicketServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        req.setAttribute("event", ev);
        req.getRequestDispatcher("paymentForm.jsp").forward(req, resp);
    }
}
