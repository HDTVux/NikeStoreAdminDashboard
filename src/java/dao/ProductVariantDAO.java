package dao;

import model.ProductVariant;
import java.sql.*;
import java.util.*;

public class ProductVariantDAO {

    // Lấy danh sách variant của 1 sản phẩm
    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT id, product_id, size, stock, price FROM product_variants WHERE product_id=? ORDER BY id";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant v = new ProductVariant();
                v.setId(rs.getInt("id"));
                v.setProductId(rs.getInt("product_id"));
                v.setSize(rs.getString("size"));
                v.setStock(rs.getInt("stock"));
                v.setPrice(rs.getBigDecimal("price") == null ? null : rs.getDouble("price"));
                list.add(v);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Thêm 1 variant mới cho sản phẩm
    public void insertVariant(ProductVariant v) {
        String sql = "INSERT INTO product_variants (product_id, size, stock, price) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, v.getProductId());
            ps.setString(2, v.getSize());
            ps.setInt(3, v.getStock());
            if (v.getPrice() == null) {
                ps.setNull(4, Types.DECIMAL);
            } else {
                ps.setDouble(4, v.getPrice());
            }
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Xoá toàn bộ variant của 1 sản phẩm (dùng khi update)
    public void deleteVariantsByProductId(int productId) {
        String sql = "DELETE FROM product_variants WHERE product_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật variant (nếu cần)
    public void updateVariant(ProductVariant v) {
        String sql = "UPDATE product_variants SET size=?, stock=?, price=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, v.getSize());
            ps.setInt(2, v.getStock());
            if (v.getPrice() == null) {
                ps.setNull(3, Types.DECIMAL);
            } else {
                ps.setDouble(3, v.getPrice());
            }
            ps.setInt(4, v.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Lấy 1 variant theo id (nếu cần)
    public ProductVariant getVariantById(int id) {
        String sql = "SELECT id, product_id, size, stock, price FROM product_variants WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductVariant v = new ProductVariant();
                v.setId(rs.getInt("id"));
                v.setProductId(rs.getInt("product_id"));
                v.setSize(rs.getString("size"));
                v.setStock(rs.getInt("stock"));
                v.setPrice(rs.getBigDecimal("price") == null ? null : rs.getDouble("price"));
                return v;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
