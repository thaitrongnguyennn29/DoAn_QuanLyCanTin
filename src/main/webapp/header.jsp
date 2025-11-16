<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NTC Canteen - <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Trang Chủ" %></title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top shadow-sm">
    <div class="container">
        <!-- Logo + Tên thương hiệu -->
        <a class="navbar-brand d-flex align-items-center gap-2" href="trangchu">
            <i class="bi bi-fork-knife fs-4"></i>
            <span>NTC Canteen</span>
        </a>

        <!-- Nút toggle cho mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menu chính -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <a class="nav-link <%= "Trang Chủ".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="trangchu">Trang Chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Thực Đơn".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="thucdon">Thực Đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Giới Thiệu".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="gioithieu">Giới Thiệu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Liên Hệ".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="lienhe">Liên Hệ</a>
                </li>
            </ul>

            <!-- Giỏ hàng + Đăng nhập -->
            <div class="d-flex align-items-center gap-3">
                <a href="giohang" class="cart text-dark position-relative" title="Giỏ hàng">
                    <i class="bi bi-cart3 fs-5"></i>
                    <span class="cart-badge">0</span>
                </a>
                <a href="dangnhap" class="btn btn-gradient px-4 py-2">Đăng Nhập</a>
            </div>
        </div>
    </div>
</nav>

