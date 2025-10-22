
<div class="sidebar">
  <div>
    <img src="assets/img/images.png" class="logo" alt="Nike Logo">
    <ul class="nav mt-4">
      <li><a href="DashboardServlet" class="<%= request.getRequestURI().contains("dashboard") ? "active" : "" %>">? Dashboard</a></li>
      <li><a href="OrderServlet" class="<%= request.getRequestURI().contains("orders") ? "active" : "" %>">? Orders</a></li>
      <li><a href="ProductServlet" class="<%= request.getRequestURI().contains("products") ? "active" : "" %>">? Products</a></li>
      <li><a href="BannerServlet" class="<%= request.getRequestURI().contains("banners") ? "active" : "" %>">? Banners</a></li>
      <li><a href="UserServlet" class="<%= request.getRequestURI().contains("users") ? "active" : "" %>">? Users</a></li>
    </ul>
  </div>

  <div class="bottom">
    <div>Need Help?</div>
    <div>support@nikestore.com</div>
    <a href="logout" class="btn btn-outline-light btn-sm mt-2 w-100">Log Out</a>
  </div>
</div>

