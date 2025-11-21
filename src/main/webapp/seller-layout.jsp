<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.TaiKhoan" %>

<%
    String contextPath = request.getContextPath();

    // SỬA 1: Đổi "taiKhoan" thành "user" cho khớp với Servlet/Filter
    Model.TaiKhoan tk = (Model.TaiKhoan) session.getAttribute("user");

    // SỬA 2: Kiểm tra null trước khi get dữ liệu (Null Safety)
    String vaiTro = (tk != null) ? tk.getVaiTro() : "Seller";
    String tenNguoiDung = (tk != null) ? tk.getTenNguoiDung() : "Khách"; // Dòng này gây lỗi cũ

    // ... code phía dưới giữ nguyên
    String currentPage = request.getParameter("page");
    if (currentPage == null || currentPage.isEmpty()) {
        currentPage = "quanlymenungay";
    }
    String contentPage = (String) request.getAttribute("contentPage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Căn Tin - Kênh Người Bán</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <style>
        :root {
            --primary-color: #3f51b5;
            --secondary-color: #f8f9fa;
            --dashboard-bg: #e9ecef;
        }

        body {
            background-color: var(--dashboard-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* --- Sidebar Styles --- */
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: var(--primary-color);
            padding-top: 20px;
            color: white;
            z-index: 1000;
            overflow-y: auto;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .sidebar a {
            padding: 15px 25px;
            text-decoration: none;
            font-size: 16px;
            color: rgba(255, 255, 255, 0.8);
            display: block;
            transition: all 0.3s;
            border-left: 4px solid transparent; /* Chuẩn bị cho border active */
        }

        .sidebar a:hover {
            background-color: #303f9f;
            color: white;
            text-decoration: none;
        }

        /* --- SỬA 4: CSS cho Menu đang Active --- */
        .sidebar a.active {
            background-color: #283593; /* Màu nền đậm hơn */
            color: #ffffff;
            font-weight: bold;
            border-left: 4px solid #ffca28; /* Vạch vàng nổi bật */
            padding-left: 21px; /* Trừ hao padding để chữ không bị lệch */
        }

        .content {
            margin-left: 250px;
            padding: 25px;
            min-height: 100vh;
        }

        /* --- Helper Classes --- */
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,.05);
            margin-bottom: 20px;
            border: none;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .content {
                margin-left: 0;
            }
        }
    </style>a
</head>
<body>

<div class="sidebar">
    <h3 class="text-center mb-4 font-weight-bold">
        <i class="fas fa-utensils mr-2"></i>Seller Portal
    </h3>

    <a href="<%= contextPath %>/Seller?page=ThongKeSeller"
       class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">
        <i class="fas fa-tachometer-alt mr-2" style="width: 20px;"></i> Tổng Quan
    </a>

    <a href="<%= contextPath %>/Seller?page=quanlymenungay"
       class="<%= "quanlymenungay".equals(currentPage) ? "active" : "" %>">
        <i class="fas fa-hamburger mr-2" style="width: 20px;"></i> Quản Lý Menu Ngày
    </a>

    <a href="<%= contextPath %>/Seller?page=quanlydonhang"
       class="<%= "quanlydonhang".equals(currentPage) ? "active" : "" %>">
        <i class="fas fa-store mr-2" style="width: 20px;"></i> Quản Lý Đơn Hàng
    </a>

    <hr style="border-color: rgba(255,255,255,0.1); margin: 20px;">

    <a href="<%= contextPath %>/trangchu" class="mt-2">
        <i class="fas fa-sign-out-alt mr-2" style="width: 20px;"></i> Đăng Xuất
    </a>
</div>

<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-dark font-weight-bold">
            <i class="fas fa-cogs text-primary"></i>
            <%
                String pageTitle = "Tổng Quan"; // Mặc định
                if ("quanlymenungay".equals(currentPage)) {
                    pageTitle = "Quản Lý Menu Ngày";
                } else if ("quanlydonhang".equals(currentPage)) {
                    pageTitle = "Quản Lý Đơn Hàng";
                }
            %>
            <%= pageTitle %>
        </h2>

        <div class="d-flex align-items-center">
            <span class="badge badge-light p-2 border shadow-sm" style="font-size: 14px;">
                <i class="fas fa-user-circle text-primary mr-1"></i> Xin chào, <strong><%= tenNguoiDung %></strong>
            </span>
        </div>
    </div>

    <%
        String successMessage = (String) session.getAttribute("message"); // Đôi khi bạn dùng "message"
        String successMsgKey2 = (String) session.getAttribute("success"); // Đôi khi dùng "success"
        String errorMessage = (String) session.getAttribute("error");

        // Gộp check cho chắc
        if (successMessage == null) successMessage = successMsgKey2;

        if (successMessage != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
        <strong><i class="fas fa-check-circle"></i> Thành công!</strong> <%= successMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
            session.removeAttribute("message");
            session.removeAttribute("success");
        }

        if (errorMessage != null) {
    %>
    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
        <strong><i class="fas fa-exclamation-circle"></i> Lỗi!</strong> <%= errorMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
            session.removeAttribute("error");
        }
    %>

    <div id="main-content">
        <%
            if (contentPage != null && !contentPage.isEmpty()) {
                try {
        %>
        <jsp:include page="<%= contentPage %>" />
        <%
        } catch (Exception e) {
        %>
        <div class="alert alert-danger">
            <h4><i class="fas fa-bug"></i> Lỗi load trang: <%= contentPage %></h4>
            <p>Chi tiết lỗi: <%= e.getMessage() %></p>
        </div>
        <%
            }
        } else {
        %>
        <div class="alert alert-warning text-center p-5">
            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i><br>
            <h4>Không tìm thấy nội dung!</h4>
            <p>Vui lòng kiểm tra lại tham số đường dẫn hoặc Servlet.</p>
        </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script> <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Global context path cho các file con sử dụng
    const contextPath = '<%= contextPath %>';

    // Tự động ẩn thông báo sau 4 giây
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                $(alert).fadeOut('slow', function() {
                    $(this).remove();
                });
            }, 4000);
        });
    });
</script>

</body>
</html>