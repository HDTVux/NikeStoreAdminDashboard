<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Message" %>

<html>
    <head>
        <title>Chi tiết Chat</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <style>
            body {
                background: #f5f6fa;
                font-family: 'Segoe UI', Roboto, sans-serif;
                display: flex;
                flex-direction: column;
                align-items: center;
                margin: 0;
                padding: 30px 0;
            }

            h2 {
                color: #333;
                font-weight: 600;
                margin-bottom: 20px;
            }

            .chat-wrapper {
                width: 80%;                 /* chiếm 80% màn hình */
                max-width: 1000px;          /* không vượt quá 1000px */
                min-width: 720px;           /* giữ tối thiểu để không quá nhỏ */
                margin: 0 auto;
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }


            .chat-messages {
                flex: 1;
                padding: 20px 24px;
                overflow-y: auto;
                background: #f7f8fc;
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            .bubble {
                max-width: 75%;
                padding: 10px 16px;
                border-radius: 20px;
                line-height: 1.5em;
                font-size: 15px;
                position: relative;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
                animation: fadeIn 0.2s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(6px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* USER MESSAGE (LEFT) */
            .user-msg {
                align-self: flex-start;
                background: #e5e6ea;
                color: #111;
                border-top-left-radius: 6px;
            }

            /* ADMIN MESSAGE (RIGHT) */
            .admin-msg {
                align-self: flex-end;
                background: #0078ff;
                color: #fff;
                border-top-right-radius: 6px;
            }

            .sender {
                font-size: 13px;
                font-weight: 600;
                opacity: 0.8;
                margin-bottom: 3px;
            }

            .msg-time {
                font-size: 12px;
                opacity: 0.7;
                margin-top: 4px;
                text-align: right;
            }

            /* CHAT INPUT */
            .chat-input {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 14px 18px;
                background: #fff;
                border-top: 1px solid #eee;
            }

            .chat-input input {
                flex: 1;
                border: none;
                background: #f0f2f5;
                border-radius: 20px;
                padding: 10px 16px;
                outline: none;
                font-size: 14px;
                transition: 0.2s;
            }

            .chat-input input:focus {
                background: #e8ecf2;
            }

            .chat-input button {
                background: #0078ff;
                border: none;
                color: #fff;
                border-radius: 20px;
                padding: 8px 18px;
                cursor: pointer;
                transition: background 0.2s;
            }

            .chat-input button:hover {
                background: #0061d9;
            }

            /* Scrollbar mảnh hơn */
            .chat-messages::-webkit-scrollbar {
                width: 6px;
            }
            .chat-messages::-webkit-scrollbar-thumb {
                background: #ccc;
                border-radius: 20px;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>

        <h2>💬 Cuộc trò chuyện #<%= request.getAttribute("chatId") %></h2>

        <div class="chat-wrapper">
            <div class="chat-messages" id="chatBox">
                <%
                  List<model.Message> messages = (List<model.Message>) request.getAttribute("messages");
                  if (messages != null && !messages.isEmpty()) {
                    for (model.Message m : messages) {
                      boolean isAdmin = m.isAdmin();
                %>
                <div class="bubble <%= isAdmin ? "admin-msg" : "user-msg" %>">
                    <div class="sender"><%= isAdmin ? "Admin" : m.getSenderName() %></div>
                    <div><%= m.getMessage() %></div>
                    <div class="msg-time"><%= m.getCreatedAt() %></div>
                </div>
                <%
                    }
                  } else {
                %>
                <p style="text-align:center; color:#777;">Chưa có tin nhắn nào.</p>
                <%
                  }
                %>
            </div>

            <form class="chat-input" method="post" action="ChatDetailServlet">
                <input type="hidden" name="chat_id" value="<%= request.getAttribute("chatId") %>">
                <input type="hidden" name="admin_id" value="1"><!-- ID admin đăng nhập -->
                <input type="text" name="message" placeholder="Nhập tin nhắn..." required>
                <button type="submit">Gửi</button>
            </form>
        </div>

        <script>
            // Tự động cuộn xuống cuối khung chat
            const chatBox = document.getElementById('chatBox');
            chatBox.scrollTop = chatBox.scrollHeight;
        </script>

    </body>
</html>
