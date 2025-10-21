<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product, model.ProductImage, java.util.*" %>
<%
  Product p = (Product) request.getAttribute("product");
  List<ProductImage> images = (List<ProductImage>) request.getAttribute("images");
  boolean isEdit = p != null;
%>
<html>
<head>
  <title><%= isEdit ? "Edit Product" : "Add Product" %> - Nike Admin</title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/admin-dashboard.css">
  <style>
/* ======= TOÀN TRANG ======= */
body {
  background: #f6f7fb;
  font-family: "Poppins", sans-serif;
  color: #222;
}

.content {
  margin-left: 240px;
  padding: 32px 40px;
}

/* ======= FORM ======= */
.card {
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  background: #fff;
  padding: 28px 32px;
}

h2 {
  font-weight: 600;
  letter-spacing: 0.5px;
}

.form-label {
  font-weight: 500;
  color: #444;
}

/* ======= KHU ẢNH SẢN PHẨM ======= */
.section-title {
  font-weight: 600;
  color: #111;
  margin-top: 40px;
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
  transition: all 0.3s ease;
  border: 1.2px solid #ddd;
}

.img-box:hover {
  transform: translateY(-4px);
  border-color: #111;
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

/* Ảnh main nổi bật */
.img-box img.main-img {
  border: 3px solid #00c851;
  box-shadow: 0 0 10px rgba(0,200,81,0.5);
}

.img-actions {
  margin-top: 8px;
}

.img-actions a, .img-actions span {
  display: inline-block;
  margin: 2px 3px;
  font-size: 13px;
  text-decoration: none;
  border-radius: 6px;
  padding: 3px 10px;
  transition: 0.2s;
}

/* Nút Set Main */
.img-actions a.btn-outline-success {
  color: #00c851;
  border: 1px solid #00c851;
}

.img-actions a.btn-outline-success:hover {
  background: #00c851;
  color: #fff;
}

/* Nút Delete */
.img-actions a.btn-outline-danger {
  color: #ff4444;
  border: 1px solid #ff4444;
}

.img-actions a.btn-outline-danger:hover {
  background: #ff4444;
  color: #fff;
}

/* Badge Main */
.badge.bg-success {
  background-color: #00c851;
  font-size: 13px;
  padding: 6px 10px;
  border-radius: 6px;
}

/* Upload box */
.img-box.upload {
  border: 2px dashed #aaa;
  background: #fafafa;
  width: 170px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  transition: all 0.25s;
}

.img-box.upload:hover {
  border-color: #111;
  background: #f0f0f0;
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
            <input name="price" type="number" step="0.01" class="form-control"
                   value="<%= isEdit?p.getPrice():"" %>" required>
          </div>

          <div class="col-md-4">
            <label class="form-label">Stock</label>
            <input name="stock" type="number" class="form-control"
                   value="<%= isEdit?p.getStock():"" %>" required>
          </div>
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
      <img src="http://localhost/<%= img.getImageUrl() %>"
           class="<%= img.isMain() ? "main-img" : "" %>"
           onerror="this.src='assets/img/noimg.png'">
      <div class="img-actions">
        <% if(!img.isMain()) { %>
          <a href="ProductServlet?action=image-main&imgId=<%=img.getId()%>&productId=<%=p.getId()%>"
             class="btn-outline-success">Set Main</a>
        <% } else { %>
          <span class="badge bg-success">Main</span>
        <% } %>
        <a href="ProductServlet?action=image-delete&imgId=<%=img.getId()%>&productId=<%=p.getId()%>"
           class="btn-outline-danger" onclick="return confirm('Delete this image?')">Delete</a>
      </div>
    </div>
  <% } } else { %>
    <div class="text-muted">No images found.</div>
  <% } %>

  <!-- Upload -->
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
</body>
</html>
