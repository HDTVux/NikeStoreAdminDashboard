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
                width: 80%;
                max-width: 1000px;
                min-width: 720px;
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
                max-height: 500px;
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

            .user-msg {
                align-self: flex-start;
                background: #e5e6ea;
                color: #111;
                border-top-left-radius: 6px;
            }

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
            
            .chat-input button:disabled {
                background: #ccc;
                cursor: not-allowed;
            }

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
                <!-- Messages sẽ được load bằng AJAX -->
            </div>

            <form class="chat-input" id="chatForm" onsubmit="return false;">
                <input type="hidden" name="chat_id" id="chatId" value="<%= request.getAttribute("chatId") %>">
                <input type="hidden" name="admin_id" id="adminId" value="<%= session.getAttribute("userId") != null ? session.getAttribute("userId") : "1" %>">
                <input type="text" name="message" id="messageInput" placeholder="Nhập tin nhắn..." required autocomplete="off">
                <button type="button" id="sendBtn" onclick="sendMessage()">Gửi</button>
            </form>
        </div>

        <script>
            var chatId = <%= request.getAttribute("chatId") %>;
            var chatBox = document.getElementById('chatBox');
            var messageInput = document.getElementById('messageInput');
            var sendBtn = document.getElementById('sendBtn');

            // Hàm format timestamp
            function formatTimestamp(timestamp) {
                var date = new Date(timestamp);
                return date.toLocaleString('vi-VN');
            }

            // Hàm tạo HTML cho message
            function createMessageHTML(msg) {
                var isAdmin = msg.admin;
                var bubbleClass = isAdmin ? 'admin-msg' : 'user-msg';
                var senderName = isAdmin ? 'Admin' : msg.senderName;
                
                return '<div class="bubble ' + bubbleClass + '">' +
                    '<div class="sender">' + senderName + '</div>' +
                    '<div>' + escapeHtml(msg.message) + '</div>' +
                    '<div class="msg-time">' + formatTimestamp(msg.createdAt) + '</div>' +
                    '</div>';
            }
            
            // Escape HTML để tránh XSS
            function escapeHtml(text) {
                var map = {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#039;'
                };
                return text.replace(/[&<>"']/g, function(m) { return map[m]; });
            }

            // Load messages từ server
            function loadMessages() {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'GetMessagesServlet?chat_id=' + chatId, true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        try {
                            var messages = JSON.parse(xhr.responseText);
                            if (messages.length > 0) {
                                var hasNewMessages = messages.length > chatBox.children.length;
                                
                                chatBox.innerHTML = '';
                                for (var i = 0; i < messages.length; i++) {
                                    chatBox.innerHTML += createMessageHTML(messages[i]);
                                }
                                
                                if (hasNewMessages) {
                                    chatBox.scrollTop = chatBox.scrollHeight;
                                }
                            }
                        } catch (e) {
                            console.error('Error parsing messages:', e);
                        }
                    }
                };
                xhr.send();
            }

            // Gửi tin nhắn
            function sendMessage() {
                var message = messageInput.value.trim();
                if (!message) return;
                
                sendBtn.disabled = true;
                sendBtn.textContent = 'Đang gửi...';
                
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'ChatDetailServlet', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == 4) {
                        sendBtn.disabled = false;
                        sendBtn.textContent = 'Gửi';
                        
                        console.log('Status:', xhr.status);
                        console.log('Response:', xhr.responseText);
                        
                        if (xhr.status == 200) {
                            try {
                                var response = JSON.parse(xhr.responseText);
                                console.log('Parsed response:', response);
                                if (response.status === 'success') {
                                    messageInput.value = '';
                                    loadMessages();
                                } else {
                                    alert('Gửi tin nhắn thất bại: ' + (response.message || 'Unknown error'));
                                }
                            } catch (e) {
                                console.error('Error parsing response:', e);
                                console.error('Response text:', xhr.responseText);
                                alert('Lỗi: Server trả về không phải JSON!\n' + xhr.responseText.substring(0, 200));
                            }
                        } else {
                            console.error('HTTP Error:', xhr.status, xhr.responseText);
                            alert('Lỗi HTTP ' + xhr.status + '!\nKiểm tra Console để biết chi tiết.');
                        }
                    }
                };
                
                var adminId = document.getElementById('adminId').value;
                var params = 'chat_id=' + chatId + 
                           '&admin_id=' + adminId + 
                           '&message=' + encodeURIComponent(message);
                           
                console.log('Sending params:', params);
                xhr.send(params);
            }
            
            // Enter để gửi
            messageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            // Load tin nhắn ban đầu
            loadMessages();

            // Tự động load tin nhắn mới mỗi 2 giây
            setInterval(loadMessages, 2000);
        </script>

    </body>
</html>