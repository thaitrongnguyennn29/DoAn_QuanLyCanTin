<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
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
    String viewMode = (String) request.getAttribute("viewMode"); // "list" hoặc "detail"

    // Chi tiết đơn hàng
    DonHang donHangDetail = (DonHang) request.getAttribute("donHangDetail");
    List<ChiTietDonHangDTO> chiTietDTOList = (List<ChiTietDonHangDTO>) request.getAttribute("chiTietDTOList");
    TaiKhoan khachHang = (TaiKhoan) request.getAttribute("khachHang");

    // Giả định trạng thái có thể lọc
    List<String> trangThaiLoc = List.of("Đang xử lí", "Đã hoàn thành", "Đã hủy");
    List<String> trangThaiMon = List.of("Mới đặt", "Đã xác nhận", "Đang giao", "Đã giao", "Đã hủy");

    // Null safety
    if (danhSachTK == null) danhSachTK = new ArrayList<>();
    if (pageRequest == null) pageRequest = new PageRequest("", "desc", "ngayDat", 10, 1);
    if (donHangPage == null) donHangPage = new Page<DonHang>(new ArrayList<>(), 1, 10, 0);
    if (viewMode == null) viewMode = "list";

    List<DonHang> danhSachDonHang = donHangPage.getData() != null ? donHangPage.getData() : new ArrayList<>();

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

    .table tbody tr { transition: all 0.3s ease; }
    .table tbody tr:hover {
        background-color: #f8f9fa;
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    /* Badges */
    .badge-status-dang-xu-ly { background-color: #ffc107; color: #000; padding: 6px 12px; font-size: 0.85rem; }
    .badge-status-da-hoan-thanh { background-color: #28a745; color: #fff; padding: 6px 12px; font-size: 0.85rem; }
    .badge-status-da-huy { background-color: #dc3545; color: #fff; padding: 6px 12px; font-size: 0.85rem; }

    .search-bar {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .filter-label { font-weight: 600; font-size: 0.9rem; margin-bottom: 5px; color: #495057; }

    .chitiet-header {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
    }

    .info-box { background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
    .info-label { font-weight: 600; color: #6c757d; font-size: 0.9rem; }
    .info-value { font-size: 1.1rem; color: #212529; margin-top: 5px; }

    .status-select { font-size: 0.85rem; padding: 2px 5px; font-weight: 600; border: 1px solid #ced4da; border-radius: 4px; }
    .status-select:focus { border-color: #80bdff; outline: 0; box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25); }

    /* Animation */
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    .fade-in { animation: fadeIn 0.5s ease; }
</style>

<div id="quanlydonhang">
    <div id="danh-sach-don-hang" class="fade-in" style="display: <%= viewMode.equals("list") ? "block" : "none" %>;">
        <div class="page-header">
            <h2 class="mb-0">
                <i class="fas fa-store"></i> Quản Lý Đơn Hàng (Kênh Người Bán)
            </h2>
            <p class="mb-0 mt-2" style="opacity: 0.9;">Theo dõi và xử lý các đơn hàng thuộc quầy của bạn</p>
        </div>

        <div class="search-bar mb-4">
            <form method="GET" action="<%= contextPath %>/Seller">
                <input type="hidden" name="page" value="quanlydonhang">
                <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
                <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
                <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="filter-label">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </label>
                        <input type="text" class="form-control" name="keyword"
                               placeholder="Mã đơn..."
                               value="<%= pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
                    </div>

                    <div class="col-md-3 mb-3">
                        <label class="filter-label">
                            <i class="fas fa-filter"></i> Trạng thái đơn
                        </label>
                        <select class="form-control custom-select" name="trangThai">
                            <option value="">-- Tất cả --</option>
                            <% for (String status : trangThaiLoc) { %>
                            <option value="<%= status %>" <%= status.equals(pageRequest.getTrangThai()) ? "selected" : "" %>><%= status %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="col-md-2 mb-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary btn-block shadow-sm">
                            <i class="fas fa-search"></i> Lọc
                        </button>
                    </div>

                    <div class="col-md-2 mb-3 d-flex align-items-end">
                        <a href="<%= contextPath %>/Seller?page=quanlydonhang" class="btn btn-outline-secondary btn-block">
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
                            <th style="width: 10%;">Mã Đơn</th>
                            <th style="width: 20%;">Khách Hàng</th>
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
                                <h5>Chưa có đơn hàng nào</h5>
                            </td>
                        </tr>
                        <%
                        } else {
                            for (int i = 0; i < danhSachDonHang.size(); i++) {
                                DonHang dh = danhSachDonHang.get(i);
                                String tenKhachHang = taiKhoanMap.getOrDefault(dh.getMaTaiKhoan(), "Khách lẻ");
                                String ngayDatStr = dh.getNgayDat() != null ? dh.getNgayDat().format(dateFormatter) : "N/A";
                                String gioStr = dh.getNgayDat() != null ? dh.getNgayDat().format(timeFormatter) : "";

                                // Badge trạng thái
                                String badgeClass = "badge-secondary";
                                if ("Đang xử lí".equals(dh.getTrangThai())) badgeClass = "badge-status-dang-xu-ly";
                                else if ("Đã hoàn thành".equals(dh.getTrangThai())) badgeClass = "badge-status-da-hoan-thanh";
                                else if ("Đã hủy".equals(dh.getTrangThai())) badgeClass = "badge-status-da-huy";
                        %>
                        <tr>
                            <td class="align-middle"><strong>#<%= dh.getMaDonHang() %></strong></td>
                            <td class="align-middle">
                                <i class="fas fa-user-circle text-primary"></i> <strong><%= tenKhachHang %></strong>
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
                                    <%= dh.getTrangThai() %>
                                </span>
                            </td>
                            <td class="align-middle text-center">
                                <a href="<%= contextPath %>/Seller?page=quanlydonhang&maDon=<%= dh.getMaDonHang() %>"
                                   class="btn btn-sm btn-info shadow-sm" title="Xem chi tiết">
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
                int currentPageNum = donHangPage.getCurrentPage();
                // Link cơ sở cho phân trang Seller
                String baseUrl = contextPath + "/Seller?page=quanlydonhang&size=" + pageRequest.getPageSize() +
                        "&sort=" + pageRequest.getSortField() + "&order=" + pageRequest.getSortOrder();

                if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
                    baseUrl += "&keyword=" + java.net.URLEncoder.encode(pageRequest.getKeyword(), "UTF-8");
                }
                if (pageRequest.getTrangThai() != null && !pageRequest.getTrangThai().isEmpty()) {
                    baseUrl += "&trangThai=" + java.net.URLEncoder.encode(pageRequest.getTrangThai(), "UTF-8");
                }
            %>
            <div class="card-footer bg-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <small class="text-muted">
                            Hiển thị <%= (currentPageNum-1)*pageRequest.getPageSize()+1 %>-<%= Math.min(currentPageNum*pageRequest.getPageSize(), donHangPage.getTotalItems()) %>
                            trong tổng số <%= donHangPage.getTotalItems() %> đơn hàng
                        </small>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <% if (currentPageNum > 1) { %>
                            <li class="page-item"><a class="page-link" href="<%= baseUrl %>&pageIdx=<%= currentPageNum-1 %>">&laquo;</a></li>
                            <% } else { %>
                            <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                            <% } %>

                            <% for (int i=1; i<=totalPages; i++) {
                                if (i == 1 || i == totalPages || (i >= currentPageNum-2 && i <= currentPageNum+2)) {
                            %>
                            <li class="page-item <%= (i==currentPageNum)?"active":"" %>">
                                <a class="page-link" href="<%= baseUrl %>&pageIdx=<%= i %>"><%= i %></a>
                            </li>
                            <% } else if (i == currentPageNum-3 || i == currentPageNum+3) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% }} %>

                            <% if (currentPageNum < totalPages) { %>
                            <li class="page-item"><a class="page-link" href="<%= baseUrl %>&pageIdx=<%= currentPageNum+1 %>">&raquo;</a></li>
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
            if (donHangDetail != null && chiTietDTOList != null) {
                String ngayDatFull = donHangDetail.getNgayDat() != null ? donHangDetail.getNgayDat().format(fullFormatter) : "N/A";
        %>
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="fas fa-receipt"></i> Chi Tiết Đơn Hàng #<%= donHangDetail.getMaDonHang() %>
                    </h2>
                    <p class="mb-0" style="opacity: 0.9;">Quản lý món ăn thuộc quầy của bạn trong đơn hàng này</p>
                </div>
                <a href="<%= contextPath %>/Seller?page=quanlydonhang" class="btn btn-light shadow-sm">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-info-circle"></i> Thông Tin Đơn Hàng</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Mã đơn hàng</div>
                            <div class="info-value"><i class="fas fa-hashtag text-primary"></i> #<%= donHangDetail.getMaDonHang() %></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Khách hàng</div>
                            <div class="info-value"><i class="fas fa-user text-success"></i> <%= khachHang != null ? khachHang.getTenDangNhap() : "Khách lẻ" %></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Ngày đặt</div>
                            <div class="info-value"><i class="far fa-calendar-alt text-info"></i> <%= ngayDatFull %></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="info-box">
                            <div class="info-label">Tổng đơn (Toàn sàn)</div>
                            <div class="info-value text-success"><i class="fas fa-money-bill-wave"></i> <%= currencyFormatter.format(donHangDetail.getTongTien()) %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fas fa-utensils"></i> Món Ăn Của Quầy Bạn
                    <span class="badge badge-primary ml-2"><%= chiTietDTOList.size() %> món</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="thead-light">
                        <tr>
                            <th style="width: 30%;">Món Ăn</th>
                            <th style="width: 10%;">Hình Ảnh</th>
                            <th style="width: 10%;">Số Lượng</th>
                            <th style="width: 15%;">Đơn Giá</th>
                            <th style="width: 15%;">Thành Tiền</th>
                            <th style="width: 20%;">Cập Nhật Trạng Thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            for (ChiTietDonHangDTO dto : chiTietDTOList) {
                                String imgUrl = (dto.getHinhAnhMonAn() != null && !dto.getHinhAnhMonAn().isEmpty())
                                        ? contextPath + "/assets/images/MonAn/" + dto.getHinhAnhMonAn()
                                        : contextPath + "/assets/images/no-image.png";
                        %>
                        <tr>
                            <td>
                                <strong><%= dto.getTenMonAn() %></strong>
                            </td>
                            <td>
                                <img src="<%= imgUrl %>" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #dee2e6;">
                            </td>
                            <td>
                                <span class="badge badge-secondary" style="font-size: 0.9em;">x<%= dto.getSoLuong() %></span>
                            </td>
                            <td><%= currencyFormatter.format(dto.getDonGia()) %></td>
                            <td>
                                <strong class="text-success"><%= currencyFormatter.format(dto.getThanhTien()) %></strong>
                            </td>
                            <td>
                                <form action="<%= contextPath %>/Seller" method="POST" id="form-<%= dto.getMaCT() %>" class="d-flex">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="maCT" value="<%= dto.getMaCT() %>">
                                    <input type="hidden" name="maDon" value="<%= dto.getMaDonHang() %>">

                                    <select name="trangThai" class="form-control status-select mr-2"
                                            id="selectStatus<%= dto.getMaCT() %>"
                                            onchange="document.getElementById('form-<%= dto.getMaCT() %>').submit()">
                                        <% for(String status : trangThaiMon) {
                                            boolean isSelected = status.equals(dto.getTrangThai());
                                        %>
                                        <option value="<%= status %>" <%= isSelected ? "selected" : "" %>><%= status %></option>
                                        <% } %>
                                    </select>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%
        } else if (viewMode.equals("detail")) {
        %>
        <div class="alert alert-danger text-center p-5">
            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i><br>
            <h5>Không tìm thấy chi tiết đơn hàng này</h5>
            <p>Có thể đơn hàng không tồn tại hoặc không chứa món ăn nào của quầy bạn.</p>
            <a href="<%= contextPath %>/Seller?page=quanlydonhang" class="btn btn-primary mt-3">Quay lại danh sách</a>
        </div>
        <%
            }
        %>
    </div>
</div>

<script>
    // --- Logic tô màu Select box (Giống hệt Admin) ---
    document.addEventListener('DOMContentLoaded', function() {
        const statusSelects = document.querySelectorAll('.status-select');

        statusSelects.forEach(select => {
            updateSelectColor(select);
            // Sự kiện change đã được xử lý inline trong HTML (submit form)
            // Nhưng vẫn cần update màu khi render
        });
    });

    function updateSelectColor(select) {
        const value = select.value;
        // Reset style
        select.className = 'form-control status-select mr-2';

        // Thêm màu nền dựa trên giá trị
        switch(value) {
            case 'Mới đặt':
                select.style.backgroundColor = '#d1ecf1'; select.style.color = '#0c5460'; break;
            case 'Đã xác nhận':
                select.style.backgroundColor = '#cce5ff'; select.style.color = '#004085'; break;
            case 'Đang giao':
                select.style.backgroundColor = '#fff3cd'; select.style.color = '#856404'; break;
            case 'Đã giao':
                select.style.backgroundColor = '#d4edda'; select.style.color = '#155724'; break;
            case 'Đã hủy':
                select.style.backgroundColor = '#f8d7da'; select.style.color = '#721c24'; break;
            default:
                select.style.backgroundColor = '#fff'; select.style.color = '#495057';
        }
    }

    // Hiển thị thông báo Toast/Alert từ Session
    <%
        String successMsg = (String) session.getAttribute("success");
        String errorMsg = (String) session.getAttribute("error");
        String msg = (String) session.getAttribute("message"); // Đôi khi dùng message

        if (successMsg != null) { session.removeAttribute("success"); %> alert('<%= successMsg %>'); <% }
        if (errorMsg != null) { session.removeAttribute("error"); %> alert('<%= errorMsg %>'); <% }
        if (msg != null) { session.removeAttribute("message"); %> alert('<%= msg %>'); <% }
    %>
</script>