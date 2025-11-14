<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="Model.MonAn" %>
<%@ page import="Model.Quay" %>

<%
    // Lấy dữ liệu từ Request
    List<MonAn> danhSachMon = (List<MonAn>) request.getAttribute("DanhSachMon");
    List<Quay> danhSachQuay = (List<Quay>) request.getAttribute("DanhSachQuay");

    if (danhSachMon == null) {
        danhSachMon = java.util.Collections.emptyList();
    }
    if (danhSachQuay == null) {
        danhSachQuay = java.util.Collections.emptyList();
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

    <!-- Bootstrap 4 CDN -->
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
    </style>
</head>
<body>

<!-- Sidebar -->
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

<!-- Content -->
<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-cogs"></i> Quản Trị Hệ Thống</h2>
        <span class="badge badge-primary p-2">Admin: Nguyễn Văn A</span>
    </div>

    <!-- Thông báo -->
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

    <!-- Dashboard Tab -->
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
                    <p class="card-value"><i class="fas fa-cube"></i> <%= danhSachMon.size() %></p>
                </div>
            </div>
        </div>
    </div>

    <hr/>
    <!-- Quản Lý Món Ăn Tab -->
    <div id="quanlymonan" class="tab-content-item" style="display:none;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3><i class="fas fa-utensils"></i> Quản Lý Món Ăn</h3>
            <button type="button" class="btn btn-primary" onclick="showAddMonAnForm()">
                <i class="fas fa-plus"></i> Thêm Món Ăn Mới
            </button>
        </div>

        <!-- Form Thêm/Sửa Món Ăn -->
        <div id="monan-form-container" class="form-monan" style="display:none;">
            <h4 id="form-monan-title">Thêm Món Ăn Mới</h4>
            <form id="monanForm" action="<%= contextPath %>/MonAnServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" id="monan-action" value="ADD">
                <input type="hidden" name="maMon" id="maMon">
                <input type="hidden" name="hinhAnhHienTai" id="hinhAnhHienTai">

                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="tenMon">Tên Món Ăn (*)</label>
                        <input type="text" class="form-control" id="tenMon" name="tenMon" required>
                    </div>
                    <div class="form-group col-md-6">
                        <label for="gia">Giá Bán (*)</label>
                        <input type="number" step="0.01" class="form-control" id="gia" name="gia" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="maQuay">Chọn Quầy (*)</label>
                        <select class="form-control" id="maQuay" name="maQuay" required>
                            <option value="">-- Chọn Quầy --</option>
                            <%
                                for (Quay quay : danhSachQuay) {
                            %>
                            <option value="<%= quay.getMaQuay() %>"><%= quay.getTenQuay() %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group col-md-6">
                        <label for="moTa">Mô Tả</label>
                        <input type="text" class="form-control" id="moTa" name="moTa">
                    </div>
                </div>

                <!-- Phần upload ảnh -->
                <div class="form-group">
                    <label>Hình Ảnh</label>

                    <div id="image-preview-area">
                        <img id="monan-current-img" src="" alt="Ảnh món ăn" style="display: none;">
                        <p id="image-placeholder" class="mb-0 p-3">
                            <i class="fas fa-image fa-3x mb-2"></i><br>
                            Chưa có ảnh / Chọn ảnh mới
                        </p>
                    </div>

                    <div class="custom-file">
                        <input type="file" class="custom-file-input" id="hinhAnh" name="hinhAnh" accept="image/*">
                        <label class="custom-file-label" for="hinhAnh" id="hinhAnhLabel">Chọn file ảnh</label>
                    </div>
                    <small class="form-text text-muted">
                        Ảnh sẽ được lưu vào: src/main/webapp/assets/images/MonAn/
                    </small>
                </div>

                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Lưu
                </button>
                <button type="button" class="btn btn-secondary" onclick="hideMonAnForm()">
                    Hủy
                </button>
            </form>
        </div>

        <!-- Bảng Danh Sách Món Ăn -->
        <div class="card p-3">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="thead-dark sticky-top">
                    <tr>
                        <th>#</th>
                        <th>Ảnh</th>
                        <th>Tên Món</th>
                        <th>Giá</th>
                        <th>Mô Tả</th>
                        <th>Quầy</th>
                        <th>Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (danhSachMon.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="7" class="text-center text-muted">Không có món ăn nào trong danh sách.</td>
                    </tr>
                    <%
                    } else {
                        for (int i = 0; i < danhSachMon.size(); i++) {
                            MonAn monan = danhSachMon.get(i);

                            // Chuẩn bị dữ liệu cho JavaScript
                            String tenMonJs = monan.getTenMonAn().replace("'", "\\'");
                            String moTaJs = monan.getMoTa() != null ? monan.getMoTa().replace("'", "\\'") : "";
                            String hinhAnhJs = monan.getHinhAnh() != null ? monan.getHinhAnh().replace("'", "\\'") : "";
                            String giaString = String.valueOf(monan.getGia());

                            // Tìm tên quầy
                            String tenQuayHienThi = "N/A";
                            for (Quay quay : danhSachQuay) {
                                if (monan.getMaQuay() == quay.getMaQuay()) {
                                    tenQuayHienThi = quay.getTenQuay();
                                    break;
                                }
                            }

                            // XỬ LÝ HIỂN THỊ ẢNH
                            String hinhAnh = monan.getHinhAnh();
                            String imageSrc = "";

                            if (hinhAnh != null && !hinhAnh.isEmpty()) {
                                // Database chỉ lưu tên file: "download.png"
                                imageSrc = contextPath + "/assets/images/MonAn/" + hinhAnh;
                            }
                    %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td>
                            <%
                                if (!imageSrc.isEmpty()) {
                            %>
                            <img src="<%= imageSrc %>" alt="<%= monan.getTenMonAn() %>" class="monan-img"
                                 onerror="this.onerror=null; this.src='<%= contextPath %>/assets/images/no-image.png';">
                            <%
                            } else {
                            %>
                            <i class="fas fa-image fa-2x text-muted"></i>
                            <%
                                }
                            %>
                        </td>
                        <td><strong><%= monan.getTenMonAn() %></strong></td>
                        <td><%= currencyFormatter.format(monan.getGia()) %></td>
                        <td><%= monan.getMoTa() != null ? monan.getMoTa() : "" %></td>
                        <td><%= tenQuayHienThi %></td>
                        <td>
                            <button type="button" class="btn btn-sm btn-info mr-1"
                                    onclick="editMonAn(
                                            '<%= monan.getMaMonAn() %>',
                                            '<%= tenMonJs %>',
                                            '<%= giaString %>',
                                            '<%= moTaJs %>',
                                            '<%= hinhAnhJs %>',
                                            '<%= monan.getMaQuay() %>'
                                            )">
                                <i class="fas fa-edit"></i> Sửa
                            </button>

                            <a href="<%= contextPath %>/MonAnServlet?action=DELETE&maMon=<%= monan.getMaMonAn() %>"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa món ăn <%= tenMonJs %> không?')">
                                <i class="fas fa-trash-alt"></i> Xóa
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Quản Lý Quầy Tab -->
    <div id="quanlyquay" class="tab-content-item" style="display:none;">
        <h3><i class="fas fa-store"></i> Quản Lý Quầy</h3>
        <p class="text-muted">Giao diện quản lý quầy sẽ được xây dựng tương tự Quản lý Món ăn.</p>
        <button type="button" class="btn btn-success">
            <i class="fas fa-plus"></i> Thêm Quầy
        </button>
    </div>

</div>

<!-- jQuery, Popper.js, Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<!-- JavaScript -->
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

    // Khi trang load xong
    document.addEventListener('DOMContentLoaded', function() {
        // Xử lý chuyển tab
        const tabContents = document.querySelectorAll('.tab-content-item');
        tabContents.forEach(item => {
            if (item.id !== 'dashboard') {
                item.style.display = 'none';
            }
        });

        document.querySelectorAll('.nav-link-item').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();

                tabContents.forEach(item => {
                    item.style.display = 'none';
                });

                const targetId = this.getAttribute('data-target');
                document.getElementById(targetId).style.display = 'block';

                document.querySelectorAll('.nav-link-item').forEach(item =>
                    item.classList.remove('active')
                );
                this.classList.add('active');
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

    // HÀM SỬA MÓN ĂN - ĐÃ FIX
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

            // ⚠️ DEBUG - In ra console
            console.log('contextPath:', contextPath);
            console.log('hinhAnh:', hinhAnh);
            console.log('Full path:', contextPath + '/assets/images/MonAn/' + hinhAnh);

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