<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Admin Login - Nike Store</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="col-md-4 offset-md-4">
        <h4 class="text-center mb-4">Đăng nhập quản trị</h4>
        <form action="../login" method="post">
            <div class="form-group mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="form-group mb-3">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-dark w-100">Đăng nhập</button>
            <p class="text-danger mt-2"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
        </form>
    </div>
</div>
</body>
</html>
