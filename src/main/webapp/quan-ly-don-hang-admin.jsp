<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="Model.DonHang"%>
<%@ page import="Model.TaiKhoan"%>
<%@ page import="Model.Page"%>
<%@ page import="Model.PageRequest"%>
<%@ page import="DTO.ChiTietDonHangDTO"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%
    // Lấy dữ liệu từ request
    String contextPath = request.getContextPath();
    Page<DonHang> donHangPage = (Page<DonHang>) request.getAttribute("donHangPage");
    List<TaiKhoan> danhSachTK = (List<TaiKhoan>) request.getAttribute("DanhSachTK");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");
    String viewMode = (String) request.getAttribute("viewMode");

    // Chi tiết đơn hàng
    DonHang donHangDetail = (DonHang) request.getAttribute("donHangDetail");
    List<ChiTietDonHangDTO> chiTietDTOList = (List<ChiTietDonHangDTO>) request.getAttribute("chiTietDTOList");
    TaiKhoan khachHang = (TaiKhoan) request.getAttribute("khachHang");

    // Giả định trạng thái có thể lọc
    List<String> trangThaiLoc = List.of("Đang xử lí", "Đã hoàn thành", "Đã hủy");

    // Null safety
    if (danhSachTK == null) danhSachTK = java.util.Collections.emptyList();
    if (pageRequest == null) pageRequest = new PageRequest("", "desc", "ngayDat", 10, 1);
    if (donHangPage == null) donHangPage = new Page<DonHang>(java.util.Collections.emptyList(), 1, 10, 0);
    if (viewMode == null) viewMode = "list";

    List<DonHang> danhSachDonHang = donHangPage.getData() != null ? donHangPage.getData() : java.util.Collections.emptyList();

    // Formatter
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    // Map Tài Khoản (MaTK -> TenDangNhap)
    Map<Integer, String> taiKhoanMap = new HashMap<>();
    for (TaiKhoan tk : danhSachTK) {
        taiKhoanMap.put(tk.getMaTaiKhoan(), tk.getTenDangNhap());
    }

    // Tính toán startIndex
    int startIndex = (donHangPage.getCurrentPage() - 1) * pageRequest.getPageSize();
%>

<style>
    /* CSS đã cung cấp ở trên */
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
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .badge-status-dang-xu-ly {
        background-color: #ffc107;
        color: #000;
        padding: 6px 12px;
        font-size: 0.85rem;
    }

    .badge-status-da-hoan-thanh {
        background-color: #28a745;
        color: #fff;
        padding: 6px 12px;
        font-size: 0.85rem;
    }

    .badge-status-da-huy {
        background-color: #dc3545;
        color: #fff;
        padding: 6px 12px;
        font-size: 0.85rem;
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

    .chitiet-header {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
    }

    .info-box {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
    }

    .info-label {
        font-weight: 600;
        color: #6c757d;
        font-size: 0.9rem;
    }

    .info-value {
        font-size: 1.1rem;
        color: #212529;
        margin-top: 5px;
    }

    .status-select {
        font-size: 0.9rem;
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
</style>

<div id="quanlydonhang">
    <div id="danh-sach-don-hang" class="fade-in" style="display: <%= viewMode.equals("list") ? "block" : "none" %>;">
        <div class="page-header">
            <h2 class="mb-0">
                <i class="fas fa-shopping-cart"></i> Quản Lý Đơn Hàng
            </h2>
            <p class="mb-0 mt-2" style="opacity: 0.9;">Theo dõi và quản lý tất cả đơn hàng của khách hàng</p>
        </div>

        <div class="search-bar mb-4">
            <form method="GET" action="<%= contextPath %>/Admin">
                <input type="hidden" name="activeTab" value="quanlydonhang">
                <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
                <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
                <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="filter-label">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </label>
                        <input type="text"
                               class="form-control"
                               name="keyword"
                               placeholder="Tên khách hàng, mã đơn..."
                               value="<%= pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
                    </div>

                    <div class="col-md-3 mb-3">
                        <label class="filter-label">
                            <i class="fas fa-filter"></i> Lọc theo trạng thái
                        </label>
                        <select class="form-control custom-select" name="trangThai">
                            <option value="">-- Tất cả trạng thái --</option>
                            <% for (String status : trangThaiLoc) { %>
                            <option value="<%= status %>" <%= status.equals(pageRequest.getTrangThai()) ? "selected" : "" %>><%= status %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label class="filter-label">
                            <i class="fas fa-calendar"></i> Lọc theo ngày
                        </label>
                        <select class="form-control custom-select" name="locNgay">
                            <option value="">-- Tất cả ngày --</option>
                            <option value="today" <%= "today".equals(pageRequest.getLocNgay()) ? "selected" : "" %>>Hôm nay</option>
                            <option value="yesterday" <%= "yesterday".equals(pageRequest.getLocNgay()) ? "selected" : "" %>>Hôm qua</option>
                            <option value="week" <%= "week".equals(pageRequest.getLocNgay()) ? "selected" : "" %>>7 ngày qua</option>
                            <option value="month" <%= "month".equals(pageRequest.getLocNgay()) ? "selected" : "" %>>30 ngày qua</option>
                        </select>
                    </div>

                    <div class="col-md-2 mb-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12">
                        <a href="<%= contextPath %>/Admin?activeTab=quanlydonhang" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-sync-alt"></i> Làm mới
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-list"></i> Danh Sách Đơn Hàng
                    <span class="badge badge-primary ml-2"><%= donHangPage.getTotalItems() %> đơn</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="thead-light">
                        <tr>
                            <th style="width: 5%;">#</th>
                            <th style="width: 20%;">Tên Khách Hàng</th>
                            <th style="width: 15%;">Ngày Đặt</th>
                            <th style="width: 15%;">Tổng Tiền</th>
                            <th style="width: 15%;">Trạng Thái</th>
                            <th style="width: 15%;" class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (danhSachDonHang.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-5">
                                <i class="fas fa-inbox fa-4x mb-3 d-block" style="opacity: 0.3;"></i>
                                <h5>Không có đơn hàng nào</h5>
                            </td>
                        </tr>
                        <%
                        } else {
                            for (int i = 0; i < danhSachDonHang.size(); i++) {
                                DonHang dh = danhSachDonHang.get(i);

                                // Tìm tên khách hàng
                                String tenKhachHang = taiKhoanMap.getOrDefault(dh.getMaTaiKhoan(), "TK #" + dh.getMaTaiKhoan());

                                // Format ngày giờ
                                String ngayDatStr = dh.getNgayDat() != null ? dh.getNgayDat().format(dateFormatter) : "N/A";
                                String gioStr = dh.getNgayDat() != null ? dh.getNgayDat().format(timeFormatter) : "";

                                // Badge class cho trạng thái
                                String badgeClass = "badge-secondary";
                                if ("Đang xử lí".equals(dh.getTrangThai())) {
                                    badgeClass = "badge-status-dang-xu-ly";
                                } else if ("Đã hoàn thành".equals(dh.getTrangThai())) {
                                    badgeClass = "badge-status-da-hoan-thanh";
                                } else if ("Đã hủy".equals(dh.getTrangThai())) {
                                    badgeClass = "badge-status-da-huy";
                                }
                        %>
                        <tr>
                            <td class="align-middle"><strong><%= startIndex + i + 1 %></strong></td>
                            <td class="align-middle">
                                <i class="fas fa-user-circle text-primary"></i>
                                <strong><%= tenKhachHang %></strong>
                            </td>
                            <td class="align-middle">
                                <small class="text-muted">
                                    <i class="far fa-calendar-alt"></i> <%= ngayDatStr %><br>
                                    <i class="far fa-clock"></i> <%= gioStr %>
                                </small>
                            </td>
                            <td class="align-middle">
                                            <span class="text-success font-weight-bold">
                                                <%= currencyFormatter.format(dh.getTongTien()) %>
                                            </span>
                            </td>
                            <td class="align-middle">
                                            <span class="badge <%= badgeClass %>">
                                                <% if ("Đang xử lí".equals(dh.getTrangThai())) { %>
                                                    <i class="fas fa-spinner"></i>
                                                <% } else if ("Đã hoàn thành".equals(dh.getTrangThai())) { %>
                                                    <i class="fas fa-check-circle"></i>
                                                <% } else if ("Đã hủy".equals(dh.getTrangThai())) { %>
                                                    <i class="fas fa-times-circle"></i>
                                                <% } %>
                                                <%= dh.getTrangThai() %>
                                            </span>
                            </td>
                            <td class="align-middle text-center">
                                <a href="<%= contextPath %>/Admin?activeTab=quanlydonhang&viewMode=detail&maDon=<%= dh.getMaDonHang() %>"
                                   class="btn btn-sm btn-info"
                                   title="Xem chi tiết">
                                    <i class="fas fa-eye"></i> Chi tiết
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <%
                int totalPages = donHangPage.getTotalPage();
                int currentPage = donHangPage.getCurrentPage();
                String baseUrl = contextPath + "/Admin?activeTab=quanlydonhang&size=" + pageRequest.getPageSize() +
                        "&sort=" + pageRequest.getSortField() + "&order=" + pageRequest.getSortOrder();
                // Bổ sung các tham số tìm kiếm/lọc hiện tại vào baseUrl
                if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
                    baseUrl += "&keyword=" + java.net.URLEncoder.encode(pageRequest.getKeyword(), "UTF-8");
                }
                if (pageRequest.getTrangThai() != null && !pageRequest.getTrangThai().isEmpty()) {
                    baseUrl += "&trangThai=" + java.net.URLEncoder.encode(pageRequest.getTrangThai(), "UTF-8");
                }
                if (pageRequest.getLocNgay() != null && !pageRequest.getLocNgay().isEmpty()) {
                    baseUrl += "&locNgay=" + java.net.URLEncoder.encode(pageRequest.getLocNgay(), "UTF-8");
                }
            %>
            <div class="card-footer bg-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <small class="text-muted">
                            Hiển thị <%= (currentPage-1)*pageRequest.getPageSize()+1 %>-<%= Math.min(currentPage*pageRequest.getPageSize(), donHangPage.getTotalItems()) %>
                            trong tổng số <%= donHangPage.getTotalItems() %> đơn hàng
                        </small>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <% if (currentPage > 1) { %>
                            <li class="page-item">
                                <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage-1 %>">&laquo;</a>
                            </li>
                            <% } else { %>
                            <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                            <% } %>

                            <%
                                int startPage = Math.max(1, currentPage-2);
                                int endPage = Math.min(totalPages, currentPage+2);
                                if (startPage > 1) { %>
                            <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=1">1</a></li>
                            <% if (startPage > 2) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% } } %>

                            <% for (int i=startPage; i<=endPage; i++) { %>
                            <li class="page-item <%= (i==currentPage)?"active":"" %>">
                                <a class="page-link" href="<%= baseUrl %>&page=<%= i %>"><%= i %></a>
                            </li>
                            <% } %>

                            <% if (endPage < totalPages) { %>
                            <% if (endPage < totalPages-1) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% } %>
                            <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= totalPages %>"><%= totalPages %></a></li>
                            <% } %>

                            <% if (currentPage < totalPages) { %>
                            <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= currentPage+1 %>">&raquo;</a></li>
                            <% } else { %>
                            <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                            <% } %>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>

    <div id="chi-tiet-don-hang" class="fade-in" style="display: <%= viewMode.equals("detail") ? "block" : "none" %>;">
        <%
            if (donHangDetail != null && chiTietDTOList != null && khachHang != null) {
                String ngayDatFull = donHangDetail.getNgayDat() != null ? donHangDetail.getNgayDat().format(fullFormatter) : "N/A";
        %>
        <div class="chitiet-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="fas fa-receipt"></i> Chi Tiết Đơn Hàng #DH<%= String.format("%03d", donHangDetail.getMaDonHang()) %>
                    </h2>
                    <p class="mb-0" style="opacity: 0.9;">Quản lý chi tiết từng món ăn trong đơn hàng</p>
                </div>
                <a href="<%= contextPath %>/Admin?activeTab=quanlydonhang" class="btn btn-light">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-info-circle"></i> Thông Tin Đơn Hàng
                </h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Mã đơn hàng</div>
                            <div class="info-value">
                                <i class="fas fa-hashtag text-primary"></i> DH<%= String.format("%03d", donHangDetail.getMaDonHang()) %>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Tên khách hàng</div>
                            <div class="info-value">
                                <i class="fas fa-user text-success"></i> <%= khachHang.getTenDangNhap() %>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Ngày đặt</div>
                            <div class="info-value">
                                <i class="far fa-calendar-alt text-info"></i> <%= ngayDatFull %>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Tổng tiền</div>
                            <div class="info-value text-success">
                                <i class="fas fa-money-bill-wave"></i> <%= currencyFormatter.format(donHangDetail.getTongTien()) %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fas fa-utensils"></i> Chi Tiết Món Ăn
                    <span class="badge badge-primary ml-2"><%= chiTietDTOList.size() %> món</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <%-- ĐÃ XÓA FORM bulkUpdateForm BAO QUANH TOÀN BỘ BẢNG --%>

                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="thead-light">
                        <tr>
                            <th style="width: 5%;">#</th>
                            <th style="width: 25%;">Tên Món</th>
                            <th style="width: 10%;">Số Lượng</th>
                            <th style="width: 12%;">Đơn Giá</th>
                            <th style="width: 12%;">Thành Tiền</th>
                            <th style="width: 18%;">Trạng Thái</th>
                            <th style="width: 15%;" class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            for (int i = 0; i < chiTietDTOList.size(); i++) {
                                ChiTietDonHangDTO dto = chiTietDTOList.get(i);
                        %>
                        <tr>
                            <td class="align-middle"><strong><%= i+1 %></strong></td>
                            <td class="align-middle">
                                <strong><%= dto.getTenMonAn() %></strong>
                                <br><small class="text-muted">Quầy: <%= dto.getTenQuay() %></small>
                            </td>
                            <td class="align-middle">
                                <span class="badge badge-secondary">x<%= dto.getSoLuong() %></span>
                            </td>
                            <td class="align-middle"><%= currencyFormatter.format(dto.getDonGia()) %></td>
                            <td class="align-middle">
                                <strong class="text-success"><%= currencyFormatter.format(dto.getThanhTien()) %></strong>
                            </td>
                            <td class="align-middle">
                                <%-- FORM ĐƠN LẺ HIỆN TẠI ĐÃ HỢP LỆ VÌ KHÔNG BỊ LỒNG --%>
                                <form action="<%= contextPath %>/DonHangServlet" method="POST" style="display: inline;" id="formStatus<%= dto.getMaCT() %>">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="maCT" value="<%= dto.getMaCT() %>">
                                    <input type="hidden" name="maDon" value="<%= donHangDetail.getMaDonHang() %>">

                                    <select class="form-control form-control-sm status-select"
                                            name="trangThai"
                                            id="selectStatus<%= dto.getMaCT() %>">
                                        <option value="Mới đặt" <%= "Mới đặt".equals(dto.getTrangThai()) ? "selected" : "" %>>Mới đặt</option>
                                        <option value="Đã xác nhận" <%= "Đã xác nhận".equals(dto.getTrangThai()) ? "selected" : "" %>>Đã xác nhận</option>
                                        <option value="Đang giao" <%= "Đang giao".equals(dto.getTrangThai()) ? "selected" : "" %>>Đang giao</option>
                                        <option value="Đã giao" <%= "Đã giao".equals(dto.getTrangThai()) ? "selected" : "" %>>Đã giao</option>
                                        <option value="Đã hủy" <%= "Đã hủy".equals(dto.getTrangThai()) ? "selected" : "" %>>Đã hủy</option>
                                    </select>
                                </form>
                            </td>
                            <td class="align-middle text-center">
                                <button type="button" class="btn btn-sm btn-primary"
                                        onclick="document.getElementById('formStatus<%= dto.getMaCT() %>').submit()">
                                    <i class="fas fa-save"></i> Lưu
                                </button>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                        <tfoot class="bg-light">
                        <tr>
                            <td colspan="4" class="text-right"><strong>Tổng cộng:</strong></td>
                            <td colspan="3">
                                <strong class="text-success" style="font-size: 1.2rem;">
                                    <%= currencyFormatter.format(donHangDetail.getTongTien()) %>
                                </strong>
                            </td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

            <%-- ĐÃ XÓA KHỐI card-footer DÀNH CHO CẬP NHẬT HÀNG LOẠT --%>

        </div>
        <%
        } else if (viewMode.equals("detail")) {
        %>
        <div class="alert alert-danger text-center">
            <i class="fas fa-exclamation-triangle"></i> Không tìm thấy chi tiết đơn hàng này.
            <a href="<%= contextPath %>/Admin?activeTab=quanlydonhang" class="btn btn-sm btn-danger ml-3">Quay lại</a>
        </div>
        <%
            }
        %>
    </div>
</div>

<script>
    // **ĐÃ XÓA các hàm JavaScript liên quan đến cập nhật hàng loạt (toggleCheckAll, capNhatHangLoat)**

    // Cập nhật màu cho select dựa trên giá trị
    document.addEventListener('DOMContentLoaded', function() {
        const statusSelects = document.querySelectorAll('.status-select');

        statusSelects.forEach(select => {
            updateSelectColor(select);

            select.addEventListener('change', function() {
                updateSelectColor(this);
            });
        });
    });

    function updateSelectColor(select) {
        const value = select.value;

        // Reset style
        select.className = 'form-control form-control-sm status-select';

        // Thêm màu dựa trên giá trị
        switch(value) {
            case 'Mới đặt':
                select.style.backgroundColor = '#d1ecf1';
                select.style.color = '#0c5460';
                select.style.fontWeight = '600';
                break;
            case 'Đã xác nhận':
                select.style.backgroundColor = '#cce5ff';
                select.style.color = '#004085';
                select.style.fontWeight = '600';
                break;
            case 'Đang giao':
                select.style.backgroundColor = '#fff3cd';
                select.style.color = '#856404';
                select.style.fontWeight = '600';
                break;
            case 'Đã giao':
                select.style.backgroundColor = '#d4edda';
                select.style.color = '#155724';
                select.style.fontWeight = '600';
                break;
            case 'Đã hủy':
                select.style.backgroundColor = '#f8d7da';
                select.style.color = '#721c24';
                select.style.fontWeight = '600';
                break;
            default:
                select.style.backgroundColor = '#fff';
                select.style.color = '#495057';
                select.style.fontWeight = 'normal';
        }
    }

    // Hiển thị thông báo nếu có
    <%
        String successMsg = (String) session.getAttribute("success");
        String errorMsg = (String) session.getAttribute("error");

        if (successMsg != null) {
            session.removeAttribute("success");
    %>
    alert('<%= successMsg %>');
    <%
        }

        if (errorMsg != null) {
            session.removeAttribute("error");
    %>
    alert('<%= errorMsg %>');
    <%
        }
    %>
</script>