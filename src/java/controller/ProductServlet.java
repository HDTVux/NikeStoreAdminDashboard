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
import java.net.HttpURLConnection;
import java.net.URL;
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

                try {
                    String uploadUrl = "https://hdtvux.id.vn/upload_api/upload_image.php";

                    // đọc bytes từ file upload
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    InputStream is = filePart.getInputStream();
                    byte[] buffer = new byte[4096];
                    int read;
                    while ((read = is.read(buffer)) != -1) {
                        baos.write(buffer, 0, read);
                    }
                    byte[] fileBytes = baos.toByteArray();

                    // tạo kết nối HTTP
                    String boundary = "----" + UUID.randomUUID();
                    HttpURLConnection conn = (HttpURLConnection) new URL(uploadUrl).openConnection();

                    conn.setDoOutput(true);
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("User-Agent", "Mozilla/5.0");
                    conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

                    DataOutputStream dos = new DataOutputStream(conn.getOutputStream());

                    // ghi dữ liệu file
                    dos.writeBytes("--" + boundary + "\r\n");
                    dos.writeBytes("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n");
                    dos.writeBytes("Content-Type: image/jpeg\r\n\r\n");
                    dos.write(fileBytes);
                    dos.writeBytes("\r\n--" + boundary + "--\r\n");
                    dos.flush();
                    dos.close();

                    int status = conn.getResponseCode();
                    if (status != 200) {
                        System.out.println("Upload failed, HTTP code: " + status);
                        return;
                    }

                    // đọc response JSON
                    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line);
                    }
                    br.close();
                    conn.disconnect();

                    String json = sb.toString();
                    json = json.replace("\\/", "/");
                    String key = "uploads/products/";
                    int start = json.indexOf(key);

                    if (start != -1) {
                        String relativePath = json.substring(start)
                                .replace("\"}", "")
                                .replace("\"", "")
                                .trim();

                        System.out.println("RELATIVE PATH = " + relativePath); // debug

                        imgDao.insertImage(productId, relativePath, false);
                    } else {
                        System.out.println("❌ Không tìm thấy key uploads/products trong JSON: " + json);
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            resp.sendRedirect("ProductServlet?action=edit&id=" + productId);
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
