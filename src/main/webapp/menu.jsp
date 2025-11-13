<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Thực Đơn");
%>

<%@ include file="header.jsp" %>

<!-- Hero Section -->
<!-- Hero Section -->
<section class="hero-section text-center position-relative">
    <div class="container position-relative z-2">
        <h1 class="hero-title">Thực Đơn Mỗi Ngày</h1>
        <p class="hero-subtitle mb-4">Chọn món ngon – Chuẩn vị – Giá sinh viên</p>
        <a href="#menu-list" class="btn btn-hero">Khám phá ngay</a>
    </div>
</section>

<!-- Menu List Section -->
<section id="menu-list" class="py-5">
    <div class="container">
        <h2 class="section-title mb-4">Phân Loại Món Ăn</h2>
        <p class="section-subtitle text-center mb-4">Tươi ngon, dinh dưỡng và chuẩn vị căn tin sinh viên.</p>
        <div class="d-flex flex-wrap justify-content-center gap-3 mb-5">
            <button class="btn btn-gradient filter-btn active" data-filter="all">Tất cả</button>
            <button class="btn btn-gradient filter-btn" data-filter="com">Cơm</button>
            <button class="btn btn-gradient filter-btn" data-filter="mi">Mì</button>
            <button class="btn btn-gradient filter-btn" data-filter="pho">Phở</button>
            <button class="btn btn-gradient filter-btn" data-filter="do-uong">Đồ Uống</button>
        </div>

        <div class="row g-4">
            <!-- Cơm -->
            <div class="col-md-4 menu-item" data-category="com">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <span class="hot-badge">Hot</span>
                        <img src="${pageContext.request.contextPath}/assets/images/MonAn/com_ComChienCaMan.jpg" class="card-img-top dish-image" alt="Cơm sườn trứng">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Cơm Sườn Trứng</h5>
                        <p class="dish-price">45.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <div class="col-md-4 menu-item" data-category="com">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/com-ga.jpg" class="dish-image" alt="Cơm Gà Xối Mỡ">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Cơm Gà Xối Mỡ</h5>
                        <p class="dish-price">42.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <div class="col-md-4 menu-item" data-category="com">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/com-tam-bi.jpg" class="dish-image" alt="Cơm Tấm Bì Chả">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Cơm Tấm Bì Chả</h5>
                        <p class="dish-price">38.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <!-- Mì -->
            <div class="col-md-4 menu-item" data-category="mi">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/mi-xao.jpg" class="dish-image" alt="Mì Xào Bò">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Mì Xào Bò</h5>
                        <p class="dish-price">40.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <div class="col-md-4 menu-item" data-category="mi">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/mi-tom.jpg" class="dish-image" alt="Mì Tôm Trứng">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Mì Tôm Trứng</h5>
                        <p class="dish-price">25.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <div class="col-md-4 menu-item" data-category="mi">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/mi-tron.jpg" class="dish-image" alt="Mì Trộn Gà">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Mì Trộn Gà</h5>
                        <p class="dish-price">37.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <!-- Phở -->
            <div class="col-md-4 menu-item" data-category="pho">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/pho-bo.jpg" class="dish-image" alt="Phở Bò Tái">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Phở Bò Tái</h5>
                        <p class="dish-price">35.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <div class="col-md-4 menu-item" data-category="pho">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/pho-ga.jpg" class="dish-image" alt="Phở Gà">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Phở Gà</h5>
                        <p class="dish-price">33.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>

            <!-- Đồ uống -->
            <div class="col-md-4 menu-item" data-category="do-uong">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/tra-sua.jpg" class="dish-image" alt="Trà Sữa">
                    </div>
                    <div class="card-body text-center">
                        <h5 class="dish-name">Trà Sữa Trân Châu</h5>
                        <p class="dish-price">25.000đ</p>
                        <button class="btn btn-add-cart">Thêm vào giỏ</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- About Section -->
<section class="about-section">
    <div class="container">
        <div class="row align-items-center gy-4">
            <div class="col-md-6">
                <img src="${pageContext.request.contextPath}/assets/images/canteen.jpg"
                     class="about-image w-100" alt="Căn tin VN">
            </div>

            <div class="col-md-6">
                <h2 class="about-title mb-3">Vì sao chọn Căn Tin VN?</h2>
                <p class="about-text mb-4">
                    Mỗi món ăn đều được chế biến từ nguyên liệu tươi ngon, đảm bảo an toàn và dinh dưỡng.
                    Chúng tôi mang đến hương vị quen thuộc, phục vụ nhanh chóng với giá cả hợp lý cho sinh viên và nhân viên văn phòng.
                </p>

                <div class="row text-start">
                    <div class="col-6 mb-3">
                        <i class="bi bi-shield-check text-primary fs-4 me-2"></i>
                        <span>Vệ sinh an toàn thực phẩm</span>
                    </div>
                    <div class="col-6 mb-3">
                        <i class="bi bi-clock-history text-primary fs-4 me-2"></i>
                        <span>Phục vụ nhanh chóng</span>
                    </div>
                    <div class="col-6 mb-3">
                        <i class="bi bi-heart-fill text-danger fs-4 me-2"></i>
                        <span>Nguyên liệu tươi sạch</span>
                    </div>
                    <div class="col-6 mb-3">
                        <i class="bi bi-currency-exchange text-success fs-4 me-2"></i>
                        <span>Giá sinh viên thân thiện</span>
                    </div>
                </div>

                <a href="#menu-list" class="btn btn-gradient mt-3">Xem Thực Đơn</a>
            </div>
        </div>
    </div>
</section>


<%@ include file="footer.jsp" %>
