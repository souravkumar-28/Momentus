<%-- 
    Document   : paymentForm
    Created on : 30 Aug, 2025, 3:58:35 AM
    Author     : SOURAV
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.momentus.model.Event" %>
<%
  Event ev = (Event) request.getAttribute("event");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Payment</title>
  <style>
    body{font-family:Arial;text-align:center;padding-top:30px;}
    .card{display:inline-block;padding:20px;border:1px solid #ccc;border-radius:8px;}
    input{margin:8px 0;padding:8px;width:260px;}
    .pay{background:#2196F3;color:white;border:none;padding:8px 16px;border-radius:4px;cursor:pointer;}
  </style>
  <script>
    function validateAndSubmit(){
      let card = document.getElementById('card').value.trim();
      let expiry = document.getElementById('expiry').value.trim();
      let cvv = document.getElementById('cvv').value.trim();
      let email = document.getElementById('email').value.trim();

      if(card.length < 12){ alert('Enter valid card number'); return false; }
      if(!/^\d{2}\/\d{2}$/.test(expiry)){ alert('Expiry should be MM/YY'); return false; }
      if(cvv.length < 3){ alert('Enter CVV'); return false; }
      if(!email.includes('@')){ alert('Enter valid email'); return false; }
      return true;
    }
  </script>
</head>
<body>
  <h2>Payment for: <%= ev.getTitle() %></h2>
  <div class="card">
    <p>Amount: ₹ <%= String.format("%.2f", ev.getAmount()) %></p>
    <form action="ConfirmBookingServlet" method="post" onsubmit="return validateAndSubmit();">
      <input type="hidden" name="eventId" value="<%= ev.getId() %>">
      <input id="card" name="cardNumber" placeholder="Card Number" required><br>
      <input id="expiry" name="expiry" placeholder="MM/YY" required><br>
      <input id="cvv" name="cvv" placeholder="CVV" required><br>
      <input id="email" name="email" placeholder="Your Email" required><br>
      <input class="pay" type="submit" value="Pay & Book">
    </form>
  </div>
</body>
</html>
