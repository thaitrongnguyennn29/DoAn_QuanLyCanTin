<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.GioHang" %>
<% request.setAttribute("pageTitle", "Xác nhận đơn hàng"); %>
<%@ include file="header.jsp" %>

<div class="checkout-page">

    <section class="hero-section text-center py-5">
        <div class="container">
            <h1 class="hero-title">Đon Hàng Của Tôi</h1>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6">

                    <div class="cart-items-wrapper mb-4">
                        <h3 class="summary-title">
                            <i class="bi bi-person-lines-fill me-2"></i>Thông tin giao hàng
                        </h3>

                        <form id="confirmForm" action="<%= request.getContextPath() %>/kiemtradonhang" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-secondary">Người nhận:</label>
                                <input type="text" class="form-control form-control-lg" value="${user.tenNguoiDung}" readonly>
                            </div>
                        </form>
                    </div>

                    <div class="cart-items-wrapper">
                        <h3 class="summary-title">
                            <i class="bi bi-bag-check-fill me-2"></i>Chi tiết đơn hàng
                        </h3>

                        <div class="mb-4 border-bottom">
                            <%
                                List<GioHang> cart = (List<GioHang>) session.getAttribute("cart");
                                if(cart != null && !cart.isEmpty()) {
                                    for(GioHang item : cart) {
                            %>
                            <div class="summary-item py-2">
                                <div class="d-flex align-items-center">
                                    <div>
                                        <span class="fw-bold text-dark"><%= item.getMonAn().getTenMonAn() %></span>
                                        <div class="small text-muted">Số lượng: <%= item.getQuantity() %></div>
                                    </div>
                                </div>
                                <span class="summary-value"><%= String.format("%,.0f", item.getTotalPrice()) %>đ</span>
                            </div>
                            <%      }
                            }
                            %>
                        </div>

                        <div class="summary-item">
                            <span>Tạm tính</span>
                            <span class="summary-value"><%= String.format("%,.0f", request.getAttribute("subtotal")) %>đ</span>
                        </div>

                        <div class="summary-item summary-total">
                            <span>Tổng thanh toán</span>
                            <span class="summary-value"><%= String.format("%,.0f", request.getAttribute("total")) %>đ</span>
                        </div>

                        <div class="mt-4">
                            <button type="submit" form="confirmForm" class="btn btn-checkout w-100 py-3 text-uppercase">
                                <i class="bi bi-check-circle-fill me-2"></i>Xác Nhận Thanh Toán
                            </button>

                            <div class="text-center mt-3">
                                <a href="<%= request.getContextPath() %>/giohang" class="text-decoration-none text-muted fw-bold">
                                    <i class="bi bi-arrow-left me-1"></i> Quay lại giỏ hàng
                                </a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>
</div>

<%@ include file="footer.jsp" %>