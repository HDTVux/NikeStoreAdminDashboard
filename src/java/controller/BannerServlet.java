package controller;

import dao.BannerDAO;
import model.Banner;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.*;
import java.nio.file.*;
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

      default: // list + pagination
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

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    // fields
    String idStr    = req.getParameter("id");
    String title    = req.getParameter("title");
    String subtitle = req.getParameter("subtitle");
    String imageUrl = req.getParameter("image_url"); // có thể rỗng nếu người dùng chọn file
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
    b.setActive("on".equals(active) || "1".equals(active) || "true".equalsIgnoreCase(active));

    // parse time
    if (starts != null && !starts.isBlank()) b.setStartsAt(Timestamp.valueOf(LocalDateTime.parse(starts, F)));
    if (ends   != null && !ends.isBlank())   b.setEndsAt(Timestamp.valueOf(LocalDateTime.parse(ends, F)));

    // xử lý upload file (nếu có)
    Part filePart = null;
    try { filePart = req.getPart("image_file"); } catch (Exception ignore) {}

    if (filePart != null && filePart.getSize() > 0) {
      // Lưu file vào XAMPP
      String uploadsDir = "C:/xampp/htdocs/uploads/banners/";
      File folder = new File(uploadsDir);
      if (!folder.exists()) folder.mkdirs();

      // Tạo tên file ngẫu nhiên
      String fileName = UUID.randomUUID().toString().replace("-", "") + ".jpg";
      Path filePath = Paths.get(uploadsDir, fileName);
      try (InputStream in = filePart.getInputStream()) {
        Files.copy(in, filePath, StandardCopyOption.REPLACE_EXISTING);
      }

      // Lưu vào DB dạng tương đối
      b.setImageUrl("uploads/banners/" + fileName);

    } else if (imageUrl != null && !imageUrl.isBlank()) {
      // người dùng nhập URL thủ công
      if (imageUrl.startsWith("http://localhost/")) {
        imageUrl = imageUrl.replace("http://localhost/", "");
      }
      b.setImageUrl(imageUrl);
    } // else: để null nếu người dùng chưa nhập gì (insert/update sẽ giữ nguyên nếu bạn muốn)

    // insert / update
    if (idStr == null || idStr.isBlank()) {
      dao.insert(b);
    } else {
      b.setId(Integer.parseInt(idStr));
      dao.update(b);
    }

    resp.sendRedirect("BannerServlet");
  }
}
