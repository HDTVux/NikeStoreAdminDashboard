package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class UserServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "toggle":
                int id = Integer.parseInt(req.getParameter("id"));
                dao.toggleActive(id);
                resp.sendRedirect("UserServlet");
                break;
            case "edit":
                int editId = Integer.parseInt(req.getParameter("id"));
                User u = dao.getUserById(editId);
                req.setAttribute("user", u);
                req.getRequestDispatcher("user_form.jsp").forward(req, resp);
                break;
            case "new":
                req.getRequestDispatcher("user_form.jsp").forward(req, resp);
                break;
            case "delete":
                int delId = Integer.parseInt(req.getParameter("id"));
                dao.deleteUser(delId);
                resp.sendRedirect("UserServlet");
                break;
            default:
                int page = 1;
                try {
                    String p = req.getParameter("page");
                    if (p != null) page = Integer.parseInt(p);
                } catch (NumberFormatException ignored) {}
                int totalUsers = dao.countUsers();
                int totalPages = (int)Math.ceil((double)totalUsers / PAGE_SIZE);
                List<User> list = dao.getUsersPaginated(page, PAGE_SIZE);
                req.setAttribute("users", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("users.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String email = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User u = new User();
        u.setEmail(email);
        u.setUsername(username);
        u.setActive(true);

        if (idStr == null || idStr.isEmpty()) {
            // new user: must have password
            if (password == null || password.isEmpty()) {
                req.setAttribute("error", "Password is required!");
                req.setAttribute("user", u);
                req.getRequestDispatcher("user_form.jsp").forward(req, resp);
                return;
            }
            u.setPassword(password);
            dao.insertUser(u);
        } else {
            // update
            u.setId(Integer.parseInt(idStr));
            if (password != null && !password.isEmpty())
                u.setPassword(password);
            dao.updateUser(u);
        }
        resp.sendRedirect("UserServlet");
    }
}
