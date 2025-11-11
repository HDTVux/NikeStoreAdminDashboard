<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Banner" %>
<%
    // ✅ Domain để load ảnh từ hosting iNET
    String BASE_URL = "https://hdtvux.id.vn/";
%>
<html>
    <head>
        <title>Banners - Nike Admin</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/admin-dashboard.css">
        <style>
            body {
                background: white;
                color: #fff;
            }
            .content {
                margin-left: 240px;
                padding: 30px 40px;
            }
            .header-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .header-bar h2 {
                font-weight: 600;
                color: #fff;
            }
            .btn-add {
                background: #fff;
                color: #000;
                border-radius: 6px;
                padding: 8px 16px;
                font-weight: 500;
                text-decoration: none;
                transition: 0.2s;
            }
            .btn-add:hover {
                background: #26ff86;
                color: #000;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                border-radius: 10px;
                overflow: hidden;
                background: #1a1a1a;
            }
            th {
                background: #000;
                color: #26ff86;
                padding: 12px;
                text-align: center;
                border-bottom: 2px solid #222;
            }
            td {
                padding: 14px 12px;
                text-align: center;
                border-bottom: 1px solid #333;
                color: #eee;
            }
            tr:hover td {
                background: #1f1f1f;
            }

            img.thumb {
                height: 60px;
                width: 140px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid #333;
            }

            .status {
                padding: 5px 14px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 500;
                display: inline-block;
            }
            .status.active {
                background: #00c853;
                color: #fff;
            }
            .status.inactive {
                background: #ff5252;
                color: #fff;
            }

            a.action {
                font-weight: 500;
                text-decoration: none;
                margin: 0 6px;
            }
            a.toggle {
                color: #ff9800;
            }
            a.edit {
                color: #26a0ff;
            }
            a.action:hover {
                text-decoration: underline;
            }

            .pagination {
                display: flex;
                justify-content: center;
                margin: 25px 0;
                list-style: none;
            }
            .pagination li {
                margin: 0 5px;
            }
            .pagination a {
                color: #fff;
                background-color: #222;
                padding: 6px 12px;
                border-radius: 6px;
                text-decoration: none;
                transition: 0.2s;
            }
            .pagination a.active {
                background-color: #26ff86;
                color: #000;
                font-weight: bold;
            }
            .pagination a:hover:not(.active) {
                background-color: #333;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>

        <div class="content">
            <div class="header-bar">
                <h2>Banners</h2>
                <a href="BannerServlet?action=new" class="btn-add">+ Add Banner</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Start - End</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                      List<Banner> list = (List<Banner>) request.getAttribute("banners");
                      if (list != null && !list.isEmpty()) {
                        for (Banner b : list) {
                    %>
                    <tr>
                        <td><%= b.getId() %></td>

                        <!-- ✅ Load ảnh từ hosting -->
                        <td>
                            <img src="https://hdtvux.id.vn/<%= b.getImageUrl() %>" 
                                 class="thumb"
                                 >

                        </td>

                        <td><%= b.getTitle() %></td>
                        <td>
                            <span class="status <%= b.isActive() ? "active" : "inactive" %>">
                                <%= b.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </td>
                        <td>
                            <%= b.getStartsAt() != null ? b.getStartsAt() : "-" %> →
                            <%= b.getEndsAt() != null ? b.getEndsAt() : "-" %>
                        </td>
                        <td>
                            <a href="BannerServlet?action=edit&id=<%=b.getId()%>" class="action edit">Edit</a>
                            <a href="BannerServlet?action=toggle&id=<%=b.getId()%>" class="action toggle">
                                <%= b.isActive() ? "Deactivate" : "Activate" %>
                            </a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" class="text-center text-muted py-4">No banners found</td></tr>
                    <% } %>
                </tbody>
            </table>

            <!-- Pagination -->
            <ul class="pagination">
                <%
                  Integer currentPage = (Integer) request.getAttribute("currentPage");
                  Integer totalPages = (Integer) request.getAttribute("totalPages");
                  if (currentPage == null) currentPage = 1;
                  if (totalPages == null) totalPages = 1;

                  if (currentPage > 1) {
                %>
                <li><a href="BannerServlet?page=<%= currentPage - 1 %>">Prev</a></li>
                    <% } %>

                <%
                  for (int i = 1; i <= totalPages; i++) {
                %>
                <li><a href="BannerServlet?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a></li>
                    <% } %>

                <%
                  if (currentPage < totalPages) {
                %>
                <li><a href="BannerServlet?page=<%= currentPage + 1 %>">Next</a></li>
                    <% } %>
            </ul>
        </div>

        <script src="assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
