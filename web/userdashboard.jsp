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
    int userId = -1;

    try {
        con = DBConnection.getConnection();

        String sqlUser = "SELECT USER_ID FROM USERS WHERE EMAIL = ?";
        ps = con.prepareStatement(sqlUser);
        ps.setString(1, userEmail);
        rs = ps.executeQuery();
        if (rs.next()) userId = rs.getInt("USER_ID");
        rs.close();
        ps.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background:#1a1a1a url('https://www.transparenttextures.com/patterns/dark-denim-3.png'); padding:20px; color:white; }
        .header { display:flex; justify-content:space-between; align-items:center; margin-bottom:30px; }
        .logout { padding:8px 16px; background:#dc3545; color:white; border-radius:5px; text-decoration:none; }
        .cards { display:flex; justify-content:space-around; flex-wrap:wrap; }
        .card { width:45%; background:#f9f9f9; border-radius:8px; padding:20px; margin:10px; color:#000; }
        table { width:100%; border-collapse: collapse; margin-top:10px; color:#000; }
        th, td { padding:8px; text-align:center; border-bottom:1px solid #555; }
        th { background:#ff4c4c; color:white; }
        .btn { padding:6px 12px; background:#28a745; color:white; border:none; border-radius:4px; cursor:pointer; }
        .btn:hover { background:#218838; }

        /* Payment Modal Styles */
        #paymentPanel {
            display:none; position:fixed; top:50%; left:50%;
            transform:translate(-50%, -50%);
            background:rgba(34,34,34,0.6); backdrop-filter: blur(15px);
            padding:25px; border-radius:20px; box-shadow:0 8px 25px rgba(0,0,0,0.4);
            z-index:1000; color:#fff; width:360px; font-family: 'Segoe UI', sans-serif;
            animation: fadeIn 0.3s ease-in-out;
        }
        #overlay {
            display:none; position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.6); backdrop-filter: blur(3px); z-index:999;
            animation: fadeIn 0.3s ease-in-out;
        }
        #paymentPanel input {
            width:100%; margin-bottom:15px; padding:10px; border-radius:10px;
            border:none; background:rgba(255,255,255,0.15); color:#fff; outline:none; font-size:16px;
        }
        #paymentPanel input:focus { background:rgba(255,255,255,0.25); border:1px solid #04ff00; }
        #paymentPanel button { width:100%; padding:12px; border:none; border-radius:12px; font-size:16px; cursor:pointer; transition:0.3s ease; }
        #paymentPanel button:hover { opacity:0.9; transform:scale(1.02); }
        #paymentPanel .payBtn { background:#74ff8e; color:#000; margin-bottom:10px; }
        #paymentPanel .cancelBtn { background:rgb(252,123,123); color:#fff; }
        @keyframes fadeIn { from {opacity:0; transform:translate(-50%, -45%);} to {opacity:1; transform:translate(-50%, -50%);} }
        #paymentMsg { font-weight:bold; margin-bottom:10px; }
    </style>
</head>
<body>
<div class="header">
    <h2>Welcome, <%= userEmail %></h2>
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<div class="cards">
    <!-- Available Events -->
    <div class="card">
        <h3>Available Events</h3>
        <table>
            <tr>
                <th>Title</th>
                <th>Date</th>
                <th>Location</th>
                <th>Amount</th>
                <th>Action</th>
            </tr>
            <%
                try {
                    String sqlEvents = "SELECT * FROM EVENT WHERE STATUS = 'APPROVED' ORDER BY EVENT_DATE ASC";
                    ps = con.prepareStatement(sqlEvents);
                    rs = ps.executeQuery();
                    boolean hasEvents = false;
                    while(rs.next()) {
                        hasEvents = true;
            %>
                        <tr>
                            <td><%= rs.getString("TITLE") %></td>
                            <td><%= rs.getDate("EVENT_DATE") %></td>
                            <td><%= rs.getString("LOCATION") %></td>
                            <td><%= rs.getInt("AMOUNT") %></td>
                            <td>
                                <button class="btn" onclick="openPaymentPopup(<%= rs.getInt("ID") %>, '<%= rs.getString("TITLE") %>', <%= rs.getInt("AMOUNT") %>)">Book</button>
                            </td>
                        </tr>
            <%
                    }
                    if(!hasEvents){
            %>
                        <tr><td colspan="5">No events available</td></tr>
            <%
                    }
                    rs.close(); ps.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <!-- My Bookings -->
    <div class="card">
        <h3>My Bookings</h3>
        <table>
            <tr>
                <th>Title</th>
                <th>Booking Date</th>
                <th>Payment Status</th>
                <th>Action</th>
            </tr>
            <%
                try {
                    String sqlBookings = "SELECT b.ID, e.TITLE, b.BOOKING_DATE, b.PAYMENT_STATUS " +
                                         "FROM BOOKING b JOIN EVENT e ON b.EVENT_ID = e.ID " +
                                         "WHERE b.USER_ID = ? ORDER BY b.BOOKING_DATE DESC";
                    ps = con.prepareStatement(sqlBookings);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();
                    boolean hasBookings = false;
                    while(rs.next()) {
                        hasBookings = true;
            %>
                        <tr>
                            <td><%= rs.getString("TITLE") %></td>
                            <td><%= rs.getDate("BOOKING_DATE") %></td>
                            <td><%= rs.getString("PAYMENT_STATUS") %></td>
                            <td>
                                <form action="DeleteBookingServlet" method="post" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="bookingId" value="<%= rs.getInt("ID") %>">
                                    <button type="submit" style="background:#dc3545; color:white; border:none; padding:5px 10px; border-radius:4px; cursor:pointer;">
                                        Cancel
                                    </button>
                                </form>
                            </td>
                        </tr>
            <%
                    }
                    if(!hasBookings){
            %>
                        <tr><td colspan="4">No bookings found</td></tr>
            <%
                    }
                } catch(Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    try { if(rs!=null) rs.close(); } catch(Exception ignored){}
                    try { if(ps!=null) ps.close(); } catch(Exception ignored){}
                    try { if(con!=null) con.close(); } catch(Exception ignored){}
                }
            %>
        </table>
    </div>
</div>

<!-- Payment Modal Panel -->
<div id="paymentPanel">
    <h3 style="text-align:center; margin-bottom:20px; color:#fff;">💳 Complete Payment</h3>
    <form id="paymentForm">
        <input type="hidden" id="eventId" name="eventId">
        <p><strong>Event:</strong> <span id="eventTitle"></span></p>
        <p><strong>Amount:</strong> ₹<span id="eventAmount"></span></p>

        <label>Name on Card:</label>
        <input type="text" name="cardName" required>

        <label>Card Number:</label>
        <input type="text" name="cardNumber" required maxlength="19" placeholder="1234 5678 9012 3456">

        <label>Expiry (MM/YY):</label>
        <input type="text" name="expiry" required maxlength="5" placeholder="MM/YY">

        <label>CVV:</label>
        <input type="password" name="cvv" required maxlength="3" placeholder="123">

        <!-- Inline message div -->
        <div id="paymentMsg"></div>

        <button type="submit" class="payBtn">Pay Now</button>
        <button type="button" class="cancelBtn" onclick="closePaymentPanel()">Cancel</button>
    </form>
</div>

<div id="overlay"></div>

<script>
const cardInput = document.querySelector('input[name="cardNumber"]');
cardInput.addEventListener('input', function(e){
    let val = this.value.replace(/\D/g,'').slice(0,16);
    let formatted = val.match(/.{1,4}/g);
    this.value = formatted ? formatted.join(' ') : '';
});

const expiryInput = document.querySelector('input[name="expiry"]');
expiryInput.addEventListener('input', function(e){
    let val = this.value.replace(/\D/g,'').slice(0,4);
    if(val.length>2) val = val.slice(0,2) + '/' + val.slice(2);
    this.value = val;
});

function openPaymentPopup(eventId, title, amount){
    document.getElementById('paymentPanel').style.display='block';
    document.getElementById('overlay').style.display='block';
    document.getElementById('eventId').value = eventId;
    document.getElementById('eventTitle').textContent = title;
    document.getElementById('eventAmount').textContent = amount;
    document.getElementById('paymentMsg').textContent = '';
}

function closePaymentPanel(){
    document.getElementById('paymentPanel').style.display='none';
    document.getElementById('overlay').style.display='none';
}

function showMsg(msg, color='#ffcc00'){
    const el = document.getElementById('paymentMsg');
    el.textContent = msg;
    el.style.color = color;
}

document.getElementById('paymentForm').addEventListener('submit', function(e){
    e.preventDefault();
    const form = e.target;
    const cardNumber = form.cardNumber.value.replace(/\s/g,'');
    const expiry = form.expiry.value;
    const cvv = form.cvv.value;

    if(!/^\d{16}$/.test(cardNumber)) return showMsg('Card number must be 16 digits','red');
    if(!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) return showMsg('Expiry must be MM/YY','red');
    if(!/^\d{3}$/.test(cvv)) return showMsg('CVV must be 3 digits','red');

    const formData = new FormData(form);
    showMsg('Processing payment...','#00ffcc');

    fetch('ConfirmBookingServlet', { method:'POST', body:new URLSearchParams(formData) })
    .then(res => res.text())
    .then(data=>{
        showMsg(data,'lightgreen');
        setTimeout(()=>{
            closePaymentPanel();
            location.reload();
        },1500);
    })
    .catch(err => showMsg('Error processing payment','red'));
});
</script>
</body>
</html>
