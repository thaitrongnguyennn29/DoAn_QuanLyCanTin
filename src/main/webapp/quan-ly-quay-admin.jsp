<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File này sử dụng các biến: quayPage, danhSachTaiKhoan, pageRequest, contextPath --%>

<%
    // Lấy dữ liệu đã được truyền từ admin.jsp
    List<Quay> danhSachQuay = quayPage.getData();

    // Biến phụ trợ cho phân trang
    int totalPages = quayPage.getTotalPage();
    int currentPage = quayPage.getCurrentPage();
    String paginationBaseUrl = contextPath + "/Admin?activeTab=quanlyquay&size=" + pageRequest.getPageSize() + "&sort=" + pageRequest.getSortField() + "&order=" + pageRequest.getSortOrder() + "&keyword=" + pageRequest.getKeyword();
    int startIndex = (quayPage.getCurrentPage() - 1) * pageRequest.getPageSize();
%>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h3><i class="fas fa-store"></i> Quản Lý Quầy</h3>
    <button type="button" class="btn btn-primary" onclick="showAddQuayForm()">
        <i class="fas fa-plus"></i> Thêm Quầy Mới
    </button>
</div>

<div id="quay-form-container" class="form-monan" style="display:none;">
    <h4 id="form-quay-title">Thêm Quầy Mới</h4>
    <form id="quayForm" action="<%= contextPath %>/QuayServlet" method="POST">
        <input type="hidden" name="action" id="quay-action" value="ADD">
        <input type="hidden" name="maQuay" id="maQuayQuay">

        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="tenQuay">Tên Quầy (*)</label>
                <input type="text" class="form-control" id="tenQuay" name="tenQuay" required>
            </div>
            <div class="form-group col-md-6">
                <label for="moTaQuay">Mô Tả</label>
                <input type="text" class="form-control" id="moTaQuay" name="moTaQuay">
            </div>
        </div>

        <div class="form-group">
            <label for="maTaiKhoan">Tài Khoản Quản Lý (*)</label>
            <select class="form-control" id="maTaiKhoan" name="maTaiKhoan" required>
                <option value="">-- Chọn Tài Khoản --</option>
                <%
                    for (TaiKhoan taiKhoan : danhSachTaiKhoan) {
                %>
                <option value="<%= taiKhoan.getMaTaiKhoan() %>"><%= taiKhoan.getTenTaiKhoan() %> (<%= taiKhoan.getUsername() %>)</option>
                <%
                    }
                %>
            </select>
        </div>

        <button type="submit" class="btn btn-success">
            <i class="fas fa-save"></i> Lưu
        </button>
        <button type="button" class="btn btn-secondary" onclick="hideQuayForm()">
            Hủy
        </button>
    </form>
</div>
<div class="card p-3 mb-3">
    <form action="<%= contextPath %>/Admin" method="GET" class="d-flex align-items-center w-100">

        <input type="hidden" name="activeTab" value="quanlyquay">
        <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
        <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
        <input type="hidden" name="page" value="1">

        <div class="form-group mr-2 flex-grow-1 mb-0">
            <label for="keyword" class="sr-only">Tìm Kiếm</label>
            <input type="text" class="form-control w-100" id="keywordQuay" name="keyword" placeholder="Nhập tên quầy..."
                   value="<%= pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
        </div>

        <button type="submit" class="btn btn-info mr-2">
            <i class="fas fa-search"></i> Tìm
        </button>

        <a href="<%= contextPath %>/Admin?activeTab=quanlyquay" class="btn btn-outline-secondary">
            <i class="fas fa-sync-alt"></i> Xóa tìm kiếm
        </a>
    </form>
</div>
<div class="card p-3">
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="thead-dark sticky-top">
            <tr>
                <th>#</th>
                <th>
                    Mã Quầy
                    <a href="<%= paginationBaseUrl %>&sort=maQuay&order=<%= pageRequest.getSortField().equals("maQuay") && pageRequest.getSortOrder().equals("asc") ? "desc" : "asc" %>" class="text-white">
                        <i class="fas fa-sort<%= pageRequest.getSortField().equals("maQuay") ? (pageRequest.getSortOrder().equals("asc") ? "-up" : "-down") : "" %> ml-1"></i>
                    </a>
                </th>
                <th>Tên Quầy</th>
                <th>Mô Tả</th>
                <th>Tài Khoản</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (danhSachQuay.isEmpty()) {
            %>
            <tr>
                <td colspan="6" class="text-center text-muted">Không có quầy nào trong danh sách.</td>
            </tr>
            <%
            } else {
                for (int i = 0; i < danhSachQuay.size(); i++) {
                    Quay quay = danhSachQuay.get(i);

                    // Chuẩn bị dữ liệu cho JavaScript
                    String tenQuayJs = quay.getTenQuay().replace("'", "\\'");
                    String moTaQuayJs = quay.getMoTa() != null ? quay.getMoTa().replace("'", "\\'") : "";

                    // Tìm tên tài khoản
                    String tenTaiKhoanHienThi = "N/A";
                    for (TaiKhoan tk : danhSachTaiKhoan) {
                        if (quay.getMaTaiKhoan() == tk.getMaTaiKhoan()) {
                            tenTaiKhoanHienThi = tk.getTenTaiKhoan() + " (" + tk.getUsername() + ")";
                            break;
                        }
                    }
            %>
            <tr>
                <td><%= startIndex + i + 1 %></td>
                <td><%= quay.getMaQuay() %></td>
                <td><strong><%= quay.getTenQuay() %></strong></td>
                <td><%= quay.getMoTa() != null ? quay.getMoTa() : "" %></td>
                <td><%= tenTaiKhoanHienThi %></td>
                <td class="action-buttons-td">
                    <div class="action-buttons">
                        <button type="button" class="btn btn-sm btn-info"
                                onclick="editQuay(
                                        '<%= quay.getMaQuay() %>',
                                        '<%= tenQuayJs %>',
                                        '<%= moTaQuayJs %>',
                                        '<%= quay.getMaTaiKhoan() %>'
                                        )">
                            <i class="fas fa-edit"></i> Sửa
                        </button>

                        <a href="<%= contextPath %>/QuayServlet?action=DELETE&maQuay=<%= quay.getMaQuay() %>"
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa quầy <%= tenQuayJs %> không?')">
                            <i class="fas fa-trash-alt"></i> Xóa
                        </a>
                    </div>
                </td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-3">
        <p class="text-muted mb-0">
            Hiển thị <%= danhSachQuay.size() %> trên tổng số **<%= quayPage.getTotalItems() %>** quầy.
            (Trang <%= quayPage.getCurrentPage() %> / <%= quayPage.getTotalPage() %>)
        </p>

        <nav aria-label="Page navigation">
            <ul class="pagination pagination-sm mb-0">
                <%
                    // ... Logic phân trang (có thể dùng lại logic từ MonAn)
                    // Nút Previous
                    if (currentPage > 1) {
                %>
                <li class="page-item">
                    <a class="page-link" href="<%= paginationBaseUrl %>&page=<%= currentPage - 1 %>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <%
                    }
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);

                    for (int i = startPage; i <= endPage; i++) {
                        String activeClass = (i == currentPage) ? "active" : "";
                %>
                <li class="page-item <%= activeClass %>">
                    <a class="page-link" href="<%= paginationBaseUrl %>&page=<%= i %>"><%= i %></a>
                </li>
                <%
                    }
                    // Nút Next
                    if (currentPage < totalPages) {
                %>
                <li class="page-item">
                    <a class="page-link" href="<%= paginationBaseUrl %>&page=<%= currentPage + 1 %>" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
                <%
                    }
                %>
            </ul>
        </nav>
    </div>
</div>