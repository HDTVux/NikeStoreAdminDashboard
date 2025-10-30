package controller;

import dao.ChatDAO;
import model.Chat;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ChatListServlet extends HttpServlet {
    private ChatDAO chatDAO = new ChatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Chat> chatList = chatDAO.getAllChats();
        request.setAttribute("chatList", chatList);
        request.getRequestDispatcher("chat_list.jsp").forward(request, response);
    }
}
