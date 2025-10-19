package controller;

import dao.DBConnection;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

try (Connection conn = DBConnection.getConnection()) {
    System.out.println("✅ Đã kết nối MySQL thành công!");
    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM users WHERE email=? AND password=? AND role='admin'"
    );
    ps.setString(1, email);
    ps.setString(2, password);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        System.out.println("✅ Đăng nhập thành công cho user: " + rs.getString("username"));
        HttpSession session = req.getSession();
        session.setAttribute("adminUser", rs.getString("username"));
        resp.sendRedirect("products");
    } else {
        System.out.println("❌ Sai email hoặc mật khẩu!");
        req.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
        req.getRequestDispatcher("jsp/login.jsp").forward(req, resp);
    }
} catch (SQLException e) {
    e.printStackTrace();
    throw new ServletException("❌ Lỗi kết nối MySQL: " + e.getMessage());
}

    }
}
