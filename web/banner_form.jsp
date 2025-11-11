<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Banner" %>

<%
    // Domain hosting của bạn
    String BASE_URL = "https://hdtvux.id.vn/";
%>

<html>
    <head>
        <title>Banner Form - Nike Admin</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/admin-dashboard.css">

        <style>
            body {
                background: #f6f7fb;
                font-family: "Poppins", "Segoe UI", sans-serif;
                color: #222;
            }
            .content {
                margin-left: 240px;
                padding: 32px 40px;
            }
            h4 {
                font-weight: 600;
                margin-bottom: 25px;
                letter-spacing: 0.5px;
            }
            form {
                background: #fff;
                padding: 25px 30px;
                border-radius: 14px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.08);
            }
            .form-label {
                font-weight: 500;
                color: #333;
            }
            .form-control {
                border-radius: 8px;
                border: 1px solid #ccc;
                transition: 0.2s;
            }
            .form-control:focus {
                border-color: #111;
                box-shadow: 0 0 0 0.15rem rgba(0,0,0,0.2);
            }
            .btn-dark {
                background-color: #111;
                border: none;
                border-radius: 8px;
                padding: 10px 20px;
            }
            .btn-dark:hover {
                background-color: #222;
            }
            .btn-secondary {
                border-radius: 8px;
            }

            /* Thumbnail preview */
            .thumb-wrapper {
                margin-top: 15px;
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .thumb {
                width: 320px;
                height: 160px;
                object-fit: cover;
                border-radius: 10px;
                border: 2px solid #ccc;
                background-color: #eee;
                transition: 0.25s;
            }
            .thumb:hover {
                border-color: #111;
                transform: scale(1.02);
            }
            .upload-zone {
                border: 2px dashed #aaa;
                border-radius: 10px;
                background: #fafafa;
                padding: 20px;
                text-align: center;
                color: #777;
                font-size: 14px;
                transition: 0.3s;
            }
            .upload-zone:hover {
                border-color: #111;
                color: #111;
                background: #f1f1f1;
            }
            .form-check-label {
                font-weight: 500;
            }
        </style>
    </head>
    <body>

        <%@ include file="includes/sidebar.jsp" %>

        <%
            Banner b = (Banner) request.getAttribute("banner");
            boolean editing = b != null;

            // Tạo preview ảnh đúng URL Hosting
            String previewSrc = "";
            if (editing && b.getImageUrl() != null) {
                previewSrc = BASE_URL + b.getImageUrl();
            }
        %>

        <div class="content">
            <h4><%= editing ? "✏️ Edit Banner #" + b.getId() : "➕ Add New Banner" %></h4>

            <form action="BannerServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= editing ? b.getId() : "" %>">

                <div class="row g-4">

                    <div class="col-md-6">
                        <label class="form-label">Title</label>
                        <input name="title" class="form-control"
                               value="<%= editing && b.getTitle()!=null? b.getTitle() : "" %>" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Subtitle</label>
                        <input name="subtitle" class="form-control"
                               value="<%= editing && b.getSubtitle()!=null? b.getSubtitle() : "" %>">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Image URL (relative path)</label>
                        <input name="image_url" class="form-control"
                               value="<%= editing && b.getImageUrl()!=null ? b.getImageUrl() : "" %>">
                        <small class="text-muted">Ví dụ: uploads/banners/sample.jpg</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Upload New Image</label>
                        <div class="upload-zone">
                            <input type="file" name="image_file" accept="image/*" onchange="previewFile(this)">
                            <p class="mt-2 mb-0">Click để chọn ảnh</p>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Deeplink</label>
                        <input name="deeplink" class="form-control"
                               value="<%= editing && b.getDeeplink()!=null? b.getDeeplink() : "" %>">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Sort Order</label>
                        <input type="number" name="sort_order" class="form-control"
                               value="<%= editing && b.getSortOrder()!=null? b.getSortOrder() : "" %>">
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="is_active"
                                   <%= editing ? (b.isActive()?"checked":"") : "checked" %>>
                            <label class="form-check-label">Active</label>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Start Time</label>
                        <input type="datetime-local" name="starts_at" class="form-control"
                               value="<%= (editing && b.getStartsAt()!=null)? b.getStartsAt().toLocalDateTime().toString().replace(' ','T') : "" %>">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">End Time</label>
                        <input type="datetime-local" name="ends_at" class="form-control"
                               value="<%= (editing && b.getEndsAt()!=null)? b.getEndsAt().toLocalDateTime().toString().replace(' ','T') : "" %>">
                    </div>

                </div>

                <!-- PREVIEW ẢNH -->
                <div class="thumb-wrapper">
                    <div>
                        <label class="form-label mb-2">Preview</label><br>
                        <img id="preview" class="thumb"
                             src="<%= previewSrc %>"
                             style="<%= previewSrc.isEmpty() ? "display:none;" : "" %>">
                    </div>
                </div>

                <!-- BUTTON -->
                <div class="mt-4">
                    <button class="btn btn-dark">Lưu</button>
                    <a href="BannerServlet" class="btn btn-secondary ms-2">Cancel</a>
                </div>

            </form>
        </div>

        <script>
            function previewFile(input) {
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = e => {
                        const img = document.getElementById('preview');
                        img.src = e.target.result;
                        img.style.display = 'block';
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>

        <script src="assets/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
