package dao;

import model.Promotion;
import java.sql.*;
import java.util.*;

public class PromotionDAO {

    private Connection conn;

    public PromotionDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy tất cả promotions
    public List<Promotion> getAll() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT pr.*, p.name AS product_name FROM promotions pr " +
                     "JOIN products p ON pr.product_id = p.id " +
                     "ORDER BY pr.created_at DESC, pr.name, pr.id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promotion pr = new Promotion();
                pr.setId(rs.getInt("id"));
                pr.setName(rs.getString("name"));
                pr.setProductId(rs.getInt("product_id"));
                pr.setDiscountPercent(rs.getDouble("discount_percent"));
                pr.setStartsAt(rs.getString("starts_at"));
                pr.setEndsAt(rs.getString("ends_at"));
                pr.setActive(rs.getBoolean("is_active"));
                pr.setProductName(rs.getString("product_name"));
                list.add(pr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm theo ID
    public Promotion findById(int id) {
        String sql = "SELECT * FROM promotions WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Promotion pr = new Promotion();
                pr.setId(rs.getInt("id"));
                pr.setName(rs.getString("name"));
                pr.setProductId(rs.getInt("product_id"));
                pr.setDiscountPercent(rs.getDouble("discount_percent"));
                pr.setStartsAt(rs.getString("starts_at"));
                pr.setEndsAt(rs.getString("ends_at"));
                pr.setActive(rs.getBoolean("is_active"));
                return pr;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert 1 promotion
    public boolean insert(Promotion p) {
        String sql = "INSERT INTO promotions (name, product_id, discount_percent, starts_at, ends_at, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getProductId());
            ps.setDouble(3, p.getDiscountPercent());
            ps.setString(4, p.getStartsAt());
            ps.setString(5, p.getEndsAt());
            ps.setBoolean(6, p.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Insert nhiều promotions cùng lúc (batch insert)
    public boolean insertBatch(String name, double discountPercent, String startsAt, 
                               String endsAt, boolean isActive, int[] productIds) {
        String sql = "INSERT INTO promotions (name, product_id, discount_percent, starts_at, ends_at, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int productId : productIds) {
                ps.setString(1, name);
                ps.setInt(2, productId);
                ps.setDouble(3, discountPercent);
                ps.setString(4, startsAt);
                ps.setString(5, endsAt);
                ps.setBoolean(6, isActive);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            return results.length == productIds.length;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update promotion
    public boolean update(Promotion p) {
        String sql = "UPDATE promotions SET name=?, product_id=?, discount_percent=?, " +
                     "starts_at=?, ends_at=?, is_active=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getProductId());
            ps.setDouble(3, p.getDiscountPercent());
            ps.setString(4, p.getStartsAt());
            ps.setString(5, p.getEndsAt());
            ps.setBoolean(6, p.isActive());
            ps.setInt(7, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa promotion
    public boolean delete(int id) {
        String sql = "DELETE FROM promotions WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Toggle active/inactive
    public boolean toggle(int id) {
        String sql = "UPDATE promotions SET is_active = NOT is_active WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Toggle theo tên chương trình (bật/tắt tất cả cùng lúc)
    public boolean toggleByName(String name) {
        String sql = "UPDATE promotions SET is_active = NOT is_active WHERE name=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa tất cả promotions theo tên
    public boolean deleteByName(String name) {
        String sql = "DELETE FROM promotions WHERE name=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}