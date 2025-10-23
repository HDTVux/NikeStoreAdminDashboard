<div class="sidebar">
    <style>
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 220px;
            height: 100vh;
            background: black;
            padding: 24px 12px 0 12px;
            display: flex;
            flex-direction: column;
            z-index: 100;
        }
        .sidebar .logo {
            width: 90%;
            display: block;
            margin: 0 auto 26px auto;
        }
        .sidebar .nav {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar .nav li {
            margin-bottom: 12px;
        }
        .sidebar .nav a {
            display: block;
            padding: 12px 18px;
            border-radius: 7px;
            font-size: 16px;
            color: #eee;
            background: none;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.19s, color 0.19s;
            letter-spacing: 0.5px;
        }
        .sidebar .nav a:hover,
        .sidebar .nav a.active {
            background: #272727;
            color: #26ff86;
        }
        .btn-logout {
            display: block;
            width: 90%;
            margin: 30px auto 0 auto;
            padding: 10px 0;
            background: #222;
            color: #eee;
            border-radius: 7px;
            text-align: center;
            font-weight: 500;
            text-decoration: none;
            transition: background 0.19s;
        }
        .btn-logout:hover {
            background: #ff4141;
            color: #fff;
        }

    </style>
    <div>
        <img src="assets/img/images.png" class="logo" alt="Nike Logo">
        <ul class="nav mt-4">
            <li><a href="DashboardServlet" class="<%= request.getRequestURI().contains("dashboard") ? "active" : "" %>">Dashboard</a></li>
            <li><a href="OrderServlet" class="<%= request.getRequestURI().contains("orders") ? "active" : "" %>">Orders</a></li>
            <li><a href="ProductServlet" class="<%= request.getRequestURI().contains("products") ? "active" : "" %>">Products</a></li>
            <li><a href="BannerServlet" class="<%= request.getRequestURI().contains("banners") ? "active" : "" %>">Banners</a></li>
            <li><a href="UserServlet" class="<%= request.getRequestURI().contains("users") ? "active" : "" %>">Users</a></li>
        </ul>
        <a href="LogoutServlet" class="btn-logout">Log Out</a>
    </div>
</div>
