package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductImageDAO;
import dao.ProductVariantDAO; // THÊM DAO NÀY
import model.Product;
import model.ProductImage;
import model.ProductVariant; // THÊM MODEL NÀY

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;
import model.Category;

@jakarta.servlet.annotation.MultipartConfig
public class ProductServlet extends HttpServlet {

    private final ProductDAO dao = new ProductDAO();
    private final ProductImageDAO imgDao = new ProductImageDAO();
    private final ProductVariantDAO variantDao = new ProductVariantDAO(); // THÊM DAO NÀY
    private final CategoryDAO catDao = new CategoryDAO();

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
                List<Category> categories = catDao.getAllCategories();
                List<ProductVariant> variants = variantDao.getVariantsByProductId(editId); // LẤY VARIANTS
                req.setAttribute("product", p);
                req.setAttribute("images", images);
                req.setAttribute("variants", variants); 
                req.setAttribute("categories", categories);
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
                List<Category> categoriesNew = catDao.getAllCategories();
                req.setAttribute("product", null);
                req.setAttribute("images", null);
                req.setAttribute("variants", null);
                req.setAttribute("categories", categoriesNew);
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
        String sizeType = req.getParameter("sizeType"); // LẤY sizeType
        String catIdStr = req.getParameter("categoryId");
        String description = req.getParameter("description");
        int catId = (catIdStr != null && !catIdStr.isEmpty()) ? Integer.parseInt(catIdStr) : 0;

        Product p = new Product();
        p.setName(name);
        p.setPrice(Double.parseDouble(price));
        if ("one-size".equals(sizeType)) {
            // chỉ parse stock khi là one-size
            try {
                p.setStock(Integer.parseInt(stock));
            } catch (Exception e) {
                p.setStock(0);
            }
        } else {
            // với shoe/clothing, mặc định stock = 0 (vì sẽ lấy từ variants)
            p.setStock(0);
        }
        p.setActive(true);
        p.setSizeType(sizeType);
        p.setCategoryId(catId);
        p.setDescription(description);
        
        if (idStr == null || idStr.isEmpty()) {
            // 🔹 Thêm mới
            int newId = dao.insertProductAndReturnId(p);

            // Nếu có variants
            if (!"one-size".equals(sizeType)) {
                String[] sizes = req.getParameterValues("variantSize");
                String[] stocks = req.getParameterValues("variantStock");
                String[] prices = req.getParameterValues("variantPrice");
                if (sizes != null) {
                    for (int i = 0; i < sizes.length; i++) {
                        ProductVariant v = new ProductVariant();
                        v.setProductId(newId);
                        v.setSize(sizes[i]);
                        v.setStock(Integer.parseInt(stocks[i]));
                        v.setPrice(Double.parseDouble(prices[i]));
                        variantDao.insertVariant(v);
                    }
                }
            }

            resp.sendRedirect("ProductServlet?action=edit&id=" + newId);
        } else {
            // 🔹 Cập nhật
            int prodId = Integer.parseInt(idStr);
            p.setId(prodId);
            dao.updateProduct(p);

            // Xử lý variants nếu là shoe/clothing: XÓA hết rồi thêm lại cho đơn giản
            if (!"one-size".equals(sizeType)) {
                variantDao.deleteVariantsByProductId(prodId);
                String[] sizes = req.getParameterValues("variantSize");
                String[] stocks = req.getParameterValues("variantStock");
                String[] prices = req.getParameterValues("variantPrice");
                if (sizes != null) {
                    for (int i = 0; i < sizes.length; i++) {
                        ProductVariant v = new ProductVariant();
                        v.setProductId(prodId);
                        v.setSize(sizes[i]);
                        v.setStock(Integer.parseInt(stocks[i]));
                        v.setPrice(Double.parseDouble(prices[i]));
                        variantDao.insertVariant(v);
                    }
                }
            } else {
                // Nếu chuyển về one-size thì xoá hết variants
                variantDao.deleteVariantsByProductId(prodId);
            }

            resp.sendRedirect("ProductServlet?action=edit&id=" + prodId);
        }
    }
}
