<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Giới Thiệu");
%>
<%@ include file="header.jsp" %>

<!-- ================== ABOUT SECTION ================== -->
<section class="about-section pt-5" id="menu-about">
    <div class="container">
        <div class="row align-items-center gy-5">
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=800&q=80"
                     alt="NTC Canteen" class="about-image w-100">
            </div>
            <div class="col-lg-6">
                <h2 class="about-title">Giới thiệu về NTC Canteen</h2>
                <p class="about-text">
                    <strong>NTC Canteen</strong> là hệ thống quản lý căn tin hiện đại, được phát triển nhằm mang lại sự tiện lợi,
                    nhanh chóng và minh bạch cho học sinh, sinh viên và nhân viên tại các trường học hoặc doanh nghiệp.
                    <br><br>
                    Với nền tảng công nghệ tiên tiến, NTC Canteen giúp bạn dễ dàng đặt món
                    và theo dõi dinh dưỡng hàng ngày — tất cả chỉ trong vài cú chạm.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- ================== VISION, MISSION & COMMITMENTS ================== -->
<section id="vision" class="py-5">
    <div class="container text-center">
        <h2 class="section-title">Tầm nhìn & Sứ mệnh</h2>
        <p class="section-subtitle mb-5">
            Hướng đến một môi trường căn-tin thông minh, an toàn và thân thiện hơn.
        </p>
        <div class="row g-4 mb-5">
            <div class="col-md-6">
                <div class="dish-card p-4">
                    <h4 class="dish-name mb-3"><i class="bi bi-eye-fill text-primary me-2"></i>Tầm nhìn</h4>
                    <p class="about-text mb-0">
                        Trở thành nền tảng quản lý căn tin hàng đầu, ứng dụng công nghệ số để mang đến trải nghiệm ăn uống an toàn, nhanh chóng và hiện đại.
                    </p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="dish-card p-4">
                    <h4 class="dish-name mb-3"><i class="bi bi-bullseye text-primary me-2"></i>Sứ mệnh</h4>
                    <p class="about-text mb-0">
                        Tối ưu hóa quy trình phục vụ, hỗ trợ nhà bếp quản lý hiệu quả
                        và giúp người dùng tiếp cận thực đơn lành mạnh, tiết kiệm thời gian và chi phí.
                    </p>
                </div>
            </div>
        </div>

        <h2 class="section-title">Cam kết của chúng tôi</h2>
        <p class="section-subtitle mb-5">
            Chúng tôi luôn giữ vững niềm tin – mang đến trải nghiệm căn-tin thông minh, an toàn và tiện lợi nhất cho mọi người.
        </p>

        <div class="row g-4">
            <!-- Cam kết 1 -->
            <div class="col-md-4">
                <div class="dish-card p-4 h-100">
                    <div class="dish-image-wrapper mb-3">
                        <i class="bi bi-shield-check text-primary fs-1"></i>
                    </div>
                    <h5 class="dish-name mb-2">An toàn & Minh bạch</h5>
                    <p class="about-text">
                        Mỗi món ăn đều được chuẩn bị với nguồn nguyên liệu rõ ràng,
                        quy trình chế biến đạt chuẩn và công khai thông tin dinh dưỡng minh bạch.
                    </p>
                </div>
            </div>

            <!-- Cam kết 2 -->
            <div class="col-md-4">
                <div class="dish-card p-4 h-100">
                    <div class="dish-image-wrapper mb-3">
                        <i class="bi bi-lightning-charge text-primary fs-1"></i>
                    </div>
                    <h5 class="dish-name mb-2">Nhanh chóng & Tiện lợi</h5>
                    <p class="about-text">
                        Ứng dụng công nghệ giúp quy trình đặt món và thanh toán chỉ trong vài giây —
                        đảm bảo tốc độ, chính xác và trải nghiệm mượt mà nhất cho người dùng.
                    </p>
                </div>
            </div>

            <!-- Cam kết 3 -->
            <div class="col-md-4">
                <div class="dish-card p-4 h-100">
                    <div class="dish-image-wrapper mb-3">
                        <i class="bi bi-heart-fill text-primary fs-1"></i>
                    </div>
                    <h5 class="dish-name mb-2">Tận tâm & Hướng đến cộng đồng</h5>
                    <p class="about-text">
                        Chúng tôi luôn đặt con người ở trung tâm — mang lại môi trường ăn uống
                        thân thiện, văn minh và góp phần lan tỏa lối sống lành mạnh trong cộng đồng.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>


<%@ include file="footer.jsp" %>
