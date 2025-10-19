package controller;

import dao.BannerDAO;
import model.Banner;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class BannerServlet extends HttpServlet {
  private final BannerDAO dao = new BannerDAO();
  private final DateTimeFormatter F = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

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
        resp.sendRedirect("banners");
        break;
      case "delete":
        dao.delete(Integer.parseInt(req.getParameter("id")));
        resp.sendRedirect("banners");
        break;
      default: // list
        List<Banner> list = dao.listAll();
        req.setAttribute("banners", list);
        req.getRequestDispatcher("banners.jsp").forward(req, resp);
    }
  }

@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    String idStr = req.getParameter("id");
    String title = req.getParameter("title");
    String subtitle = req.getParameter("subtitle");
    String imageUrl = req.getParameter("image_url");
    String deeplink = req.getParameter("deeplink");
    String sort = req.getParameter("sort_order");
    String active = req.getParameter("is_active");
    String starts = req.getParameter("starts_at");
    String ends = req.getParameter("ends_at");

    Banner b = new Banner();
    b.setTitle(title);
    b.setSubtitle(subtitle);
    b.setDeeplink(deeplink);
    b.setSortOrder((sort == null || sort.isBlank()) ? null : Integer.parseInt(sort));
    b.setActive("on".equals(active) || "1".equals(active) || "true".equalsIgnoreCase(active));

    // ✅ Chỉ lưu phần tương đối
    if (imageUrl != null && !imageUrl.isBlank()) {
        // Nếu người dùng dán nguyên đường dẫn http, cắt phần "http://localhost/"
        if (imageUrl.startsWith("http://localhost/")) {
            imageUrl = imageUrl.replace("http://localhost/", "");
        }
        b.setImageUrl(imageUrl);
    }

    // Convert thời gian
    DateTimeFormatter F = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    if (starts != null && !starts.isBlank()) {
        b.setStartsAt(Timestamp.valueOf(LocalDateTime.parse(starts, F)));
    }
    if (ends != null && !ends.isBlank()) {
        b.setEndsAt(Timestamp.valueOf(LocalDateTime.parse(ends, F)));
    }

    if (idStr == null || idStr.isBlank()) {
        dao.insert(b);
    } else {
        b.setId(Integer.parseInt(idStr));
        dao.update(b);
    }

    resp.sendRedirect("banners");
}

}
