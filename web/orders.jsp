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
  <div class="header-bar">
    <h2>Orders</h2>
  </div>

  <table class="table table-striped">
    <thead>
      <tr><th>ID</th><th>User ID</th><th>Status</th><th>Total</th><th>Payment</th><th>Created</th><th>Actions</th></tr>
    </thead>
    <tbody>
      <%
        List<Order> list = (List<Order>) request.getAttribute("orders");
        if (list != null && !list.isEmpty()) {
          for (Order o : list) {
      %>
      <tr>
        <td><%= o.getId() %></td>
        <td><%= o.getUserId() %></td>
        <td><%= o.getStatus() %></td>
        <td>$<%= o.getTotalPrice() %></td>
        <td><%= o.getPaymentMethod() %></td>
        <td><%= o.getCreatedAt() %></td>
        <td>
          <a href="orders?action=view&id=<%=o.getId()%>" class="btn btn-sm btn-outline-dark">View</a>
          <a href="orders?action=cancel&id=<%=o.getId()%>" class="btn btn-sm btn-danger">Cancel</a>
        </td>
      </tr>
      <% } } else { %>
      <tr><td colspan="7" class="text-center text-muted">No orders found</td></tr>
      <% } %>
    </tbody>
  </table>
</div>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
