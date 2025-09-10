<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="com.momentus.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("userEmail") == null) {
        response.sendRedirect("login.html?msg=Please login first");
        return;
    }

    String userEmail = (String) session1.getAttribute("userEmail");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background:#1a1a1a url('https://www.transparenttextures.com/patterns/dark-denim-3.png');
            padding: 20px;
        }
        h2 {
            text-align: center;
        }
        table {
    width: 90%;
    margin: 20px auto;
    border-collapse: collapse;
    background: #fff;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);

    border-radius: 10px;   
    overflow: hidden;      
}
        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #fb5f5f;
            color: #fff;
        }
        tr:hover {
            background: #f1f1f1;
        }
        .header {
    display: flex;
    justify-content: space-between;   /* Heading left, button right */
    align-items: center;
    margin-bottom: 20px;
    padding: 0 20px;
}

    .back-btn {
        padding: 6px 12px;
        background: #f76a6a;
        color: white;
        border-radius: 5px;
        text-decoration: none;
        font-size: 14px;
        transition: 0.3s ease;
    }
    .back-btn:hover {
        background: #ff0000;
    }

    .header h2 {
        color: white;
        margin: 0;
        font-size: 22px;
        font-weight: 600;
    }
    </style>
</head>
<body>
    <div class="header">
    <h2>My Bookings</h2>
    <a href="userdashboard.jsp" class="back-btn">⬅ Back to Dashboard</a>
</div>

    <table>
        <tr>
            <th>Booking ID</th>
            <th>Event Title</th>
            <th>Event Status</th>
            <th>Booking Date</th>
            <th>Payment Status</th>
        </tr>
        <%
            try {
                con = DBConnection.getConnection();

                // Get USER_ID from USERS
                String sqlUser = "SELECT USER_ID FROM USERS WHERE EMAIL = ?";
                ps = con.prepareStatement(sqlUser);
                ps.setString(1, userEmail);
                rs = ps.executeQuery();

                int userId = -1;
                if (rs.next()) {
                    userId = rs.getInt("USER_ID");
                }
                rs.close();
                ps.close();

                if (userId != -1) {
                    // Fetch bookings with event details
                    String sql = "SELECT b.ID, NVL(e.TITLE, 'Event Not Available') AS TITLE, " +
                                 "b.BOOKING_DATE, b.PAYMENT_STATUS, e.STATUS AS EVENT_STATUS " +
                                 "FROM BOOKING b " +
                                 "LEFT JOIN EVENT e ON b.EVENT_ID = e.ID " +
                                 "WHERE b.USER_ID = ? " +
                                 "ORDER BY b.BOOKING_DATE DESC";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();

                    boolean hasBookings = false;
                    while (rs.next()) {
                        hasBookings = true;
        %>
                        <tr>
                            <td><%= rs.getInt("ID") %></td>
                            <td><%= rs.getString("TITLE") %></td>
                            <td><%= rs.getString("EVENT_STATUS") != null ? rs.getString("EVENT_STATUS") : "N/A" %></td>
                            <td><%= rs.getDate("BOOKING_DATE") %></td>
                            <td><%= rs.getString("PAYMENT_STATUS") %></td>
                        </tr>
        <%
                    }
                    if (!hasBookings) {
        %>
                        <tr>
                            <td colspan="5">No bookings found</td>
                        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (con != null) con.close(); } catch (Exception ignored) {}
            }
        %>
    </table>

    
</body>
</html>
