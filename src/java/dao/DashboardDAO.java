package dao;

import java.sql.*;
import org.json.JSONObject;
import org.json.JSONArray;
import dao.DBConnection;

public class DashboardDAO {

    // Tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Tổng doanh thu (cộng total_price từ orders)
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM orders WHERE status='paid'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Số banner đang hoạt động
    public int getActiveBanners() {
        String sql = "SELECT COUNT(*) FROM banners WHERE is_active=1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Điểm rating trung bình
    public double getAverageRating() {
        String sql = "SELECT AVG(rating) FROM reviews";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Doanh thu theo tháng
    public JSONObject getRevenueByMonth() {
        JSONObject obj = new JSONObject();
        JSONArray labels = new JSONArray();
        JSONArray data = new JSONArray();

        String sql = """
            SELECT DATE_FORMAT(created_at, '%b') AS month, SUM(total_price) AS total
            FROM orders
            WHERE status='paid'
            GROUP BY MONTH(created_at)
            ORDER BY MONTH(created_at)
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                labels.put(rs.getString("month"));
                data.put(rs.getDouble("total"));
            }
            obj.put("labels", labels);
            obj.put("data", data);
        } catch (Exception e) { e.printStackTrace(); }
        return obj;
    }

    // Top sản phẩm bán chạy
    public JSONObject getTopSales() {
        JSONObject obj = new JSONObject();
        JSONArray labels = new JSONArray();
        JSONArray data = new JSONArray();

        String sql = """
            SELECT p.name, SUM(oi.quantity) AS total_sold
            FROM order_items oi
            JOIN products p ON p.id = oi.product_id
            GROUP BY p.name
            ORDER BY total_sold DESC
            LIMIT 5
        """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                labels.put(rs.getString("name"));
                data.put(rs.getInt("total_sold"));
            }
            obj.put("labels", labels);
            obj.put("data", data);
        } catch (Exception e) { e.printStackTrace(); }
        return obj;
    }
    
    // Tổng số khách hàng đang hoạt động
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role='customer' AND is_active=1";
        try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    } 
    // 5 đơn hàng gần nhất
public JSONArray getRecentOrders() {
    JSONArray arr = new JSONArray();
    String sql = """
        SELECT o.id, u.username, o.total_price, o.status, o.created_at
        FROM orders o
        JOIN users u ON u.id = o.user_id
        ORDER BY o.created_at DESC
        LIMIT 5
    """;
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            JSONObject row = new JSONObject();
            row.put("id", rs.getInt("id"));
            row.put("username", rs.getString("username"));
            row.put("total_price", rs.getDouble("total_price"));
            row.put("status", rs.getString("status"));
            row.put("created_at", rs.getTimestamp("created_at").toString());
            arr.put(row);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return arr;
}
}
