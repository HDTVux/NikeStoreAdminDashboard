package dao;

import model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT id, name, price, stock, is_active, size_type, category_id, description FROM products ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setActive(rs.getBoolean("is_active"));
                p.setSizeType(rs.getString("size_type"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Product getProductById(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setActive(rs.getBoolean("is_active"));
                p.setSizeType(rs.getString("size_type"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setDescription(rs.getString("description"));
                return p;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void insertProduct(Product p) {
        String sql = "INSERT INTO products (name, price, stock, is_active, size_type, category_id, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.setBoolean(4, p.isActive());
            ps.setString(5, p.getSizeType());
            ps.setString(6, p.getDescription());
            ps.setInt(7, p.getCategoryId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void updateProduct(Product p) {
        String sql = "UPDATE products SET name=?, price=?, stock=?, size_type=?, category_id=?, description=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.setString(4, p.getSizeType());
            ps.setInt(5, p.getCategoryId());
            ps.setString(6, p.getDescription());
            ps.setInt(7, p.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void toggleActive(int id) {
        String sql = "UPDATE products SET is_active = NOT is_active WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Product> getProductsPaginated(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT id, name, price, stock, is_active, size_type FROM products ORDER BY id DESC LIMIT ? OFFSET ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setActive(rs.getBoolean("is_active"));
                p.setSizeType(rs.getString("size_type"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

public int insertProductAndReturnId(Product p) {
    String sql = "INSERT INTO products (name, description, price, stock, is_active, size_type, category_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, p.getName());
        ps.setString(2, p.getDescription());
        ps.setDouble(3, p.getPrice());
        ps.setInt(4, p.getStock());
        ps.setBoolean(5, p.isActive());
        ps.setString(6, p.getSizeType());
        ps.setInt(7, p.getCategoryId());
        ps.executeUpdate();
        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return -1;
}

}
