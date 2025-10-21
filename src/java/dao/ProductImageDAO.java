package dao;

import model.ProductImage;
import java.sql.*;
import java.util.*;
import java.util.UUID;

public class ProductImageDAO {

    // Lấy tất cả ảnh của 1 sản phẩm
    public List<ProductImage> getImagesByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY is_main DESC, id DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage img = new ProductImage();
                img.setId(rs.getInt("id"));
                img.setProductId(rs.getInt("product_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setMain(rs.getBoolean("is_main"));
                list.add(img);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Thêm ảnh mới
    public void insertImage(int productId, String imageUrl, boolean isMain) {
        String sql = "INSERT INTO product_images (product_id, image_url, is_main) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, imageUrl);
            ps.setBoolean(3, isMain);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Xóa ảnh
    public void deleteImage(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM product_images WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Đặt ảnh làm main
    public void setMainImage(int productId, int imgId) {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            // Reset ảnh khác
            try (PreparedStatement ps1 = c.prepareStatement("UPDATE product_images SET is_main=0 WHERE product_id=?")) {
                ps1.setInt(1, productId);
                ps1.executeUpdate();
            }
            // Đặt ảnh chính
            try (PreparedStatement ps2 = c.prepareStatement("UPDATE product_images SET is_main=1 WHERE id=?")) {
                ps2.setInt(1, imgId);
                ps2.executeUpdate();
            }
            c.commit();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Lấy ảnh chính
    public String getMainImage(int productId) {
        String sql = "SELECT image_url FROM product_images WHERE product_id=? AND is_main=1 LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("image_url");
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
