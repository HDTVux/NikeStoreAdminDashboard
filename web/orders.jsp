<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Order" %>
<html>
<head>
  <title>Orders - Nike Admin</title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
  <h2 class="mb-4 text-white">Orders</h2>

  <div class="table-responsive">
    <table class="table table-dark table-hover w-100">
      <thead>
        <tr>
          <th>ID</th>
          <th>User</th>
          <th>Status</th>
          <th>Total</th>
          <th>Payment</th>
          <th>Shipping Fee</th>
          <th>Subtotal</th>
          <th>Created</th>
        </tr>
      </thead>
      <tbody>
        <%
          List<Order> orders = (List<Order>) request.getAttribute("orders");
          if (orders != null && !orders.isEmpty()) {
              for (Order o : orders) {
        %>
          <tr>
            <td><%= o.getId() %></td>
            <td><%= o.getUserEmail() %></td>
            <td><%= o.getStatus() %></td>
            <td><%= String.format("%,.2f USD", o.getTotalPrice()) %></td>
            <td><%= o.getPaymentMethod() %></td>
            <td><%= String.format("%,.2f", o.getShippingFee()) %></td>
            <td><%= String.format("%,.2f", o.getSubtotal()) %></td>
            <td><%= o.getCreatedAt() %></td>
          </tr>
        <%
              }
          } else {
        %>
          <tr><td colspan="8">No orders found.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>

  <!-- Pagination -->
  <ul class="pagination">
    <%
      int currentPage = (int) request.getAttribute("currentPage");
      int totalPages = (int) request.getAttribute("totalPages");
      if (currentPage > 1) {
    %>
      <li><a href="?page=<%= currentPage - 1 %>">Prev</a></li>
    <% } %>
    <%
      for (int i = 1; i <= totalPages; i++) {
    %>
      <li><a href="?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a></li>
    <% } %>
    <%
      if (currentPage < totalPages) {
    %>
      <li><a href="?page=<%= currentPage + 1 %>">Next</a></li>
    <% } %>
  </ul>
</div>
</body>
</html>
