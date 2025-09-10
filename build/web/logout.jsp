


<%-- 
    Document   : newjsp
    Created on : 30 Aug, 2025, 5:10:20 AM
    Author     : SOURAV
--%>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession != null) {
        userSession.invalidate();
    }
    response.sendRedirect("login.html?msg=Logged out successfully");
%>
