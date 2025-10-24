package dao;

import model.Category;
import java.sql.*;
import java.util.*;

public class CategoryDAO {
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name FROM categories";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                list.add(cat);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return list;
    }
}
