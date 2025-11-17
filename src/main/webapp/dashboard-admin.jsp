<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // ✅ Lấy dữ liệu thống kê từ request
    Integer totalMonAn = (Integer) request.getAttribute("totalMonAn");
    Integer totalQuay = (Integer) request.getAttribute("totalQuay");
    Integer totalTaiKhoan = (Integer) request.getAttribute("totalTaiKhoan");

    // Null safety
    if (totalMonAn == null) totalMonAn = 0;
    if (totalQuay == null) totalQuay = 0;
    if (totalTaiKhoan == null) totalTaiKhoan = 0;

    // TODO: Khi có service đơn hàng
    // Long totalDonHang = (Long) request.getAttribute("totalDonHang");
    // Double totalDoanhThu = (Double) request.getAttribute("totalDoanhThu");
%>

<div id="dashboard">
    <h3 class="mb-4">Tổng Quan Hệ Thống</h3>

    <div class="row">
        <div class="col-md-4">
            <div class="card p-3 text-center" id="card-doanhthu">
                <p class="card-title">Doanh Thu Tháng</p>
                <p class="card-value">
                    <i class="fas fa-dollar-sign"></i>
                    25.600.000₫
                </p>
                <small class="text-white-50">Coming soon...</small>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3 text-center" id="card-donhang">
                <p class="card-title">Tổng Đơn Hàng</p>
                <p class="card-value">
                    <i class="fas fa-shopping-cart"></i> 342
                </p>
                <small class="text-white-50">Coming soon...</small>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3 text-center" id="card-monan">
                <p class="card-title">Tổng Món Ăn</p>
                <p class="card-value">
                    <i class="fas fa-hamburger"></i> <%= totalMonAn %>
                </p>
            </div>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-3 text-center">
                <h5><i class="fas fa-store"></i> Quầy</h5>
                <h2 class="text-primary"><%= totalQuay %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3 text-center">
                <h5><i class="fas fa-users"></i> Tài Khoản</h5>
                <h2 class="text-success"><%= totalTaiKhoan %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3 text-center">
                <h5><i class="fas fa-calendar"></i> Menu Hôm Nay</h5>
                <h2 class="text-info">-</h2>
                <small class="text-muted">Coming soon...</small>
            </div>
        </div>
    </div>
</div>