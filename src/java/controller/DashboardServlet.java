package controller;

import dao.DashboardDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import org.json.JSONObject;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private DashboardDAO dao = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy dữ liệu tổng quan
        int totalOrders = dao.getTotalOrders();
        double totalRevenue = dao.getTotalRevenue();
        int liveOffers = dao.getActiveBanners();
        double avgRating = dao.getAverageRating();

        // Lấy dữ liệu biểu đồ doanh thu & top sales
        JSONObject revenueData = dao.getRevenueByMonth();
        JSONObject topSalesData = dao.getTopSales();

        // Gửi sang JSP
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("liveOffers", liveOffers);
        req.setAttribute("avgRating", avgRating);

        req.setAttribute("revenueData", revenueData.toString());
        req.setAttribute("topSalesData", topSalesData.toString());

        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }
}
