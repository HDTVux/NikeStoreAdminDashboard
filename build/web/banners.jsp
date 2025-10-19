<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Banner" %>
<html>
<head>
  <title>Banners - Nike Admin</title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
  <div class="header-bar">
    <h2>Banners</h2>
    <a href="banners?action=new" class="btn btn-dark">+ Add Banner</a>
  </div>

  <table class="table table-striped align-middle">
    <thead>
      <tr><th>ID</th><th>Image</th><th>Title</th><th>Active</th><th>Start-End</th><th>Actions</th></tr>
    </thead>
    <tbody>
      <%
        List<Banner> list = (List<Banner>) request.getAttribute("banners");
        if (list != null && !list.isEmpty()) {
          for (Banner b : list) {
      %>
      <tr>
        <td><%= b.getId() %></td>
        <td><img src="<%= b.getImageUrl() %>" style="height:60px" onerror="this.src='assets/img/noimg.png'"></td>
        <td><%= b.getTitle() %></td>
        <td><%= b.isActive() ? "✅" : "❌" %></td>
        <td>
          <%= b.getStartsAt() != null ? b.getStartsAt() : "-" %> → 
          <%= b.getEndsAt() != null ? b.getEndsAt() : "-" %>
        </td>
        <td>
          <a href="banners?action=toggle&id=<%=b.getId()%>" class="btn btn-sm btn-outline-dark">Toggle</a>
          <a href="banners?action=edit&id=<%=b.getId()%>" class="btn btn-sm btn-warning">Edit</a>
        </td>
      </tr>
      <% } } else { %>
      <tr><td colspan="6" class="text-center text-muted">No banners found</td></tr>
      <% } %>
    </tbody>
  </table>
</div>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
