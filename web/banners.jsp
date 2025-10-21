<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Banner" %>
<html>
<head>
  <title>Banners - Nike Admin</title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/admin-dashboard.css">
  <style>
    .pagination{display:flex;justify-content:center;gap:6px;margin-top:16px;}
    .pagination a{padding:6px 12px;border-radius:6px;background:#111;color:#fff;text-decoration:none;border:1px solid #333;}
    .pagination a.active{background:#fff;color:#000;}
    .table{width:100%;}
    .table td,.table th{vertical-align:middle;text-align:center;}
  </style>
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
  <div class="header-bar">
    <h2>Banners</h2>
    <a href="BannerServlet?action=new" class="btn btn-dark">+ Add Banner</a>
  </div>

  <table class="table table-dark mt-3">
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
        <td><img src="<%= b.getImageUrl() %>" style="height:60px;width:140px;object-fit:cover;border-radius:6px"
                 onerror="this.src='assets/img/noimg.png'"></td>
        <td><%= b.getTitle() %></td>
        <td><%= b.isActive() ? "✅" : "❌" %></td>
        <td>
          <%= b.getStartsAt() != null ? b.getStartsAt() : "-" %> →
          <%= b.getEndsAt()   != null ? b.getEndsAt()   : "-" %>
        </td>
        <td>
          <a href="BannerServlet?action=toggle&id=<%=b.getId()%>" class="btn btn-sm btn-outline-light">Toggle</a>
          <a href="BannerServlet?action=edit&id=<%=b.getId()%>"   class="btn btn-sm btn-warning">Edit</a>
          <a href="BannerServlet?action=delete&id=<%=b.getId()%>" class="btn btn-sm btn-outline-danger"
             onclick="return confirm('Delete this banner?')">Delete</a>
        </td>
      </tr>
      <% } } else { %>
      <tr><td colspan="6" class="text-center text-muted">No banners found</td></tr>
      <% } %>
    </tbody>
  </table>

  <!-- Pagination -->
  <div class="pagination">
    <%
      Integer currentPage = (Integer) request.getAttribute("currentPage");
      Integer totalPages  = (Integer) request.getAttribute("totalPages");
      if (currentPage == null) currentPage = 1;
      if (totalPages  == null) totalPages  = 1;

      if (currentPage > 1) {
    %>
      <a href="BannerServlet?page=<%= currentPage - 1 %>">Prev</a>
    <% } %>

    <%
      for (int i = 1; i <= totalPages; i++) {
    %>
      <a href="BannerServlet?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
    <%
      }
      if (currentPage < totalPages) {
    %>
      <a href="BannerServlet?page=<%= currentPage + 1 %>">Next</a>
    <% } %>
  </div>
</div>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
