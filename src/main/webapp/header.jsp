<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Căn Tin VN - <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Trang Chủ" %></title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="trangchu">
            <i class="bi bi-cup-hot-fill"></i> NTC Cateen
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <a class="nav-link <%= "Trang Chủ".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="trangchu">Trang Chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Thực Đơn".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="thucdon">Thực Đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Theo Dõi Đơn Hàng".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="#">Theo Dõi Đơn Hàng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Giới Thiệu".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="#">Giới Thiệu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Liên Hệ".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="#">Liên Hệ</a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <a href="#" class="text-dark position-relative">
                    <i class="bi bi-cart3 fs-5"></i>
                    <span class="cart-badge" id="cartCount">0</span>
                </a>
                <button class="btn btn-gradient" href = "dangnhap">Đăng Nhập</button>
            </div>
        </div>
    </div>
</nav>
