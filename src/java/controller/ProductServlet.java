package controller;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ProductServlet extends HttpServlet {
    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "toggle":
                int id = Integer.parseInt(req.getParameter("id"));
                dao.toggleActive(id);
                resp.sendRedirect("products");
                break;

            case "edit":
                int editId = Integer.parseInt(req.getParameter("id"));
                Product p = dao.getProductById(editId);
                req.setAttribute("product", p);
                req.getRequestDispatcher("product_form.jsp").forward(req, resp);
                break;

            case "new":
                req.getRequestDispatcher("product_form.jsp").forward(req, resp);
                break;

            default:
                List<Product> list = dao.getAllProducts();
                req.setAttribute("products", list);
                req.getRequestDispatcher("products.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String price = req.getParameter("price");
        String stock = req.getParameter("stock");

        Product p = new Product();
        p.setName(name);
        p.setPrice(Double.parseDouble(price));
        p.setStock(Integer.parseInt(stock));
        p.setActive(true);

        if (idStr == null || idStr.isEmpty()) {
            dao.insertProduct(p);
        } else {
            p.setId(Integer.parseInt(idStr));
            dao.updateProduct(p);
        }
        resp.sendRedirect("products");
    }
}
