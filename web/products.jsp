<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<html>
<head>
  <title>Products - Nike Admin</title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
  <div class="header-bar">
    <h2>Products</h2>
    <a href="products?action=new" class="btn btn-dark">+ Add Product</a>
  </div>

  <table class="table table-striped">
    <thead>
      <tr>
        <th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Active</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <%
        List<Product> list = (List<Product>) request.getAttribute("products");
        if (list != null && !list.isEmpty()) {
          for (Product p : list) {
      %>
      <tr>
        <td><%= p.getId() %></td>
        <td><%= p.getName() %></td>
        <td>$<%= p.getPrice() %></td>
        <td><%= p.getStock() %></td>
        <td><%= p.isActive() ? "✅" : "❌" %></td>
        <td>
          <a href="products?action=toggle&id=<%=p.getId()%>" class="btn btn-sm btn-outline-dark">Toggle</a>
          <a href="products?action=edit&id=<%=p.getId()%>" class="btn btn-sm btn-warning">Edit</a>
        </td>
      </tr>
      <% } } else { %>
      <tr><td colspan="6" class="text-center text-muted">No products found</td></tr>
      <% } %>
    </tbody>
  </table>
</div>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
