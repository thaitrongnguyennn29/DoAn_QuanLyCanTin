<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="Model.DonHang"%>
<%@ page import="Model.TaiKhoan"%>
<%@ page import="Model.Page"%>
<%@ page import="Model.PageRequest"%>
<%@ page import="DTO.ChiTietDonHangDTO"%> <%-- QUAN TRỌNG: Import DTO --%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.math.BigDecimal"%>

<%
    // 1. LẤY DỮ LIỆU CƠ BẢN
    String contextPath = request.getContextPath();

    // Base URL động để xử lý phân trang và nút quay lại
    String baseUrl = (String) request.getAttribute("baseUrl");
    if (baseUrl == null) baseUrl = contextPath + "/Seller/DonHang";

    // Dữ liệu danh sách đơn hàng
    Page<DonHang> donHangPage = (Page<DonHang>) request.getAttribute("donHangPage");
    List<TaiKhoan> danhSachTK = (List<TaiKhoan>) request.getAttribute("DanhSachTK");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");
    String viewMode = (String) request.getAttribute("viewMode");

    // Dữ liệu chi tiết đơn hàng (Dùng DTO)
    DonHang donHangDetail = (DonHang) request.getAttribute("donHangDetail");
    List<ChiTietDonHangDTO> chiTietDTOList = (List<ChiTietDonHangDTO>) request.getAttribute("chiTietDTOList");
    TaiKhoan khachHang = (TaiKhoan) request.getAttribute("khachHang");

    // Danh sách trạng thái lọc
    List<String> trangThaiLoc = List.of("Đang xử lí", "Đã hoàn thành", "Đã hủy");

    // Xử lý Null Safety (Tránh lỗi NullPointer)
    if (danhSachTK == null) danhSachTK = java.util.Collections.emptyList();
    if (pageRequest == null) pageRequest = new PageRequest("", "desc", "ngayDat", 10, 1);
    if (donHangPage == null) donHangPage = new Page<DonHang>(java.util.Collections.emptyList(), 1, 10, 0);
    if (viewMode == null) viewMode = "list";

    List<DonHang> danhSachDonHang = donHangPage.getData() != null ? donHangPage.getData() : java.util.Collections.emptyList();

    // Formatter
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    // Map Tài Khoản để hiển thị tên khách nhanh
    Map<Integer, String> taiKhoanMap = new HashMap<>();
    for (TaiKhoan tk : danhSachTK) {
        taiKhoanMap.put(tk.getMaTaiKhoan(), tk.getTenDangNhap());
    }

    // Tính index STT
    int startIndex = (donHangPage.getCurrentPage() - 1) * pageRequest.getPageSize();
%>

<style>
    /* --- Giao diện Seller (Màu Cam/Vàng chủ đạo) --- */
    .page-header-seller {
        background: linear-gradient(135deg, #f09819 0%, #edde5d 100%);
        color: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 25px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        margin-bottom: 20px;
    }

    .table tbody tr:hover {
        background-color: #fffcf5; /* Màu nền khi hover (Vàng nhạt) */
    }

    /* Badges Trạng thái */
    .badge-status-dang-xu-ly { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
    .badge-status-da-hoan-thanh { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .badge-status-da-huy { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

    .status-select {
        font-size: 0.9rem;
        font-weight: 500;
        border-radius: 5px;
    }

    /* Animation */
    .fade-in { animation: fadeIn 0.5s ease-out forwards; opacity: 0; transform: translateY(20px); }
    @keyframes fadeIn { to { opacity: 1; transform: translateY(0); } }
</style>

<div id="quanlydonhang-seller">

    <%-- ========================================================================
         PHẦN 1: DANH SÁCH ĐƠN HÀNG (HIỆN KHI VIEWMODE = LIST)
         ======================================================================== --%>
    <div id="danh-sach-don-hang" class="fade-in" style="display: <%= viewMode.equals("list") ? "block" : "none" %>;">

        <div class="page-header-seller">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1"><i class="fas fa-store"></i> Kênh Người Bán</h2>
                    <p class="mb-0" style="opacity: 0.9;">Quản lý đơn hàng từ khách hàng</p>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-body">
                <form method="GET" action="<%= baseUrl %>">
                    <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
                    <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
                    <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="font-weight-bold">Tìm kiếm</label>
                            <input type="text" class="form-control" name="keyword"
                                   placeholder="Mã đơn, tên khách..."
                                   value="<%= pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
                        </div>

                        <div class="col-md-3 mb-3">
                            <label class="font-weight-bold">Trạng thái</label>
                            <select class="form-control custom-select" name="trangThai">
                                <option value="">-- Tất cả --</option>
                                <% for (String status : trangThaiLoc) { %>
                                <option value="<%= status %>" <%= status.equals(pageRequest.getTrangThai()) ? "selected" : "" %>><%= status %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="col-md-3 mb-3">
                            <label class="font-weight-bold">Thời gian</label>
                            <select class="form-control custom-select" name="locNgay">
                                <option value="">-- Tất cả --</option>
                                <option value="today" <%= "today".equals(pageRequest.getLocNgay()) ? "selected" : "" %>>Hôm nay</option>
                                <option value="week" <%= "week".equals(pageRequest.getLocNgay()) ? "selected" : "" %>>7 ngày qua</option>
                            </select>
                        </div>

                        <div class="col-md-2 mb-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-warning btn-block text-white font-weight-bold">
                                <i class="fas fa-filter"></i> Lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-white">
                <h5 class="mb-0 text-dark font-weight-bold">
                    <i class="fas fa-list-ul text-warning mr-2"></i> Danh Sách Đơn Hàng
                </h5>
            </div>

            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Khách Hàng</th>
                            <th>Thời Gian</th>
                            <th>Tổng Giá Trị Đơn</th>
                            <th>Trạng Thái Chung</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (danhSachDonHang.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-5">Không tìm thấy đơn hàng nào.</td>
                        </tr>
                        <%
                        } else {
                            for (int i = 0; i < danhSachDonHang.size(); i++) {
                                DonHang dh = danhSachDonHang.get(i);
                                String tenKhach = taiKhoanMap.getOrDefault(dh.getMaTaiKhoan(), "Khách #" + dh.getMaTaiKhoan());

                                String badgeClass = "badge-secondary";
                                if ("Đang xử lí".equals(dh.getTrangThai())) badgeClass = "badge-status-dang-xu-ly";
                                else if ("Đã hoàn thành".equals(dh.getTrangThai())) badgeClass = "badge-status-da-hoan-thanh";
                                else if ("Đã hủy".equals(dh.getTrangThai())) badgeClass = "badge-status-da-huy";
                        %>
                        <tr>
                            <td class="align-middle font-weight-bold"><%= startIndex + i + 1 %></td>
                            <td class="align-middle">
                                <span class="font-weight-bold"><%= tenKhach %></span><br>
                                <small class="text-muted">#DH<%= dh.getMaDonHang() %></small>
                            </td>
                            <td class="align-middle">
                                <%= dh.getNgayDat() != null ? dh.getNgayDat().format(fullFormatter) : "N/A" %>
                            </td>
                            <td class="align-middle text-success font-weight-bold">
                                <%= currencyFormatter.format(dh.getTongTien()) %>
                            </td>
                            <td class="align-middle">
                                <span class="badge p-2 <%= badgeClass %>"><%= dh.getTrangThai() %></span>
                            </td>
                            <td class="align-middle text-center">
                                <a href="<%= baseUrl %>?viewMode=detail&maDon=<%= dh.getMaDonHang() %>"
                                   class="btn btn-info btn-sm shadow-sm">
                                    <i class="fas fa-eye"></i> Xem
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

            <div class="card-footer bg-white">
                <%
                    String pageUrl = baseUrl + "?size=" + pageRequest.getPageSize() +
                            "&sort=" + pageRequest.getSortField() +
                            "&order=" + pageRequest.getSortOrder();
                    if (pageRequest.getKeyword() != null) pageUrl += "&keyword=" + pageRequest.getKeyword();
                    if (pageRequest.getTrangThai() != null) pageUrl += "&trangThai=" + pageRequest.getTrangThai();

                    int totalPages = donHangPage.getTotalPage();
                    int curPage = donHangPage.getCurrentPage();
                %>
                <nav>
                    <ul class="pagination pagination-sm justify-content-center mb-0">
                        <li class="page-item <%= (curPage <= 1) ? "disabled" : "" %>">
                            <a class="page-link" href="<%= pageUrl %>&page=<%= curPage - 1 %>">Trước</a>
                        </li>
                        <% for(int p = 1; p <= totalPages; p++) { %>
                        <li class="page-item <%= (p == curPage) ? "active" : "" %>">
                            <a class="page-link" href="<%= pageUrl %>&page=<%= p %>"><%= p %></a>
                        </li>
                        <% } %>
                        <li class="page-item <%= (curPage >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="<%= pageUrl %>&page=<%= curPage + 1 %>">Sau</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <%-- ========================================================================
         PHẦN 2: CHI TIẾT ĐƠN HÀNG (HIỆN KHI VIEWMODE = DETAIL)
         ======================================================================== --%>
    <div id="chi-tiet-don-hang" class="fade-in" style="display: <%= viewMode.equals("detail") ? "block" : "none" %>;">
        <%
            if (donHangDetail != null) {
        %>

        <div class="page-header-seller d-flex justify-content-between align-items-center">
            <div>
                <h3 class="mb-0">Đơn Hàng #<%= String.format("%03d", donHangDetail.getMaDonHang()) %></h3>
                <p class="mb-0">Khách hàng: <%= khachHang != null ? khachHang.getTenDangNhap() : "N/A" %></p>
            </div>
            <a href="<%= baseUrl %>" class="btn btn-light text-warning font-weight-bold shadow-sm">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="card">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0 font-weight-bold text-dark">
                    <i class="fas fa-utensils text-warning mr-2"></i> Món Ăn Của Quầy Bạn
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="thead-light">
                        <tr>
                            <th>#</th>
                            <th>Thông Tin Món</th>
                            <th>Số Lượng</th>
                            <th>Đơn Giá</th>
                            <th>Thành Tiền</th>
                            <th style="width: 150px;">Trạng Thái</th>
                            <th class="text-center">Lưu</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (chiTietDTOList != null && !chiTietDTOList.isEmpty()) {
                                for (int i = 0; i < chiTietDTOList.size(); i++) {
                                    ChiTietDonHangDTO dto = chiTietDTOList.get(i);

                                    // --- TÍNH THÀNH TIỀN TẠI JSP ĐỂ AN TOÀN ---
                                    BigDecimal thanhTien = BigDecimal.ZERO;
                                    if(dto.getDonGia() != null) {
                                        thanhTien = dto.getDonGia().multiply(BigDecimal.valueOf(dto.getSoLuong()));
                                    }
                        %>
                        <tr>
                            <td class="align-middle font-weight-bold"><%= i + 1 %></td>
                            <td class="align-middle">
                                <div class="d-flex align-items-center">
                                    <% if(dto.getHinhAnhMonAn() != null && !dto.getHinhAnhMonAn().isEmpty()) { %>
                                    <img src="<%= contextPath %>/<%= dto.getHinhAnhMonAn() %>"
                                         class="rounded mr-3" style="width: 50px; height: 50px; object-fit: cover;"
                                         onerror="this.src='https://via.placeholder.com/50'">
                                    <% } else { %>
                                    <div class="rounded mr-3 bg-light d-flex align-items-center justify-content-center text-muted"
                                         style="width: 50px; height: 50px;"><i class="fas fa-image"></i></div>
                                    <% } %>
                                    <div>
                                        <div class="font-weight-bold text-dark"><%= dto.getTenMonAn() %></div>
                                        <small class="text-muted">Mã món: <%= dto.getMaMonAn() %></small>
                                    </div>
                                </div>
                            </td>
                            <td class="align-middle">
                                <span class="badge badge-light border px-3 py-2">x<%= dto.getSoLuong() %></span>
                            </td>
                            <td class="align-middle text-muted"><%= currencyFormatter.format(dto.getDonGia()) %></td>
                            <td class="align-middle">
                                <span class="font-weight-bold text-success">
                                    <%= currencyFormatter.format(thanhTien) %>
                                </span>
                            </td>

                            <td class="align-middle">
                                <form action="<%= contextPath %>/DonHangServlet" method="POST" id="formStatus<%= dto.getMaCT() %>">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="maCT" value="<%= dto.getMaCT() %>">
                                    <input type="hidden" name="maDon" value="<%= donHangDetail.getMaDonHang() %>">

                                    <select class="form-control form-control-sm status-select"
                                            name="trangThai"
                                            id="selectStatus<%= dto.getMaCT() %>"
                                            onchange="updateSelectColor(this)">
                                        <option value="Mới đặt" <%= "Mới đặt".equals(dto.getTrangThai()) ? "selected" : "" %>>Mới đặt</option>
                                        <option value="Đang giao" <%= "Đang giao".equals(dto.getTrangThai()) ? "selected" : "" %>>Đang giao</option>
                                        <option value="Đã giao" <%= "Đã giao".equals(dto.getTrangThai()) ? "selected" : "" %>>Đã giao</option>
                                        <option value="Đã hủy" <%= "Đã hủy".equals(dto.getTrangThai()) ? "selected" : "" %>>Đã hủy</option>
                                    </select>
                                </form>
                            </td>

                            <td class="align-middle text-center">
                                <button type="button" class="btn btn-primary btn-sm shadow-sm"
                                        onclick="document.getElementById('formStatus<%= dto.getMaCT() %>').submit()"
                                        title="Lưu thay đổi">
                                    <i class="fas fa-save"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr><td colspan="7" class="text-center text-danger py-4">Không có món ăn nào của quầy bạn trong đơn này.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <% } else if ("detail".equals(viewMode)) { %>
        <div class="alert alert-danger text-center shadow-sm">
            <h4>Không tìm thấy dữ liệu đơn hàng!</h4>
            <a href="<%= baseUrl %>" class="btn btn-danger mt-2">Quay lại</a>
        </div>
        <% } %>
    </div>
</div>

<script>
    // JS xử lý màu sắc Dropdown
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.status-select').forEach(select => updateSelectColor(select));
    });

    function updateSelectColor(select) {
        const val = select.value;
        select.className = 'form-control form-control-sm status-select';

        if(val === 'Mới đặt') select.style.cssText = "background-color: #d1ecf1; color: #0c5460; border-color: #bee5eb;";
        else if(val === 'Đang giao') select.style.cssText = "background-color: #fff3cd; color: #856404; border-color: #ffeeba;";
        else if(val === 'Đã giao') select.style.cssText = "background-color: #d4edda; color: #155724; border-color: #c3e6cb;";
        else if(val === 'Đã hủy') select.style.cssText = "background-color: #f8d7da; color: #721c24; border-color: #f5c6cb;";
        else select.style.cssText = "";
    }

    // Thông báo từ Session (Lưu/Lỗi)
    <%
        String successMsg = (String) session.getAttribute("success");
        String errorMsg = (String) session.getAttribute("error");
        if (successMsg != null) { session.removeAttribute("success"); %>
    alert('<%= successMsg %>');
    <% } if (errorMsg != null) { session.removeAttribute("error"); %>
    alert('<%= errorMsg %>');
    <% } %>
</script>