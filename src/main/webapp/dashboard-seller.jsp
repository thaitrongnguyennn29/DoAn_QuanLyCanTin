<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="DTO.ThongKeDTO" %> <%
    // 1. Lấy dữ liệu từ Servlet truyền sang
    // Ép kiểu về List<ThongKeDTO>
    List<ThongKeDTO> listDoanhThu = (List<ThongKeDTO>) request.getAttribute("dataDoanhThu");
    List<ThongKeDTO> listTopMon = (List<ThongKeDTO>) request.getAttribute("dataTopMon");
%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="row">
    <div class="col-md-8">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Doanh thu 7 ngày qua</h6>
            </div>
            <div class="card-body">
                <div class="chart-bar">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Top món bán chạy</h6>
            </div>
            <div class="card-body">
                <div class="chart-pie pt-4 pb-2">
                    <canvas id="topProductChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // --- 1. XỬ LÝ DỮ LIỆU DOANH THU (Java -> JS) ---
    const labelsRev = [];
    const dataRev = [];

    <%
       // Kiểm tra null để tránh lỗi
       if (listDoanhThu != null) {
           for (ThongKeDTO item : listDoanhThu) {
    %>
    // Đoạn này là JavaScript, nhưng được chèn dữ liệu từ Java
    labelsRev.push("<%= item.getLabel() %>"); // In ra ngày
    dataRev.push(<%= item.getValue() %>);     // In ra tiền
    <%
           }
       }
    %>

    // Vẽ biểu đồ cột
    const ctxRev = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctxRev, {
        type: 'bar',
        data: {
            labels: labelsRev,
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: dataRev,
                backgroundColor: '#4e73df',
                hoverBackgroundColor: '#2e59d9',
                borderColor: '#4e73df',
                borderWidth: 1
            }]
        },
        options: {
            maintainAspectRatio: false,
            scales: { y: { beginAtZero: true } }
        }
    });

    // --- 2. XỬ LÝ DỮ LIỆU TOP MÓN (Java -> JS) ---
    const labelsTop = [];
    const dataTop = [];

    <%
       if (listTopMon != null) {
           for (ThongKeDTO item : listTopMon) {
    %>
    labelsTop.push("<%= item.getLabel() %>"); // Tên món
    dataTop.push(<%= item.getValue() %>);     // Số lượng
    <%
           }
       }
    %>

    // Vẽ biểu đồ tròn
    const ctxTop = document.getElementById('topProductChart').getContext('2d');
    new Chart(ctxTop, {
        type: 'doughnut',
        data: {
            labels: labelsTop,
            datasets: [{
                data: dataTop,
                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b'],
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }]
        },
        options: {
            maintainAspectRatio: false,
            cutout: '80%',
        }
    });
</script>