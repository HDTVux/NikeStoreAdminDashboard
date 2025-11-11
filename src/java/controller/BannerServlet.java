package controller;

import dao.BannerDAO;
import model.Banner;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@MultipartConfig
public class BannerServlet extends HttpServlet {

    private final BannerDAO dao = new BannerDAO();
    private final DateTimeFormatter F = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final int PAGE_SIZE = 8;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                req.getRequestDispatcher("banner_form.jsp").forward(req, resp);
                break;

            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Banner b = dao.findById(id);
                req.setAttribute("banner", b);
                req.getRequestDispatcher("banner_form.jsp").forward(req, resp);
                break;

            case "toggle":
                dao.toggle(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect("BannerServlet");
                break;

            case "delete":
                dao.delete(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect("BannerServlet");
                break;

            default:
                int page = 1;
                try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}

                int total = dao.count();
                int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
                List<Banner> list = dao.listPaginated(page, PAGE_SIZE);

                req.setAttribute("banners", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", Math.max(totalPages, 1));

                req.getRequestDispatcher("banners.jsp").forward(req, resp);
        }
    }

    // ============================================
    // 🔥 POST: ADD / UPDATE BANNER
    // ============================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr    = req.getParameter("id");
        String title    = req.getParameter("title");
        String subtitle = req.getParameter("subtitle");
        String imageUrl = req.getParameter("image_url"); // nhập thủ công
        String deeplink = req.getParameter("deeplink");
        String sort     = req.getParameter("sort_order");
        String active   = req.getParameter("is_active");
        String starts   = req.getParameter("starts_at");
        String ends     = req.getParameter("ends_at");

        Banner b = new Banner();
        b.setTitle(title);
        b.setSubtitle(subtitle);
        b.setDeeplink(deeplink);
        b.setSortOrder((sort == null || sort.isBlank()) ? null : Integer.parseInt(sort));
        b.setActive("on".equals(active) || "1".equals(active));

        if (starts != null && !starts.isBlank())
            b.setStartsAt(Timestamp.valueOf(LocalDateTime.parse(starts, F)));

        if (ends != null && !ends.isBlank())
            b.setEndsAt(Timestamp.valueOf(LocalDateTime.parse(ends, F)));

        // ===========================
        // ✅ UPLOAD ẢNH BANNER
        // ===========================
        Part filePart = null;
        try { filePart = req.getPart("image_file"); } catch (Exception ignore) {}

        if (filePart != null && filePart.getSize() > 0) {
            try {
                String uploadUrl = "https://hdtvux.id.vn/upload_api/upload_banner.php";

                // đọc bytes
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                InputStream is = filePart.getInputStream();
                byte[] buffer = new byte[4096];
                int read;
                while ((read = is.read(buffer)) != -1) baos.write(buffer, 0, read);
                byte[] fileBytes = baos.toByteArray();

                // multipart request
                String boundary = "----" + UUID.randomUUID();
                HttpURLConnection conn = (HttpURLConnection) new URL(uploadUrl).openConnection();

                conn.setDoOutput(true);
                conn.setRequestMethod("POST");
                conn.setRequestProperty("User-Agent", "Mozilla/5.0");
                conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

                DataOutputStream dos = new DataOutputStream(conn.getOutputStream());

                dos.writeBytes("--" + boundary + "\r\n");
                dos.writeBytes("Content-Disposition: form-data; name=\"file\"; filename=\"banner.jpg\"\r\n");
                dos.writeBytes("Content-Type: image/jpeg\r\n\r\n");
                dos.write(fileBytes);
                dos.writeBytes("\r\n--" + boundary + "--\r\n");
                dos.flush();
                dos.close();

                // đọc JSON
                int status = conn.getResponseCode();
                if (status == 200) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder sb = new StringBuilder();
                    String line;

                    while ((line = br.readLine()) != null) sb.append(line);
                    br.close();
                    String json = sb.toString().replace("\\/", "/");

                    // tách path
                    String key = "uploads/banners/";
                    int start = json.indexOf(key);

                    if (start != -1) {
                        String relativePath = json.substring(start)
                                .replace("\"}", "")
                                .replace("\"", "")
                                .trim();

                        b.setImageUrl(relativePath); // ✅ lưu dạng relative
                    } else {
                        System.out.println("❌ Không tìm thấy uploads/banners trong JSON: " + json);
                    }
                } else {
                    System.out.println("❌ Upload banner thất bại. HTTP Code: " + status);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (imageUrl != null && !imageUrl.isBlank()) {
            // nếu người dùng nhập tay
            if (imageUrl.startsWith("http://localhost/"))
                imageUrl = imageUrl.replace("http://localhost/", "");

            b.setImageUrl(imageUrl);
        }

        // insert/update
        if (idStr == null || idStr.isBlank()) {
            dao.insert(b);
        } else {
            b.setId(Integer.parseInt(idStr));
            dao.update(b);
        }

        resp.sendRedirect("BannerServlet");
    }
}
