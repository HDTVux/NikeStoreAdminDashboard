package dao;

import model.User;
import java.sql.*;
import java.util.*;

public class UserDAO {
    public List<User> getUsersPaginated(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        int offset = (page-1)*pageSize;
        String sql = "SELECT * FROM users ORDER BY id DESC LIMIT ? OFFSET ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setUsername(rs.getString("username"));
                u.setActive(rs.getBoolean("is_active"));
                list.add(u);
            }
        } catch(Exception e){ e.printStackTrace(); }
        return list;
    }

    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if(rs.next()) return rs.getInt(1);
        } catch(Exception e){ e.printStackTrace(); }
        return 0;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setUsername(rs.getString("username"));
                u.setActive(rs.getBoolean("is_active"));
                return u;
            }
        } catch(Exception e){ e.printStackTrace(); }
        return null;
    }

    public void insertUser(User u) {
        String sql = "INSERT INTO users (email, username, password, is_active) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getPassword());
            ps.setBoolean(4, u.isActive());
            ps.executeUpdate();
        } catch(Exception e){ e.printStackTrace(); }
    }

    public void updateUser(User u) {
        String sql = "UPDATE users SET email=?, username=?, is_active=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getUsername());
            ps.setBoolean(3, u.isActive());
            ps.setInt(4, u.getId());
            ps.executeUpdate();
        } catch(Exception e){ e.printStackTrace(); }
    }

    public void toggleActive(int id) {
        String sql = "UPDATE users SET is_active = NOT is_active WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e){ e.printStackTrace(); }
    }

    public void deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e){ e.printStackTrace(); }
    }
    
    public User getUserByEmailAndPassword(String email, String password) {
    String sql = "SELECT * FROM users WHERE email=? AND password=?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setEmail(rs.getString("email"));
            u.setUsername(rs.getString("username"));
            u.setRole(rs.getString("role")); // THÊM field role vào model.User
            // ... các trường khác nếu cần
            return u;
        }
    } catch(Exception e){ e.printStackTrace(); }
    return null;
}

}
