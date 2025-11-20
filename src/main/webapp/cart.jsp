<%@ page import="Model.GioHang" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Giỏ Hàng"); %>
<%@ include file="header.jsp" %>

<div class="cart-page">
    <section class="hero-section text-center py-5">
        <div class="container">
            <h1 class="hero-title">Giỏ Hàng Của Bạn</h1>
            <p class="hero-subtitle mb-0">Kiểm tra các món ăn và hoàn tất đơn hàng.</p>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <%
                List<GioHang> cart = (List<GioHang>) session.getAttribute("cart");
                if (cart == null || cart.isEmpty()) {
            %>
            <div class="container py-5">
                <div class="empty-cart-wrapper text-center py-5">
                    <div class="empty-cart-icon mb-4">
                        <i class="bi bi-cart-x"></i>
                    </div>
                    <h3 class="empty-cart-title mb-3">
                        Giỏ hàng của bạn đang trống
                    </h3>
                    <p class="empty-cart-text mb-4">
                        Có vẻ như bạn chưa chọn món ăn nào.<br>
                        Hãy ghé qua thực đơn để chọn món ngon nhé!
                    </p>
                    <div class="continue-shopping mt-4">
                        <a href="<%= request.getContextPath() %>/thucdon" class="btn btn-outline-primary">
                            <i class="bi bi-arrow-left me-2"></i>Khám phá thực đơn
                        </a>
                    </div>
                </div>
            </div>
            <% } else {
                Double subtotal = (Double) request.getAttribute("subtotal");
                Double discount = (Double) request.getAttribute("discount");
                Double total = (Double) request.getAttribute("total");
            %>
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="cart-items-wrapper">
                        <h2 class="section-title">Món Ăn Đã Chọn</h2>
                        <p class="section-subtitle">Bạn có <%= cart.size() %> món trong giỏ hàng</p>

                        <% for (GioHang item : cart) { %>
                        <div class="cart-item">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-3">
                                    <img src="<%= request.getContextPath() %>/assets/images/MonAn/<%= item.getMonAn().getHinhAnh() %>"
                                         alt="<%= item.getMonAn().getTenMonAn() %>"
                                         class="cart-item-img">
                                </div>
                                <div class="col-md-4 col-9">
                                    <h5 class="cart-item-name mb-0"><%= item.getMonAn().getTenMonAn() %></h5>
                                    <small class="text-muted"><%= String.format("%,.0f", item.getMonAn().getGia()) %>đ / món</small>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="quantity-control">
                                        <button class="qty-btn minus" data-mamon="<%= item.getMonAn().getMaMonAn() %>">-</button>
                                        <input type="number" class="qty-input" value="<%= item.getQuantity() %>"
                                               data-mamon="<%= item.getMonAn().getMaMonAn() %>" readonly>
                                        <button class="qty-btn plus" data-mamon="<%= item.getMonAn().getMaMonAn() %>">+</button>
                                    </div>
                                </div>
                                <div class="col-md-2 col-4">
                                    <p class="cart-item-price mb-0"><%= String.format("%,.0f", item.getTotalPrice()) %>đ</p>
                                </div>
                                <div class="col-md-1 col-2">
                                    <button class="btn-remove" data-mamon="<%= item.getMonAn().getMaMonAn() %>">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <div class="continue-shopping mt-4">
                            <a href="<%= request.getContextPath() %>/thucdon" class="btn btn-outline-primary">
                                <i class="bi bi-arrow-left me-2"></i>Tiếp Tục Mua Sắm
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="order-summary">
                        <h3 class="summary-title">Tóm Tắt Đơn Hàng</h3>
                        <div class="summary-item">
                            <span>Tạm tính</span>
                            <span class="summary-value"><%= String.format("%,.0f", subtotal) %>đ</span>
                        </div>
                        <% if (discount > 0) { %>
                        <div class="summary-item">
                            <span>Giảm giá</span>
                            <span class="summary-value text-success">-<%= String.format("%,.0f", discount) %>đ</span>
                        </div>
                        <% } %>
                        <hr class="summary-divider">
                        <div class="summary-item summary-total">
                            <span>Tổng cộng</span>
                            <span class="summary-value"><%= String.format("%,.0f", total) %>đ</span>
                        </div>
                        <button class="btn btn-checkout w-100 mt-4"
                                onclick="window.location.href='<%= request.getContextPath() %>/kiemtradonhang'">
                            Đặt Hàng Ngay
                        </button>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </section>
</div>

<%@ include file="footer.jsp" %>