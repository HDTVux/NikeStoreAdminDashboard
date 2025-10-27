<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Promotion" %>
<html>
<head>
    <title>Promotions - Nike Admin</title>
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
        a.activate {
            color: #00c853;
        }
        a.deactivate {
            color: #ff9800;
        }
        a.action:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="content">
        <div class="header-bar">
            <h2>Promotions</h2>
            <a href="PromotionServlet?action=new" class="btn-add">+ Add Promotion</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Product</th>
                    <th>Discount (%)</th>
                    <th>Start</th>
                    <th>End</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Promotion> list = (List<Promotion>) request.getAttribute("promotions");
                    if (list != null && !list.isEmpty()) {
                        for (Promotion p : list) {
                %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><%= p.getProductName() %></td>
                    <td><%= p.getDiscountPercent() %></td>
                    <td><%= p.getStartsAt() %></td>
                    <td><%= p.getEndsAt() %></td>
                    <td>
                        <span class="status <%= p.isActive() ? "active" : "inactive" %>">
                            <%= p.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </td>
                    <td>
                        <a href="PromotionServlet?action=edit&id=<%= p.getId() %>" class="action edit">Edit</a>
                        <% if (p.isActive()) { %>
                            <a href="PromotionServlet?action=toggle&id=<%= p.getId() %>" class="action deactivate">Deactivate</a>
                        <% } else { %>
                            <a href="PromotionServlet?action=toggle&id=<%= p.getId() %>" class="action activate">Activate</a>
                        <% } %>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr>
                    <td colspan="7" class="text-muted text-center py-4">No promotions found</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
