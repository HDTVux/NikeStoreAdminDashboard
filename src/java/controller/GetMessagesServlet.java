package controller;

import dao.MessageDAO;
import model.Message;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class GetMessagesServlet extends HttpServlet {
    private MessageDAO messageDAO = new MessageDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            int chatId = Integer.parseInt(request.getParameter("chat_id"));
            List<Message> messages = messageDAO.getMessagesByChatId(chatId);
            
            // Tạo JSON thủ công
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < messages.size(); i++) {
                Message m = messages.get(i);
                if (i > 0) json.append(",");
                
                json.append("{")
                    .append("\"id\":").append(m.getId()).append(",")
                    .append("\"chatId\":").append(m.getChatId()).append(",")
                    .append("\"senderId\":").append(m.getSenderId()).append(",")
                    .append("\"senderName\":\"").append(escapeJson(m.getSenderName())).append("\",")
                    .append("\"admin\":").append(m.isAdmin()).append(",")
                    .append("\"message\":\"").append(escapeJson(m.getMessage())).append("\",")
                    .append("\"createdAt\":\"").append(m.getCreatedAt().toString()).append("\"")
                    .append("}");
            }
            json.append("]");
            
            out.write(json.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Invalid chat_id\"}");
        }
    }
    
    // Hàm escape ký tự đặc biệt trong JSON
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}