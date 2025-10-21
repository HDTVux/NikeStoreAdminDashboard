package dao;

import model.Order;
import model.OrderItem;
import java.sql.*;
import java.util.*;

public class OrderDAO {

public List<Order> listAll() {
    List<Order> list = new ArrayList<>();
    String sql = """
        SELECT o.id, o.user_id, u.email AS user_email,
               o.status, o.total_price, o.shipping_address,
               o.payment_method, o.shipping_fee, o.subtotal, o.created_at
        FROM orders o
        JOIN users u ON o.user_id = u.id
        ORDER BY o.created_at DESC
    """;
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Order o = new Order();
            o.setId(rs.getInt("id"));
            o.setUserId(rs.getInt("user_id"));
            o.setUserEmail(rs.getString("user_email"));
            o.setStatus(rs.getString("status"));
            o.setTotalPrice(rs.getDouble("total_price"));
            o.setShippingAddress(rs.getString("shipping_address"));
            o.setPaymentMethod(rs.getString("payment_method"));
            o.setShippingFee(rs.getDouble("shipping_fee"));
            o.setSubtotal(rs.getDouble("subtotal"));
            o.setCreatedAt(rs.getTimestamp("created_at"));
            list.add(o);
        }
        System.out.println(">>> Loaded " + list.size() + " orders from DB");
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

  public Order findWithItems(int orderId){
    Order o = null;
    String osql = """
      SELECT o.*, u.email AS user_email
      FROM orders o
      LEFT JOIN users u ON u.id=o.user_id
      WHERE o.id=?
      """;
    String isql = """
      SELECT oi.*, p.name AS product_name
      FROM order_items oi
      LEFT JOIN products p ON p.id = oi.product_id
      WHERE oi.order_id=?
      """;
    try (Connection c = DBConnection.getConnection()){
      try (PreparedStatement ps = c.prepareStatement(osql)){
        ps.setInt(1, orderId);
        try(ResultSet rs = ps.executeQuery()){
          if (rs.next()){
            o = new Order();
            o.setId(rs.getInt("id"));
            o.setUserId(rs.getInt("user_id"));
            o.setStatus(rs.getString("status"));
            o.setTotalPrice(rs.getDouble("total_price"));
            o.setShippingAddress(rs.getString("shipping_address"));
            o.setCreatedAt(rs.getTimestamp("created_at"));
            o.setPaymentMethod(rs.getString("payment_method"));
            o.setShippingFee(rs.getDouble("shipping_fee"));
            o.setSubtotal(rs.getDouble("subtotal"));
            o.setUserEmail(rs.getString("user_email"));
          }
        }
      }
      if (o != null){
        List<OrderItem> items = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(isql)){
          ps.setInt(1, orderId);
          try(ResultSet rs = ps.executeQuery()){
            while(rs.next()){
              OrderItem it = new OrderItem();
              it.setId(rs.getInt("id"));
              it.setOrderId(orderId);
              it.setProductId(rs.getInt("product_id"));
              it.setVariantId((Integer)rs.getObject("variant_id"));
              it.setQuantity(rs.getInt("quantity"));
              it.setPrice(rs.getDouble("price"));
              it.setProductName(rs.getString("product_name"));
              items.add(it);
            }
          }
        }
        o.setItems(items);
      }
    }catch(Exception e){ e.printStackTrace(); }
    return o;
  }

  public void updateStatus(int orderId, String status){
    String sql = "UPDATE orders SET status=? WHERE id=?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)){
      ps.setString(1, status);
      ps.setInt(2, orderId);
      ps.executeUpdate();
    }catch(Exception e){ e.printStackTrace(); }
  }
   // Đếm tổng số đơn hàng
    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách đơn hàng có phân trang, JOIN user để có email
    public List<Order> getOrdersPaginated(int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT o.id, o.user_id, u.email AS user_email,
                   o.status, o.total_price, o.shipping_address,
                   o.payment_method, o.shipping_fee, o.subtotal, o.created_at
            FROM orders o
            JOIN users u ON o.user_id = u.id
            ORDER BY o.created_at DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setUserEmail(rs.getString("user_email"));
                o.setStatus(rs.getString("status"));
                o.setTotalPrice(rs.getDouble("total_price"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setShippingFee(rs.getDouble("shipping_fee"));
                o.setSubtotal(rs.getDouble("subtotal"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
