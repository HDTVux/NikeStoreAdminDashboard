package controller;

import dao.CategoryDAO;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

public class CategoryServlet extends HttpServlet {

    private final CategoryDAO dao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "toggle": {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    dao.toggleActive(Integer.parseInt(idStr));
                }
                resp.sendRedirect("CategoryServlet");
                break;
            }

            case "edit": {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    Category cat = dao.getCategoryById(Integer.parseInt(idStr));
                    req.setAttribute("category", cat);
                }
                req.getRequestDispatcher("category_form.jsp").forward(req, resp);
                break;
            }

            case "new": {
                req.setAttribute("category", null);
                req.getRequestDispatcher("category_form.jsp").forward(req, resp);
                break;
            }

            default: {
                List<Category> list = dao.getAllCategories();
                req.setAttribute("categories", list);
                req.getRequestDispatcher("categories.jsp").forward(req, resp);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        String name = req.getParameter("name");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Category name cannot be empty.");
            req.getRequestDispatcher("category_form.jsp").forward(req, resp);
            return;
        }

        Category cat = new Category();
        cat.setName(name.trim());

        if (idStr == null || idStr.isEmpty()) {
            dao.insertCategory(cat);
        } else {
            cat.setId(Integer.parseInt(idStr));
            dao.updateCategory(cat);
        }

        resp.sendRedirect("CategoryServlet");
    }
}
