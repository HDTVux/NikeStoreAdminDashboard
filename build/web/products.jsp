<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<html>
    <head>
        <title>Products - Nike Admin</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/admin-dashboard.css">
        <style>
            .table th, .table td {
                text-align: center;
                vertical-align: middle;
            }
            .pagination {
                display: flex;
                justify-content: center;
                margin: 20px 0;
                list-style: none;
            }
            .pagination li {
                margin: 0 5px;
            }
            .pagination a {
                color: #fff;
                background-color: #333;
                padding: 6px 12px;
                border-radius: 6px;
                text-decoration: none;
                transition: 0.2s;
            }
            .pagination a.active {
                background-color: #fff;
                color: #000;
                font-weight: bold;
            }
            .pagination a:hover:not(.active) {
                background-color: #555;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>
        <div class="content">
            <div class="header-bar">
                <h2>Products</h2>
                <a href="ProductServlet?action=new" class="btn btn-dark">+ Add Product</a>
            </div>
            <table class="table table-dark mt-3">
                <thead>
                    <tr>
                        <th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Active</th><th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                      List<Product> list = (List<Product>) request.getAttribute("products");
                      if (list != null && !list.isEmpty()) {
                        for (Product p : list) {
                    %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td><%= p.getName() %></td>
                        <td>$<%= p.getPrice() %></td>
                        <td><%= p.getStock() %></td>
                        <td><%= p.isActive() ? "✅" : "❌" %></td>
                        <td>
                            <a href="ProductServlet?action=toggle&id=<%=p.getId()%>" class="btn btn-sm btn-outline-dark">Toggle</a>
                            <a href="ProductServlet?action=edit&id=<%=p.getId()%>" class="btn btn-sm btn-warning">Edit</a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" class="text-center text-muted">No products found</td></tr>
                    <% } %>
                </tbody>
            </table>

            <!-- Pagination -->
            <ul class="pagination">
                <%
                  int currentPage = (int) request.getAttribute("currentPage");
                  int totalPages = (int) request.getAttribute("totalPages");
                  if (currentPage > 1) {
                %>
                <li><a href="ProductServlet?page=<%= currentPage - 1 %>">Prev</a></li>
                    <% }
      for (int i = 1; i <= totalPages; i++) { %>
                <li><a href="ProductServlet?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a></li>
                    <% }
      if (currentPage < totalPages) { %>
                <li><a href="ProductServlet?page=<%= currentPage + 1 %>">Next</a></li>
                    <% } %>
            </ul>
        </div>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
