<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Order, model.OrderItem, java.util.*" %>
<%
  Order o = (Order) request.getAttribute("order");
%>
<html>
<head>
  <title>Chi tiết đơn #<%= o!=null? o.getId() : "" %></title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <style>.content{margin-left:220px;padding:20px;}</style>
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>
<%@ include file="includes/header.jsp" %>

<div class="content">
  <h4>Đơn hàng #<%= o.getId() %></h4>
  <div class="mb-3">
    <div>Khách: <strong><%= o.getUserEmail() %></strong></div>
    <div>Địa chỉ: <%= o.getShippingAddress() %></div>
    <div>Thanh toán: <%= o.getPaymentMethod() %></div>
    <div>Trạng thái hiện tại: <span class="badge bg-secondary"><%= o.getStatus() %></span></div>
  </div>

  <form action="orders" method="post" class="mb-4">
    <input type="hidden" name="id" value="<%= o.getId() %>">
    <div class="input-group" style="max-width:400px;">
      <select name="status" class="form-select">
        <option value="pending"   <%= "pending".equals(o.getStatus())?"selected":"" %>>pending</option>
        <option value="paid"      <%= "paid".equals(o.getStatus())?"selected":"" %>>paid</option>
        <option value="cancelled" <%= "cancelled".equals(o.getStatus())?"selected":"" %>>cancelled</option>
      </select>
      <button class="btn btn-dark">Cập nhật</button>
    </div>
  </form>

  <h5>Danh sách sản phẩm</h5>
  <table class="table table-bordered">
    <thead>
      <tr><th>Sản phẩm</th><th>Variant</th><th>SL</th><th>Giá</th><th>Tạm tính</th></tr>
    </thead>
    <tbody>
    <%
      List<OrderItem> items = o.getItems();
      double sum = 0;
      if (items!=null) {
        for (OrderItem it : items){
          double line = it.getPrice() * it.getQuantity();
          sum += line;
    %>
      <tr>
        <td><%= it.getProductName() %></td>
        <td><%= it.getVariantId()==null? "-" : it.getVariantId() %></td>
        <td><%= it.getQuantity() %></td>
        <td>$<%= it.getPrice() %></td>
        <td>$<%= line %></td>
      </tr>
    <% } } %>
    </tbody>
    <tfoot>
      <tr>
        <th colspan="4" class="text-end">Subtotal</th><th>$<%= o.getSubtotal() %></th>
      </tr>
      <tr>
        <th colspan="4" class="text-end">Shipping</th><th>$<%= o.getShippingFee() %></th>
      </tr>
      <tr>
        <th colspan="4" class="text-end">Total</th><th>$<%= o.getTotalPrice() %></th>
      </tr>
    </tfoot>
  </table>

  <a href="orders" class="btn btn-secondary">← Quay lại</a>
</div>
<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
