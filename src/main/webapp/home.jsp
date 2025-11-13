<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Trang Chủ");
%>
<%@ include file="header.jsp" %>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <h1 class="hero-title">Bữa Ăn Chất Lượng,<br>Khởi Đầu Thành Công</h1>
                <p class="hero-subtitle">Thưởng thức món ăn Việt Nam đậm chất truyền thống, được chế biến tươi mới mỗi ngày</p>
                <button class="btn btn-hero">
                    Xem Thực Đơn Ngay <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </div>
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&h=400&fit=crop"
                     alt="Món ăn đặc sắc"
                     class="img-fluid hero-image">
            </div>
        </div>
    </div>
</section>

<!-- Featured Dishes -->
<section class="py-5" style="padding: 80px 0 !important;">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Món Ăn Nổi Bật</h2>
            <p class="section-subtitle">Được yêu thích nhất bởi thực khách</p>
        </div>
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <span class="hot-badge">HOT</span>
                        <img src="${pageContext.request.contextPath}/assets/images/MonAn/mi_MiVitTiem.jpg"
                             class="card-img-top dish-image"
                             alt="Cơm Tấm Sườn Nướng">
                    </div>
                    <div class="card-body">
                        <h5 class="dish-name">Cơm Tấm Sườn Nướng</h5>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="dish-price">45.000đ</span>
                            <button class="btn btn-add-cart" onclick="addToCart()">
                                <i class="bi bi-cart-plus"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <span class="hot-badge">HOT</span>
                        <img src="https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400&h=300&fit=crop"
                             class="card-img-top dish-image"
                             alt="Phở Bò Đặc Biệt">
                    </div>
                    <div class="card-body">
                        <h5 class="dish-name">Phở Bò Đặc Biệt</h5>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="dish-price">50.000đ</span>
                            <button class="btn btn-add-cart" onclick="addToCart()">
                                <i class="bi bi-cart-plus"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <span class="hot-badge">HOT</span>
                        <img src="https://images.unsplash.com/photo-1559314809-0d155014e29e?w=400&h=300&fit=crop"
                             class="card-img-top dish-image"
                             alt="Bún Chả Hà Nội">
                    </div>
                    <div class="card-body">
                        <h5 class="dish-name">Bún Chả Hà Nội</h5>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="dish-price">42.000đ</span>
                            <button class="btn btn-add-cart" onclick="addToCart()">
                                <i class="bi bi-cart-plus"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <span class="hot-badge">HOT</span>
                        <img src="https://images.unsplash.com/photo-1559314809-0d155014e29e?w=400&h=300&fit=crop"
                             class="card-img-top dish-image"
                             alt="Bánh Mì Thịt Nướng">
                    </div>
                    <div class="card-body">
                        <h5 class="dish-name">Bánh Mì Thịt Nướng</h5>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="dish-price">25.000đ</span>
                            <button class="btn btn-add-cart" onclick="addToCart()">
                                <i class="bi bi-cart-plus"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- About Section -->
<section class="about-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <div class="row g-3">
                    <div class="col-6">
                        <img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=300&h=300&fit=crop"
                             class="img-fluid about-image" alt="Căn tin">
                    </div>
                    <div class="col-6 pt-5">
                        <img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=300&h=300&fit=crop"
                             class="img-fluid about-image" alt="Món ăn">
                    </div>
                    <div class="col-6">
                        <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&h=300&fit=crop"
                             class="img-fluid about-image" alt="Không gian">
                    </div>
                    <div class="col-6 pt-5">
                        <img src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300&h=300&fit=crop"
                             class="img-fluid about-image" alt="Thực phẩm">
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <h2 class="about-title">Về Chúng Tôi</h2>
                <p class="about-text">
                    NTC Canteen tự hào là địa chỉ tin cậy cung cấp bữa ăn sạch, ngon và tiện lợi cho mọi người.<br>
                    Với đội ngũ đầu bếp giàu kinh nghiệm và nguyên liệu tươi ngon được tuyển chọn kỹ lưỡng,
                    chúng tôi cam kết mang đến những món ăn chất lượng nhất với giá cả phải chăng.
                </p>
            </div>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>