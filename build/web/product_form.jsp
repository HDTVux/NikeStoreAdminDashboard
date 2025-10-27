<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product, model.ProductImage, model.ProductVariant, model.Category, java.util.*" %>
<%
    Product p = (Product) request.getAttribute("product");
    List<ProductImage> images = (List<ProductImage>) request.getAttribute("images");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    boolean isEdit = p != null;
%>
<html>
<head>
    <title><%= isEdit ? "Edit Product" : "Add Product" %> - Nike Admin</title>
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
        .card {
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .card h2 {
            font-weight: 600;
            color: #111;
            margin-bottom: 24px;
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .form-control, .form-select {
            border-radius: 6px;
        }
        .section-title {
            font-weight: 600;
            color: #111;
            margin: 30px 0 15px 0;
            font-size: 18px;
        }
        .btn-save {
            background: #000;
            color: #fff;
            border-radius: 6px;
            padding: 10px 20px;
            font-weight: 500;
            transition: 0.2s;
        }
        .btn-save:hover {
            background: #222;
            color: #26ff86;
        }
        .btn-cancel {
            border-radius: 6px;
            padding: 10px 20px;
            font-weight: 500;
            margin-left: 10px;
        }

        /* IMAGE PREVIEW */
        .images-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .img-box {
            width: 180px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            padding: 10px;
            text-align: center;
        }
        .img-box img {
            width: 140px;
            height: 140px;
            object-fit: cover;
            border-radius: 8px;
            background: #eee;
        }
        .img-box img.main-img {
            border: 3px solid #00c853;
            box-shadow: 0 0 10px rgba(0,200,83,0.4);
        }
        .img-actions {
            margin-top: 10px;
        }
        .img-actions a {
            font-size: 13px;
            padding: 4px 10px;
            border-radius: 6px;
            text-decoration: none;
        }
        .btn-outline-success {
            color: #00c853;
            border: 1px solid #00c853;
        }
        .btn-outline-success:hover {
            background: #00c853;
            color: #fff;
        }
        .btn-outline-danger {
            color: #ff5252;
            border: 1px solid #ff5252;
        }
        .btn-outline-danger:hover {
            background: #ff5252;
            color: #fff;
        }
        .badge.bg-success {
            background-color: #00c853 !important;
            font-size: 13px;
            padding: 5px 10px;
        }
        .img-box.upload {
            border: 2px dashed #aaa;
            background: #fafafa;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 180px;
        }
        .img-box.upload input[type="file"] {
            width: 140px;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
    <div class="card">
        <h2><%= isEdit ? "Edit Product" : "Add Product" %></h2>
        <form method="post" action="ProductServlet">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= p.getId() %>">
            <% } %>

            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">Product Name</label>
                    <input name="name" class="form-control" value="<%= isEdit ? p.getName() : "" %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select name="categoryId" class="form-select" required>
                        <% if (categories != null) for (Category cat : categories) { %>
                            <option value="<%= cat.getId() %>" <%= isEdit && p.getCategoryId()==cat.getId() ? "selected" : "" %>>
                                <%= cat.getName() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Price</label>
                    <input name="price" type="number" step="0.01" class="form-control" value="<%= isEdit ? p.getPrice() : "" %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Size Type</label>
                    <select name="sizeType" id="sizeType" class="form-select" onchange="toggleVariantSection()">
                        <option value="one-size" <%= isEdit && "one-size".equals(p.getSizeType()) ? "selected" : "" %>>One Size</option>
                        <option value="shoe" <%= isEdit && "shoe".equals(p.getSizeType()) ? "selected" : "" %>>Shoe</option>
                        <option value="clothing" <%= isEdit && "clothing".equals(p.getSizeType()) ? "selected" : "" %>>Clothing</option>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="3"><%= isEdit ? p.getDescription() : "" %></textarea>
                </div>
            </div>

            <div class="row mt-3" id="stockRow" style="display:none">
                <div class="col-md-4">
                    <label class="form-label">Stock</label>
                    <input name="stock" type="number" class="form-control" value="<%= isEdit ? p.getStock() : "" %>">
                </div>
            </div>

            <div id="variantSection" style="display:none">
                <label class="section-title">Variants (Size / Stock / Price)</label>
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Size</th><th>Stock</th><th>Price</th><th></th></tr>
                    </thead>
                    <tbody id="variantTable">
                        <% if (isEdit && variants != null) for (ProductVariant v : variants) { %>
                        <tr>
                            <td><input name="variantSize" value="<%= v.getSize() %>" class="form-control" required></td>
                            <td><input name="variantStock" value="<%= v.getStock() %>" type="number" class="form-control" required></td>
                            <td><input name="variantPrice" value="<%= v.getPrice() %>" type="number" class="form-control" required></td>
                            <td><button type="button" class="btn btn-danger" onclick="removeVariantRow(this)">X</button></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <button type="button" class="btn btn-outline-success" onclick="addVariantRow()">+ Add Size</button>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn-save">Save</button>
                <a href="ProductServlet" class="btn btn-cancel btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <% if (isEdit) { %>
    <div class="section-title mt-5">Product Images</div>
    <div class="images-list mt-3">
        <% if (images != null && !images.isEmpty()) for (ProductImage img : images) { %>
        <div class="img-box">
            <img src="http://localhost/<%= img.getImageUrl() %>" class="<%= img.isMain() ? "main-img" : "" %>" onerror="this.src='assets/img/noimg.jpg'">
            <div class="img-actions">
                <% if (!img.isMain()) { %>
                    <a href="ProductServlet?action=image-main&imgId=<%=img.getId()%>&productId=<%=p.getId()%>" class="btn btn-sm btn-outline-success">Set Main</a>
                <% } else { %>
                    <span class="badge bg-success">Main</span>
                <% } %>
                <a href="ProductServlet?action=image-delete&imgId=<%=img.getId()%>&productId=<%=p.getId()%>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this image?')">Delete</a>
            </div>
        </div>
        <% } else { %>
        <div class="text-muted">No images found.</div>
        <% } %>

        <div class="img-box upload">
            <form method="post" action="ProductServlet?action=upload-image" enctype="multipart/form-data">
                <input type="hidden" name="productId" value="<%=p.getId()%>">
                <input type="file" name="imageFile" accept="image/*" required>
                <button class="btn btn-dark mt-2" style="color: #eee" type="submit">Upload</button>
            </form>
        </div>
    </div>
    <% } %>
</div>

<script src="assets/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleVariantSection() {
        const type = document.getElementById("sizeType").value;
        document.getElementById("variantSection").style.display = (type === "one-size") ? "none" : "";
        document.getElementById("stockRow").style.display = (type === "one-size") ? "" : "none";
    }
    function addVariantRow() {
        const tbody = document.getElementById("variantTable");
        const row = document.createElement("tr");
        row.innerHTML = `
            <td><input name="variantSize" class="form-control" required></td>
            <td><input name="variantStock" type="number" class="form-control" required></td>
            <td><input name="variantPrice" type="number" class="form-control" required></td>
            <td><button type="button" class="btn btn-danger" onclick="removeVariantRow(this)">X</button></td>
        `;
        tbody.appendChild(row);
    }
    function removeVariantRow(btn) {
        btn.closest("tr").remove();
    }
    window.onload = toggleVariantSection;
</script>
</body>
</html>
