<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Category" %>
<%
    Category cat = (Category) request.getAttribute("category");
    boolean isEdit = cat != null;
%>
<html>
<head>
    <title><%= isEdit ? "Edit Category" : "Add Category" %> - Nike Admin</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
    <style>
        body {
            background-color: #f5f6fa;
        }
        .content {
            margin-left: 240px;
            padding: 50px 60px;
            min-height: 100vh;
        }
        .card {
            border-radius: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            background: #fff;
            padding: 50px 60px;
            max-width: 900px;
            margin: 0 auto;
        }
        h2 {
            font-weight: 700;
            color: #111;
            margin-bottom: 40px;
            font-size: 28px;
        }
        .form-label {
            font-weight: 500;
            color: #333;
            font-size: 16px;
            margin-bottom: 10px;
        }
        .form-control {
            border-radius: 10px;
            padding: 14px 16px;
            font-size: 15px;
            border: 1px solid #ccc;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #111;
            box-shadow: 0 0 5px rgba(0,0,0,0.2);
        }
        .btn {
            border-radius: 10px;
            padding: 12px 28px;
            font-weight: 500;
            letter-spacing: 0.3px;
            min-width: 120px;
        }
        .btn-dark {
            background-color: #111;
            color: #eee;
            border: none;
        }
        .btn-dark:hover {
            background-color: #000;
        }
        .btn-secondary {
            background-color: #ddd;
            color: #222;
            border: none;
            text-align: center;
        }
        .btn-secondary:hover {
            background-color: #ccc;
        }
        .btn-row {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        @media (max-width: 991px) {
            .content {
                margin-left: 0;
                padding: 30px 20px;
            }
            .card {
                padding: 30px 24px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="content">
        <div class="card">
            <h2><%= isEdit ? "Edit Category" : "Add Category" %></h2>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger mb-4">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form method="post" action="CategoryServlet">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= cat.getId() %>">
                <% } %>

                <div class="mb-5">
                    <label class="form-label">Category Name</label>
                    <input name="name" class="form-control"
                           value="<%= isEdit ? cat.getName() : "" %>"
                           placeholder="Enter category name" required>
                </div>

                <!-- Hàng nút có khoảng cách đều -->
                <div class="btn-row">
                    <button class="btn btn-dark">Save</button>
                    <a href="CategoryServlet" class="btn btn-secondary">Back</a>
                </div>
            </form>
        </div>
    </div>

    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
