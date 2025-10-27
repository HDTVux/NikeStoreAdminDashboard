<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.User" %>
<html>
<head>
    <title>Users - Nike Admin</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
    <style>
        body {
            background: #f8f9fa;
        }
        .content {
            margin-left: 240px;
            padding: 30px 40px;
        }
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .header-bar h2 {
            font-weight: 600;
            color: #222;
        }
        .btn-add {
            background: #000;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 18px;
            font-weight: 500;
            transition: 0.2s;
            text-decoration: none;
        }
        .btn-add:hover {
            background: #222;
            color: #26ff86;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
        }
        th {
            background: #111;
            color: #fff;
            padding: 12px;
            text-align: center;
        }
        td {
            padding: 14px 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        tr:last-child td {
            border-bottom: none;
        }
        .status {
            padding: 6px 14px;
            border-radius: 20px;
            color: #fff;
            font-size: 14px;
            font-weight: 500;
            display: inline-block;
        }
        .status.active {
            background: #00c853;
        }
        .status.inactive {
            background: #ff5252;
        }
        a.action {
            font-weight: 500;
            text-decoration: none;
            margin: 0 6px;
        }
        a.edit {
            color: #007bff;
        }
        a.delete {
            color: #ff5252;
        }
        a.toggle {
            color: #ff9800;
        }
        a.action:hover {
            text-decoration: underline;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            list-style: none;
        }
        .pagination li {
            margin: 0 5px;
        }
        .pagination a {
            color: #fff;
            background-color: #333;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.2s;
        }
        .pagination a.active {
            background-color: #fff;
            color: #000;
            font-weight: bold;
        }
        .pagination a:hover:not(.active) {
            background-color: #555;
        }
    </style>
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
    <div class="header-bar">
        <h2>Users</h2>
        <a href="UserServlet?action=new" class="btn-add">+ Add User</a>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Email</th>
            <th>Username</th>
            <th>Status</th>
            <th>Actions</th>
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
            <td>
                <span class="status <%= u.isActive() ? "active" : "inactive" %>">
                    <%= u.isActive() ? "Active" : "Inactive" %>
                </span>
            </td>
            <td>
                <a href="UserServlet?action=edit&id=<%=u.getId()%>" class="action edit">Edit</a>
                <a href="UserServlet?action=toggle&id=<%=u.getId()%>" class="action toggle">
                    <%= u.isActive() ? "Deactivate" : "Activate" %>
                </a>
                <a href="UserServlet?action=delete&id=<%=u.getId()%>" 
                   class="action delete" 
                   onclick="return confirm('Delete this user?')">Delete</a>
            </td>
        </tr>
        <% 
                }
            } else { 
        %>
        <tr>
            <td colspan="5" class="text-muted text-center py-4">No users found</td>
        </tr>
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

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
