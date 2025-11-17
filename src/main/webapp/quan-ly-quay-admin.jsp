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
%>

<div id="quanlyquay">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Danh Sách Quầy</h3>
        <button type="button" class="btn btn-primary" onclick="showAddQuayForm()">
            <i class="fas fa-plus"></i> Thêm Quầy Mới
        </button>
    </div>

    <!-- FORM THÊM/SỬA -->
    <div id="quay-form-container" class="card p-4 mb-3" style="display:none;">
        <h4 id="form-quay-title" class="mb-3">
            <i class=""></i> Thêm Quầy Mới
        </h4>

        <form id="quayForm" action="<%= contextPath %>/QuayServlet" method="POST">
            <input type="hidden" name="action" id="quay-action" value="ADD">
            <input type="hidden" name="maQuay" id="maQuay">

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="tenQuay"><i class="fas fa-store"></i> Tên Quầy <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="tenQuay" name="tenQuay" placeholder="Nhập tên quầy" required>
                </div>

                <div class="form-group col-md-6">
                    <label for="maTK"><i class="fas fa-user"></i> Tài Khoản Quản Lý <span class="text-danger">*</span></label>
                    <select class="form-control" id="maTK" name="maTK" required>
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
                <label for="moTa"><i class="fas fa-align-left"></i> Mô Tả</label>
                <textarea class="form-control" id="moTa" name="moTa" rows="2" placeholder="Mô tả quầy..."></textarea>
            </div>

            <hr>

            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-secondary mr-2" onclick="hideQuayForm()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Lưu Quầy
                </button>
            </div>
        </form>
    </div>

    <!-- THANH TÌM KIẾM -->
    <div class="card p-3 mb-3">
        <form action="<%= contextPath %>/Admin" method="GET" class="form-inline w-100">
            <input type="hidden" name="activeTab" value="quanlyquay">
            <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
            <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
            <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

            <div class="form-group mr-2 flex-grow-1">
                <input type="text" class="form-control w-100" name="keyword"
                       placeholder="Tìm theo tên quầy..."
                       value="<%= pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword() %>">
            </div>

            <button type="submit" class="btn btn-info mr-2">
                <i class="fas fa-search"></i> Tìm
            </button>

            <a href="<%= contextPath %>/Admin?activeTab=quanlyquay" class="btn btn-outline-secondary">
                <i class="fas fa-sync-alt"></i> Làm mới
            </a>
        </form>
    </div>

    <!-- BẢNG DANH SÁCH QUẦY -->
    <div class="card">
        <div class="card-body p-0">

            <table class="table table-striped table-hover mb-0">
                <thead class="thead-dark">
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
                    </td>
                </tr>
                <%
                } else {
                    int startIndex = (quayPage.getCurrentPage() - 1) * pageRequest.getPageSize();

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

                        String tenQuayJs = q.getTenQuay().replace("'", "\\'");
                        String moTaJs = (q.getMoTa() == null ? "" : q.getMoTa().replace("'", "\\'"));
                %>
                <tr>
                    <td class="align-middle"><strong><%= startIndex + i + 1 %></strong></td>
                    <td class="align-middle"><strong><%= q.getTenQuay() %></strong></td>
                    <td class="align-middle"><span class="badge badge-info px-2 py-1"><i class="fas fa-user"></i> <%= tenTK %></span></td>
                    <td class="align-middle"><%= q.getMoTa() == null || q.getMoTa().isEmpty() ? "<em class='text-muted'>Không có mô tả</em>" : q.getMoTa() %></td>

                    <td class="align-middle text-center">
                        <div class="btn-group">
                            <button class="btn btn-sm btn-info"
                                    onclick="editQuay('<%= q.getMaQuay() %>', '<%= tenQuayJs %>', '<%= moTaJs %>', '<%= q.getMaTaiKhoan() %>')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-danger"
                                    onclick="return confirmDelete('<%= q.getTenQuay() %>', '<%= contextPath %>/QuayServlet?action=DELETE&maQuay=<%= q.getMaQuay() %>')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <% } } %>
                </tbody>
            </table>

        </div>

        <!-- PHÂN TRANG -->
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
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm mb-0 justify-content-center">

                    <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage - 1 %>">&laquo;</a>
                    </li>
                    <% } else { %>
                    <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                    <% } %>

                    <%
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);

                        for (int p = startPage; p <= endPage; p++) {
                    %>
                    <li class="page-item <%= (p == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="<%= baseUrl %>&page=<%= p %>"><%= p %></a>
                    </li>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage + 1 %>">&raquo;</a>
                    </li>
                    <% } else { %>
                    <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                    <% } %>

                </ul>
            </nav>
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
    }

    function confirmDelete(name, url) {
        if (confirm("Bạn có chắc muốn xóa quầy: " + name + " ?")) {
            window.location.href = url;
        }
        return false;
    }
</script>
