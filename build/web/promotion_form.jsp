<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Product, model.Promotion" %>
<%
    Promotion p = (Promotion) request.getAttribute("promotion");
    List<Product> products = (List<Product>) request.getAttribute("products");
    boolean editing = (p != null);
%>
<html>
<head>
    <title><%= editing ? "Edit" : "Add" %> Promotion</title>
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
        form {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            max-width: 700px;
        }
        label {
            font-weight: 500;
            color: #333;
        }
        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #ccc;
            padding: 10px;
        }
        .btn-save {
            background: #000;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 18px;
            font-weight: 500;
            transition: 0.2s;
        }
        .btn-save:hover {
            background: #222;
            color: #26ff86;
        }
        .btn-cancel {
            border-radius: 6px;
            padding: 10px 18px;
            font-weight: 500;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="content">
        <div class="header-bar">
            <h2><%= editing ? "Edit Promotion" : "Add Promotion" %></h2>
        </div>

        <form method="post" action="PromotionServlet">
            <% if (editing) { %>
                <input type="hidden" name="id" value="<%= p.getId() %>">
            <% } %>

            <!-- Product -->
            <div class="mb-3">
                <label class="form-label">Product</label>
                <select class="form-select" name="product_id" required>
                    <% for (Product prod : products) { %>
                        <option value="<%= prod.getId() %>" 
                            <%= editing && prod.getId() == p.getProductId() ? "selected" : "" %>>
                            <%= prod.getName() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <!-- Discount -->
            <div class="mb-3">
                <label class="form-label">Discount (%)</label>
                <input type="number" name="discount_percent" class="form-control"
                       value="<%= editing ? p.getDiscountPercent() : "" %>" 
                       step="0.01" min="0" max="100" required>
            </div>

            <!-- Start / End -->
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Starts At</label>
                    <input type="datetime-local" name="starts_at" class="form-control"
                           value="<%= editing && p.getStartsAt() != null ? p.getStartsAt().replace(' ', 'T') : "" %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Ends At</label>
                    <input type="datetime-local" name="ends_at" class="form-control"
                           value="<%= editing && p.getEndsAt() != null ? p.getEndsAt().replace(' ', 'T') : "" %>" required>
                </div>
            </div>

            <!-- Active -->
            <div class="form-check mb-3">
                <input type="checkbox" name="is_active" class="form-check-input" id="activeCheck"
                       <%= editing && p.isActive() ? "checked" : "" %>>
                <label class="form-check-label" for="activeCheck">Active</label>
            </div>

            <button type="submit" class="btn-save">Save</button>
            <a href="PromotionServlet?action=list" class="btn btn-cancel btn-secondary">Cancel</a>
        </form>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
