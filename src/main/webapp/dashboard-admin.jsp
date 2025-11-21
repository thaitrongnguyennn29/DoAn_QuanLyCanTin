<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="DTO.ThongKeDTO"%>
<%@ page import="DTO.ThongKeTongQuatDTO"%>

<%
    // 1. Lấy dữ liệu từ Servlet truyền sang
    ThongKeTongQuatDTO tkTong = (ThongKeTongQuatDTO) request.getAttribute("thongKeTong");
    List<ThongKeDTO> listDoanhThu = (List<ThongKeDTO>) request.getAttribute("dataDoanhThu");
    List<ThongKeDTO> listTopQuay = (List<ThongKeDTO>) request.getAttribute("dataTopQuay");

    // 2. Null Safety (Tránh lỗi nếu dữ liệu chưa có)
    if (tkTong == null) tkTong = new ThongKeTongQuatDTO();
    if (listDoanhThu == null) listDoanhThu = new ArrayList<>();
    if (listTopQuay == null) listTopQuay = new ArrayList<>();

    // 3. Formatter tiền tệ VN
    NumberFormat vnMoney = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    /* === CSS CHUYÊN NGHIỆP === */
    .dashboard-header {
        margin-bottom: 25px;
    }
    .dashboard-title {
        font-size: 1.8rem;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    .dashboard-subtitle {
        color: #7f8c8d;
        font-size: 0.95rem;
    }

    /* Card thống kê (KPIs) */
    .kpi-card {
        border: none;
        border-radius: 12px;
        padding: 20px;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        height: 100%;
    }
    .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }
    /* Màu Gradient cho từng card */
    .bg-gradient-primary { background: linear-gradient(45deg, #4e73df, #224abe); }
    .bg-gradient-success { background: linear-gradient(45deg, #1cc88a, #13855c); }
    .bg-gradient-info    { background: linear-gradient(45deg, #36b9cc, #258391); }

    .kpi-icon {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 3rem;
        opacity: 0.3;
    }
    .kpi-title {
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-weight: 600;
        margin-bottom: 5px;
        opacity: 0.9;
    }
    .kpi-value {
        font-size: 1.8rem;
        font-weight: 700;
    }

    /* Container Biểu đồ */
    .chart-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 25px;
        height: 100%; /* Để canh đều chiều cao */
    }
    .chart-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        border-bottom: 1px solid #f1f1f1;
        padding-bottom: 10px;
    }
    .chart-title {
        font-weight: 700;
        color: #4e73df;
        margin: 0;
        font-size: 1.1rem;
    }
</style>

<div class="container-fluid">

    <div class="dashboard-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="dashboard-title"><i class="fas fa-tachometer-alt"></i> Tổng Quan Hệ Thống</h1>
        </div>
        <div>
            <a href="<%= request.getContextPath() %>/ExportExcel" class="btn btn-success shadow-sm">
                <i class="fas fa-file-excel mr-2"></i> Xuất Báo Cáo Excel
            </a>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-xl-4 col-md-6 mb-4">
            <div class="kpi-card bg-gradient-primary">
                <div class="kpi-title">Tổng Doanh Thu</div>
                <div class="kpi-value"><%= vnMoney.format(tkTong.getTongDoanhThu()) %></div>
                <div class="kpi-icon"><i class="fas fa-dollar-sign"></i></div>
            </div>
        </div>

        <div class="col-xl-4 col-md-6 mb-4">
            <div class="kpi-card bg-gradient-success">
                <div class="kpi-title">Đơn Hàng Hoàn Thành</div>
                <div class="kpi-value"><%= tkTong.getTongDonHang() %> <small style="font-size: 1rem; font-weight: 400;">đơn</small></div>
                <div class="kpi-icon"><i class="fas fa-shopping-bag"></i></div>
            </div>
        </div>

        <div class="col-xl-4 col-md-6 mb-4">
            <div class="kpi-card bg-gradient-info">
                <div class="kpi-title">Thành Viên</div>
                <div class="kpi-value"><%= tkTong.getTongThanhVien() %> <small style="font-size: 1rem; font-weight: 400;">người</small></div>
                <div class="kpi-icon"><i class="fas fa-users"></i></div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-8 col-lg-7">
            <div class="chart-card">
                <div class="chart-header">
                    <h6 class="chart-title">Biểu Đồ Doanh Thu (7 Ngày Gần Nhất)</h6>
                </div>
                <div class="chart-body" style="position: relative; height: 350px;">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-xl-4 col-lg-5">
            <div class="chart-card">
                <div class="chart-header">
                    <h6 class="chart-title">Top Quầy Bán Chạy (Thị Phần)</h6>
                </div>
                <div class="chart-body" style="position: relative; height: 350px; display: flex; justify-content: center;">
                    <canvas id="topStallChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // --- 1. PREPARE DATA (JAVA -> JS) ---
    // Dữ liệu Doanh thu
    const labelsRevenue = [];
    const dataRevenue = [];
    <% for(ThongKeDTO item : listDoanhThu) { %>
    labelsRevenue.push("<%= item.getLabel() %>");
    dataRevenue.push(<%= item.getValue() %>);
    <% } %>

    // Dữ liệu Top Quầy
    const labelsStall = [];
    const dataStall = [];
    <% for(ThongKeDTO item : listTopQuay) { %>
    labelsStall.push("<%= item.getLabel() %>");
    dataStall.push(<%= item.getValue() %>);
    <% } %>

    // --- 2. CONFIG CHART JS ---

    // Config chung cho Font chữ đẹp hơn
    Chart.defaults.font.family = "'Segoe UI', 'Helvetica', 'Arial', sans-serif";
    Chart.defaults.color = '#858796';

    // === CHART 1: DOANH THU (Area Line) ===
    const ctxRevenue = document.getElementById('revenueChart').getContext('2d');

    // Tạo màu Gradient cho đẹp (Mờ dần từ trên xuống)
    const gradientRevenue = ctxRevenue.createLinearGradient(0, 0, 0, 400);
    gradientRevenue.addColorStop(0, 'rgba(78, 115, 223, 0.5)'); // Màu đậm ở trên
    gradientRevenue.addColorStop(1, 'rgba(78, 115, 223, 0.0)'); // Trong suốt ở dưới

    new Chart(ctxRevenue, {
        type: 'line',
        data: {
            labels: labelsRevenue,
            datasets: [{
                label: "Doanh thu",
                data: dataRevenue,
                backgroundColor: gradientRevenue, // Vùng màu bên dưới
                borderColor: "#4e73df",           // Màu đường kẻ
                pointBackgroundColor: "#4e73df",
                pointBorderColor: "#fff",
                pointHoverBackgroundColor: "#fff",
                pointHoverBorderColor: "#4e73df",
                fill: true,                       // Bật chế độ tô màu vùng dưới
                tension: 0.4,                     // Độ cong của đường (0.4 là mềm mại)
                pointRadius: 4,
                pointHoverRadius: 6
            }]
        },
        options: {
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }, // Ẩn chú thích vì chỉ có 1 đường
                tooltip: {
                    backgroundColor: "rgb(255,255,255)",
                    bodyColor: "#858796",
                    titleColor: "#6e707e",
                    borderColor: '#dddfeb',
                    borderWidth: 1,
                    padding: 10,
                    displayColors: false,
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) { label += ': '; }
                            // Format tiền tệ trong tooltip
                            label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                            return label;
                        }
                    }
                }
            },
            scales: {
                x: { grid: { display: false, drawBorder: false } },
                y: {
                    ticks: {
                        callback: function(value) {
                            // Rút gọn số tiền trên trục Y (Ví dụ: 1tr, 500k...)
                            if (value >= 1000000) return (value/1000000) + 'tr';
                            if (value >= 1000) return (value/1000) + 'k';
                            return value;
                        }
                    },
                    grid: { color: "rgb(234, 236, 244)", borderDash: [2], drawBorder: false }
                }
            }
        }
    });

    // === CHART 2: TOP QUẦY (Doughnut) ===
    const ctxStall = document.getElementById('topStallChart').getContext('2d');
    new Chart(ctxStall, {
        type: 'doughnut',
        data: {
            labels: labelsStall,
            datasets: [{
                data: dataStall,
                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b'],
                hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf', '#dda20a', '#be2617'],
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }]
        },
        options: {
            maintainAspectRatio: false,
            cutout: '75%', // Độ rộng của lỗ tròn ở giữa (75% là thanh mảnh đẹp)
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { padding: 20, usePointStyle: true }
                },
                tooltip: {
                    backgroundColor: "rgb(255,255,255)",
                    bodyColor: "#858796",
                    borderColor: '#dddfeb',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            let label = context.label || '';
                            let value = context.parsed || 0;
                            // Format tiền tệ
                            let money = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                            return label + ': ' + money;
                        }
                    }
                }
            }
        }
    });
</script>