package dao;

import model.Chat;
import java.sql.*;
import java.util.*;

public class ChatDAO {

    public List<Chat> getAllChats() {
        List<Chat> list = new ArrayList<>();
        String sql = """
            SELECT c.id, c.user_id, u.username, c.status, c.created_at, c.updated_at,
                   (SELECT message FROM messages WHERE chat_id=c.id ORDER BY created_at DESC LIMIT 1) AS last_message,
                   (SELECT MAX(created_at) FROM messages WHERE chat_id=c.id) AS last_message_time
            FROM chats c
            JOIN users u ON c.user_id = u.id
            ORDER BY c.updated_at DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Chat c = new Chat();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setUserName(rs.getString("username"));
                c.setStatus(rs.getString("status"));
                c.setLastMessage(rs.getString("last_message"));
                c.setLastMessageTime(rs.getTimestamp("last_message_time"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateChatStatus(int chatId, String status) {
        String sql = "UPDATE chats SET status=?, updated_at=NOW() WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, chatId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
