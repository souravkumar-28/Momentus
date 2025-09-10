<%-- 
    Document   : bookingConfirmation
    Created on : 30 Aug, 2025, 3:58:53 AM
    Author     : SOURAV
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    String eventTitle = (String) request.getAttribute("eventTitle");
    String eventDate = (String) request.getAttribute("eventDate");
    String userName = (String) request.getAttribute("userName");
    String userEmail = (String) request.getAttribute("userEmail");
    Double amountObj = (Double) request.getAttribute("amount");
    String amountStr = amountObj != null ? String.format("%.2f", amountObj) : "0.00";
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Booking Receipt</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f6f6f6; padding: 20px; }
    .receipt { width:700px; margin:20px auto; background:white; padding:24px; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.1); }
    .header { text-align:center; margin-bottom:10px; }
    .field { margin:8px 0; }
    .label { color:#555; display:inline-block; width:160px; font-weight:600; }
    .value { color:#222; display:inline-block; }
    .actions { text-align:center; margin-top:18px; }
    .btn { padding:10px 16px; border:none; border-radius:6px; cursor:pointer; margin:6px; }
    .download { background:#2196F3;color:white; }
    .printBtn { background:#4CAF50;color:white; }
  </style>
</head>
<body>
  <div class="receipt" id="receipt">
    <div class="header">
      <h2>Booking Receipt</h2>
      <div>Thank you for booking!</div>
    </div>

    <div class="field"><span class="label">Booking ID:</span><span class="value"><%= bookingId %></span></div>
    <div class="field"><span class="label">Event:</span><span class="value"><%= eventTitle %></span></div>
    <div class="field"><span class="label">Event Date:</span><span class="value"><%= eventDate %></span></div>
    <div class="field"><span class="label">Name:</span><span class="value"><%= userName %></span></div>
    <div class="field"><span class="label">Email:</span><span class="value"><%= userEmail %></span></div>
    <div class="field"><span class="label">Amount:</span><span class="value">₹ <%= amountStr %></span></div>

    <div class="actions">
      <button class="btn download" id="downloadBtn">Download Receipt (PDF)</button>
      <button class="btn printBtn" onclick="window.print()">Print</button>
      <a href="MyBookingsServlet" class="btn" style="background:#777;color:white;text-decoration:none;padding:10px 16px;border-radius:6px;">My Bookings</a>
    </div>
  </div>

  <!-- html2canvas + jsPDF -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

  <script>
    (function(){
      const bookingId = "<%= bookingId %>";
      const autoDownload = true;

      async function generatePdfAndSave(filename) {
        const { jsPDF } = window.jspdf;
        const receipt = document.getElementById('receipt');
        const canvas = await html2canvas(receipt, { scale: 2 });
        const imgData = canvas.toDataURL('image/png');

        const doc = new jsPDF({ unit: 'px', format: 'a4' });
        const pageWidth = doc.internal.pageSize.getWidth();
        const margin = 20;
        const pdfWidth = pageWidth - margin*2;
        const imgProps = doc.getImageProperties(imgData);
        const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

        doc.addImage(imgData, 'PNG', margin, margin, pdfWidth, pdfHeight);
        doc.setProperties({ title: "Receipt " + filename });
        doc.save(filename);
      }

      window.addEventListener('load', function(){
        if (autoDownload) {
          const filename = 'receipt_booking_' + bookingId + '.pdf';
          generatePdfAndSave(filename).catch(err => console.error('PDF gen failed', err));
        }
      });

      document.getElementById('downloadBtn').addEventListener('click', function(){
        const filename = 'receipt_booking_' + bookingId + '.pdf';
        generatePdfAndSave(filename);
      });
    })();
  </script>
</body>
</html>
