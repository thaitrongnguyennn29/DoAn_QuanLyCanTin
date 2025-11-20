<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.DonHang" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<% request.setAttribute("pageTitle", "Quản Lý Đơn Hàng"); %>
<%@ include file="header.jsp" %>

<div class="my-order-page">

    <section class="hero-section text-center py-5">
        <div class="container">
            <h1 class="hero-title">Xem đơn hàng của bạn</h1>
            <p class="mb-0">Xem các món ăn và các đơn hàng của bạn.</p>
        </div>
    </section>

    <div class="container py-5">

        <ul class="nav nav-tabs justify-content-center" id="orderTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="active-tab" data-bs-toggle="tab" data-bs-target="#active" type="button" role="tab">
                    <i class="bi bi-hourglass-split me-2"></i>Đơn Đang Mua
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="past-tab" data-bs-toggle="tab" data-bs-target="#past" type="button" role="tab">
                    <i class="bi bi-archive me-2"></i>Lịch Sử Đơn Hàng
                </button>
            </li>
        </ul>

        <div class="tab-content mt-3" id="orderTabsContent">

            <div class="tab-pane fade show active" id="active" role="tabpanel">
                <div class="row g-4"> <%
                    List<DonHang> activeList = (List<DonHang>) request.getAttribute("activeOrders");
                    if (activeList != null && !activeList.isEmpty()) {
                        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                        for (DonHang dh : activeList) {
                %>
                    <div class="col-md-6 col-lg-6">
                        <div class="card order-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h5 class="card-title fw-bold">
                                            #<%= String.format("DH%03d", dh.getMaDonHang()) %>
                                        </h5>
                                        <p class="card-text text-muted small">
                                            <i class="bi bi-clock me-1"></i><%= dh.getNgayDat().format(fmt) %>
                                        </p>
                                    </div>
                                    <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">
                                        <%= dh.getTrangThai() %>
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                    <span class="fw-bold fs-5 text-dark">
                                        <%= String.format("%,.0f", dh.getTongTien()) %>đ
                                    </span>
                                    <button onclick="viewOrderDetail(<%= dh.getMaDonHang() %>)" class="btn btn-outline-primary rounded-pill btn-sm px-4 fw-bold">
                                        Chi tiết <i class="bi bi-chevron-right"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%      }
                    } else {
                    %>
                    <div class="text-center py-5 empty-state">
                        <p>Hiện không có đơn hàng nào đang xử lý.</p>
                        <a href="thucdon" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-bold">Đặt món ngay</a>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="tab-pane fade" id="past" role="tabpanel">
                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 text-center">
                            <thead class="bg-light">
                            <tr>
                                <th class="ps-3">Mã Đơn</th>
                                <th>Ngày Đặt</th>
                                <th>Tổng Tiền</th>
                                <th>Trạng Thái</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<DonHang> pastList = (List<DonHang>) request.getAttribute("pastOrders");
                                if (pastList != null && !pastList.isEmpty()) {
                                    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                    for (DonHang dh : pastList) {
                                        String badge = "Đã hoàn thành".equals(dh.getTrangThai()) ? "bg-success" : "bg-danger";
                            %>
                            <tr>
                                <td class="ps-3 fw-bold">
                                    #<%= String.format("DH%03d", dh.getMaDonHang()) %>
                                </td>
                                <td><%= dh.getNgayDat().format(fmt) %></td>
                                <td class="fw-bold text-dark"><%= String.format("%,.0f", dh.getTongTien()) %>đ</td>
                                <td><span class="badge <%= badge %> rounded-pill px-3"><%= dh.getTrangThai() %></span></td>
                                <td class="text-end">
                                    <button onclick="viewOrderDetail(<%= dh.getMaDonHang() %>)" class="btn btn-sm btn-light text-primary rounded-circle p-2" title="Xem chi tiết">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                </td>
                            </tr>
                            <%      }
                            } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    Bạn chưa đặt đơn hàng nào.
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold" style="color: #005C97;">Chi Tiết Đơn Hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body pt-0" id="modalContent">
                    <% if (request.getAttribute("autoOpenModal") != null) { %>
                    <jsp:include page="order-detail.jsp" />
                    <% } else { %>
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status"></div>
                        <p class="mt-2 text-muted small">Đang tải dữ liệu...</p>
                    </div>
                    <% } %>
                </div>

                <div class="modal-footer border-top-0 pt-0 pb-4">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

<%@ include file="footer.jsp" %>