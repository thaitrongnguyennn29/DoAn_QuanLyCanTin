<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.TaiKhoan" %>

<%
    String contextPath = request.getContextPath();
    String tenNguoiDung = "Admin"; // Tạm thời không check session

    String currentTab = request.getParameter("activeTab");
    if (currentTab == null) currentTab = "dashboard";

    String contentPage = (String) request.getAttribute("contentPage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Căn Tin - Admin Dashboard</title>

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
        }

        .sidebar a {
            padding: 15px 25px;
            text-decoration: none;
            font-size: 18px;
            color: white;
            display: block;
            transition: background-color 0.3s;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: #303f9f;
            text-decoration: none;
        }

        .content {
            margin-left: 250px;
            padding: 20px;
            min-height: 100vh;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,.05);
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: bold;
        }

        .card-value {
            font-size: 2.5rem;
            font-weight: bold;
        }

        #card-doanhthu { background: #3498db; color: white; }
        #card-donhang { background: #2ecc71; color: white; }
        #card-monan { background: #9b59b6; color: white; }

        .table-responsive {
            max-height: 60vh;
            overflow-y: auto;
        }

        .monan-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }

        #image-preview-area {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            margin-bottom: 15px;
        }

        #image-preview-area img {
            max-width: 250px;
            max-height: 250px;
            object-fit: contain;
            border-radius: 8px;
        }

        #image-placeholder {
            color: #6c757d;
        }

        .custom-file-label::after {
            content: "Chọn";
        }

        .action-buttons {
            display: flex;
            align-items: center;
            justify-content: flex-start;
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
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h3 class="text-center mb-4">
        <i class="fas fa-utensils"></i> Quản Lý Căn Tin
    </h3>

    <a href="<%= contextPath %>/Admin?activeTab=dashboard"
       class="<%= currentTab.equals("dashboard") ? "active" : "" %>">
        <i class="fas fa-tachometer-alt"></i> Dashboard
    </a>

    <a href="<%= contextPath %>/Admin?activeTab=quanlymonan"
       class="<%= currentTab.equals("quanlymonan") ? "active" : "" %>">
        <i class="fas fa-hamburger"></i> Quản Lý Món Ăn
    </a>

    <a href="<%= contextPath %>/Admin?activeTab=quanlyquay"
       class="<%= currentTab.equals("quanlyquay") ? "active" : "" %>">
        <i class="fas fa-store"></i> Quản Lý Quầy
    </a>

    <a href="<%= contextPath %>/Admin?activeTab=quanlytaikhoan"
       class="<%= currentTab.equals("quanlytaikhoan") ? "active" : "" %>">
        <i class="fas fa-users"></i> Quản Lý Tài Khoản
    </a>

    <a href="<%= contextPath %>/Admin?activeTab=quanlydonhang"
       class="<%= currentTab.equals("quanlydonhang") ? "active" : "" %>">
        <i class="fas fa-shopping-cart"></i> Quản Lý Đơn Hàng
    </a>

    <hr style="border-color: rgba(255,255,255,0.2);">

    <a href="<%= contextPath %>/Logout" class="mt-3">
        <i class="fas fa-sign-out-alt"></i> Đăng Xuất
    </a>
</div>

<!-- Main Content -->
<div class="content">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>
            <i class="fas fa-cogs"></i>
            <%
                String pageTitle = "Dashboard";
                switch(currentTab) {
                    case "quanlymonan": pageTitle = "Quản Lý Món Ăn"; break;
                    case "quanlyquay": pageTitle = "Quản Lý Quầy"; break;
                    case "quanlytaikhoan": pageTitle = "Quản Lý Tài Khoản"; break;
                    case "quanlydonhang": pageTitle = "Quản Lý Đơn Hàng"; break;
                }
            %>
            <%= pageTitle %>
        </h2>
        <span class="badge badge-primary p-2" style="font-size: 14px;">
                <i class="fas fa-user"></i> <%= tenNguoiDung %>
            </span>
    </div>

    <!-- Alert Messages -->
    <%
        String successMessage = (String) session.getAttribute("message");
        String errorMessage = (String) session.getAttribute("error");

        if (successMessage != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong><i class="fas fa-check-circle"></i> Thành công!</strong> <%= successMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
            session.removeAttribute("message");
        }

        if (errorMessage != null) {
    %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong><i class="fas fa-exclamation-circle"></i> Lỗi!</strong> <%= errorMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
            session.removeAttribute("error");
        }
    %>

    <!-- Dynamic Content Area -->
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
            <h4>Lỗi load trang: <%= contentPage %></h4>
            <p><%= e.getMessage() %></p>
        </div>
        <%
            }
        } else {
        %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            Không có nội dung để hiển thị!
        </div>
        <%
            }
        %>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Global context path
    const contextPath = '<%= contextPath %>';

    // Auto-hide alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                $(alert).fadeOut('slow', function() {
                    $(this).remove();
                });
            }, 5000);
        });
    });

    // Confirm delete
    function confirmDelete(itemName, deleteUrl) {
        if (confirm('Bạn có chắc chắn muốn xóa "' + itemName + '" không?')) {
            window.location.href = deleteUrl;
        }
        return false;
    }

    // Preview image
    function previewImage(input, previewId) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById(previewId);
                if (preview) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';

                    const placeholder = document.getElementById('image-placeholder');
                    if (placeholder) {
                        placeholder.style.display = 'none';
                    }
                }
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Format currency
    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    // Scroll to top
    function scrollToTop() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
</script>

</body>
</html>