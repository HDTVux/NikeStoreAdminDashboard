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
  <div class="row g-3 mb-4">
    <div class="col-md-3">
      <div class="card-stat">
        <small>STORE RATING</small>
        <div class="value">3.0 / 5 ★</div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card-stat positive">
        <small>TOTAL PAID REVENUE</small>
        <div class="value">425,293 USD</div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card-stat positive">
        <small>TOTAL ORDERS</small>
        <div class="value">5,320</div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card-stat negative">
        <small>LIVE OFFERS</small>
        <div class="value">185</div>
      </div>
    </div>
  </div>

  <!-- CHARTS + TOP SALES -->
  <div class="row g-4 mb-4">
    <div class="col-md-8">
      <div class="chart-box">
        <h5>Revenue (Example Chart)</h5>
        <div style="height:220px; display:flex;align-items:center;justify-content:center;color:#aaa;">
          [Chart Placeholder]
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="chart-box">
        <h5>Top Sales</h5>
        <div class="top-sales mt-3">
          <div class="ring" style="--percent:65"><span>65%</span><div>Sneakers</div></div>
          <div class="ring" style="--percent:16"><span>16%</span><div>Jackets</div></div>
          <div class="ring" style="--percent:12"><span>12%</span><div>Pants</div></div>
        </div>
      </div>
    </div>
  </div>

  <!-- ORDERS TABLE -->
  <div class="chart-box">
    <h5>Recent Orders</h5>
    <table class="table table-striped mt-3">
      <thead>
        <tr><th>Order ID</th><th>Products</th><th>Amount</th><th>Date</th></tr>
      </thead>
      <tbody>
        <tr><td>4895-403-293-8467</td><td>5</td><td>USD 730.00</td><td>16/04/2017</td></tr>
        <tr><td>4895-403-293-8468</td><td>3</td><td>USD 390.00</td><td>17/04/2017</td></tr>
      </tbody>
    </table>
  </div>
</div>

<script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
