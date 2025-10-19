package controller;

import dao.OrderDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class OrderServlet extends HttpServlet {
  private final OrderDAO dao = new OrderDAO();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String action = req.getParameter("action");
    if (action == null) action = "list";

    switch (action){
      case "view":
        int id = Integer.parseInt(req.getParameter("id"));
        Order o = dao.findWithItems(id);
        req.setAttribute("order", o);
        req.getRequestDispatcher("order_detail.jsp").forward(req, resp);
        break;
      default:
        List<Order> list = dao.listAll();
        req.setAttribute("orders", list);
        req.getRequestDispatcher("orders.jsp").forward(req, resp);
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String idStr = req.getParameter("id");
    String status = req.getParameter("status");
    if (idStr != null && status != null){
      dao.updateStatus(Integer.parseInt(idStr), status);
    }
    resp.sendRedirect("orders");
  }
}
