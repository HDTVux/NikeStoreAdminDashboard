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

            case "toggleGroup":
                // Toggle tất cả promotions cùng tên
                try {
                    String name = req.getParameter("name");
                    if (name != null && !name.isEmpty()) {
                        promoDAO.toggleByName(name);
                    }
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

            case "deleteGroup":
                // Xóa tất cả promotions cùng tên
                try {
                    String name = req.getParameter("name");
                    if (name != null && !name.isEmpty()) {
                        promoDAO.deleteByName(name);
                    }
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
            String id = req.getParameter("id");

            // Nếu có ID -> Edit mode (chỉ edit 1 promotion)
            if (id != null && !id.isEmpty()) {
                Promotion p = new Promotion();
                p.setId(Integer.parseInt(id));
                p.setName(req.getParameter("name"));
                p.setProductId(Integer.parseInt(req.getParameter("product_id")));
                p.setDiscountPercent(Double.parseDouble(req.getParameter("discount_percent")));
                p.setStartsAt(req.getParameter("starts_at"));
                p.setEndsAt(req.getParameter("ends_at"));
                p.setActive(req.getParameter("is_active") != null);
                promoDAO.update(p);
            } 
            // Không có ID -> Create mode (có thể chọn nhiều sản phẩm)
            else {
                String name = req.getParameter("name");
                double discountPercent = Double.parseDouble(req.getParameter("discount_percent"));
                String startsAt = req.getParameter("starts_at");
                String endsAt = req.getParameter("ends_at");
                boolean isActive = req.getParameter("is_active") != null;

                // Lấy danh sách product_ids đã chọn
                String[] productIdsStr = req.getParameterValues("product_ids");

                if (productIdsStr != null && productIdsStr.length > 0) {
                    int[] productIds = new int[productIdsStr.length];
                    for (int i = 0; i < productIdsStr.length; i++) {
                        productIds[i] = Integer.parseInt(productIdsStr[i]);
                    }

                    // Insert batch
                    promoDAO.insertBatch(name, discountPercent, startsAt, endsAt, isActive, productIds);
                } else {
                    resp.getWriter().println("Please select at least one product!");
                    return;
                }
            }

            resp.sendRedirect("PromotionServlet?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error saving promotion: " + e.getMessage());
        }
    }
}