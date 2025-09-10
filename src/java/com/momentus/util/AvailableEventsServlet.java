package com.momentus.util;

import com.momentus.model.Event;
import com.momentus.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class AvailableEventsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.html");
            return;
        }

        List<Event> events = new ArrayList<>();
        String sql = "SELECT ID, TITLE, DESCRIPTION, AMOUNT, EVENT_DATE, LOCATION FROM EVENT WHERE STATUS = 'APPROVED' ORDER BY EVENT_DATE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("ID"));
                e.setTitle(rs.getString("TITLE"));
                e.setDescription(rs.getString("DESCRIPTION"));
                e.setAmount(rs.getDouble("AMOUNT"));
                e.setEventDate(rs.getDate("EVENT_DATE"));
                e.setLocation(rs.getString("LOCATION"));
                events.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(AvailableEventsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        req.setAttribute("eventsList", events);
        req.getRequestDispatcher("availableEvents.jsp").forward(req, resp);
    }
}
