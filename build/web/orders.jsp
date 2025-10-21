<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Order" %>
<html>
    <head>
        <title>Orders - Nike Admin</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/admin-dashboard.css">
        <style>
            body {
                background: #f6f7fb;
                font-family: "Poppins", "Segoe UI", sans-serif;
                color: #222;
                margin: 0;
            }
            .content {
                margin-left: 13%;
                padding: 32px 38px 38px 38px;
            }
            .table-responsive {
                margin-bottom: 28px;
                max-width: 100%;
                overflow-x: auto;
            }
            .table-dark {
                width: 100%;
                background-color: #111;
                color: #eee;
                border-radius: 10px;
                border-collapse: separate;
                border-spacing: 0;
                overflow: hidden;
                border: none;
                box-shadow: 0 2px 10px #0001;
            }
            .table-dark th, .table-dark td {
                text-align: center;
                vertical-align: middle;
                padding: 13px 12px;
                border: none;
            }
            .table-dark th {
                background-color: #191919;
                color: #b7b7b7;
                font-size: 14px;
                letter-spacing: 1px;
                text-transform: uppercase;
            }
            .table-dark td {
                background: #181818;
                font-size: 15px;
            }
            .table-dark tr:hover td {
                background: #222;
            }
            .status-select {
                min-width: 105px;
                padding: 5px 10px;
                border-radius: 5px;
                border: none;
                background: #232323;
                color: #fafafa;
                font-weight: 500;
                transition: border 0.2s;
            }
            .status-select:focus {
                border: 1.5px solid #1e90ff;
                background: #191919;
            }
            .btn-update-status {
                background: #222;
                color: #fff;
                border: none;
                border-radius: 5px;
                padding: 5px 14px;
                font-size: 13px;
                font-weight: 600;
                box-shadow: 0 2px 10px #2222 inset;
                cursor: pointer;
                transition: background 0.2s;
                margin-left: 2px;
            }
            .btn-update-status:hover {
                background: #1e90ff;
                color: #fff;
            }
            .badge-status {
                padding: 6px 16px;
                border-radius: 18px;
                font-size: 14px;
                font-weight: 500;
                background: #444;
                color: #fff;
                text-transform: capitalize;
                letter-spacing: 0.5px;
                display: inline-block;
                min-width: 64px;
            }
            .badge-status.paid {
                background: #00e676;
                color: #111;
            }
            .badge-status.pending {
                background: #ffc107;
                color: #222;
            }
            .badge-status.cancelled {
                background: #ff5252;
                color: #fff;
            }
            .filter-form {
                display: flex;
                align-items: center;
                gap: 14px;
                margin-bottom: 20px;
                justify-content: flex-end;
            }
            .filter-form select,
            .filter-form input[type="text"] {
                border-radius: 6px;
                border: none;
                padding: 8px 14px;
                font-size: 15px;
                background: #191919;
                color: #fafafa;
                transition: border 0.2s;
            }
            .filter-form select:focus,
            .filter-form input[type="text"]:focus {
                border: 1.5px solid #1e90ff;
                background: #232323;
            }
            .filter-form .btn {
                padding: 8px 18px;
                border-radius: 5px;
            }
            .pagination {
                display: flex;
                justify-content: center;
                margin: 20px 0;
                list-style: none;
                padding: 0;
            }
            .pagination li {
                margin: 0 5px;
            }
            .pagination a {
                color: #fff;
                background-color: #333;
                padding: 7px 15px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                transition: 0.2s;
            }
            .pagination a.active {
                background-color: #fff;
                color: #000;
                font-weight: bold;
            }
            .pagination a:hover:not(.active) {
                background-color: #1e90ff;
                color: #fff;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>

        <div class="filter-form">
            <form class="d-flex" method="get" action="OrderServlet">
                <select name="status" class="form-select me-2 status-select">
                    <option value="all"   <%= "all".equals(request.getAttribute("statusFilter")) ? "selected":"" %>>Tất cả trạng thái</option>
                    <option value="pending"   <%= "pending".equals(request.getAttribute("statusFilter")) ? "selected":"" %>>pending</option>
                    <option value="paid"      <%= "paid".equals(request.getAttribute("statusFilter")) ? "selected":"" %>>paid</option>
                    <option value="cancelled" <%= "cancelled".equals(request.getAttribute("statusFilter")) ? "selected":"" %>>cancelled</option>
                </select>
                <input type="text" name="email" class="form-control me-2" style="min-width:180px;" 
                       value="<%= request.getAttribute("emailFilter") %>" placeholder="Tìm email khách">
                <button class="btn btn-dark" style="min-width:70px;color: #ffffff;">Lọc</button>
            </form>
        </div>
        <div class="content">
            <div class="table-responsive">
                <table class="table table-dark table-hover w-100">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th>Payment</th>
                            <th>Shipping Fee</th>
                            <th>Subtotal</th>
                            <th>Created</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                          List<Order> orders = (List<Order>) request.getAttribute("orders");
                          if (orders != null && !orders.isEmpty()) {
                              for (Order o : orders) {
                        %>
                        <tr>
                            <td><%= o.getId() %></td>
                            <td><%= o.getUserEmail() %></td>
                            <td>
                                <% if ("pending".equals(o.getStatus())) { %>
                                <form action="OrderServlet" method="post" style="display:inline-flex;">
                                    <input type="hidden" name="id" value="<%= o.getId() %>">
                                    <select name="status" class="status-select">
                                        <option value="pending"   selected>pending</option>
                                        <option value="paid">paid</option>
                                        <option value="cancelled">cancelled</option>
                                    </select>
                                    <button class="btn-update-status">Cập nhật</button>
                                </form>
                                <% } else { %>
                                <span class="badge-status <%= o.getStatus() %>"><%= o.getStatus() %></span>
                                <% } %>
                            </td>

                            <td><%= String.format("%,.2f USD", o.getTotalPrice()) %></td>
                            <td><%= o.getPaymentMethod() %></td>
                            <td><%= String.format("%,.2f", o.getShippingFee()) %></td>
                            <td><%= String.format("%,.2f", o.getSubtotal()) %></td>
                            <td><%= o.getCreatedAt() %></td>
                        </tr>
                        <%
                              }
                          } else {
                        %>
                        <tr><td colspan="8">No orders found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

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
    </body>
</html>
