package controller;

import dao.OrderDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class OrderServlet extends HttpServlet {
  private final OrderDAO dao = new OrderDAO();
  private static final int PAGE_SIZE = 10;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String action = req.getParameter("action");
    if (action == null) action = "list";

    switch (action) {
      case "view":
        int id = Integer.parseInt(req.getParameter("id"));
        Order o = dao.findWithItems(id);
        req.setAttribute("order", o);
        req.getRequestDispatcher("order_detail.jsp").forward(req, resp);
        break;

      default:
        // Lấy trang hiện tại
        int page = 1;
        try {
          String p = req.getParameter("page");
          if (p != null) page = Integer.parseInt(p);
        } catch (NumberFormatException ignored) {}

        // Lấy tổng số đơn
        int totalOrders = dao.countOrders();
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        // Lấy danh sách phân trang
        List<Order> list = dao.getOrdersPaginated(page, PAGE_SIZE);

        // Gán cho JSP
        req.setAttribute("orders", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("orders.jsp").forward(req, resp);
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String idStr = req.getParameter("id");
    String status = req.getParameter("status");
    if (idStr != null && status != null) {
      dao.updateStatus(Integer.parseInt(idStr), status);
    }
    resp.sendRedirect("orders");
  }
}
