package dao;

import model.Message;
import java.sql.*;
import java.util.*;
import dao.DBConnection;

public class MessageDAO {

    public List<Message> getMessagesByChatId(int chatId) {
        List<Message> list = new ArrayList<>();
        String sql = """
            SELECT m.*, u.username
            FROM messages m
            JOIN users u ON m.sender_id = u.id
            WHERE m.chat_id = ?
            ORDER BY m.created_at ASC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, chatId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message m = new Message();
                m.setId(rs.getInt("id"));
                m.setChatId(rs.getInt("chat_id"));
                m.setSenderId(rs.getInt("sender_id"));
                m.setSenderName(rs.getString("username"));
                m.setAdmin(rs.getBoolean("is_admin"));
                m.setMessage(rs.getString("message"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean sendAdminMessage(int chatId, int adminId, String message) {
        String sql = "INSERT INTO messages (chat_id, sender_id, is_admin, message) VALUES (?, ?, 1, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, chatId);
            ps.setInt(2, adminId);
            ps.setString(3, message);
            ps.executeUpdate();

            PreparedStatement upd = conn.prepareStatement("UPDATE chats SET updated_at=NOW(), status='open' WHERE id=?");
            upd.setInt(1, chatId);
            upd.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
