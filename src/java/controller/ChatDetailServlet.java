package controller;

import dao.ChatDAO;
import dao.MessageDAO;
import model.Message;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
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
        int chatId = Integer.parseInt(request.getParameter("chat_id"));
        int adminId = Integer.parseInt(request.getParameter("admin_id"));
        String message = request.getParameter("message");

        messageDAO.sendAdminMessage(chatId, adminId, message);
        response.sendRedirect("ChatDetailServlet?chat_id=" + chatId);
    }
}
