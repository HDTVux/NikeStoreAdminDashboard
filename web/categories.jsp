<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Category, java.util.List" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<html>
    <head>
        <title>Categories - Nike Admin</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/admin-dashboard.css">
        <style>
            body {
                background-color: #f5f6fa;
            }
            .content {
                margin-left: 240px;
                padding: 32px 40px;
                min-height: 100vh;
            }
            .card {
                border-radius: 16px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                background: #fff;
                padding: 28px 32px;
                width: 100%;
            }
            .table-container {
                overflow-x: auto;
            }
            .table {
                width: 100%;
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 0;
            }
            .table thead {
                background-color: #111;
                color: #fff;
            }
            .table th, .table td {
                vertical-align: middle;
                white-space: nowrap;
                padding: 16px 12px;        /* ✅ Giãn dòng hơn mặc định */
                line-height: 1.6;          /* ✅ Tăng khoảng cách dòng */
            }
            .table tbody tr {
                height: 60px;              /* ✅ Chiều cao tối thiểu mỗi hàng */
                transition: background-color 0.25s;
            }
            .table tbody tr:hover {
                background-color: #f8f9fa;
            }
            .btn {
                border-radius: 8px;
                padding: 6px 14px;
            }
            .btn-dark {
                background-color: #111;
                border: none;
                color: #eee;
            }
            .btn-dark:hover {
                background-color: #000;
            }
            .btn-outline-primary {
                border-color: #007bff;
                color: #007bff;
            }
            .btn-outline-primary:hover {
                background-color: #007bff;
                color: #fff;
            }
            .btn-outline-warning {
                border-color: #ffc107;
                color: #ffc107;
            }
            .btn-outline-warning:hover {
                background-color: #ffc107;
                color: #111;
            }
            .btn-outline-success {
                border-color: #00c851;
                color: #00c851;
            }
            .btn-outline-success:hover {
                background-color: #00c851;
                color: #fff;
            }
            .badge {
                font-size: 13px;
                padding: 8px 12px; /* ✅ Giãn padding badge cho cân */
                border-radius: 10px;
            }
            .badge.bg-success {
                background-color: #00c851;
            }
            .badge.bg-danger {
                background-color: #ff4444;
            }
            h2 {
                font-weight: 600;
                color: #111;
            }
            @media (max-width: 991px) {
                .content {
                    margin-left: 0;
                    padding: 20px;
                }
                .card {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>

        <div class="content">
            <div class="card">
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <h2 class="text-dark fw-bold mb-0">Categories</h2>
                    <a href="CategoryServlet?action=new" class="btn btn-dark px-3">+ Add Category</a>
                </div>

                <div class="table-container">
                    <table class="table table-bordered align-middle text-center">
                        <thead>
                            <tr>
                                <th style="width:80px;">ID</th>
                                <th>Name</th>
                                <th style="width:140px;">Status</th>
                                <th style="width:220px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (categories != null && !categories.isEmpty()) {
                            for (Category cat : categories) { %>
                            <tr>
                                <td><%= cat.getId() %></td>
                                <td><%= cat.getName() %></td>
                                <td>
                                    <% if (cat.isActive()) { %>
                                    <span class="badge bg-success">Active</span>
                                    <% } else { %>
                                    <span class="badge bg-danger">Inactive</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="CategoryServlet?action=edit&id=<%=cat.getId()%>" 
                                       class="btn btn-sm btn-outline-primary me-1">Edit</a>
                                    <a href="CategoryServlet?action=toggle&id=<%=cat.getId()%>" 
                                       class="btn btn-sm <%= cat.isActive() ? "btn-outline-warning" : "btn-outline-success" %>">
                                        <%= cat.isActive() ? "Deactivate" : "Activate" %>
                                    </a>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="4" class="text-muted py-4">No categories found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
