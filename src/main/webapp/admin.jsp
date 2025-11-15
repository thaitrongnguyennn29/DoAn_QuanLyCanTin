<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="Model.MonAn" %>
<%@ page import="Model.Quay" %>
<%@ page import="Model.Page" %>
<%@ page import="Model.PageRequest" %>

<%
    Page<MonAn> monAnPage = (Page<MonAn>) request.getAttribute("monAnPage");
    List<Quay> danhSachQuay = (List<Quay>) request.getAttribute("DanhSachQuay");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");

    List<MonAn> danhSachMon = null;

    if (monAnPage != null) {
        danhSachMon = monAnPage.getData();
    } else {
        danhSachMon = java.util.Collections.emptyList();
        // Khởi tạo rỗng an toàn nếu dữ liệu không tồn tại
        monAnPage = new Page<MonAn>(danhSachMon, 1, 10, 0);
    }

    if (danhSachQuay == null) {
        danhSachQuay = java.util.Collections.emptyList();
    }

    if (pageRequest == null) {
        // Khởi tạo mặc định nếu chưa có (Phòng trường hợp lỗi null)
        pageRequest = new PageRequest("", "asc", "gia", 10, 1);
    }

    // Định dạng tiền tệ Việt Nam
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    // Context Path
    String contextPath = request.getContextPath();
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

        /* Màu sắc cho Dashboard Cards */
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

        .form-monan {
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #fff;
            margin-bottom: 20px;
        }

        /* Preview ảnh */
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
    </style>
</head>
<body>

<div class="sidebar">
    <h3 class="text-center mb-4">
        <i class="fas fa-utensils"></i> Quản Lý Căn Tin
    </h3>
    <a href="#" class="nav-link-item active" data-target="dashboard">
        <i class="fas fa-tachometer-alt"></i> Dashboard
    </a>
    <a href="#" class="nav-link-item" data-target="quanlymonan">
        <i class="fas fa-hamburger"></i> Quản Lý Món Ăn
    </a>
    <a href="#" class="nav-link-item" data-target="quanlyquay">
        <i class="fas fa-store"></i> Quản Lý Quầy
    </a>
    <a href="<%= contextPath %>/Logout" class="mt-5">
        <i class="fas fa-sign-out-alt"></i> Đăng Xuất
    </a>
</div>

<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-cogs"></i> Quản Trị Hệ Thống</h2>
        <span class="badge badge-primary p-2">Admin: Nguyễn Văn A</span>
    </div>

    <%
        String successMessage = (String) session.getAttribute("message");
        String errorMessage = (String) session.getAttribute("error");
        if (successMessage != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Thành công!</strong> <%= successMessage %>
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
        <strong>Lỗi!</strong> <%= errorMessage %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
            session.removeAttribute("error");
        }
    %>

    <div id="dashboard" class="tab-content-item">
        <h3 class="mb-4">Tổng Quan</h3>
        <div class="row">
            <div class="col-md-4">
                <div class="card p-3 text-center" id="card-doanhthu">
                    <p class="card-title">Doanh Thu Tháng</p>
                    <p class="card-value"><i class="fas fa-dollar-sign"></i> 25.600.000₫</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 text-center" id="card-donhang">
                    <p class="card-title">Tổng Đơn Hàng</p>
                    <p class="card-value"><i class="fas fa-shopping-cart"></i> 342</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 text-center" id="card-monan">
                    <p class="card-title">Tổng Món Ăn</p>
                    <p class="card-value"><i class="fas fa-cube"></i> <%= monAnPage.getTotalItems() %></p>
                </div>
            </div>
        </div>
    </div>

    <hr/>
    <div id="quanlymonan" class="tab-content-item" style="display:none;">
       <%@include file="quan-ly-mon-an-admin.jsp"%>
    </div>

    <div id="quanlyquay" class="tab-content-item" style="display:none;">
    <%@include file="quan-ly-quay-admin.jsp"%>
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Khai báo biến DOM
    const monanFormContainer = document.getElementById('monan-form-container');
    const monanForm = document.getElementById('monanForm');
    const formTitle = document.getElementById('form-monan-title');

    const maMonInput = document.getElementById('maMon');
    const tenMonInput = document.getElementById('tenMon');
    const giaInput = document.getElementById('gia');
    const moTaInput = document.getElementById('moTa');
    const maQuaySelect = document.getElementById('maQuay');
    const hinhAnhHienTaiInput = document.getElementById('hinhAnhHienTai');

    const monanActionInput = document.getElementById('monan-action');
    const monanCurrentImg = document.getElementById('monan-current-img');
    const hinhAnhFileInput = document.getElementById('hinhAnh');
    const hinhAnhLabel = document.getElementById('hinhAnhLabel');
    const imagePlaceholder = document.getElementById('image-placeholder');

    // Hàm preview ảnh mới
    function previewNewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                monanCurrentImg.src = e.target.result;
                monanCurrentImg.style.display = 'block';
                imagePlaceholder.style.display = 'none';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Khi trang load xong (Cập nhật logic chuyển tab)
    document.addEventListener('DOMContentLoaded', function() {
        // Lấy tab active từ URL (sau khi tìm kiếm/phân trang/thêm/sửa/xóa)
        const urlParams = new URLSearchParams(window.location.search);
        const activeTab = urlParams.get('activeTab') || 'dashboard'; // Mặc định là dashboard

        // Xử lý hiển thị tab
        const tabContents = document.querySelectorAll('.tab-content-item');
        tabContents.forEach(item => {
            if (item.id === activeTab) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });

        // Xử lý active link trên Sidebar
        document.querySelectorAll('.nav-link-item').forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('data-target') === activeTab) {
                link.classList.add('active');
            }
            // Sửa logic click để chuyển hướng và reset các tham số phân trang/tìm kiếm
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('data-target');
                window.location.href = '<%= contextPath %>/Admin?activeTab=' + targetId;
            });
        });

        // Xử lý upload file
        hinhAnhFileInput.addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'Chọn file ảnh';
            hinhAnhLabel.textContent = fileName;
            previewNewImage(this);
        });
    });

    // Reset form
    function resetMonAnForm() {
        monanForm.reset();
        maMonInput.value = '';
        monanActionInput.value = 'ADD';
        formTitle.textContent = 'Thêm Món Ăn Mới';

        monanCurrentImg.style.display = 'none';
        monanCurrentImg.src = '';
        imagePlaceholder.style.display = 'block';
        hinhAnhLabel.textContent = 'Chọn file ảnh';
        hinhAnhFileInput.required = true;
        hinhAnhHienTaiInput.value = '';
    }

    // Hiển thị form thêm món
    function showAddMonAnForm() {
        resetMonAnForm();
        monanFormContainer.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Ẩn form
    function hideMonAnForm() {
        monanFormContainer.style.display = 'none';
        resetMonAnForm();
    }

    // HÀM SỬA MÓN ĂN
    function editMonAn(maMon, tenMon, gia, moTa, hinhAnh, maQuay) {
        resetMonAnForm();

        // Cập nhật dữ liệu
        maMonInput.value = maMon;
        tenMonInput.value = tenMon;
        giaInput.value = gia;
        moTaInput.value = moTa;
        maQuaySelect.value = maQuay;

        // Cập nhật trạng thái form
        monanActionInput.value = 'EDIT';
        formTitle.textContent = 'Sửa Món Ăn: ' + tenMon;
        hinhAnhFileInput.required = false;

        //XỬ LÝ HIỂN THỊ ẢNH
        if (hinhAnh && hinhAnh.trim() !== '') {
            const contextPath = '<%= contextPath %>';

            // Tạo đường dẫn đầy đủ
            monanCurrentImg.src = contextPath + '/assets/images/MonAn/' + hinhAnh;

            monanCurrentImg.style.display = 'block';
            imagePlaceholder.style.display = 'none';
            hinhAnhLabel.textContent = 'Chọn file mới để thay đổi';
            hinhAnhHienTaiInput.value = hinhAnh;
        } else {
            monanCurrentImg.style.display = 'none';
            imagePlaceholder.style.display = 'block';
            hinhAnhLabel.textContent = 'Chọn file ảnh để tải lên';
            hinhAnhHienTaiInput.value = '';
        }

        // Hiển thị form
        monanFormContainer.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
</script>

</body>
</html>