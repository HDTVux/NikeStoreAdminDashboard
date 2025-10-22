<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Admin Login - Nike Store</title>
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
            display: flex; justify-content: center; align-items: center;
            font-family: 'Segoe UI', Poppins, Arial, sans-serif;
        }
        .login-box {
            background: rgba(255,255,255,0.18);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31,38,135,0.25);
            padding: 40px 38px 32px 38px;
            width: 360px;
            text-align: center;
            backdrop-filter: blur(6px);
        }
        .login-box .avatar {
            width: 82px; height: 82px;
            border-radius: 50%;
            background: #1a355b;
            display: flex; justify-content: center; align-items: center;
            margin: 0 auto -26px auto;
            font-size: 45px;
            color: #fff;
            border: 4px solid #fff;
        }
        .login-box form {
            margin-top: 38px;
        }
        .login-box input[type=text], .login-box input[type=password] {
            width: 100%; padding: 12px 15px;
            margin: 12px 0; border: none;
            border-radius: 7px;
            background: #fff;
            font-size: 15px;
            outline: none;
        }
        .login-box .row-opts {
            display: flex; align-items: center; justify-content: space-between;
            font-size: 13px; color: #5c6a8a; margin-bottom: 16px;
        }
        .login-box input[type=checkbox] { margin-right: 4px; }
        .login-box button {
            width: 100%; padding: 11px;
            border: none;
            border-radius: 8px;
            background: #2e4372;
            color: #fff; font-weight: 600; font-size: 16px;
            letter-spacing: 1px;
            margin-top: 8px;
            transition: background 0.18s;
        }
        .login-box button:hover {
            background: #222b44;
        }
        .login-box .error-msg {
            background: #ffd3d3;
            color: #c51d1d;
            padding: 8px 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <div class="avatar">
            <span>&#128100;</span>
        </div>
        <form method="post" action="LoginServlet">
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-msg"><%= request.getAttribute("error") %></div>
            <% } %>
            <input type="text" name="email" placeholder="Email ID" required autofocus>
            <input type="password" name="password" placeholder="Password" required>
            <div class="row-opts">
                <span>
                    <input type="checkbox" name="remember" checked disabled> Remember me
                </span>
            </div>
            <button type="submit">LOGIN</button>
        </form>
    </div>
</body>
</html>
