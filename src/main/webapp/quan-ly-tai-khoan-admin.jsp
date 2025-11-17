<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="Model.TaiKhoan"%>
<%@ page import="Model.Page"%>
<%@ page import="Model.PageRequest"%>

<%
    String contextPath = request.getContextPath();
    Page<TaiKhoan> taiKhoanPage = (Page<TaiKhoan>) request.getAttribute("taiKhoanPage");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");
    if (taiKhoanPage == null) taiKhoanPage = new Page<TaiKhoan>(java.util.Collections.emptyList(), 1, 10, 0);
    if (pageRequest == null) pageRequest = new PageRequest("", "asc", "maTK", 10, 1);
    List<TaiKhoan> danhSachTaiKhoan = taiKhoanPage.getData();

    // Tính toán startIndex
    int startIndex = (taiKhoanPage.getCurrentPage() - 1) * pageRequest.getPageSize();
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

    /* Phong cách riêng cho form */
    #tk-form-container {
        background-color: #f7f7f7;
        border: 1px solid #e0e0e0;
        border-left: 5px solid #007bff; /* Viền màu nổi bật */
    }

    #form-tk-title {
        color: #007bff;
        font-weight: 700;
    }

    /* Badges cho vai trò */
    .badge-danger { background-color: #dc3545; color: #fff; } /* Admin */
    .badge-warning { background-color: #ffc107; color: #000; } /* Seller */
    .badge-info { background-color: #17a2b8; color: #fff; } /* User */
    .badge-secondary { background-color: #6c757d; color: #fff; } /* Default */
</style>

<div id="quanlytaikhoan" class="fade-in">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="mb-0">
                <i class="fas fa-users-cog"></i> Quản Lý Tài Khoản
            </h2>
            <button type="button" class="btn btn-light" onclick="showAddTKForm()">
                <i class="fas fa-plus"></i> Thêm Tài Khoản
            </button>
        </div>
        <p class="mb-0 mt-2" style="opacity: 0.9;">Quản lý thông tin và vai trò người dùng</p>
    </div>
    <div id="tk-form-container" class="card p-4 mb-4" style="display:none;">
        <h4 id="form-tk-title" class="mb-4 pb-2 border-bottom"><i class="fas fa-user"></i> Thêm Tài Khoản</h4>
        <form id="tkForm" action="<%= contextPath %>/TaiKhoanServlet" method="POST">
            <input type="hidden" name="action" id="tk-action" value="ADD">
            <input type="hidden" name="maTK" id="maTK">
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label class="filter-label"><i class="fas fa-sign-in-alt"></i> Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" name="tenDangNhap" id="tenDangNhap" class="form-control" placeholder="Tên đăng nhập" required>
                </div>
                <div class="form-group col-md-4">
                    <label class="filter-label"><i class="fas fa-key"></i> Mật khẩu <span class="text-danger">*</span></label>
                    <input type="text" name="matKhau" id="matKhau" class="form-control" placeholder="Mật khẩu" required>
                </div>
                <div class="form-group col-md-4">
                    <label class="filter-label"><i class="fas fa-user-tag"></i> Vai trò <span class="text-danger">*</span></label>
                    <select name="vaiTro" id="vaiTro" class="form-control custom-select" required>
                        <option value="admin">Admin</option>
                        <option value="seller">Seller</option>
                        <option value="user">User</option>
                    </select>
                </div>
            </div>
            <hr>
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-outline-secondary mr-2" onclick="hideTKForm()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Lưu Tài Khoản
                </button>
            </div>
        </form>
    </div>
    <div class="search-bar mb-4">
        <form action="<%= contextPath %>/Admin" method="GET" class="d-flex w-100">
            <input type="hidden" name="activeTab" value="quanlytaikhoan">
            <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
            <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
            <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

            <div class="form-group mr-3 flex-grow-1 mb-0">
                <label class="filter-label mr-2 d-none d-sm-inline">
                    <i class="fas fa-search"></i> Tìm kiếm:
                </label>
                <input type="text" class="form-control w-100" name="keyword"
                       placeholder="Tìm theo tên đăng nhập..."
                       value="<%= pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword() %>">
            </div>

            <div class="d-flex align-items-end">
                <button type="submit" class="btn btn-primary mr-2" style="height: fit-content;">
                    <i class="fas fa-search"></i> Tìm
                </button>

                <a href="<%= contextPath %>/Admin?activeTab=quanlytaikhoan" class="btn btn-outline-secondary" style="height: fit-content;">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </a>
            </div>
        </form>
    </div>
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-list"></i> Danh Sách Tài Khoản
                <span class="badge badge-primary ml-2"><%= taiKhoanPage.getTotalItems() %> tài khoản</span>
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="thead-light">
                    <tr>
                        <th style="width:8%;">#</th>
                        <th style="width:25%;">Tên đăng nhập</th>
                        <th style="width:25%;">Mật khẩu</th>
                        <th style="width:20%;">Vai trò</th>
                        <th style="width:22%;" class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (danhSachTaiKhoan.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="5" class="text-center text-muted py-5">
                            <i class="fas fa-inbox fa-4x mb-3 d-block" style="opacity:0.3;"></i>
                            <h5>Không có tài khoản nào</h5>
                            <p>Hãy thêm tài khoản mới bằng cách nhấn nút **"Thêm Tài Khoản"** ở trên</p>
                        </td>
                    </tr>
                    <%  } else {
                        for (int i = 0; i < danhSachTaiKhoan.size(); i++) {
                            TaiKhoan tk = danhSachTaiKhoan.get(i);

                            // Gán class cho vai trò
                            String roleClass = "badge-secondary";
                            if ("admin".equals(tk.getVaiTro())) roleClass = "badge-danger";
                            else if ("seller".equals(tk.getVaiTro())) roleClass = "badge-warning";
                            else if ("user".equals(tk.getVaiTro())) roleClass = "badge-info";

                            // Escape mật khẩu và tên đăng nhập cho JS
                            String tenDangNhapJs = tk.getTenDangNhap().replace("'", "\\'");
                            String matKhauJs = tk.getMatKhau().replace("'", "\\'");
                    %>
                    <tr>
                        <td class="align-middle"><strong><%= startIndex + i + 1 %></strong></td>
                        <td class="align-middle">
                            <i class="fas fa-user-circle text-primary"></i>
                            <strong><%= tk.getTenDangNhap() %></strong>
                        </td>
                        <td class="align-middle"><small class="text-muted"><%= tk.getMatKhau() %></small></td>
                        <td class="align-middle">
                            <span class="badge <%= roleClass %> px-2 py-1">
                                <i class="fas fa-tag"></i> <%= tk.getVaiTro().toUpperCase() %>
                            </span>
                        </td>
                        <td class="align-middle text-center">
                            <div class="btn-group">
                                <button class="btn btn-sm btn-info"
                                        onclick="editTK('<%= tk.getMaTaiKhoan() %>', '<%= tenDangNhapJs %>', '<%= matKhauJs %>', '<%= tk.getVaiTro() %>')" title="Sửa tài khoản">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
                                <button class="btn btn-sm btn-danger"
                                        onclick="return confirmDelete('<%= tenDangNhapJs %>', '<%= contextPath %>/TaiKhoanServlet?action=DELETE&maTK=<%= tk.getMaTaiKhoan() %>')" title="Xóa tài khoản">
                                    <i class="fas fa-trash-alt"></i> Xóa
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%      }
                    } %>
                    </tbody>
                </table>
            </div>
        </div>

        <%
            int totalPages = taiKhoanPage.getTotalPage();
            int currentPage = taiKhoanPage.getCurrentPage();
            // Đảm bảo baseUrl trỏ về /Admin để giữ activeTab
            String baseUrl = contextPath + "/Admin?activeTab=quanlytaikhoan&size=" + pageRequest.getPageSize() + "&sort=" + pageRequest.getSortField() + "&order=" + pageRequest.getSortOrder();

            if(pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty())
                baseUrl += "&keyword=" + java.net.URLEncoder.encode(pageRequest.getKeyword(), "UTF-8");
        %>
        <div class="card-footer bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <small class="text-muted">Hiển thị <%= (startIndex + 1) %>-<%= startIndex + danhSachTaiKhoan.size() %> trong tổng số <%= taiKhoanPage.getTotalItems() %> tài khoản</small>
                </div>

                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <% if(currentPage>1){ %>
                        <li class="page-item">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage-1 %>" aria-label="Previous">&laquo;</a>
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

                        <% for(int p=startPage;p<=endPage;p++){ %>
                        <li class="page-item <%= (p==currentPage)?"active":"" %>">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= p %>"><%= p %></a>
                        </li>
                        <% } %>

                        <% if (endPage < totalPages) { %>
                        <% if (endPage < totalPages-1) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= totalPages %>"><%= totalPages %></a></li>
                        <% } %>

                        <% if(currentPage<totalPages){ %>
                        <li class="page-item">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage+1 %>" aria-label="Next">&raquo;</a>
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
    function showAddTKForm() {
        document.getElementById("tk-form-container").style.display="block";
        document.getElementById("form-tk-title").innerHTML="<i class='fas fa-user'></i> Thêm Tài Khoản";
        document.getElementById("tk-action").value="ADD";
        document.getElementById("maTK").value="";
        document.getElementById("tenDangNhap").value="";
        document.getElementById("matKhau").value="";
        document.getElementById("vaiTro").value="admin";
    }

    function hideTKForm() {
        document.getElementById("tk-form-container").style.display="none";
    }

    function editTK(maTK, tenDangNhap, matKhau, vaiTro){
        document.getElementById("tk-form-container").style.display="block";
        document.getElementById("form-tk-title").innerHTML="<i class='fas fa-edit'></i> Sửa Tài Khoản";
        document.getElementById("tk-action").value="EDIT";
        document.getElementById("maTK").value=maTK;
        document.getElementById("tenDangNhap").value=tenDangNhap;
        document.getElementById("matKhau").value=matKhau;
        document.getElementById("vaiTro").value=vaiTro;
    }

    function confirmDelete(name,url){
        if(confirm("Bạn có chắc muốn xóa tài khoản: "+name+" ?")){
            window.location.href=url;
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