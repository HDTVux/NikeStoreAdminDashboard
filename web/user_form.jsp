<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%
  User u = (User) request.getAttribute("user");
  boolean isEdit = u != null;
%>
<html>
<head>
    <title><%= isEdit ? "Edit User" : "Add User" %> - Nike Admin</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>
<div class="content">
    <div class="card p-4 mb-4">
        <h2 class="mb-4 text-dark"><%= isEdit ? "Edit User" : "Add User" %></h2>
        <form method="post" action="UserServlet">
            <% if(isEdit){ %>
            <input type="hidden" name="id" value="<%=u.getId()%>">
            <% } %>
            <div class="mb-3">
                <label>Email</label>
                <input name="email" class="form-control" value="<%= isEdit?u.getEmail():"" %>" required>
            </div>
            <div class="mb-3">
                <label>Username</label>
                <input name="username" class="form-control" value="<%= isEdit?u.getUsername():"" %>" required>
            </div>
            <% if(!isEdit) { %>
            <div class="mb-3">
                <label>Password</label>
                <input name="password" type="password" class="form-control" required>
            </div>
            <% } %>
            <button class="btn btn-dark">Save</button>
            <a href="UserServlet" class="btn btn-secondary ms-2">Back</a>
        </form>
    </div>
</div>
</body>
</html>
