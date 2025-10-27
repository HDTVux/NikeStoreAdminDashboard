package controller;

import dao.PromotionDAO;
import dao.ProductDAO;
import model.Promotion;
import model.Product;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class PromotionServlet extends HttpServlet {

    private final PromotionDAO promoDAO = new PromotionDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                req.setAttribute("products", productDAO.getAllProducts());
                req.getRequestDispatcher("promotion_form.jsp").forward(req, resp);
                break;

            case "edit":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Promotion pr = promoDAO.findById(id);
                    req.setAttribute("promotion", pr);
                    req.setAttribute("products", productDAO.getAllProducts());
                    req.getRequestDispatcher("promotion_form.jsp").forward(req, resp);
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.getWriter().println("Error loading promotion: " + e.getMessage());
                }
                break;

            case "toggle":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    promoDAO.toggle(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                resp.sendRedirect("PromotionServlet?action=list");
                break;

            case "delete":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    promoDAO.delete(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                resp.sendRedirect("PromotionServlet?action=list");
                break;

            default:
                try {
                    List<Promotion> list = promoDAO.getAll();
                    req.setAttribute("promotions", list);
                    req.getRequestDispatcher("promotions.jsp").forward(req, resp);
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.getWriter().println("Error loading promotions: " + e.getMessage());
                }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            Promotion p = new Promotion();
            p.setProductId(Integer.parseInt(req.getParameter("product_id")));
            p.setDiscountPercent(Double.parseDouble(req.getParameter("discount_percent")));
            p.setStartsAt(req.getParameter("starts_at"));
            p.setEndsAt(req.getParameter("ends_at"));
            p.setActive(req.getParameter("is_active") != null);

            String id = req.getParameter("id");
            if (id == null || id.isEmpty()) {
                promoDAO.insert(p);
            } else {
                p.setId(Integer.parseInt(id));
                promoDAO.update(p);
            }

            resp.sendRedirect("PromotionServlet?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error saving promotion: " + e.getMessage());
        }
    }
}
