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
%>

<div id="quanlytaikhoan">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Danh Sách Tài Khoản</h3>
        <button type="button" class="btn btn-primary" onclick="showAddTKForm()">
            <i class="fas fa-plus"></i> Thêm Tài Khoản
        </button>
    </div>

    <!-- FORM THÊM/SỬA -->
    <div id="tk-form-container" class="card p-4 mb-3" style="display:none;">
        <h4 id="form-tk-title" class="mb-3"><i class="fas fa-user"></i> Thêm Tài Khoản</h4>
        <form id="tkForm" action="<%= contextPath %>/TaiKhoanServlet" method="POST">
            <input type="hidden" name="action" id="tk-action" value="ADD">
            <input type="hidden" name="maTK" id="maTK">
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" name="tenDangNhap" id="tenDangNhap" class="form-control" required>
                </div>
                <div class="form-group col-md-4">
                    <label>Mật khẩu <span class="text-danger">*</span></label>
                    <input type="text" name="matKhau" id="matKhau" class="form-control" required>
                </div>
                <div class="form-group col-md-4">
                    <label>Vai trò <span class="text-danger">*</span></label>
                    <select name="vaiTro" id="vaiTro" class="form-control" required>
                        <option value="admin">Admin</option>
                        <option value="seller">Seller</option>
                        <option value="user">User</option>
                    </select>
                </div>
            </div>
            <hr>
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-secondary mr-2" onclick="hideTKForm()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Lưu
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
                       placeholder="Tìm theo tên tài khoản..."
                       value="<%= pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword() %>">
            </div>

            <button type="submit" class="btn btn-info mr-2">
                <i class="fas fa-search"></i> Tìm
            </button>

            <a href="<%= contextPath %>/Admin?activeTab=quanlytaikhoan" class="btn btn-outline-secondary">
                <i class="fas fa-sync-alt"></i> Làm mới
            </a>
        </form>
    </div>

    <!-- BẢNG DANH SÁCH -->
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-striped table-hover mb-0">
                <thead class="thead-dark">
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
                        <h5>Không có tài khoản</h5>
                    </td>
                </tr>
                <%  } else {
                    int startIndex = (pageRequest.getPage() - 1) * pageRequest.getPageSize();
                    for (int i = 0; i < danhSachTaiKhoan.size(); i++) {
                        TaiKhoan tk = danhSachTaiKhoan.get(i);
                %>
                <tr>
                    <td class="align-middle"><strong><%= startIndex + i + 1 %></strong></td>
                    <td class="align-middle"><strong><%= tk.getTenDangNhap() %></strong></td>
                    <td class="align-middle"><%= tk.getMatKhau() %></td>
                    <td class="align-middle"><span class="badge badge-info px-2 py-1"><%= tk.getVaiTro() %></span></td>
                    <td class="align-middle text-center">
                        <div class="btn-group">
                            <button class="btn btn-sm btn-info"
                                    onclick="editTK('<%= tk.getMaTaiKhoan() %>', '<%= tk.getTenDangNhap() %>', '<%= tk.getMatKhau() %>', '<%= tk.getVaiTro() %>')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-danger"
                                    onclick="return confirmDelete('<%= tk.getTenDangNhap() %>', '<%= contextPath %>/TaiKhoanServlet?action=DELETE&maTK=<%= tk.getMaTaiKhoan() %>')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <%      }
                } %>
                </tbody>
            </table>
        </div>

        <!-- PHÂN TRANG -->
        <%
            int totalPages = taiKhoanPage.getTotalPage();
            int currentPage = taiKhoanPage.getCurrentPage();
            String baseUrl = contextPath + "/TaiKhoanServlet?size=" + pageRequest.getPageSize();
            if(pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty())
                baseUrl += "&keyword=" + java.net.URLEncoder.encode(pageRequest.getKeyword(), "UTF-8");
        %>
        <div class="card-footer bg-white">
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm mb-0 justify-content-center">
                    <% if(currentPage>1){ %>
                    <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= currentPage-1 %>">&laquo;</a></li>
                    <% } else { %>
                    <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                    <% } %>

                    <%
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        for(int p=startPage;p<=endPage;p++){
                    %>
                    <li class="page-item <%= (p==currentPage)?"active":"" %>">
                        <a class="page-link" href="<%= baseUrl %>&page=<%= p %>"><%= p %></a>
                    </li>
                    <% } %>

                    <% if(currentPage<totalPages){ %>
                    <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= currentPage+1 %>">&raquo;</a></li>
                    <% } else { %>
                    <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                    <% } %>
                </ul>
            </nav>
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
</script>
