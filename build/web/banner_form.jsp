<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Banner" %>
<html>
    <head>
        <title>Banner form</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <style>.content{
            margin-left:220px;
            padding:20px;
        }</style>
    </head>
    <body>
        <%@ include file="includes/sidebar.jsp" %>
        <%@ include file="includes/header.jsp" %>
        <%
          Banner b = (Banner) request.getAttribute("banner");
          boolean editing = b != null;
        %>
        <div class="content">
            <h4><%= editing? "Sửa banner #"+b.getId() : "Thêm banner" %></h4>
            <form action="banners" method="post" class="mt-3">
                <input type="hidden" name="id" value="<%= editing? b.getId() : "" %>">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label>Tiêu đề</label>
                        <input name="title" class="form-control" value="<%= editing && b.getTitle()!=null? b.getTitle() : "" %>">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Phụ đề</label>
                        <input name="subtitle" class="form-control" value="<%= editing && b.getSubtitle()!=null? b.getSubtitle() : "" %>">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Image URL (ví dụ: uploads/banners/tenfile.jpg)</label>
                        <input name="image_url" class="form-control" required
                               value="<%= editing && b.getImageUrl()!=null ? b.getImageUrl().replace("http://localhost/", "") : "" %>">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label>Deeplink</label>
                        <input name="deeplink" class="form-control" value="<%= editing && b.getDeeplink()!=null? b.getDeeplink() : "" %>">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label>Thứ tự</label>
                        <input type="number" name="sort_order" class="form-control" value="<%= editing && b.getSortOrder()!=null? b.getSortOrder() : "" %>">
                    </div>
                    <div class="col-md-3 mb-3 d-flex align-items-end">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="is_active" <%= editing && b.isActive()? "checked": (!editing? "checked":"") %> >
                            <label class="form-check-label">Kích hoạt</label>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label>Bắt đầu</label>
                        <input type="datetime-local" name="starts_at" class="form-control"
                               value="<%= (editing && b.getStartsAt()!=null)? b.getStartsAt().toLocalDateTime().toString().replace(' ','T') : "" %>">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label>Kết thúc</label>
                        <input type="datetime-local" name="ends_at" class="form-control"
                               value="<%= (editing && b.getEndsAt()!=null)? b.getEndsAt().toLocalDateTime().toString().replace(' ','T') : "" %>">
                    </div>
                </div>
                <button class="btn btn-dark">Lưu</button>
                <a href="banners" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
