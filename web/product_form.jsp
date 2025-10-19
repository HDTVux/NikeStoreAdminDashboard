<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product" %>
<html>
<head>
    <title>Thêm / Sửa sản phẩm</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h3><%= request.getAttribute("product") == null ? "Thêm sản phẩm mới" : "Chỉnh sửa sản phẩm" %></h3>
    <%
        Product p = (Product) request.getAttribute("product");
        if (p == null) p = new Product();
    %>
    <form action="../products" method="post" class="mt-3">
        <input type="hidden" name="id" value="<%= p.getId() %>"/>
        <div class="mb-3">
            <label>Tên sản phẩm</label>
            <input type="text" name="name" value="<%= p.getName() %>" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Giá ($)</label>
            <input type="number" step="0.01" name="price" value="<%= p.getPrice() %>" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Tồn kho</label>
            <input type="number" name="stock" value="<%= p.getStock() %>" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-dark">Lưu</button>
        <a href="../products" class="btn btn-secondary">Hủy</a>
    </form>
</div>
</body>
</html>
