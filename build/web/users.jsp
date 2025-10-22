<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.User" %>
<html>
<head>
    <title>Users - Nike Admin</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
    <div class="header-bar">
        <h2>Users</h2>
        <a href="UserServlet?action=new" class="btn btn-dark">+ Add User</a>
    </div>

    <table class="table table-dark mt-3">
        <thead>
            <tr>
                <th>ID</th><th>Email</th><th>Username</th><th>Active</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<User> list = (List<User>) request.getAttribute("users");
            if (list != null && !list.isEmpty()) {
                for (User u : list) {
        %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.isActive() ? "✅" : "❌" %></td>
                <td>
                    <a href="UserServlet?action=toggle&id=<%=u.getId()%>" class="btn btn-sm btn-outline-dark">Toggle</a>
                    <a href="UserServlet?action=edit&id=<%=u.getId()%>" class="btn btn-sm btn-warning">Edit</a>
                    <a href="UserServlet?action=delete&id=<%=u.getId()%>" class="btn btn-sm btn-danger" onclick="return confirm('Delete user?')">Delete</a>
                </td>
            </tr>
        <% } } else { %>
            <tr><td colspan="5" class="text-center text-muted">No users found</td></tr>
        <% } %>
        </tbody>
    </table>
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
