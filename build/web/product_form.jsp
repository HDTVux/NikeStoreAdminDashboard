<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product, model.ProductImage, model.ProductVariant, java.util.*" %>
<%
  Product p = (Product) request.getAttribute("product");
  List<ProductImage> images = (List<ProductImage>) request.getAttribute("images");
  List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
  boolean isEdit = p != null;
%>
<html>
    <head>
        <title><%= isEdit ? "Edit Product" : "Add Product" %> - Nike Admin</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/admin-dashboard.css">
        <style>
            .content {
                margin-left: 240px;
                padding: 32px 40px;
            }
            .card {
                border-radius: 16px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                background: #fff;
                padding: 28px 32px;
            }
            .form-label {
                font-weight: 500;
                color: #444;
            }
            .section-title {
                font-weight: 600;
                color: #111;
                margin-top: 36px;
                margin-bottom: 14px;
                font-size: 18px;
            }
            .images-list {
                display: flex;
                flex-wrap: wrap;
                gap: 24px;
                margin-top: 10px;
            }
            .img-box {
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                padding: 14px;
                width: 170px;
                text-align: center;
                transition: all 0.3s;
                border: 1.2px solid #ddd;
            }
            .img-box img {
                width: 140px;
                height: 140px;
                object-fit: cover;
                border-radius: 10px;
                border: 2px solid transparent;
                background: #eee;
                transition: 0.25s;
            }
            .img-box img.main-img {
                border: 3px solid #00c851;
                box-shadow: 0 0 10px rgba(0,200,81,0.5);
            }
            .img-actions {
                margin-top: 8px;
            }
            .img-actions a, .img-actions span {
                margin: 2px 3px;
                font-size: 13px;
                border-radius: 6px;
                padding: 3px 10px;
            }
            .img-actions a.btn-outline-success {
                color: #00c851;
                border: 1px solid #00c851;
            }
            .img-actions a.btn-outline-success:hover {
                background: #00c851;
                color: #fff;
            }
            .img-actions a.btn-outline-danger {
                color: #ff4444;
                border: 1px solid #ff4444;
            }
            .img-actions a.btn-outline-danger:hover {
                background: #ff4444;
                color: #fff;
            }
            .badge.bg-success {
                background-color: #00c851;
                font-size: 13px;
                padding: 6px 10px;
            }
            .img-box.upload {
                border: 2px dashed #aaa;
                background: #fafafa;
                width: 170px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            .img-box.upload input[type="file"] {
                width: 130px;
                margin-bottom: 8px;
            }
            .img-box.upload .btn {
                padding: 5px 16px;
                font-size: 13px;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>
        <div class="content">
            <div class="card p-4 mb-4">
                <h2 class="mb-4 text-dark"><%= isEdit ? "Edit Product" : "Add Product" %></h2>
                <form method="post" action="ProductServlet">
                    <% if(isEdit){ %>
                    <input type="hidden" name="id" value="<%=p.getId()%>">
                    <% } %>
                    <div class="row g-4">
                        <div class="col-md-4">
                            <label class="form-label">Name</label>
                            <input name="name" class="form-control" value="<%= isEdit?p.getName():"" %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Price</label>
                            <input name="price" type="number" step="0.01" class="form-control" value="<%= isEdit?p.getPrice():"" %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Size Type</label>
                            <select name="sizeType" id="sizeType" class="form-select" onchange="toggleVariantSection()">
                                <option value="one-size" <%= isEdit && "one-size".equals(p.getSizeType()) ? "selected" : "" %>>One Size</option>
                                <option value="shoe" <%= isEdit && "shoe".equals(p.getSizeType()) ? "selected" : "" %>>Shoe</option>
                                <option value="clothing" <%= isEdit && "clothing".equals(p.getSizeType()) ? "selected" : "" %>>Clothing</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mt-3" id="stockRow" style="display:none">
                        <div class="col-md-4">
                            <label class="form-label">Stock</label>
                            <input name="stock" type="number" class="form-control" value="<%= isEdit?p.getStock():"" %>">
                        </div>
                    </div>
                    <div id="variantSection" style="display:none">
                        <label class="form-label mb-2">Variants (Size/Stock/Price)</label>
                        <table class="table table-bordered">
                            <thead>
                                <tr><th>Size</th><th>Stock</th><th>Price</th><th></th></tr>
                            </thead>
                            <tbody id="variantTable">
                                <% if(isEdit && variants != null) {
                              for(model.ProductVariant v : variants) { %>
                                <tr>
                                    <td><input name="variantSize" value="<%= v.getSize() %>" class="form-control" required></td>
                                    <td><input name="variantStock" value="<%= v.getStock() %>" type="number" class="form-control" required></td>
                                    <td><input name="variantPrice" value="<%= v.getPrice() %>" type="number" class="form-control" required></td>
                                    <td><button type="button" class="btn btn-danger" onclick="removeVariantRow(this)">X</button></td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                        <button type="button" class="btn btn-outline-success" onclick="addVariantRow()">+ Add Size</button>
                    </div>
                    <div class="mt-4">
                        <button class="btn btn-dark px-4" style="color: #eee">Save</button>
                        <a href="ProductServlet" class="btn btn-secondary ms-2">Back</a>
                    </div>
                </form>
            </div>

            <% if(isEdit) { %>
            <div>
                <div class="section-title mb-3">Product Images</div>
                <div class="images-list">
                    <% if(images != null && !images.isEmpty()) {
                for(ProductImage img : images) { %>
                    <div class="img-box">
                        <img src="http://localhost/<%= img.getImageUrl() %>" class="<%= img.isMain() ? "main-img" : "" %>" onerror="this.src='assets/img/noimg.jpg'">
                        <div class="img-actions">
                            <% if(!img.isMain()) { %>
                            <a href="ProductServlet?action=image-main&imgId=<%=img.getId()%>&productId=<%=p.getId()%>" class="btn btn-sm btn-outline-success">Set Main</a>
                            <% } else { %>
                            <span class="badge bg-success">Main</span>
                            <% } %>
                            <a href="ProductServlet?action=image-delete&imgId=<%=img.getId()%>&productId=<%=p.getId()%>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this image?')">Delete</a>
                        </div>
                    </div>
                    <% } } else { %>
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
            </div>
            <% } %>
        </div>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script>
                                function toggleVariantSection() {
                                    var type = document.getElementById("sizeType").value;
                                    document.getElementById("variantSection").style.display = (type === "one-size") ? "none" : "";
                                    document.getElementById("stockRow").style.display = (type === "one-size") ? "" : "none";
                                }
                                function addVariantRow() {
                                    var tbody = document.getElementById("variantTable");
                                    var row = document.createElement("tr");
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
