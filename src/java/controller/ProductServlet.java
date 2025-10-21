package controller;

import dao.ProductDAO;
import dao.ProductImageDAO;
import model.Product;
import model.ProductImage;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@jakarta.servlet.annotation.MultipartConfig
public class ProductServlet extends HttpServlet {

    private final ProductDAO dao = new ProductDAO();
    private final ProductImageDAO imgDao = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }
        final int PAGE_SIZE = 10;

        switch (action) {
            case "toggle":
                dao.toggleActive(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect("ProductServlet");
                break;

            case "edit":
                int editId = Integer.parseInt(req.getParameter("id"));
                Product p = dao.getProductById(editId);
                List<ProductImage> images = imgDao.getImagesByProductId(editId);
                req.setAttribute("product", p);
                req.setAttribute("images", images);
                req.getRequestDispatcher("product_form.jsp").forward(req, resp);
                break;

            case "image-main":
                imgDao.setMainImage(Integer.parseInt(req.getParameter("productId")),
                        Integer.parseInt(req.getParameter("imgId")));
                resp.sendRedirect("ProductServlet?action=edit&id=" + req.getParameter("productId"));
                break;

            case "image-delete":
                imgDao.deleteImage(Integer.parseInt(req.getParameter("imgId")));
                resp.sendRedirect("ProductServlet?action=edit&id=" + req.getParameter("productId"));
                break;
            case "new":
            req.setAttribute("product", null);
            req.setAttribute("images", null);
            req.getRequestDispatcher("product_form.jsp").forward(req, resp);
            break;

            default:
                int page = 1;
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (Exception ignored) {
                }
                int totalProducts = dao.countProducts();
                int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
                List<Product> list = dao.getProductsPaginated(page, PAGE_SIZE);
                req.setAttribute("products", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("products.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("upload-image".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            Part filePart = req.getPart("imageFile");

            if (filePart != null && filePart.getSize() > 0) {
                String uploadsDir = "C:/xampp/htdocs/uploads/products/";
                File uploadFolder = new File(uploadsDir);
                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }

                String fileName = UUID.randomUUID().toString().replace("-", "") + ".jpg";
                Path filePath = Paths.get(uploadsDir, fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }

                String relativePath = "uploads/products/" + fileName;
                imgDao.insertImage(productId, relativePath, false);
            }

            resp.sendRedirect("ProductServlet?action=edit&id=" + req.getParameter("productId"));
            return;
        }

        // ===== THÊM HOẶC CẬP NHẬT PRODUCT =====
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
            // 🔹 Thêm mới
            int newId = dao.insertProductAndReturnId(p);
            resp.sendRedirect("ProductServlet?action=edit&id=" + newId);
        } else {
            // 🔹 Cập nhật
            p.setId(Integer.parseInt(idStr));
            dao.updateProduct(p);
            resp.sendRedirect("ProductServlet");
        }
    }

}
