<%-- 
    Document   : availableEvents
    Created on : 30 Aug, 2025, 3:58:14 AM
    Author     : SOURAV
--%>

<%@ page import="java.util.*, com.momentus.model.Event" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Available Events</title>
  <style>
    body{font-family:Arial;padding:20px;}
    table{width:95%;margin:auto;border-collapse:collapse;}
    th,td{border:1px solid #ddd;padding:8px;text-align:center;}
    th{background:#2E8B57;color:white;}
    .btn{padding:6px 12px;border:none;border-radius:4px;cursor:pointer;}
    .book{background:#4CAF50;color:white;}
  </style>
</head>
<body>
  <h2 style="text-align:center;">Available Events</h2>
  <table>
    <tr><th>Title</th><th>Description</th><th>Amount</th><th>Date</th><th>Location</th><th>Action</th></tr>
    <%
      List<Event> events = (List<Event>) request.getAttribute("eventsList");
      if (events != null && !events.isEmpty()) {
        for (Event e : events) {
    %>
    <tr>
      <td><%= e.getTitle() %></td>
      <td><%= e.getDescription() %></td>
      <td>? <%= String.format("%.2f", e.getAmount()) %></td>
      <td><%= e.getEventDate() %></td>
      <td><%= e.getLocation() %></td>
      <td>
        <form action="BookTicketServlet" method="post">
          <input type="hidden" name="eventId" value="<%= e.getId() %>">
          <input class="btn book" type="submit" value="Book Ticket">
        </form>
      </td>
    </tr>
    <%  }
      } else { %>
    <tr><td colspan="6">No approved events right now.</td></tr>
    <% } %>
  </table>
</body>
</html>
