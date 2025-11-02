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
            max-width: 900px;
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
        .product-list {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 15px;
            background: #fafafa;
        }
        .product-item {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .product-item:last-child {
            border-bottom: none;
        }
        .product-item label {
            font-weight: normal;
            cursor: pointer;
            margin: 0;
        }
        .select-all-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .select-all-btn:hover {
            background: #0056b3;
        }
        .alert-info {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="content">
        <div class="header-bar">
            <h2><%= editing ? "Edit Promotion" : "Create New Promotion" %></h2>
        </div>

        <% if (!editing) { %>
        <div class="alert-info">
            <strong>💡 Tip:</strong> You can select multiple products to apply the same promotion at once!
        </div>
        <% } %>

        <form method="post" action="PromotionServlet">
            <% if (editing) { %>
                <input type="hidden" name="id" value="<%= p.getId() %>">
            <% } %>

            <!-- Promotion Name -->
            <div class="mb-3">
                <label class="form-label">Promotion Name <span style="color:red;">*</span></label>
                <input type="text" name="name" class="form-control" 
                       placeholder="e.g. Flash Sale Tết 2025"
                       value="<%= editing && p.getName() != null ? p.getName() : "" %>" required>
                <small class="text-muted">This name groups promotions together for easier management</small>
            </div>

            <!-- Product Selection -->
            <div class="mb-3">
                <label class="form-label">
                    <%= editing ? "Product" : "Select Products" %> 
                    <span style="color:red;">*</span>
                </label>
                
                <% if (editing) { %>
                    <!-- Edit mode: chỉ chọn 1 product -->
                    <select class="form-select" name="product_id" required>
                        <% for (Product prod : products) { %>
                            <option value="<%= prod.getId() %>" 
                                <%= prod.getId() == p.getProductId() ? "selected" : "" %>>
                                <%= prod.getName() %> - $<%= prod.getPrice() %>
                            </option>
                        <% } %>
                    </select>
                <% } else { %>
                    <!-- Create mode: chọn nhiều products -->
                    <button type="button" class="select-all-btn" onclick="toggleSelectAll()">
                        Select All / Deselect All
                    </button>
                    <div class="product-list" id="productList">
                        <% 
                        if (products != null && !products.isEmpty()) {
                            for (Product prod : products) { 
                        %>
                            <div class="product-item">
                                <input type="checkbox" name="product_ids" 
                                       value="<%= prod.getId() %>" 
                                       id="prod_<%= prod.getId() %>">
                                <label for="prod_<%= prod.getId() %>">
                                    <%= prod.getName() %> - $<%= prod.getPrice() %> 
                                    <span style="color: #999;">(Stock: <%= prod.getStock() %>)</span>
                                </label>
                            </div>
                        <% 
                            }
                        } else {
                        %>
                            <p class="text-muted">No products available</p>
                        <% } %>
                    </div>
                    <small class="text-muted">Check multiple products to apply the same discount</small>
                <% } %>
            </div>

            <!-- Discount -->
            <div class="mb-3">
                <label class="form-label">Discount (%) <span style="color:red;">*</span></label>
                <input type="number" name="discount_percent" class="form-control"
                       value="<%= editing ? p.getDiscountPercent() : "" %>" 
                       step="0.01" min="0" max="100" placeholder="e.g. 25" required>
            </div>

            <!-- Start / End -->
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Starts At <span style="color:red;">*</span></label>
                    <input type="datetime-local" name="starts_at" class="form-control"
                           value="<%= editing && p.getStartsAt() != null ? p.getStartsAt().replace(' ', 'T') : "" %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Ends At <span style="color:red;">*</span></label>
                    <input type="datetime-local" name="ends_at" class="form-control"
                           value="<%= editing && p.getEndsAt() != null ? p.getEndsAt().replace(' ', 'T') : "" %>" required>
                </div>
            </div>

            <!-- Active -->
            <div class="form-check mb-3">
                <input type="checkbox" name="is_active" class="form-check-input" id="activeCheck"
                       <%= editing && p.isActive() ? "checked" : "checked" %>>
                <label class="form-check-label" for="activeCheck">Active</label>
            </div>

            <button type="submit" class="btn-save">
                <%= editing ? "Update" : "Create Promotion" %>
            </button>
            <a href="PromotionServlet?action=list" class="btn btn-cancel btn-secondary">Cancel</a>
        </form>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSelectAll() {
            const checkboxes = document.querySelectorAll('#productList input[type="checkbox"]');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            checkboxes.forEach(cb => cb.checked = !allChecked);
        }
    </script>
</body>
</html>