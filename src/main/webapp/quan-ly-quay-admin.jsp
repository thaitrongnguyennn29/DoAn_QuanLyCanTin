<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="Model.Quay"%>
<%@ page import="Model.TaiKhoan"%>
<%@ page import="Model.Page"%>
<%@ page import="Model.PageRequest"%>

<%
    String contextPath = request.getContextPath();

    // Lấy dữ liệu
    Page<Quay> quayPage = (Page<Quay>) request.getAttribute("quayPage");
    List<TaiKhoan> danhSachTaiKhoan = (List<TaiKhoan>) request.getAttribute("DanhSachTK");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");

    if (quayPage == null) quayPage = new Page<Quay>(java.util.Collections.emptyList(), 1, 10, 0);
    if (danhSachTaiKhoan == null) danhSachTaiKhoan = java.util.Collections.emptyList();
    if (pageRequest == null) pageRequest = new PageRequest("", "asc", "MaQuay", 10, 1);

    List<Quay> danhSachQuay = quayPage.getData();

    // Tính toán startIndex
    int startIndex = (quayPage.getCurrentPage() - 1) * pageRequest.getPageSize();
%>

<style>
    .page-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 20px;
    }

    .table tbody tr {
        transition: all 0.3s ease;
    }

    .table tbody tr:hover {
        background-color: #f8f9fa;
        transform: translateY(-2px); /* Hiệu ứng chuyển động khi hover */
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .search-bar {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .filter-label {
        font-weight: 600;
        font-size: 0.9rem;
        margin-bottom: 5px;
        color: #495057;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .fade-in {
        animation: fadeIn 0.5s ease;
    }

    /* Phong cách riêng cho form quầy */
    #quay-form-container {
        background-color: #f7f7f7;
        border: 1px solid #e0e0e0;
        border-left: 5px solid #007bff; /* Viền màu nổi bật */
    }

    #form-quay-title {
        color: #007bff;
        font-weight: 700;
    }
</style>

<div id="quanlyquay" class="fade-in">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="mb-0">
                <i class="fas fa-store"></i> Quản Lý Quầy
            </h2>
            <button type="button" class="btn btn-light" onclick="showAddQuayForm()">
                <i class="fas fa-plus"></i> Thêm Quầy Mới
            </button>
        </div>
        <p class="mb-0 mt-2" style="opacity: 0.9;">Tạo, chỉnh sửa và quản lý các quầy bán hàng</p>
    </div>
    <div id="quay-form-container" class="card p-4 mb-4" style="display:none;">
        <h4 id="form-quay-title" class="mb-4 pb-2 border-bottom">
            <i class="fas fa-store"></i> Thêm Quầy Mới
        </h4>

        <form id="quayForm" action="<%= contextPath %>/QuayServlet" method="POST">
            <input type="hidden" name="action" id="quay-action" value="ADD">
            <input type="hidden" name="maQuay" id="maQuay">

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="tenQuay" class="filter-label"><i class="fas fa-store"></i> Tên Quầy <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="tenQuay" name="tenQuay" placeholder="Nhập tên quầy" required>
                </div>

                <div class="form-group col-md-6">
                    <label for="maTK" class="filter-label"><i class="fas fa-user"></i> Tài Khoản Quản Lý <span class="text-danger">*</span></label>
                    <select class="form-control custom-select" id="maTK" name="maTK" required>
                        <option value="">-- Chọn Tài Khoản --</option>
                        <% for (TaiKhoan tk : danhSachTaiKhoan) { %>
                        <option value="<%= tk.getMaTaiKhoan() %>">
                            <%= tk.getTenDangNhap() %> (Vai trò: <%= tk.getVaiTro() %>)
                        </option>
                        <% } %>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="moTa" class="filter-label"><i class="fas fa-align-left"></i> Mô Tả</label>
                <textarea class="form-control" id="moTa" name="moTa" rows="2" placeholder="Mô tả quầy..."></textarea>
            </div>

            <hr>

            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-outline-secondary mr-2" onclick="hideQuayForm()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Lưu Quầy
                </button>
            </div>
        </form>
    </div>
    <div class="search-bar mb-4">
        <form action="<%= contextPath %>/Admin" method="GET" class="d-flex w-100">
            <input type="hidden" name="activeTab" value="quanlyquay">
            <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
            <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
            <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

            <div class="form-group mr-3 flex-grow-1 mb-0">
                <label class="filter-label mr-2 d-none d-sm-inline">
                    <i class="fas fa-search"></i> Tìm kiếm:
                </label>
                <input type="text" class="form-control w-100" name="keyword"
                       placeholder="Tìm theo tên quầy hoặc mô tả..."
                       value="<%= pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword() %>">
            </div>

            <div class="d-flex align-items-end">
                <button type="submit" class="btn btn-primary mr-2" style="height: fit-content;">
                    <i class="fas fa-search"></i> Tìm
                </button>

                <a href="<%= contextPath %>/Admin?activeTab=quanlyquay" class="btn btn-outline-secondary" style="height: fit-content;">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </a>
            </div>
        </form>
    </div>
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-list"></i> Danh Sách Quầy
                <span class="badge badge-primary ml-2"><%= quayPage.getTotalItems() %> quầy</span>
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="thead-light">
                    <tr>
                        <th style="width: 8%;">#</th>
                        <th style="width: 20%;">Tên Quầy</th>
                        <th style="width: 20%;">Tài Khoản</th>
                        <th style="width: 35%;">Mô Tả</th>
                        <th style="width: 17%;" class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (danhSachQuay.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="5" class="text-center text-muted py-5">
                            <i class="fas fa-inbox fa-4x mb-3 d-block" style="opacity: 0.3;"></i>
                            <h5>Không có quầy nào</h5>
                            <p>Hãy thêm quầy mới bằng cách nhấn nút **"Thêm Quầy Mới"** ở trên</p>
                        </td>
                    </tr>
                    <%
                    } else {
                        for (int i = 0; i < danhSachQuay.size(); i++) {
                            Quay q = danhSachQuay.get(i);

                            // Lấy tên tài khoản
                            String tenTK = "N/A";
                            for (TaiKhoan tk : danhSachTaiKhoan) {
                                if (tk.getMaTaiKhoan() == q.getMaTaiKhoan()) {
                                    tenTK = tk.getTenDangNhap();
                                    break;
                                }
                            }

                            // BẢO TOÀN LOGIC BACKEND JS
                            String tenQuayJs = q.getTenQuay().replace("'", "\\'");
                            String moTaJs = (q.getMoTa() == null ? "" : q.getMoTa().replace("'", "\\'"));
                    %>
                    <tr>
                        <td class="align-middle"><strong><%= startIndex + i + 1 %></strong></td>
                        <td class="align-middle">
                            <i class="fas fa-store text-info"></i>
                            <strong><%= q.getTenQuay() %></strong>
                        </td>
                        <td class="align-middle">
                            <span class="badge badge-info px-2 py-1">
                                <i class="fas fa-user-circle"></i> <%= tenTK %>
                            </span>
                        </td>
                        <td class="align-middle">
                            <small class="text-muted">
                                <%= q.getMoTa() == null || q.getMoTa().isEmpty() ? "<em>Không có mô tả</em>" : q.getMoTa() %>
                            </small>
                        </td>

                        <td class="align-middle text-center">
                            <div class="btn-group">
                                <button class="btn btn-sm btn-info"
                                        onclick="editQuay('<%= q.getMaQuay() %>', '<%= tenQuayJs %>', '<%= moTaJs %>', '<%= q.getMaTaiKhoan() %>')" title="Sửa quầy">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
                                <button class="btn btn-sm btn-danger"
                                        onclick="return confirmDelete('<%= q.getTenQuay() %>', '<%= contextPath %>/QuayServlet?action=DELETE&maQuay=<%= q.getMaQuay() %>')" title="Xóa quầy">
                                    <i class="fas fa-trash-alt"></i> Xóa
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <%
            int totalPages = quayPage.getTotalPage();
            int currentPage = quayPage.getCurrentPage();

            String baseUrl = contextPath + "/Admin?activeTab=quanlyquay"
                    + "&size=" + pageRequest.getPageSize()
                    + "&sort=" + pageRequest.getSortField()
                    + "&order=" + pageRequest.getSortOrder();

            if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
                baseUrl += "&keyword=" + java.net.URLEncoder.encode(pageRequest.getKeyword(), "UTF-8");
            }
        %>

        <div class="card-footer bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <small class="text-muted">Hiển thị <%= (startIndex + 1) %>-<%= startIndex + danhSachQuay.size() %> trong tổng số <%= quayPage.getTotalItems() %> quầy</small>
                </div>

                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">

                        <% if (currentPage > 1) { %>
                        <li class="page-item">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage - 1 %>" aria-label="Previous">&laquo;</a>
                        </li>
                        <% } else { %>
                        <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                        <% } %>

                        <%
                            int startPage = Math.max(1, currentPage - 2);
                            int endPage = Math.min(totalPages, currentPage + 2);

                            if (startPage > 1) { %>
                        <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=1">1</a></li>
                        <% if (startPage > 2) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } } %>

                        <% for (int p = startPage; p <= endPage; p++) { %>
                        <li class="page-item <%= (p == currentPage) ? "active" : "" %>">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= p %>"><%= p %></a>
                        </li>
                        <% } %>

                        <% if (endPage < totalPages) { %>
                        <% if (endPage < totalPages-1) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= totalPages %>"><%= totalPages %></a></li>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                        <li class="page-item">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage + 1 %>" aria-label="Next">&raquo;</a>
                        </li>
                        <% } else { %>
                        <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                        <% } %>

                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<script>
    function showAddQuayForm() {
        document.getElementById("quay-form-container").style.display = "block";
        document.getElementById("form-quay-title").innerHTML = "<i class='fas fa-store'></i> Thêm Quầy Mới";
        document.getElementById("quay-action").value = "ADD";
        document.getElementById("maQuay").value = "";
        document.getElementById("tenQuay").value = "";
        document.getElementById("moTa").value = "";
        document.getElementById("maTK").value = "";
    }

    function hideQuayForm() {
        document.getElementById("quay-form-container").style.display = "none";
    }

    function editQuay(maQuay, tenQuay, moTa, maTK) {
        document.getElementById("quay-form-container").style.display = "block";
        document.getElementById("form-quay-title").innerHTML = "<i class='fas fa-edit'></i> Sửa Quầy";
        document.getElementById("quay-action").value = "EDIT";

        document.getElementById("maQuay").value = maQuay;
        document.getElementById("tenQuay").value = tenQuay;
        document.getElementById("moTa").value = moTa;
        document.getElementById("maTK").value = maTK;

        // Cần đảm bảo select custom-select được chọn giá trị
        document.getElementById("maTK").value = maTK;
    }

    function confirmDelete(name, url) {
        if (confirm("Bạn có chắc muốn xóa quầy: " + name + " ?")) {
            window.location.href = url;
        }
        return false;
    }

    // Hiển thị thông báo (Nếu có logic từ trang Đơn hàng/Món ăn)
    <%
        // Giả định logic thông báo (từ các trang trước)
        String successMsg = (String) session.getAttribute("success");
        String errorMsg = (String) session.getAttribute("error");

        if (successMsg != null) {
            session.removeAttribute("success");
    %>
    console.log('SUCCESS: <%= successMsg %>');
    <%
        }

        if (errorMsg != null) {
            session.removeAttribute("error");
    %>
    console.error('ERROR: <%= errorMsg %>');
    <%
        }
    %>
</script>