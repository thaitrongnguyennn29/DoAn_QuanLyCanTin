<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="Model.MonAn"%>
<%@ page import="DTO.MenuNgayDTO"%>
<%@ page import="Model.Page"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.util.ArrayList"%>

<%
    String contextPath = request.getContextPath();

    // 1. Null Safety cho các biến Server
    Object dsMonObj = request.getAttribute("danhSachMon");
    List<MonAn> danhSachMon = (dsMonObj instanceof List) ? (List<MonAn>) dsMonObj : new ArrayList<>();

    Object maQuayObj = request.getAttribute("maQuay");
    int maQuay = (maQuayObj != null) ? (Integer) maQuayObj : 1;

    Object tenQuayObj = request.getAttribute("tenQuay");
    String tenQuay = (tenQuayObj != null) ? (String) tenQuayObj : "Quầy Cơm";

    Page<MenuNgayDTO> menuPage = (Page<MenuNgayDTO>) request.getAttribute("menuPage");

    // 2. Formatter
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String todayStr = LocalDate.now().toString();
%>

<style>
    .page-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
    .dish-item { display: flex; align-items: center; padding: 12px; margin-bottom: 10px; border: 2px solid #e9ecef; border-radius: 8px; cursor: pointer; transition: 0.3s; }
    .dish-item:hover { border-color: #667eea; background-color: #f8f9ff; transform: translateX(5px); }
    .dish-item.disabled { opacity: 0.5; cursor: not-allowed; background-color: #eee; pointer-events: none; }
    .dish-item img { width: 50px; height: 50px; object-fit: cover; border-radius: 5px; margin-right: 15px; }
    .selected-dish .remove-btn { color: #dc3545; cursor: pointer; margin-left: auto; font-size: 1.2rem; }
    .menu-list { height: 600px; overflow-y: auto; border: 1px solid #ddd; border-radius: 5px; padding: 15px; background: #fff; }
    .state-container { display: none; }
    .state-container.active { display: block; }
</style>

<div id="quanlymenungay">
    <div id="state-1" class="state-container active">
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-0"><i class="fas fa-calendar-plus"></i> Tạo / Cập Nhật Menu</h2>
                <p class="mb-0 mt-1">Chọn ngày và món ăn. Nếu ngày đã có menu, hệ thống sẽ ghi đè.</p>
            </div>
            <div>
                <button type="button" class="btn btn-light mr-2" onclick="showAddMonAnForm()">
                    <i class="fas fa-plus"></i> Thêm Món Nhanh
                </button>
                <button type="button" class="btn btn-warning" onclick="showState2()">
                    <i class="fas fa-list"></i> Xem Danh Sách
                </button>
            </div>
        </div>

        <div id="monan-form-container" class="card p-4 mb-4" style="display:none; border-left: 5px solid #28a745;">
            <h5 class="text-success mb-3">Thêm Món Ăn Mới Vào Kho</h5>
            <form action="<%= contextPath %>/MonAnServlet?origin=seller" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="ADD">
                <input type="hidden" name="maQuay" value="<%= maQuay %>">
                <div class="form-row">
                    <div class="col-md-4"><input type="text" class="form-control" name="tenMon" placeholder="Tên món" required></div>
                    <div class="col-md-3"><input type="number" class="form-control" name="gia" placeholder="Giá" required></div>
                    <div class="col-md-3"><input type="file" class="form-control-file" name="hinhAnh"></div>
                    <div class="col-md-2"><button type="submit" class="btn btn-success btn-block">Lưu</button></div>
                </div>
            </form>
        </div>

        <form id="menuForm" action="<%= contextPath %>/MenuNgayServlet" method="POST">
            <input type="hidden" name="action" value="SAVE">
            <input type="hidden" name="maQuay" value="<%= maQuay %>">
            <input type="hidden" name="ngay" id="selectedNgay" value="<%= todayStr %>">

            <div id="selectedDishesInput"></div>

            <div class="card mb-3 p-3 shadow-sm">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <label class="font-weight-bold">Ngày áp dụng:</label>
                        <input type="date" class="form-control" id="dateInput" value="<%= todayStr %>" onchange="onDateChange()">
                    </div>
                    <div class="col-md-4">
                        <label class="font-weight-bold">Quầy:</label>
                        <div class="form-control bg-light text-primary font-weight-bold"><%= tenQuay %></div>
                    </div>
                    <div class="col-md-4 text-right">
                        <button type="submit" class="btn btn-success btn-lg mt-4 shadow">
                            <i class="fas fa-save"></i> Lưu Menu
                        </button>
                    </div>
                </div>
            </div>
        </form>

        <div class="row">
            <div class="col-md-6">
                <div class="menu-list shadow-sm">
                    <h5 class="text-primary border-bottom pb-2">Món Ăn Trong Kho</h5>
                    <div id="availableDishes">
                        <% for (MonAn mon : danhSachMon) {
                            if (mon == null) continue;
                            String img = (mon.getHinhAnh() != null) ? contextPath + "/assets/images/MonAn/" + mon.getHinhAnh() : contextPath + "/assets/images/no-image.png";
                        %>
                        <div class="dish-item" id="dish-<%= mon.getMaMonAn() %>" onclick="addToMenu(<%= mon.getMaMonAn() %>)">
                            <img src="<%= img %>" onerror="this.src='<%= contextPath %>/assets/images/no-image.png'">
                            <div class="flex-grow-1">
                                <div class="font-weight-bold"><%= mon.getTenMonAn() %></div>
                                <div class="text-success"><%= currencyFormatter.format(mon.getGia()) %></div>
                            </div>
                            <i class="fas fa-plus-circle text-primary fa-lg"></i>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="menu-list bg-light shadow-sm">
                    <h5 class="text-success border-bottom pb-2">Menu Đã Chọn (<span id="count">0</span>)</h5>
                    <div id="selectedDishesContainer">
                        <p class="text-center text-muted mt-5">Chưa có món nào được chọn</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="state-2" class="state-container">
        <div class="page-header">
            <h2 class="mb-0"><i class="fas fa-list"></i> Danh Sách Menu Đã Tạo</h2>
            <button class="btn btn-light mt-3" onclick="showState1()">
                <i class="fas fa-arrow-left"></i> Quay lại tạo mới
            </button>
        </div>

        <div class="card shadow-sm p-3">
            <form action="<%= contextPath %>/Seller" method="GET" class="row align-items-end">
                <input type="hidden" name="page" value="quanlymenungay">
                <input type="hidden" name="view" value="list">

                <div class="col-md-3"><label>Từ ngày</label><input type="date" class="form-control" name="tuNgay"></div>
                <div class="col-md-3"><label>Đến ngày</label><input type="date" class="form-control" name="denNgay"></div>
                <div class="col-md-2"><button type="submit" class="btn btn-primary btn-block">Lọc</button></div>
                <div class="col-md-4 text-right"><span>Tổng: <strong><%= (menuPage!=null)?menuPage.getTotalItems():0 %></strong> menu</span></div>
            </form>

            <table class="table table-hover mt-3">
                <thead class="thead-light">
                <tr>
                    <th>Ngày</th>
                    <th>Số món</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% if (menuPage != null && menuPage.getData() != null) {
                    for (MenuNgayDTO dto : menuPage.getData()) { %>
                <tr>
                    <td class="align-middle font-weight-bold"><%= dto.getNgay().format(dateFormatter) %></td>
                    <td class="align-middle"><span class="badge badge-info"><%= dto.getSoMon() %> món</span></td>
                    <td class="align-middle text-center">
                        <a href="<%= contextPath %>/MenuNgayServlet?action=DELETE&ngay=<%= dto.getNgay() %>&maQuay=<%= maQuay %>"
                           class="btn btn-sm btn-danger" onclick="return confirm('Xóa menu ngày này?')">
                            <i class="fas fa-trash"></i> Xóa
                        </a>
                    </td>
                </tr>
                <% }} else { %>
                <tr><td colspan="3" class="text-center py-3">Chưa có dữ liệu</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    /* --- KHỞI TẠO DỮ LIỆU AN TOÀN CHO JS --- */
    var allDishes = [
        <% for (MonAn mon : danhSachMon) {
             if (mon != null) {
                 // Xử lý chuỗi để tránh lỗi Syntax JS
                 String safeName = (mon.getTenMonAn()!=null) ? mon.getTenMonAn().replace("\"", "\\\"").replace("\r", "").replace("\n", "") : "";
                 String safeImg = (mon.getHinhAnh()!=null) ? contextPath+"/assets/images/MonAn/"+mon.getHinhAnh() : contextPath+"/assets/images/no-image.png";
        %>
        {
            id: <%= mon.getMaMonAn() %>,
            name: "<%= safeName %>",
            price: "<%= currencyFormatter.format(mon.getGia()) %>",
            img: "<%= safeImg %>"
        },
        <% }} %>
    ];

    var selectedIds = [];

    // Khi trang load xong
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        // Logic chuyển đổi view đơn giản
        if (urlParams.get('view') === 'list') {
            document.getElementById('state-1').classList.remove('active');
            document.getElementById('state-2').classList.add('active');
        } else {
            document.getElementById('state-1').classList.add('active');
            document.getElementById('state-2').classList.remove('active');
        }
    });

    // Điều hướng
    function showState2() { window.location.href = '<%= contextPath %>/Seller?page=quanlymenungay&view=list'; }
    function showState1() { window.location.href = '<%= contextPath %>/Seller?page=quanlymenungay'; }
    function showAddMonAnForm() { document.getElementById('monan-form-container').style.display = 'block'; }
    function onDateChange() { document.getElementById('selectedNgay').value = document.getElementById('dateInput').value; }

    // Core Logic Thêm/Xóa Món (Đã fix lỗi thêm món)
    function addToMenu(id) {
        var numericId = parseInt(id);
        if (!selectedIds.includes(numericId)) {
            selectedIds.push(numericId);
            render();
        }
    }

    function removeFromMenu(id) {
        var numericId = parseInt(id);
        selectedIds = selectedIds.filter(function(x){ return x !== numericId; });
        render();
    }

    function render() {
        var container = document.getElementById('selectedDishesContainer');
        var inputContainer = document.getElementById('selectedDishesInput');
        var countSpan = document.getElementById('count');

        container.innerHTML = '';
        inputContainer.innerHTML = '';

        if (selectedIds.length === 0) {
            container.innerHTML = '<p class="text-center text-muted mt-5">Chưa có món nào được chọn</p>';
        } else {
            selectedIds.forEach(function(id) {
                var dish = allDishes.find(function(d){ return d.id === id; });
                if (dish) {
                    // Dùng cộng chuỗi an toàn
                    var html =
                        '<div class="dish-item bg-white border shadow-sm p-2 mb-2 d-flex align-items-center">' +
                        '<img src="' + dish.img + '" style="width:50px;height:50px;object-fit:cover;border-radius:5px;margin-right:10px;">' +
                        '<div class="flex-grow-1"><b>' + dish.name + '</b><br><small>' + dish.price + '</small></div>' +
                        '<div onclick="removeFromMenu(' + dish.id + ')" style="cursor:pointer;color:red;"><i class="fas fa-times-circle"></i></div>' +
                        '</div>';
                    container.innerHTML += html;

                    // Tạo input hidden
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'danhSachMaMon[]';
                    input.value = id;
                    inputContainer.appendChild(input);
                }
            });
        }

        if(countSpan) countSpan.innerText = selectedIds.length;

        // Cập nhật giao diện bên trái (Mờ đi các món đã chọn)
        allDishes.forEach(function(d) {
            var el = document.getElementById('dish-' + d.id);
            if (el) {
                if (selectedIds.includes(d.id)) {
                    el.style.opacity = '0.5';
                    el.style.pointerEvents = 'none';
                } else {
                    el.style.opacity = '1';
                    el.style.pointerEvents = 'auto';
                }
            }
        });
    }

    // Thông báo
    <% if (session.getAttribute("message") != null) { %>
    setTimeout(function() { alert("<%= session.getAttribute("message") %>"); }, 200);
    <% session.removeAttribute("message"); %>
    <% } %>
    <% if (session.getAttribute("error") != null) { %>
    setTimeout(function() { alert("<%= session.getAttribute("error") %>"); }, 200);
    <% session.removeAttribute("error"); %>
    <% } %>
</script>
</div>