<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="d-flex justify-content-between align-items-center mb-3">
        <h3> Quản Lý Món Ăn</h3>
        <button type="button" class="btn btn-primary" onclick="showAddMonAnForm()">
            <i class="fas fa-plus"></i> Thêm Món Ăn Mới
        </button>
    </div>
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
    <div class="card p-3 mb-3 d-flex">
        <form action="<%= contextPath %>/Admin" method="GET" class="form-inline w-100">
            <input type="hidden" name="activeTab" value="quanlymonan">
            <input type="hidden" name="sort" value="<%= pageRequest.getSortField() %>">
            <input type="hidden" name="order" value="<%= pageRequest.getSortOrder() %>">

            <div class="form-group mr-2">
                <label for="keyword" class="sr-only">Tìm Kiếm</label>
                <input type="text" class="form-control" id="keyword" name="keyword" placeholder="Nhập tên món ăn..."
                       value="<%= pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
            </div>
            <div class="form-group mr-2">
            </div>
            <button type="submit" class="btn btn-info mr-2">
                <i class="fas fa-search"></i> Tìm
            </button>
            <a href="<%= contextPath %>/Admin?activeTab=quanlymonan" class="btn btn-outline-secondary">
                <i class="fas fa-sync-alt"></i> Xóa tìm kiếm
            </a>
        </form>
    </div>
    <div class="card p-3">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="thead-dark sticky-top">
                <tr>
                    <th>#</th>
                    <th>Ảnh</th>
                    <th>
                        Tên Món
                        <a href="<%= contextPath %>/Admin?activeTab=quanlymonan&page=1&size=<%= pageRequest.getPageSize() %>&sort=tenMonAn&order=<%= pageRequest.getSortField().equals("tenMonAn") && pageRequest.getSortOrder().equals("asc") ? "desc" : "asc" %>&keyword=<%= pageRequest.getKeyword() %>" class="text-white">
                            <i class="fas fa-sort<%= pageRequest.getSortField().equals("tenMonAn") ? (pageRequest.getSortOrder().equals("asc") ? "-up" : "-down") : "" %> ml-1"></i>
                        </a>
                    </th>
                    <th>
                        Giá
                        <a href="<%= contextPath %>/Admin?activeTab=quanlymonan&page=1&size=<%= pageRequest.getPageSize() %>&sort=gia&order=<%= pageRequest.getSortField().equals("gia") && pageRequest.getSortOrder().equals("asc") ? "desc" : "asc" %>&keyword=<%= pageRequest.getKeyword() %>" class="text-white">
                            <i class="fas fa-sort<%= pageRequest.getSortField().equals("gia") ? (pageRequest.getSortOrder().equals("asc") ? "-up" : "-down") : "" %> ml-1"></i>
                        </a>
                    </th>
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
                    // Tính số thứ tự bắt đầu
                    int startIndex = (monAnPage.getCurrentPage() - 1) * pageRequest.getPageSize();

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
                            imageSrc = contextPath + "/assets/images/MonAn/" + hinhAnh;
                        }
                %>
                <tr>
                    <td><%= startIndex + i + 1 %></td>
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
                    <td class="d-flex align-items-center">
                        <div class="action-buttons">
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

        <div class="d-flex justify-content-between align-items-center mt-3">
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm mb-0">
                    <%
                        int totalPages = monAnPage.getTotalPage();
                        int currentPage = monAnPage.getCurrentPage();
                        String paginationBaseUrl = contextPath + "/Admin?activeTab=quanlymonan&size=" + pageRequest.getPageSize() + "&sort=" + pageRequest.getSortField() + "&order=" + pageRequest.getSortOrder() + "&keyword=" + pageRequest.getKeyword();

                        // Nút Previous
                        if (currentPage > 1) {
                    %>
                    <li class="page-item">
                        <a class="page-link" href="<%= paginationBaseUrl %>&page=<%= currentPage - 1 %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <%
                        }

                        // Các Nút Số Trang
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);

                        if (startPage > 1) {
                    %>
                    <li class="page-item"><a class="page-link" href="<%= paginationBaseUrl %>&page=1">1</a></li>
                    <%
                        if (startPage > 2) {
                    %>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                    <%
                            }
                        }


                        for (int i = startPage; i <= endPage; i++) {
                            String activeClass = (i == currentPage) ? "active" : "";
                    %>
                    <li class="page-item <%= activeClass %>">
                        <a class="page-link" href="<%= paginationBaseUrl %>&page=<%= i %>"><%= i %></a>
                    </li>
                    <%
                        }

                        if (endPage < totalPages) {
                            if (endPage < totalPages - 1) {
                    %>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                    <%
                        }
                    %>
                    <li class="page-item"><a class="page-link" href="<%= paginationBaseUrl %>&page=<%= totalPages %>"><%= totalPages %></a></li>
                    <%
                        }


                        // Nút Next
                        if (currentPage < totalPages) {
                    %>
                    <li class="page-item">
                        <a class="page-link" href="<%= paginationBaseUrl %>&page=<%= currentPage + 1 %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                    <%
                        }
                    %>
                </ul>
            </nav>
        </div>
    </div>