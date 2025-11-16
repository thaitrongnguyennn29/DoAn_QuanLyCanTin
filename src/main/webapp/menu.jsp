<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="header.jsp" %>

<div class="menu-page">

    <!-- HERO -->
    <section class="menu-hero  position-relative py-5">
        <div class="container position-relative z-2">
            <h1 class="menu-hero-title fw-bold display-5">Thực Đơn Mỗi Ngày</h1>
            <p class="menu-hero-subtitle lead mb-4">Chọn món ngon – Chuẩn vị – Giá sinh viên</p>
            <a href="#menulist" class="btn menu-hero-btn">Khám phá ngay</a>
        </div>
    </section>

    <!-- FILTER -->
    <section  class="menu-filter py-5">
        <div class="container">

            <h2 class="menu-section-title fw-bold mb-3 text-center">Phân Loại Món Ăn</h2>
            <p class="menu-section-subtitle text-muted text-center mb-4">Tươi ngon, dinh dưỡng và chuẩn vị căn tin sinh viên.</p>

            <div id="menulist" class="menu-filter-btn d-flex flex-wrap justify-content-center gap-2 mb-5">
                <button class="btn btn-outline-primary active" data-filter="all">Tất cả</button>
                <button class="btn btn-outline-primary" data-filter="com">Cơm</button>
                <button class="btn btn-outline-primary" data-filter="mi">Mì</button>
                <button class="btn btn-outline-primary" data-filter="pho">Phở</button>
                <button class="btn btn-outline-primary" data-filter="do-uong">Đồ Uống</button>
            </div>

            <div class="row g-4">
                                <!-- CARD ITEM -->
                <div class="col-lg-3 col-md-6 menu-card-item" data-category="com">
                    <div class="dish-card">
                        <div class="dish-image-wrapper">
                            <img src="assets/images/MonAn/com_ComBo.jpg" class="dish-image w-100" alt="Cơm Bò Lúc Lắc">
                        </div>
                        <div class="p-3">
                            <h5 class="dish-name">Cơm Bò Lúc Lắc</h5>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="dish-price">65.000đ</span>
                                <button class="btn-add-cart btn-sm"><i class="bi bi-cart-plus"></i> Thêm</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 menu-card-item" data-category="com">
                    <div class="dish-card">
                        <div class="dish-image-wrapper">
                            <img src="assets/images/MonAn/com_ComChienCaMan.jpg" class="dish-image w-100" alt="Cơm Chiên Cá Mặn">
                        </div>
                        <div class="p-3">
                            <h5 class="dish-name">Cơm Chiên Cá Mặn</h5>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="dish-price">45.000đ</span>
                                <button class="btn-add-cart btn-sm"><i class="bi bi-cart-plus"></i> Thêm</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ABOUT -->
    <section class="menu-about py-5">
        <div class="container">
            <div class="row align-items-center gy-4">

                <div class="col-md-6">
                    <img src="${pageContext.request.contextPath}/assets/images/canteen.jpg"
                         class="menu-about-img img-fluid rounded" alt="Căn tin VN">
                </div>

                <div class="col-md-6">
                    <h2 class="menu-about-title fw-bold mb-3">Vì sao chọn NTC Canteen?</h2>
                    <p class="menu-about-text mb-4">
                        Mỗi món ăn đều được chế biến từ nguyên liệu tươi ngon, đảm bảo an toàn và dinh dưỡng.
                        Chúng tôi mang đến hương vị quen thuộc, phục vụ nhanh chóng với giá cả hợp lý cho sinh viên và tất cả mọi người.
                    </p>

                    <div class="row menu-about-features">
                        <div class="col-6 mb-3">
                            <i class="bi bi-shield-check text-primary fs-4 me-2"></i>
                            Vệ sinh an toàn thực phẩm
                        </div>

                        <div class="col-6 mb-3">
                            <i class="bi bi-clock-history text-primary fs-4 me-2"></i>
                            Phục vụ nhanh chóng
                        </div>

                        <div class="col-6 mb-3">
                            <i class="bi bi-heart-fill text-danger fs-4 me-2"></i>
                            Nguyên liệu tươi sạch
                        </div>

                        <div class="col-6 mb-3">
                            <i class="bi bi-currency-exchange text-success fs-4 me-2"></i>
                            Giá sinh viên thân thiện
                        </div>
                    </div>

                    <a href="#menulist" class="btn btn-primary menu-about-btn mt-3">Xem Thực Đơn</a>
                </div>

            </div>
        </div>
    </section>

</div>

<%@ include file="footer.jsp" %>
