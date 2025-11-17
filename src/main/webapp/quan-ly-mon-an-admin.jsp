<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="Model.MonAn"%>
<%@ page import="Model.Quay"%>
<%@ page import="Model.Page"%>
<%@ page import="Model.PageRequest"%>

<%
    // Lấy dữ liệu từ request
    String contextPath = request.getContextPath();
    Page<MonAn> monAnPage = (Page<MonAn>) request.getAttribute("monAnPage");
    List<Quay> danhSachQuay = (List<Quay>) request.getAttribute("DanhSachQuay");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");

    // Null safety
    if (danhSachQuay == null) danhSachQuay = java.util.Collections.emptyList();
    if (pageRequest == null) pageRequest = new PageRequest("", "asc", "gia", 10, 1);
    if (monAnPage == null) monAnPage = new Page<MonAn>(java.util.Collections.emptyList(), 1, 10, 0);

    List<MonAn> danhSachMon = monAnPage.getData() != null ? monAnPage.getData() : java.util.Collections.emptyList();

    // Formatter tiền tệ
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    // Placeholder tìm kiếm
    String searchPlaceholder = (String) request.getAttribute("searchPlaceholder");
    if (searchPlaceholder == null) searchPlaceholder = "Tìm theo tên món ăn...";
%>

<div id="quanlymonan">
    <!-- Header với nút thêm mới -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Danh Sách Món Ăn</h3>
        <button type="button" class="btn btn-primary" onclick="showAddMonAnForm()">
            <i class="fas fa-plus"></i> Thêm Món Ăn Mới
        </button>
    </div>

    <!-- FORM THÊM/SỬA MÓN ĂN -->
    <div id="monan-form-container" class="card p-4 mb-3" style="display:none;">
        <h4 id="form-monan-title" class="mb-3">
            <i class=""></i> Thêm Món Ăn Mới
        </h4>

        <form id="monanForm" action="<%= contextPath %>/MonAnServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" id="monan-action" value="ADD">
            <input type="hidden" name="maMon" id="maMon">
            <input type="hidden" name="hinhAnhHienTai" id="hinhAnhHienTai">

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="tenMon">
                        <i class="fas fa-hamburger"></i> Tên Món Ăn <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="tenMon" name="tenMon" placeholder="Nhập tên món ăn" required>
                </div>
                <div class="form-group col-md-6">
                    <label for="gia">
                        <i class="fas fa-dollar-sign"></i> Giá Bán <span class="text-danger">*</span>
                    </label>
                    <input type="number" step="1000" min="0" class="form-control" id="gia" name="gia" placeholder="VD: 25000" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label for="maQuay">
                        <i class="fas fa-store"></i> Chọn Quầy <span class="text-danger">*</span>
                    </label>
                    <select class="form-control" id="maQuay" name="maQuay" required>
                        <option value="">-- Chọn Quầy --</option>
                        <% for (Quay quay : danhSachQuay) { %>
                        <option value="<%= quay.getMaQuay() %>"><%= quay.getTenQuay() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group col-md-6">
                    <label for="moTa">
                        <i class="fas fa-align-left"></i> Mô Tả
                    </label>
                    <input type="text" class="form-control" id="moTa" name="moTa" placeholder="Mô tả ngắn về món ăn">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-image"></i> Hình Ảnh</label>
                <div id="image-preview-area">
                    <img id="monan-current-img" src="" alt="Ảnh món ăn" style="display: none;">
                    <div id="image-placeholder" class="p-3">
                        <i class="fas fa-image fa-3x mb-2"></i><br>
                        <span class="text-muted">Chưa có ảnh / Chọn ảnh mới</span>
                    </div>
                </div>
                <div class="custom-file">
                    <input type="file" class="custom-file-input" id="hinhAnh" name="hinhAnh" accept="image/*">
                    <label class="custom-file-label" for="hinhAnh" id="hinhAnhLabel">Chọn file ảnh</label>
                </div>
                <small class="form-text text-muted">
                    <i class="fas fa-info-circle"></i> Định dạng: JPG, PNG, GIF. Kích thước tối đa: 5MB
                </small>
            </div>

            <hr>

            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-secondary mr-2" onclick="hideMonAnForm()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Lưu Món Ăn
                </button>
            </div>
        </form>
    </div>

    <!-- THANH TÌM KIẾM -->
    <div class="card p-3 mb-3">
        <form action="<%= contextPath %>/Admin" method="GET" class="form-inline w-100">
            <input type="hidden" name="activeTab" value="quanlymonan">
            <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
            <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">
            <input type="hidden" name="size" value="<%= pageRequest.getPageSize() %>">

            <div class="form-group mr-2 flex-grow-1">
                <input type="text"
                       class="form-control w-100"
                       id="keyword"
                       name="keyword"
                       placeholder="<%= searchPlaceholder %>"
                       value="<%= pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
            </div>

            <button type="submit" class="btn btn-info mr-2">
                <i class="fas fa-search"></i> Tìm
            </button>

            <a href="<%= contextPath %>/Admin?activeTab=quanlymonan" class="btn btn-outline-secondary">
                <i class="fas fa-sync-alt"></i> Làm mới
            </a>
        </form>
    </div>

    <!-- BẢNG DANH SÁCH MÓN ĂN -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="thead-dark">
                    <tr>
                        <th style="width: 5%;">#</th>
                        <th style="width: 10%;">Ảnh</th>
                        <th style="width: 25%;">Tên Món</th>
                        <th style="width: 15%;">Giá</th>
                        <th style="width: 20%;">Mô Tả</th>
                        <th style="width: 10%;">Quầy</th>
                        <th style="width: 15%;" class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (danhSachMon.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="7" class="text-center text-muted py-5">
                            <i class="fas fa-inbox fa-4x mb-3 d-block" style="opacity: 0.3;"></i>
                            <h5>Không có món ăn nào</h5>
                            <p>Hãy thêm món ăn mới bằng cách nhấn nút "Thêm Món Ăn Mới" ở trên</p>
                        </td>
                    </tr>
                    <%
                    } else {
                        int startIndex = (monAnPage.getCurrentPage() - 1) * pageRequest.getPageSize();
                        for (int i = 0; i < danhSachMon.size(); i++) {
                            MonAn monan = danhSachMon.get(i);

                            String tenMonJs = monan.getTenMonAn()
                                    .replace("\\", "\\\\").replace("'", "\\'")
                                    .replace("\"", "&quot;").replace("\n", "\\n").replace("\r", "");
                            String moTaJs = monan.getMoTa() != null ? monan.getMoTa().replace("\\","\\\\").replace("'", "\\'").replace("\"","&quot;").replace("\n","\\n").replace("\r","") : "";
                            String hinhAnhJs = monan.getHinhAnh() != null ? monan.getHinhAnh().replace("'", "\\'") : "";
                            String giaString = String.valueOf(monan.getGia());

                            String tenQuayHienThi = "N/A";
                            for (Quay quay : danhSachQuay) {
                                if (monan.getMaQuay() == quay.getMaQuay()) {
                                    tenQuayHienThi = quay.getTenQuay();
                                    break;
                                }
                            }

                            String imageSrc = monan.getHinhAnh() != null && !monan.getHinhAnh().isEmpty() ? contextPath + "/assets/images/MonAn/" + monan.getHinhAnh() : "";
                    %>
                    <tr>
                        <td class="align-middle"><strong><%= startIndex + i + 1 %></strong></td>
                        <td class="align-middle">
                            <% if (!imageSrc.isEmpty()) { %>
                            <img src="<%= imageSrc %>" alt="<%= monan.getTenMonAn() %>" class="monan-img"
                                 onerror="this.onerror=null; this.src='<%= contextPath %>/assets/images/no-image.png';">
                            <% } else { %>
                            <div class="text-center" style="width:60px;height:60px;background:#f0f0f0;border-radius:5px;display:flex;align-items:center;justify-content:center;">
                                <i class="fas fa-image fa-2x text-muted"></i>
                            </div>
                            <% } %>
                        </td>
                        <td class="align-middle"><strong><%= monan.getTenMonAn() %></strong></td>
                        <td class="align-middle"><span class="text-success font-weight-bold"><%= currencyFormatter.format(monan.getGia()) %></span></td>
                        <td class="align-middle"><small class="text-muted"><%= monan.getMoTa() != null && !monan.getMoTa().isEmpty() ? monan.getMoTa() : "<em>Chưa có mô tả</em>" %></small></td>
                        <td class="align-middle"><span class="badge badge-info px-2 py-1"><i class="fas fa-store"></i> <%= tenQuayHienThi %></span></td>
                        <td class="align-middle text-center">
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-sm btn-info" onclick="editMonAn('<%= monan.getMaMonAn() %>', '<%= tenMonJs %>', '<%= giaString %>', '<%= moTaJs %>', '<%= hinhAnhJs %>', '<%= monan.getMaQuay() %>')" title="Sửa món ăn">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-danger" onclick="return confirmDelete('<%= tenMonJs %>', '<%= contextPath %>/MonAnServlet?action=DELETE&maMon=<%= monan.getMaMonAn() %>')" title="Xóa món ăn">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
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

        <!-- PHÂN TRANG -->
        <%
            int totalPages = monAnPage.getTotalPage();
            int currentPage = monAnPage.getCurrentPage();
            String baseUrl = contextPath + "/Admin?activeTab=quanlymonan&size=" + pageRequest.getPageSize() + "&sort=" + pageRequest.getSortField() + "&order=" + pageRequest.getSortOrder();
            if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
                baseUrl += "&keyword=" + java.net.URLEncoder.encode(pageRequest.getKeyword(), "UTF-8");
            }
        %>

        <div class="card-footer bg-white">
            <div class="d-flex justify-content-between align-items-center mt-3">
                <div>
                </div>

                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <% if (currentPage > 1) { %>
                        <li class="page-item">
                            <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage-1 %>" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a>
                        </li>
                        <% } else { %>
                        <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                        <% } %>

                        <%
                            int startPage = Math.max(1, currentPage-2);
                            int endPage = Math.min(totalPages, currentPage+2);
                            if (startPage > 1) { %>
                        <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=1">1</a></li>
                        <% if (startPage > 2) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } } %>

                        <% for (int i=startPage; i<=endPage; i++) { %>
                        <li class="page-item <%= (i==currentPage)?"active":"" %>"><a class="page-link" href="<%= baseUrl %>&page=<%= i %>"><%= i %></a></li>
                        <% } %>

                        <% if (endPage < totalPages) { %>
                        <% if (endPage < totalPages-1) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= totalPages %>"><%= totalPages %></a></li>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                        <li class="page-item"><a class="page-link" href="<%= baseUrl %>&page=<%= currentPage+1 %>" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>
                        <% } else { %>
                        <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                        <% } %>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<script>
    // Hiển thị form thêm món
    function showAddMonAnForm() {
        document.getElementById('monan-form-container').style.display = 'block';
        document.getElementById('form-monan-title').innerHTML = '<i class="fas fa-utensils"></i> Thêm Món Ăn Mới';
        document.getElementById('monan-action').value = 'ADD';
        document.getElementById('maMon').value = '';
        document.getElementById('tenMon').value = '';
        document.getElementById('gia').value = '';
        document.getElementById('moTa').value = '';
        document.getElementById('maQuay').value = '';
        document.getElementById('hinhAnhHienTai').value = '';
        document.getElementById('monan-current-img').style.display = 'none';
        document.getElementById('image-placeholder').style.display = 'block';
        document.getElementById('hinhAnhLabel').innerText = 'Chọn file ảnh';
    }

    // Ẩn form
    function hideMonAnForm() {
        document.getElementById('monan-form-container').style.display = 'none';
    }

    // Sửa món ăn
    function editMonAn(maMon, tenMon, gia, moTa, hinhAnh, maQuay) {
        document.getElementById('monan-form-container').style.display = 'block';
        document.getElementById('form-monan-title').innerHTML = '<i class="fas fa-edit"></i> Sửa Món Ăn';
        document.getElementById('monan-action').value = 'EDIT';
        document.getElementById('maMon').value = maMon;
        document.getElementById('tenMon').value = tenMon;
        document.getElementById('gia').value = gia;
        document.getElementById('moTa').value = moTa;
        document.getElementById('maQuay').value = maQuay;
        document.getElementById('hinhAnhHienTai').value = hinhAnh;

        var currentImg = document.getElementById('monan-current-img');
        var placeholder = document.getElementById('image-placeholder');

        if (hinhAnh) {
            currentImg.src = '<%= contextPath %>/assets/images/MonAn/' + hinhAnh;
            currentImg.style.display = 'block';
            placeholder.style.display = 'none';
        } else {
            currentImg.style.display = 'none';
            placeholder.style.display = 'block';
        }

        document.getElementById('hinhAnhLabel').innerText = 'Chọn file ảnh';
    }

    // Xác nhận xóa món ăn
    function confirmDelete(tenMon, url) {
        if (confirm('Bạn có chắc chắn muốn xóa món "' + tenMon + '" không?')) {
            window.location.href = url;
        }
        return false;
    }

    // Preview ảnh khi chọn file mới
    document.getElementById('hinhAnh').addEventListener('change', function(e) {
        var file = e.target.files[0];
        if (!file) return;

        var reader = new FileReader();
        reader.onload = function(event) {
            document.getElementById('monan-current-img').src = event.target.result;
            document.getElementById('monan-current-img').style.display = 'block';
            document.getElementById('image-placeholder').style.display = 'none';
        };
        reader.readAsDataURL(file);

        document.getElementById('hinhAnhLabel').innerText = file.name;
    });
</script>

