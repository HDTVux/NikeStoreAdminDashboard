package controller;

import dao.ChatDAO;
import dao.MessageDAO;
import model.Message;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class ChatDetailServlet extends HttpServlet {
    private ChatDAO chatDAO = new ChatDAO();
    private MessageDAO messageDAO = new MessageDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int chatId = Integer.parseInt(request.getParameter("chat_id"));
        List<Message> messages = messageDAO.getMessagesByChatId(chatId);
        request.setAttribute("chatId", chatId);
        request.setAttribute("messages", messages);
        request.getRequestDispatcher("chat_detail.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response type trước khi làm gì khác
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int chatId = Integer.parseInt(request.getParameter("chat_id"));
            int adminId = Integer.parseInt(request.getParameter("admin_id"));
            String message = request.getParameter("message");
            
            System.out.println("Received: chatId=" + chatId + ", adminId=" + adminId + ", message=" + message);
            
            boolean success = messageDAO.sendAdminMessage(chatId, adminId, message);
            
            if (success) {
                out.write("{\"status\": \"success\"}");
                System.out.println("Message sent successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"status\": \"error\", \"message\": \"Database error\"}");
                System.out.println("Failed to send message");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"status\": \"error\", \"message\": \"Invalid parameters\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }
}