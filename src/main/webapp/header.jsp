<%@ page import="Model.GioHang" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.TaiKhoan" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // 1. Lấy số lượng giỏ hàng
    List<GioHang> headerCart = (List<GioHang>) session.getAttribute("cart");
    int cartCount = (headerCart != null) ? headerCart.size() : 0;

    // 2. Lấy User từ Session ra
    TaiKhoan user = (TaiKhoan) session.getAttribute("user");
%>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NTC Canteen - <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Trang Chủ" %></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="trangchu">
            <i class="bi bi-fork-knife fs-4"></i>
            <span>NTC Canteen</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
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
                    <a class="nav-link <%= "Giới Thiệu".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="gioithieu">Giới Thiệu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Liên Hệ".equals(request.getAttribute("pageTitle")) ? "active" : "" %>" href="lienhe">Liên Hệ</a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <a href="giohang" class="cart text-dark position-relative" title="Giỏ hàng">
                    <i class="bi bi-cart3 fs-5"></i>
                    <span class="cart-badge"><%= cartCount %></span>
                </a>

                <%-- LOGIC JAVA SCRIPTLET --%>
                <% if (user == null) { %>
                <a href="dangnhap" class="btn btn-gradient px-4 py-2">Đăng Nhập</a>
                <% } else { %>
                <div class="dropdown">
                    <a class="nav-link d-flex align-items-center gap-2"
                       href="#"
                       role="button"
                       id="dropdownMenuButton"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">
                        <div class="rounded-circle d-flex justify-content-center align-items-center text-white"
                             style="width: 35px; height: 35px;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0"
                        aria-labelledby="dropdownMenuButton">
                        <!-- Header với tên người dùng -->
                        <li>
                            <h6 class="dropdown-header text-primary mb-0">
                                <i class="bi bi-person-circle me-2"></i>
                                <%= user.getTenNguoiDung() %>
                            </h6>
                        </li>
                        <li><hr class="dropdown-divider"></li>

                        <!-- Thông tin tài khoản -->
                        <li>
                            <a class="dropdown-item" href="thongtin-taikhoan">
                                <i class="bi bi-person-gear me-2"></i>
                                <span>Thông tin tài khoản</span>
                            </a>
                        </li>

                        <% String role = user.getVaiTro(); %>

                        <% if ("admin".equals(role)) { %>
                        <li>
                            <a class="dropdown-item" href="Admin">
                                <i class="bi bi-speedometer2 me-2"></i>
                                <span>Truy cập trang quản lý</span>
                            </a>
                        </li>
                        <% } else if ("seller".equals(role)) { %>
                        <li>
                            <a class="dropdown-item" href="#">
                                <i class="bi bi-shop me-2"></i>
                                <span>Truy cập trang bán hàng</span>
                            </a>
                        </li>
                        <% } %>

                        <li>
                            <a class="dropdown-item" href="donhang-cuatoi">
                                <i class="bi bi-bag-check me-2"></i>
                                <span>Xem đơn hàng của tôi</span>
                            </a>
                        </li>

                        <li>
                            <a class="dropdown-item" href="#">
                                <i class="bi bi-gear me-2"></i>
                                <span>Cài đặt</span>
                            </a>
                        </li>

                        <!-- Trợ giúp -->
                        <li>
                            <a class="dropdown-item" href="#">
                                <i class="bi bi-question-circle me-2"></i>
                                <span>Trợ giúp</span>
                            </a>
                        </li>

                        <li><hr class="dropdown-divider"></li>

                        <!-- Đăng xuất -->
                        <li>
                            <a class="dropdown-item text-danger" href="dangnhap?action=logout">
                                <i class="bi bi-box-arrow-right me-2"></i>
                                <span>Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </div>
                <% } %>
                <%-- KẾT THÚC LOGIC --%>
            </div>
        </div>
    </div>
</nav>