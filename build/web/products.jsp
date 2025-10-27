<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<html>
<head>
    <title>Products - Nike Admin</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
    <style>
        body {
            background: white;
            color: #fff;
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
            color: #fff;
        }
        .btn-add {
            background: #fff;
            color: #000;
            border-radius: 6px;
            padding: 8px 16px;
            font-weight: 500;
            text-decoration: none;
            transition: 0.2s;
        }
        .btn-add:hover {
            background: #26ff86;
            color: #000;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 10px;
            overflow: hidden;
            background: #1a1a1a;
        }
        th {
            background: #000;
            color: #26ff86;
            padding: 12px;
            text-align: center;
            border-bottom: 2px solid #222;
        }
        td {
            padding: 14px 12px;
            text-align: center;
            border-bottom: 1px solid #333;
            color: #eee;
        }
        tr:hover td {
            background: #1f1f1f;
        }

        .status {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            display: inline-block;
        }
        .status.active {
            background: #00c853;
            color: #fff;
        }
        .status.inactive {
            background: #ff5252;
            color: #fff;
        }

        a.action {
            font-weight: 500;
            text-decoration: none;
            margin: 0 6px;
        }
        a.toggle {
            color: #ff9800;
        }
        a.edit {
            color: #26a0ff;
        }
        a.action:hover {
            text-decoration: underline;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin: 25px 0;
            list-style: none;
        }
        .pagination li {
            margin: 0 5px;
        }
        .pagination a {
            color: #fff;
            background-color: #222;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.2s;
        }
        .pagination a.active {
            background-color: #26ff86;
            color: #000;
            font-weight: bold;
        }
        .pagination a:hover:not(.active) {
            background-color: #333;
        }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="content">
        <div class="header-bar">
            <h2>Products</h2>
            <a href="ProductServlet?action=new" class="btn-add">+ Add Product</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th>Actions</th>
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
                    <td>
                        <span class="status <%= p.isActive() ? "active" : "inactive" %>">
                            <%= p.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </td>
                    <td>
                        <a href="ProductServlet?action=edit&id=<%=p.getId()%>" class="action edit">Edit</a>
                        <a href="ProductServlet?action=toggle&id=<%=p.getId()%>" class="action toggle">
                            <%= p.isActive() ? "Deactivate" : "Activate" %>
                        </a>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="6" class="text-center text-muted py-4">No products found</td></tr>
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
            <li><a href="ProductServlet?page=<%= currentPage - 1 %>">Prev</a></li>
            <% } %>
            <%
              for (int i = 1; i <= totalPages; i++) {
            %>
            <li><a href="ProductServlet?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a></li>
            <% } %>
            <%
              if (currentPage < totalPages) {
            %>
            <li><a href="ProductServlet?page=<%= currentPage + 1 %>">Next</a></li>
            <% } %>
        </ul>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
