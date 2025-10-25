package controller;

import dao.OrderDAO;
import model.Order;
import Mail.Email;
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
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                int id = Integer.parseInt(req.getParameter("id"));
                Order o = dao.findWithItems(id);
                req.setAttribute("order", o);
                req.getRequestDispatcher("order_detail.jsp").forward(req, resp);
                break;
            default:
                // Lấy filter
                String status = req.getParameter("status");
                String email = req.getParameter("email");
                if (status == null) {
                    status = "all";
                }
                if (email == null) {
                    email = "";
                }

                // Trang hiện tại
                int page = 1;
                try {
                    String p = req.getParameter("page");
                    if (p != null) {
                        page = Integer.parseInt(p);
                    }
                } catch (NumberFormatException ignored) {
                }

                int totalOrders = dao.countOrdersFiltered(status, email);
                int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);
                List<Order> list = dao.getOrdersFiltered(status, email, page, PAGE_SIZE);

                req.setAttribute("orders", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("statusFilter", status);
                req.setAttribute("emailFilter", email);
                req.getRequestDispatcher("orders.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");
        if (idStr != null && status != null) {
            int orderId = Integer.parseInt(idStr);
            dao.updateStatus(orderId, status);
            dao.updatePaymentStatus(orderId, status);
            if ("cancelled".equals(status)) {
                dao.restoreStockWhenCancelled(orderId);
            }

            // Gửi mail thông báo trạng thái mới
            Order order = dao.findWithItems(orderId);
            String to = order.getUserEmail();
            String subject = "NikeStore: Thông báo đơn hàng #" + orderId;
            String content = "Đơn hàng #" + orderId + " của bạn đã được cập nhật trạng thái thành: " + status + ".\n"
                    + "Bạn có thể kiểm tra chi tiết tại app hoặc liên hệ CSKH nếu có thắc mắc.\n"
                    + "Xin chân thành cảm ơn vì đã sử dụng dịch vụ của chúng tôi.";
            // Gửi email (nếu có email)
            if (to != null && !to.isEmpty()) {
                Email.SendEmails(to, subject, content);
            }
        }
        resp.sendRedirect("OrderServlet");
    }
}
