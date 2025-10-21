<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
  <title>Dashboard - Nike Admin</title>
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>
<body>
<%@ include file="includes/sidebar.jsp" %>

<div class="content">
  <div class="header-bar">
    <h2>DASHBOARD</h2>
    <div>
      <button class="btn btn-light btn-sm">Daily</button>
      <button class="btn btn-dark btn-sm">Weekly</button>
      <button class="btn btn-light btn-sm">Monthly</button>
    </div>
  </div>

  <!-- STATS -->
<!-- STATS DYNAMIC FROM DB -->
  <div class="row g-3 mb-4 text-center">
    <div class="col-md-3">
      <div class="card-stat">
        <small>STORE RATING</small>
        <div class="value">
          <%= request.getAttribute("avgRating") != null ? String.format("%.1f", request.getAttribute("avgRating")) : "0.0" %> / 5 ★
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card-stat positive">
        <small>TOTAL PAID REVENUE</small>
        <div class="value">
          <%= request.getAttribute("totalRevenue") != null ? String.format("%,.0f USD", Double.parseDouble(request.getAttribute("totalRevenue").toString())) : "0 USD" %>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card-stat positive">
        <small>TOTAL ORDERS</small>
        <div class="value">
          <%= request.getAttribute("totalOrders") != null ? request.getAttribute("totalOrders") : 0 %>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card-stat negative">
        <small>LIVE OFFERS</small>
        <div class="value">
          <%= request.getAttribute("liveOffers") != null ? request.getAttribute("liveOffers") : 0 %>
        </div>
      </div>
    </div>

  <!-- CHARTS -->
  <div class="row g-4 mb-4">
    <div class="col-md-8">
      <div class="chart-box">
        <h5>Revenue Overview</h5>
        <canvas id="revenueChart" height="150"></canvas>
      </div>
    </div>

<div class="col-md-4">
  <div class="chart-box top-sales-box">
    <h5>Top Sales</h5>
    <div class="top-sales-canvas">
      <canvas id="topSalesChart"></canvas>
    </div>
  </div>
</div>
  </div>

  <!-- ORDERS TABLE -->
  <div class="chart-box">
    <h5>Recent Orders</h5>
    <table class="table table-dark mt-3">
      <thead>
        <tr><th>Order ID</th><th>Products</th><th>Amount</th><th>Date</th></tr>
      </thead>
      <tbody>
        <tr><td>4895-403-293-8467</td><td>5</td><td>USD 730.00</td><td>16/04/2017</td></tr>
        <tr><td>4895-403-293-8468</td><td>3</td><td>USD 390.00</td><td>17/04/2017</td></tr>
        <tr><td>4895-403-293-8471</td><td>4</td><td>USD 540.00</td><td>18/04/2017</td></tr>
      </tbody>
    </table>
  </div>
</div>

<!-- Bootstrap + Chart.js -->
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
/* === Lấy dữ liệu JSON từ Servlet === */
const revenueData = JSON.parse('<%= request.getAttribute("revenueData") %>');
const topSalesData = JSON.parse('<%= request.getAttribute("topSalesData") %>');

/* === Biểu đồ Doanh thu theo tháng === */
new Chart(document.getElementById('revenueChart'), {
  type: 'line',
  data: {
    labels: revenueData.labels,
    datasets: [{
      label: 'Revenue (USD)',
      data: revenueData.data,
      borderColor: '#111',
      backgroundColor: 'rgba(0,0,0,0.1)',
      tension: 0.4,
      fill: true,
      pointRadius: 4,
      pointBackgroundColor: '#111'
    }]
  },
  options: {
    plugins: { legend: { display: false } },
    scales: {
      x: { grid: { display: false } },
      y: { beginAtZero: true }
    }
  }
});

/* === Biểu đồ Top sản phẩm bán chạy === */
new Chart(document.getElementById('topSalesChart'), {
  type: 'doughnut',
  data: {
    labels: topSalesData.labels,
    datasets: [{
      data: topSalesData.data,
      backgroundColor: ['#111','#333','#555','#777','#999'],
      borderWidth: 0
    }]
  },
  options: {
    plugins: { legend: { position: 'bottom' } },
    cutout: '70%',
  }
});
</script>
</body>
</html>
