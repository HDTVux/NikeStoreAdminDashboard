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
        .promo-group {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .promo-group-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 2px solid #000;
            margin-bottom: 15px;
        }
        .promo-group-title {
            font-size: 18px;
            font-weight: 600;
            color: #000;
        }
        .promo-group-info {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        .group-actions a {
            margin-left: 10px;
            font-weight: 500;
            text-decoration: none;
        }
        .group-actions a.toggle {
            color: #ff9800;
        }
        .group-actions a.delete {
            color: #f44336;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #f5f5f5;
            padding: 10px;
            text-align: center;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        td {
            padding: 12px 10px;
            text-align: center;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        tr:last-child td {
            border-bottom: none;
        }
        .status {
            padding: 5px 12px;
            border-radius: 20px;
            color: #fff;
            font-size: 13px;
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
            margin: 0 5px;
            font-size: 13px;
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
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="content">
        <div class="header-bar">
            <h2>Promotions Management</h2>
            <a href="PromotionServlet?action=new" class="btn-add">+ Create Promotion</a>
        </div>

        <%
            List<Promotion> list = (List<Promotion>) request.getAttribute("promotions");
            
            if (list != null && !list.isEmpty()) {
                // Nhóm promotions theo name
                Map<String, List<Promotion>> groupedPromos = new LinkedHashMap<>();
                for (Promotion pr : list) {
                    String name = pr.getName();
                    if (name == null || name.isEmpty()) {
                        name = "Unnamed Promotion";
                    }
                    groupedPromos.computeIfAbsent(name, k -> new ArrayList<>()).add(pr);
                }

                // Hiển thị từng nhóm
                for (Map.Entry<String, List<Promotion>> entry : groupedPromos.entrySet()) {
                    String groupName = entry.getKey();
                    List<Promotion> promos = entry.getValue();
                    
                    // Lấy thông tin chung từ promotion đầu tiên
                    Promotion first = promos.get(0);
                    boolean groupActive = first.isActive();
        %>
        
        <div class="promo-group">
            <div class="promo-group-header">
                <div>
                    <div class="promo-group-title">
                        📢 <%= groupName %>
                        <span class="status <%= groupActive ? "active" : "inactive" %>">
                            <%= groupActive ? "Active" : "Inactive" %>
                        </span>
                    </div>
                    <div class="promo-group-info">
                        <strong><%= first.getDiscountPercent() %>% OFF</strong> • 
                        <%= promos.size() %> product(s) • 
                        <%= first.getStartsAt() %> to <%= first.getEndsAt() %>
                    </div>
                </div>
                <div class="group-actions">
                    <a href="PromotionServlet?action=toggleGroup&name=<%= java.net.URLEncoder.encode(groupName, "UTF-8") %>" 
                       class="toggle" onclick="return confirm('Toggle all promotions in this group?')">
                        <%= groupActive ? "⏸ Deactivate All" : "▶ Activate All" %>
                    </a>
                    <a href="PromotionServlet?action=deleteGroup&name=<%= java.net.URLEncoder.encode(groupName, "UTF-8") %>" 
                       class="delete" onclick="return confirm('Delete all promotions in this group?')">
                        🗑 Delete Group
                    </a>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product</th>
                        <th>Discount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Promotion p : promos) { %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td><%= p.getProductName() %></td>
                        <td><%= p.getDiscountPercent() %>%</td>
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
                    <% } %>
                </tbody>
            </table>
        </div>

        <% 
                } // end for each group
            } else { 
        %>
        <div class="empty-state">
            <h3>📭 No Promotions Yet</h3>
            <p>Create your first promotion to start attracting customers!</p>
        </div>
        <% } %>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>