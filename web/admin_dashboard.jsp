<%@ page import="java.util.*" %>
<%@ page import="com.momentus.model.Event" %>
<%
    ArrayList<Event> pendingEvents = (ArrayList<Event>) request.getAttribute("pendingEvents");
%>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h3>Pending Event Requests</h3>

    <p>Pending events received: <%= (pendingEvents != null ? pendingEvents.size() : "null") %></p>

    <table class="table table-striped table-bordered mt-3">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            if(pendingEvents != null && !pendingEvents.isEmpty()) {
                for(Event ev : pendingEvents) {
        %>
            <tr>
                <td><%= ev.getId() %></td>
                <td><%= ev.getTitle() %></td>
                <td><%= ev.getStatus() %></td>
                <td>
                    <form action="AdminDashboardServlet" method="post" class="d-inline">
                        <input type="hidden" name="eventId" value="<%= ev.getId() %>"/>
                        <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
                    </form>
                    <form action="AdminDashboardServlet" method="post" class="d-inline">
                        <input type="hidden" name="eventId" value="<%= ev.getId() %>"/>
                        <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
                    </form>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="4" class="text-center">No pending events.</td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
