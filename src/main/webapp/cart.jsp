<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Giỏ Hàng");
%>
<%@ include file="header.jsp" %>
<div class="cart-page">
    <!-- HERO -->
    <section class="hero-section text-center py-5">
        <div class="container">
            <h1 class="hero-title">Giỏ Hàng Của Bạn</h1>
            <p class="hero-subtitle mb-0">Kiểm tra các món ăn và hoàn tất đơn hàng.</p>
        </div>
    </section>

    <!-- CART CONTENT -->
    <section class="cart-content py-5">
        <div class="container">
            <div class="row">
                <!-- CART ITEMS - BÊN TRÁI -->
                <div class="col-lg-8 mb-4">
                    <div class="cart-items-wrapper">
                        <h2 class="section-title">Món Ăn Đã Chọn</h2>
                        <p class="section-subtitle">Bạn có 3 món trong giỏ hàng</p>

                        <!-- Cart Item -->
                        <div class="cart-item">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-3">
                                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200&h=200&fit=crop"
                                         alt="Pizza" class="cart-item-img">
                                </div>
                                <div class="col-md-4 col-9">
                                    <h5 class="cart-item-name">Pizza Hải Sản Đặc Biệt</h5>
                                    <p class="cart-item-desc">Size: Lớn, Viền phô mai</p>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="quantity-control">
                                        <button class="qty-btn minus">-</button>
                                        <input type="number" class="qty-input" value="1" min="1">
                                        <button class="qty-btn plus">+</button>
                                    </div>
                                </div>
                                <div class="col-md-2 col-4">
                                    <p class="cart-item-price">299.000đ</p>
                                </div>
                                <div class="col-md-1 col-2">
                                    <button class="btn-remove">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="cart-item">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-3">
                                    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&h=200&fit=crop"
                                         alt="Burger" class="cart-item-img">
                                </div>
                                <div class="col-md-4 col-9">
                                    <h5 class="cart-item-name">Burger Bò Phô Mai</h5>
                                    <p class="cart-item-desc">Kèm khoai tây chiên</p>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="quantity-control">
                                        <button class="qty-btn minus">-</button>
                                        <input type="number" class="qty-input" value="2" min="1">
                                        <button class="qty-btn plus">+</button>
                                    </div>
                                </div>
                                <div class="col-md-2 col-4">
                                    <p class="cart-item-price">149.000đ</p>
                                </div>
                                <div class="col-md-1 col-2">
                                    <button class="btn-remove">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="cart-item">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-3">
                                    <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&h=200&fit=crop"
                                         alt="Salad" class="cart-item-img">
                                </div>
                                <div class="col-md-4 col-9">
                                    <h5 class="cart-item-name">Salad Trộn Rau Củ</h5>
                                    <p class="cart-item-desc">Sốt dầu ô liu</p>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="quantity-control">
                                        <button class="qty-btn minus">-</button>
                                        <input type="number" class="qty-input" value="1" min="1">
                                        <button class="qty-btn plus">+</button>
                                    </div>
                                </div>
                                <div class="col-md-2 col-4">
                                    <p class="cart-item-price">89.000đ</p>
                                </div>
                                <div class="col-md-1 col-2">
                                    <button class="btn-remove">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="continue-shopping mt-4">
                            <a href="menu.jsp" class="btn btn-outline-primary">
                                <i class="bi bi-arrow-left me-2"></i>Tiếp Tục Mua Sắm
                            </a>
                        </div>
                    </div>
                </div>

                <!-- ORDER SUMMARY - BÊN PHẢI -->
                <div class="col-lg-4">
                    <div class="order-summary">
                        <h3 class="summary-title">Tóm Tắt Đơn Hàng</h3>

                        <div class="summary-item">
                            <span>Tạm tính</span>
                            <span class="summary-value">686.000đ</span>
                        </div>

                        <div class="summary-item">
                            <span>Phí vận chuyển</span>
                            <span class="summary-value">30.000đ</span>
                        </div>

                        <div class="summary-item">
                            <span>Giảm giá</span>
                            <span class="summary-value text-success">-50.000đ</span>
                        </div>

                        <hr class="summary-divider">

                        <div class="summary-item summary-total">
                            <span>Tổng cộng</span>
                            <span class="summary-value">666.000đ</span>
                        </div>

                        <button class="btn btn-checkout w-100 mt-4">
                            Đặt Hàng Ngay
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
    document.querySelectorAll('.qty-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.parentElement.querySelector('.qty-input');
            let value = parseInt(input.value);

            if(this.classList.contains('plus')) {
                input.value = value + 1;
            } else if(this.classList.contains('minus') && value > 1) {
                input.value = value - 1;
            }
        });
    });
</script>

<%@ include file="footer.jsp" %>