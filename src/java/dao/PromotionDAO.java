package dao;

import model.Promotion;
import java.sql.*;
import java.util.*;
import dao.DBConnection;

public class PromotionDAO {

    private Connection conn;

    public PromotionDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Promotion> getAll() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT pr.*, p.name AS product_name FROM promotions pr JOIN products p ON pr.product_id = p.id ORDER BY pr.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promotion pr = new Promotion();
                pr.setId(rs.getInt("id"));
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

    public Promotion findById(int id) {
        String sql = "SELECT * FROM promotions WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Promotion pr = new Promotion();
                pr.setId(rs.getInt("id"));
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

    public boolean insert(Promotion p) {
        String sql = "INSERT INTO promotions (product_id, discount_percent, starts_at, ends_at, is_active) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getProductId());
            ps.setDouble(2, p.getDiscountPercent());
            ps.setString(3, p.getStartsAt());
            ps.setString(4, p.getEndsAt());
            ps.setBoolean(5, p.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Promotion p) {
        String sql = "UPDATE promotions SET product_id=?, discount_percent=?, starts_at=?, ends_at=?, is_active=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getProductId());
            ps.setDouble(2, p.getDiscountPercent());
            ps.setString(3, p.getStartsAt());
            ps.setString(4, p.getEndsAt());
            ps.setBoolean(5, p.isActive());
            ps.setInt(6, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

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
}
