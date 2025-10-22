package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = dao.getUserByEmailAndPassword(email, password);
        if(user == null) {
            req.setAttribute("error", "Invalid email or password!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }
        // Chỉ cho phép admin
        if(!"admin".equalsIgnoreCase(user.getRole())) {
            req.setAttribute("error", "Permission denied! Only admin can access.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }
        // Đăng nhập thành công
        req.getSession().setAttribute("authUser", user);
        resp.sendRedirect("DashboardServlet");
    }
}
