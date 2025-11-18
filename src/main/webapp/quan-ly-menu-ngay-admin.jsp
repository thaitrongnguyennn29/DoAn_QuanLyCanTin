<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.text.DecimalFormat"%>

<%!
    // =================================================================
    // KHỐI KHAI BÁO JSP (ĐÃ XÓA escapeJson)
    // =================================================================

    // Hàm Java helper để tạo HTML cho món đã chọn
    public static String createSelectedMonItemHtml(String maMon, String tenMon, String giaText, String trangThai) {
        return String.format(
                "<li class='list-group-item d-flex justify-content-between align-items-center'>" +
                        "<div style='flex-grow: 1;'>" +
                        "<input type='hidden' name='maMonMenu[]' value='%s'>" +
                        "<strong>%s</strong>" +
                        "<small class='text-muted d-block'>Giá: %s</small>" +
                        "</div>" +
                        "<div class='d-flex align-items-center'>" +
                        "<select class='form-control form-control-sm mr-2' name='trangThai_%s' style='width: 120px;'>" +
                        "<option value='Còn bán' %s>Còn bán</option>" +
                        "<option value='Hết món' %s>Hết món</option>" +
                        "</select>" +
                        "<button type='button' class='btn btn-sm btn-danger' onclick=\"removeMon(this, '%s')\">" +
                        "<i class='fas fa-trash-alt'></i>" +
                        "</button>" +
                        "</div>" +
                        "</li>",
                maMon, tenMon, giaText, maMon,
                "Còn bán".equals(trangThai) ? "selected" : "",
                "Hết món".equals(trangThai) ? "selected" : "",
                maMon
        );
    }

    // Hàm Java helper để tạo HTML cho món có sẵn (đã xóa escapeJson)
    public static String createAvailableMonItemHtml(String maMon, String tenMon, String giaText, String giaRaw) {
        return String.format(
                "<li class='list-group-item d-flex justify-content-between align-items-center'>" +
                        "<div>" +
                        "<input type='checkbox' name='monAnAvailable' value='%s' id='mon_%s' class='mr-2 available-checkbox'" +
                        "data-tenmon='%s' data-gia='%s'>" +
                        "<label for='mon_%s' class='mb-0 font-weight-bold'>%s</label>" +
                        "</div>" +
                        "<span class='item-gia'>%s</span>" +
                        "</li>",
                maMon, maMon, tenMon, giaRaw, maMon, tenMon, giaText // Sử dụng tenMon TRỰC TIẾP
        );
    }
%>

<%
    // --- Dữ liệu MOCK và Cấu hình ---
    String contextPath = request.getContextPath();
    DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    LocalDate today = LocalDate.now();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // Mock Data: Danh sách Quầy
    Map<Integer, String> mockQuaysMap = new HashMap<>();
    mockQuaysMap.put(1, "Quầy Món Nước");
    mockQuaysMap.put(2, "Quầy Cơm Văn Phòng");
    mockQuaysMap.put(3, "Quầy Ăn Vặt");

    // Mock Data: Danh sách Menu Ngày (List View Data)
    List<String[]> mockMenuList = new ArrayList<>();
    mockMenuList.add(new String[]{"201", today.format(displayFormatter), "1", "Phở Bò Đặc Biệt", "65000", "Còn bán"});
    mockMenuList.add(new String[]{"202", today.format(displayFormatter), "1", "Mì Quảng", "45000", "Còn bán"});
    mockMenuList.add(new String[]{"203", today.minusDays(1).format(displayFormatter), "2", "Cơm Sườn Bì Chả", "45000", "Còn bán"});
    mockMenuList.add(new String[]{"204", today.minusDays(1).format(displayFormatter), "3", "Bánh Tráng Trộn", "20000", "Hết món"});

    // Mock Data: Danh sách Món Ăn có sẵn của Quầy 1
    List<String[]> mockMonAnAvailable = new ArrayList<>();
    mockMonAnAvailable.add(new String[]{"101", "Hủ Tiếu Nam Vang", "50000"});
    mockMonAnAvailable.add(new String[]{"102", "Bún Chả Hà Nội", "55000"});

    // Mock Data: Danh sách Món đã có trong Menu Ngày hôm nay
    List<String[]> mockMonDaCo = new ArrayList<>();
    mockMonDaCo.add(new String[]{"106", "Bún Bò Huế", "60000", "Còn bán"});
    mockMonDaCo.add(new String[]{"107", "Cháo Lòng", "30000", "Hết món"});

    List<String> trangThaiLoc = List.of("Còn bán", "Hết món");

    // Giá trị mặc định cho Detail View
    int defaultMaQuay = 1;
    String defaultNgay = today.format(dateFormatter);

    String filterQuay = request.getParameter("filterQuay") != null ? request.getParameter("filterQuay") : "";
    String filterNgay = request.getParameter("filterNgay") != null ? request.getParameter("filterNgay") : "";
    String filterTrangThai = request.getParameter("filterTrangThai") != null ? request.getParameter("filterTrangThai") : "";
%>

<style>
    /* CSS đã cung cấp */
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
    .filter-label {
        font-weight: 600;
        font-size: 0.9rem;
        margin-bottom: 5px;
        color: #495057;
    }
    .fade-in {
        animation: fadeIn 0.5s ease;
    }
    .menu-header-card {
        background-color: #f7f7f7;
        border: 1px solid #e0e0e0;
        border-left: 5px solid #ffc107;
    }
    .scrollable-list {
        max-height: 450px;
        overflow-y: auto;
        border: 1px solid #dee2e6;
        border-radius: 5px;
    }
    .list-group-item:hover {
        background-color: #f8f9fa;
    }
    .badge-con-ban {
        background-color: #28a745;
        color: #fff;
    }
    .badge-het-mon {
        background-color: #dc3545;
        color: #fff;
    }
    .list-header {
        background-color: #e9ecef;
        font-weight: 600;
        padding: 10px 15px;
        border-bottom: 1px solid #dee2e6;
    }
    .item-gia {
        font-weight: 500;
        color: #28a745;
    }
</style>

<div id="quanlymenungay" class="fade-in">

    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="mb-0">
                <i class="fas fa-calendar-alt"></i> Quản Lý Menu Ngày
            </h2>
            <button type="button" class="btn btn-light" onclick="showMenuForm()">
                <i class="fas fa-plus"></i> Thêm Menu Ngày Mới
            </button>
        </div>
        <p class="mb-0 mt-2" style="opacity: 0.9;">Tổng quan và thiết lập danh sách món ăn bán theo từng ngày.</p>
    </div>

    <%-- ========================================================= --%>
    <%-- 1. DANH SÁCH MENU NGÀY (LIST VIEW) --%>
    <%-- ========================================================= --%>
    <div id="listView" style="display: block;">

        <div class="card p-4 mb-4">
            <h4 class="mb-3 pb-2 border-bottom">
                <i class="fas fa-filter text-info"></i> Lọc và Tìm kiếm Menu
            </h4>
            <form action="<%= contextPath %>/Admin" method="GET">
                <input type="hidden" name="activeTab" value="quanlymenungay">

                <div class="form-row">
                    <div class="form-group col-md-3">
                        <label class="filter-label" for="filterNgay">Ngày</label>
                        <input type="date" class="form-control" name="filterNgay" value="<%= filterNgay %>">
                    </div>

                    <div class="form-group col-md-3">
                        <label class="filter-label" for="filterQuay">Quầy</label>
                        <select class="form-control custom-select" name="filterQuay">
                            <option value="">-- Tất cả Quầy --</option>
                            <% for (Map.Entry<Integer, String> entry : mockQuaysMap.entrySet()) { %>
                            <option value="<%= entry.getKey() %>" <%= String.valueOf(entry.getKey()).equals(filterQuay) ? "selected" : "" %>><%= entry.getValue() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group col-md-3">
                        <label class="filter-label" for="filterTrangThai">Trạng Thái</label>
                        <select class="form-control custom-select" name="filterTrangThai">
                            <option value="">-- Tất cả Trạng Thái --</option>
                            <% for (String status : trangThaiLoc) { %>
                            <option value="<%= status %>" <%= status.equals(filterTrangThai) ? "selected" : "" %>><%= status %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary mr-2">
                            <i class="fas fa-search"></i> Lọc
                        </button>
                        <a href="<%= contextPath %>/Admin?activeTab=quanlymenungay" class="btn btn-outline-secondary">
                            <i class="fas fa-sync-alt"></i>
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-list-check"></i> Menu Ngày Đã Thiết Lập
                    <span class="badge badge-primary ml-2"><%= mockMenuList.size() %> món</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="thead-light">
                        <tr>
                            <th style="width: 5%;">#</th>
                            <th style="width: 15%;">Ngày</th>
                            <th style="width: 30%;">Tên Món</th>
                            <th style="width: 15%;">Quầy</th>
                            <th style="width: 15%;">Giá Bán</th>
                            <th style="width: 10%;">Trạng Thái</th>
                            <th style="width: 10%;" class="text-center">Thao Tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (mockMenuList.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <i class="fas fa-inbox fa-4x mb-3 d-block" style="opacity: 0.3;"></i>
                                <h5>Không có món ăn nào được thiết lập trong Menu Ngày</h5>
                            </td>
                        </tr>
                        <%
                        } else {
                            for (int i = 0; i < mockMenuList.size(); i++) {
                                String[] item = mockMenuList.get(i);
                                String maMenu = item[0];
                                String ngay = item[1];
                                String maQuay = item[2];
                                String tenMon = item[3];
                                long gia = Long.parseLong(item[4]);
                                String trangThai = item[5];

                                String tenQuay = mockQuaysMap.getOrDefault(Integer.parseInt(maQuay), "N/A");
                                String badgeClass = "Còn bán".equals(trangThai) ? "badge-con-ban" : "badge-het-mon";
                        %>
                        <tr>
                            <td class="align-middle"><%= i + 1 %></td>
                            <td class="align-middle"><i class="far fa-calendar-alt"></i> **<%= ngay %>**</td>
                            <td class="align-middle"><strong><%= tenMon %></strong></td>
                            <td class="align-middle"><span class="badge badge-info"><%= tenQuay %></span></td>
                            <td class="align-middle"><span class="text-success"><%= currencyFormatter.format(gia) %></span></td>
                            <td class="align-middle"><span class="badge <%= badgeClass %>"><%= trangThai %></span></td>
                            <td class="align-middle text-center">
                                <button type="button" class="btn btn-sm btn-warning"
                                        onclick="editMenuNgay('<%= maQuay %>', '<%= ngay %>')">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
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
        </div>
    </div>

    <%-- ========================================================= --%>
    <%-- 2. FORM THIẾT LẬP MENU (DETAIL/CREATE/UPDATE VIEW) --%>
    <%-- ========================================================= --%>
    <div id="detailView" style="display: none;">

        <button type="button" class="btn btn-outline-secondary mb-3" onclick="showListView()">
            <i class="fas fa-arrow-left"></i> Quay lại Danh sách Menu
        </button>

        <form id="menuNgayForm" method="POST" action="<%= contextPath %>/MenuNgayServlet">
            <input type="hidden" name="action" value="saveMenu">

            <div class="card menu-header-card p-4 mb-4">
                <h4 class="mb-4 pb-2 border-bottom">
                    <i class="fas fa-edit text-warning"></i> Thiết Lập Menu Ngày
                </h4>
                <div class="row align-items-center">
                    <%-- 1. Chọn Quầy --%>
                    <div class="col-md-5 form-group">
                        <label class="filter-label" for="maQuayDetail">
                            <i class="fas fa-store"></i> Quầy Bán
                        </label>
                        <select class="form-control custom-select" id="maQuayDetail" name="maQuay" required onchange="loadMenuContent()">
                            <option value="">-- Chọn Quầy --</option>
                            <% for (Map.Entry<Integer, String> entry : mockQuaysMap.entrySet()) { %>
                            <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                            <% } %>
                        </select>
                    </div>

                    <%-- 2. Chọn Ngày --%>
                    <div class="col-md-4 form-group">
                        <label class="filter-label" for="ngayMenuDetail">
                            <i class="fas fa-calendar-day"></i> Ngày Áp Dụng
                        </label>
                        <input type="date"
                               class="form-control"
                               id="ngayMenuDetail"
                               name="ngayMenu"
                               value="<%= today.format(dateFormatter) %>"
                               onchange="loadMenuContent()"
                               required>
                    </div>

                    <%-- 3. Nút tải dữ liệu (Chỉ là hình thức, logic nằm ở onchange) --%>
                    <div class="col-md-3 form-group d-flex align-items-end">
                        <button type="button" class="btn btn-primary btn-block" onclick="loadMenuContent()">
                            <i class="fas fa-sync-alt"></i> Tải Menu
                        </button>
                    </div>
                </div>
            </div>

            <div id="menuContent" class="row">

                <%-- Cột 1: Món Ăn Có Sẵn --%>
                <div class="col-md-6">
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">
                                <i class="fas fa-list-ul text-info"></i> Danh Sách Món Ăn Có Sẵn
                                <span class="badge badge-secondary ml-2" id="availableCount">0</span>
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="list-header d-flex justify-content-between">
                                <span><input type="checkbox" id="checkAllAvailable" onclick="toggleCheckAll()"> Chọn Tất Cả</span>
                                <span>Giá</span>
                            </div>
                            <div class="scrollable-list">
                                <ul class="list-group list-group-flush" id="availableItemsList">
                                    <%-- Nội dung được tải bằng JS --%>
                                </ul>
                            </div>
                        </div>
                        <div class="card-footer d-flex justify-content-between">
                            <button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="#addMonModal" id="btnThemMonMoi">
                                <i class="fas fa-plus-circle"></i> Thêm Món Mới
                            </button>
                            <button type="button" class="btn btn-success" onclick="moveSelectedToMenu()">
                                <i class="fas fa-arrow-right"></i> Thêm đã chọn
                            </button>
                        </div>
                    </div>
                </div>

                <%-- Cột 2: Menu Ngày Đã Chọn --%>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-warning text-dark">
                            <h5 class="mb-0">
                                <i class="fas fa-clipboard-list"></i> Menu Đã Thiết Lập
                                <span class="badge badge-dark ml-2" id="selectedCount">0</span>
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="list-header d-flex justify-content-between">
                                <span>Món Ăn</span>
                                <span style="width: 150px;">Trạng Thái</span>
                            </div>
                            <div class="scrollable-list">
                                <ul class="list-group list-group-flush" id="selectedItemsList">
                                    <%-- Nội dung được tải bằng JS --%>
                                </ul>
                            </div>
                        </div>
                        <div class="card-footer text-right">
                            <button type="submit" class="btn btn-lg btn-success">
                                <i class="fas fa-save"></i> LƯU VÀ CẬP NHẬT MENU NGÀY
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>

    </div>
</div>

<div class="modal fade" id="addMonModal" tabindex="-1" role="dialog" aria-labelledby="addMonModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="addMonModalLabel">
                    <i class="fas fa-plus-circle"></i> Thêm Món Ăn Mới
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p class="text-muted">Món mới sẽ được thêm vào **Bảng Món Ăn** và **Menu Ngày** hiện tại.</p>
                <div class="form-group">
                    <label for="newTenMon">Tên Món <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="newTenMon" required>
                </div>
                <div class="form-group">
                    <label for="newGia">Giá (VNĐ) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="newGia" min="1000" step="1000" required>
                </div>
                <div class="form-group">
                    <label for="newMoTa">Mô Tả (Tùy chọn)</label>
                    <textarea class="form-control" id="newMoTa" rows="2"></textarea>
                </div>
                <div class="form-group">
                    <label class="filter-label">Quầy Món Ăn:</label>
                    <div class="alert alert-info py-2 mb-0">
                        <i class="fas fa-store"></i> <strong id="selectedQuayName"></strong>
                    </div>
                    <small class="text-muted">Món mới sẽ được gán vĩnh viễn cho quầy này.</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-success" onclick="addAndSelectNewMon()">
                    <i class="fas fa-check"></i> Lưu & Thêm vào Menu
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // --- KHỐI TẠO DỮ LIỆU JS TỪ JAVA (ĐÃ XÓA escapeJson) ---
    <%
        // TẠO JSON DỮ LIỆU MÓN CÓ SẴN (RAW STRING)
        StringBuilder jsonAvailable = new StringBuilder("[");
        for (int i = 0; i < mockMonAnAvailable.size(); i++) {
            String[] mon = mockMonAnAvailable.get(i);
            // SỬ DỤNG mon[i] TRỰC TIẾP (Chấp nhận rủi ro lỗi cú pháp JS nếu có dấu ")
            jsonAvailable.append(String.format("[\"%s\",\"%s\",\"%s\"]",
                mon[0],
                mon[1],
                mon[2]
            ));
            if (i < mockMonAnAvailable.size() - 1) jsonAvailable.append(",");
        }
        jsonAvailable.append("]");

        // TẠO JSON DỮ LIỆU MÓN ĐÃ CHỌN (RAW STRING)
        StringBuilder jsonSelected = new StringBuilder("[");
        for (int i = 0; i < mockMonDaCo.size(); i++) {
            String[] mon = mockMonDaCo.get(i);
             // SỬ DỤNG mon[i] TRỰC TIẾP
            jsonSelected.append(String.format("[\"%s\",\"%s\",\"%s\",\"%s\"]",
                mon[0],
                mon[1],
                mon[2],
                mon[3]
            ));
            if (i < mockMonDaCo.size() - 1) jsonSelected.append(",");
        }
        jsonSelected.append("]");

        // TẠO JSON DỮ LIỆU TÊN QUẦY (RAW STRING)
        StringBuilder jsonQuayNames = new StringBuilder("{");
        int count = 0;
        for (Entry<Integer, String> entry : mockQuaysMap.entrySet()) {
             // SỬ DỤNG entry.getValue() TRỰC TIẾP
            jsonQuayNames.append(String.format("\"%s\":\"%s\"",
                entry.getKey(),
                entry.getValue()
            ));
            if (count < mockQuaysMap.size() - 1) jsonQuayNames.append(",");
            count++;
        }
        jsonQuayNames.append("}");
    %>

    // Khai báo các biến JavaScript sử dụng chuỗi JSON được xây dựng
    const mockDataAvailable = <%= jsonAvailable.toString() %>;
    const mockDataSelected = <%= jsonSelected.toString() %>;
    const mockQuayNames = <%= jsonQuayNames.toString() %>;

    // =================================================================
    // CÁC HÀM XỬ LÝ JAVASCRIPT
    // =================================================================

    const currencyFormatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

    // Hàm tạo HTML cho món đã được thêm vào Menu Ngày (JavaScript)
    function createSelectedMonItem(maMon, tenMon, giaRaw, trangThai) {
        const giaText = currencyFormatter.format(giaRaw);
        const selected = trangThai === 'Còn bán' ? 'selected' : '';
        const notSelected = trangThai === 'Hết món' ? 'selected' : '';

        return `
            <li class='list-group-item d-flex justify-content-between align-items-center'>
                <div style='flex-grow: 1;'>
                    <input type='hidden' name='maMonMenu[]' value="${maMon}">
                    <strong>${tenMon}</strong>
                    <small class='text-muted d-block'>Giá: ${giaText}</small>
                </div>
                <div class='d-flex align-items-center'>
                    <select class='form-control form-control-sm mr-2' name="trangThai_${maMon}" style='width: 120px;'>
                        <option value='Còn bán' ${selected}>Còn bán</option>
                        <option value='Hết món' ${notSelected}>Hết món</option>
                    </select>
                    <button type='button' class='btn btn-sm btn-danger' onclick="removeMon(this, '${maMon}')">
                        <i class='fas fa-trash-alt'></i>
                    </button>
                </div>
            </li>
         `;
    }

    // Hàm tạo HTML cho món có sẵn
    function createAvailableMonItem(maMon, tenMon, giaRaw) {
        const giaText = currencyFormatter.format(giaRaw);
        return `
            <li class="list-group-item d-flex justify-content-between align-items-center">
                <div>
                    <input type="checkbox" name="monAnAvailable" value="${maMon}" id="mon_${maMon}" class="mr-2 available-checkbox"
                        data-tenmon="${tenMon}" data-gia="${giaRaw}">
                    <label for="mon_${maMon}" class="mb-0 font-weight-bold">${tenMon}</label>
                </div>
                <span class="item-gia">${giaText}</span>
            </li>
        `;
    }

    function toggleCheckAll() {
        const checkAll = document.getElementById('checkAllAvailable');
        const checkboxes = document.querySelectorAll('.available-checkbox');

        checkboxes.forEach(checkbox => {
            checkbox.checked = checkAll.checked;
        });
    }

    function updateItemCount() {
        const availableCount = document.querySelectorAll('#availableItemsList li:not(.empty-message)').length;
        const selectedCount = document.querySelectorAll('#selectedItemsList li:not(.empty-message)').length;
        document.getElementById('availableCount').textContent = availableCount;
        document.getElementById('selectedCount').textContent = selectedCount;
    }

    function updateEmptyMessage(listId, message, iconClass) {
        const list = document.getElementById(listId);
        const currentItems = list.querySelectorAll('li:not(.empty-message)').length;

        list.querySelectorAll('.empty-message').forEach(el => el.remove());

        if (currentItems === 0) {
            const emptyHtml = `
                <li class="list-group-item text-center text-muted py-5 empty-message">
                    <i class="${iconClass} fa-3x mb-2" style="opacity: 0.5;"></i>
                    <p class="mb-0">${message}</p>
                </li>
            `;
            list.innerHTML = emptyHtml;
        }
        updateItemCount();
    }

    function moveSelectedToMenu() {
        const availableList = document.getElementById('availableItemsList');
        const selectedList = document.getElementById('selectedItemsList');
        const checkboxes = availableList.querySelectorAll('input[type="checkbox"]:checked');

        if (checkboxes.length === 0) {
            alert('Vui lòng chọn ít nhất một món để thêm vào Menu.');
            return;
        }

        checkboxes.forEach(checkbox => {
            const maMon = checkbox.value;
            const tenMon = checkbox.getAttribute('data-tenmon');
            const giaRaw = parseFloat(checkbox.getAttribute('data-gia'));
            const listItem = checkbox.closest('li');

            const newItemHtml = createSelectedMonItem(maMon, tenMon, giaRaw, 'Còn bán');

            listItem.remove();
            selectedList.insertAdjacentHTML('beforeend', newItemHtml);
        });

        document.getElementById('checkAllAvailable').checked = false;

        updateEmptyMessage('availableItemsList', 'Tất cả món đã được thêm vào Menu Ngày.', 'fa-check');
        updateEmptyMessage('selectedItemsList', 'Menu Ngày này đang trống.', 'fa-utensils');
    }

    function removeMon(button, maMon) {
        if (!confirm('Bạn có chắc muốn xóa món này khỏi Menu Ngày không? Món sẽ trở lại danh sách có sẵn.')) {
            return;
        }
        const listItem = button.closest('li');
        const tenMon = listItem.querySelector('strong').textContent;
        const giaRaw = 60000; // Mock giá trị thô

        listItem.remove();

        const availableList = document.getElementById('availableItemsList');
        const newAvailableItem = createAvailableMonItem(maMon, tenMon, giaRaw);
        availableList.insertAdjacentHTML('beforeend', newAvailableItem);

        updateEmptyMessage('availableItemsList', 'Tất cả món đã được thêm vào Menu Ngày.', 'fa-check');
        updateEmptyMessage('selectedItemsList', 'Menu Ngày này đang trống.', 'fa-utensils');
    }

    function addAndSelectNewMon() {
        const tenMon = document.getElementById('newTenMon').value;
        const gia = document.getElementById('newGia').value;

        if (!tenMon || !gia) {
            alert('Vui lòng nhập Tên Món và Giá.');
            return;
        }

        const newMaMon = 'NEW-' + Math.floor(Math.random() * 1000);
        const giaRaw = parseFloat(gia);

        const selectedList = document.getElementById('selectedItemsList');
        const newItemHtml = createSelectedMonItem(newMaMon, tenMon, giaRaw, 'Còn bán');
        selectedList.insertAdjacentHTML('beforeend', newItemHtml);

        $('#addMonModal').modal('hide');
        alert('Món "' + tenMon + '" đã được thêm vào Menu Ngày! Vui lòng nhấn LƯU để xác nhận.');

        document.getElementById('newTenMon').value = '';
        document.getElementById('newGia').value = '';
        document.getElementById('newMoTa').value = '';

        updateEmptyMessage('selectedItemsList', 'Menu Ngày này đang trống.', 'fa-utensils');
    }

    function loadMenuContent() {
        const maQuay = document.getElementById('maQuayDetail').value;
        const ngayMenu = document.getElementById('ngayMenuDetail').value;
        const quayDropdown = document.getElementById('maQuayDetail');
        const quayName = quayDropdown.options[quayDropdown.selectedIndex].text;

        if (!maQuay || !ngayMenu || maQuay === '') {
            return;
        }

        document.getElementById('selectedQuayName').textContent = quayName;

        const availableList = document.getElementById('availableItemsList');
        const selectedList = document.getElementById('selectedItemsList');

        availableList.innerHTML = '';
        selectedList.innerHTML = '';

        // Tải món có sẵn
        mockDataAvailable.forEach(mon => {
            // [MaMon, TenMon, Gia]
            const maMon = mon[0];
            const tenMon = mon[1];
            const giaRaw = parseFloat(mon[2]);
            availableList.insertAdjacentHTML('beforeend', createAvailableMonItem(maMon, tenMon, giaRaw));
        });

        // Tải món đã chọn
        mockDataSelected.forEach(mon => {
            // [MaMon, TenMon, Gia, TrangThai]
            const maMon = mon[0];
            const tenMon = mon[1];
            const giaRaw = parseFloat(mon[2]);
            const trangThai = mon[3];
            selectedList.insertAdjacentHTML('beforeend', createSelectedMonItem(maMon, tenMon, giaRaw, trangThai));
        });

        updateEmptyMessage('availableItemsList', 'Tất cả món đã được thêm vào Menu Ngày.', 'fa-check');
        updateEmptyMessage('selectedItemsList', 'Menu Ngày này đang trống.', 'fa-utensils');

        console.log(`Đã tải Mock Menu cho: ${quayName} vào ngày ${ngayMenu}`);
    }

    // Nút "Thêm Menu Ngày Mới" (Ẩn/Hiện form)
    function showMenuForm() {
        document.getElementById('listView').style.display = 'none';
        document.getElementById('detailView').style.display = 'block';

        // Thiết lập giá trị mặc định khi thêm mới (Quầy 1, Ngày hiện tại)
        document.getElementById('maQuayDetail').value = '1';
        document.getElementById('ngayMenuDetail').value = '<%= today.format(dateFormatter) %>';
        loadMenuContent();
    }

    // Nút "Sửa" trong List View (Ẩn/Hiện form và điền dữ liệu)
    function editMenuNgay(maQuay, ngayHienThi) {
        document.getElementById('listView').style.display = 'none';
        document.getElementById('detailView').style.display = 'block';

        // Chuyển đổi định dạng ngày từ DD/MM/YYYY sang YYYY-MM-DD
        const parts = ngayHienThi.split('/');
        const ngayFormatted = `${parts[2]}-${parts[1]}-${parts[0]}`;

        // Điền giá trị vào form chi tiết
        document.getElementById('maQuayDetail').value = maQuay;
        document.getElementById('ngayMenuDetail').value = ngayFormatted;

        loadMenuContent();
    }

    // Chuyển về List View
    function showListView() {
        document.getElementById('detailView').style.display = 'none';
        document.getElementById('listView').style.display = 'block';
    }

    // Khởi tạo ban đầu
    document.addEventListener('DOMContentLoaded', function() {
        // Không cần loadMenuContent() ở đây vì detailView mặc định là none.
    });
</script>