<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Chat" %>
<html>
<head>
    <title>Chat Support - Admin</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            margin: 30px 0 20px 0;
            color: #333;
            font-weight: 600;
        }

        .chat-table-container {
            width: 90%;
            max-width: 1000px;
            margin: auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #343a40;
            color: #fff;
        }

        th, td {
            padding: 12px 16px;
            text-align: center;
            border-bottom: 1px solid #e9ecef;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        td a {
            background-color: #007bff;
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            transition: 0.2s;
        }

        td a:hover {
            background-color: #0056b3;
        }

        .status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .status.open { background-color: #d1ecf1; color: #0c5460; }
        .status.closed { background-color: #f8d7da; color: #721c24; }
        .status.active { background-color: #d4edda; color: #155724; }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <h2>💬 Danh sách cuộc trò chuyện</h2>

    <div class="chat-table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Người dùng</th>
                    <th>Trạng thái</th>
                    <th>Tin nhắn cuối</th>
                    <th>Thời gian</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
            <%
                List<model.Chat> list = (List<model.Chat>) request.getAttribute("chatList");
                if (list != null && !list.isEmpty()) {
                    for (model.Chat c : list) {
            %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><%= c.getUserName() %></td>
                    <td>
                        <span class="status <%= c.getStatus() %>">
                            <%= c.getStatus() %>
                        </span>
                    </td>
                    <td><%= c.getLastMessage() %></td>
                    <td><%= c.getLastMessageTime() %></td>
                    <td>
                        <a href="ChatDetailServlet?chat_id=<%= c.getId() %>">Xem chi tiết</a>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="6" style="color: #666;">Không có cuộc trò chuyện nào</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</body>
</html>
