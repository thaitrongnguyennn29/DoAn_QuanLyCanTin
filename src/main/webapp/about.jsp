<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Giới Thiệu");
%>
<%@ include file="header.jsp" %>

<div class="about-page">
    <!-- ABOUT SECTION -->
    <section class="hero-section position-relative">
        <div class="container position-relative z-2">
            <div class="row align-items-center">
                <div class="col-lg-6 text-center mt-4 mt-lg-0">
                    <img src="https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=800&q=80"
                         alt="NTC Canteen" class="hero-image img-fluid">
                </div>
                <div class="col-lg-6">
                    <h1 class="hero-title">Giới thiệu về NTC Canteen</h1>
                    <p class="hero-subtitle">
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

    <!-- VISION, MISSION & COMMITMENTS -->
    <section class="py-5">
        <div class="container text-center">
            <h2 class="section-title">Tầm nhìn &amp; Sứ mệnh</h2>
            <p class="section-subtitle">
                Hướng đến một môi trường căn-tin thông minh, an toàn và thân thiện hơn.
            </p>

            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <div class="card shadow-sm p-4 h-100 border-0">
                        <h4 class="h5 mb-3"><i class="bi bi-eye-fill text-primary me-2"></i>Tầm nhìn</h4>
                        <p class="mb-0">
                            Trở thành nền tảng quản lý căn tin hàng đầu, ứng dụng công nghệ số để mang đến trải nghiệm ăn uống an toàn, nhanh chóng và hiện đại.
                        </p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card shadow-sm p-4 h-100 border-0">
                        <h4 class="h5 mb-3"><i class="bi bi-bullseye text-primary me-2"></i>Sứ mệnh</h4>
                        <p class="mb-0">
                            Tối ưu hóa quy trình phục vụ, hỗ trợ nhà bếp quản lý hiệu quả
                            và giúp người dùng tiếp cận thực đơn lành mạnh, tiết kiệm thời gian và chi phí.
                        </p>
                    </div>
                </div>
            </div>

            <h2 class="section-title">Cam kết của chúng tôi</h2>
            <p class="section-subtitle">
                Chúng tôi luôn giữ vững niềm tin – mang đến trải nghiệm căn-tin thông minh, an toàn và tiện lợi nhất cho mọi người.
            </p>

            <div class="row g-4">
                <!-- Cam kết 1 -->
                <div class="col-md-4">
                    <div class="card shadow-sm p-4 h-100 border-0 text-center">
                        <div class="mb-3">
                            <i class="bi bi-shield-check text-primary fs-1"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">An toàn &amp; Minh bạch</h5>
                        <p class="mb-0">
                            Mỗi món ăn đều được chuẩn bị với nguồn nguyên liệu rõ ràng,
                            quy trình chế biến đạt chuẩn và công khai thông tin dinh dưỡng minh bạch.
                        </p>
                    </div>
                </div>

                <!-- Cam kết 2 -->
                <div class="col-md-4">
                    <div class="card shadow-sm p-4 h-100 border-0 text-center">
                        <div class="mb-3">
                            <i class="bi bi-lightning-charge text-primary fs-1"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">Nhanh chóng &amp; Tiện lợi</h5>
                        <p class="mb-0">
                            Ứng dụng công nghệ giúp quy trình đặt món và thanh toán chỉ trong vài giây —
                            đảm bảo tốc độ, chính xác và trải nghiệm mượt mà nhất cho người dùng.
                        </p>
                    </div>
                </div>

                <!-- Cam kết 3 -->
                <div class="col-md-4">
                    <div class="card shadow-sm p-4 h-100 border-0 text-center">
                        <div class="mb-3">
                            <i class="bi bi-heart-fill text-primary fs-1"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">Tận tâm &amp; Hướng đến cộng đồng</h5>
                        <p class="mb-0">
                            Chúng tôi luôn đặt con người ở trung tâm — mang lại môi trường ăn uống
                            thân thiện, văn minh và góp phần lan tỏa lối sống lành mạnh trong cộng đồng.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ABOUT NTC TEAM -->
    <section class="ntc-section">
        <div class="container text-center">
            <h2 class="section-title">Về nhóm NTC</h2>
            <p class="section-subtitle">
                Nhóm NTC – Học tập, phối hợp và phát triển kỹ năng làm việc nhóm.
            </p>

            <div class="row g-4 mb-5 justify-content-center">
                <div class="col-md-4">
                    <div class="card shadow-sm p-4 h-100 text-center border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/canteen.jpg" alt="Tấn" class="rounded-circle mb-4 mx-auto" style="width:140px;height:140px;object-fit:cover;">
                        <h5 class="fw-semibold"><i class="bi bi-person-circle me-2"></i>Hoàng Tấn</h5>
                        <p class="text-muted mb-0">Chủ Kênh</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm p-4 h-100 text-center border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/Nguyen.png" alt="Nguyễn" class="rounded-circle mb-4 mx-auto" style="width:140px;height:140px;object-fit:cover;">
                        <h5 class="fw-semibold"><i class="bi bi-person-circle me-2"></i>Thái Nguyễn</h5>
                        <p class="text-muted mb-0">Developer</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm p-4 h-100 text-center border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/Chien.jpg" alt="Chiến" class="rounded-circle mb-4 mx-auto" style="width:140px;height:140px;object-fit:cover;">
                        <h5 class="fw-semibold"><i class="bi bi-person-circle me-2"></i>Minh Chiến</h5>
                        <p class="text-muted mb-0">Designer</p>
                    </div>
                </div>
            </div>

            <div class="row g-4 text-start justify-content-center">
                <div class="col-lg-12">
                    <div class="goal-card shadow-sm p-4 h-100 border-0">
                        <h5 class="fw-semibold mb-3">
                            <i class="bi bi-flag-fill me-2"></i>Mục tiêu – nhiệm vụ của nhóm
                        </h5>
                        <ul class="mb-2 list-unstyled small">
                            <li class="mb-2"><i class="bi bi-bookmark-fill text-primary me-2"></i>
                                <strong>Mục tiêu học tập và rèn luyện kỹ năng:</strong> giao tiếp; lắng nghe; thuyết phục; ra quyết định; lập kế hoạch; thu thập, xử lý thông tin; kiểm soát, tổ chức, phân công nhiệm vụ; quản lý thời gian; giải quyết mâu thuẫn; kỹ năng thuyết trình; tư duy phản biện.
                            </li>
                            <li class="mb-2"><i class="bi bi-lightbulb-fill text-warning me-2"></i>
                                Tạo môi trường học tập hiệu quả, giúp các thành viên hỗ trợ lẫn nhau để nâng cao kiến thức và kỹ năng thực tiễn.
                            </li>
                            <li class="mb-2"><i class="bi bi-people-fill text-success me-2"></i>
                                Áp dụng các phương pháp học theo nhóm để nâng cao trách nhiệm cá nhân, khả năng làm việc độc lập.
                            </li>
                            <li class="mb-2"><i class="bi bi-stars text-primary me-2"></i>
                                <strong>Mục tiêu chung:</strong> Đạt được điểm A; đảm bảo sự tham gia tích cực của tất cả thành viên; xây dựng tinh thần trách nhiệm, kỷ luật và làm việc nhóm.
                            </li>
                            <li><i class="bi bi-list-check text-danger me-2"></i>
                                <strong>Nhiệm vụ:</strong> Làm bài thường kỳ, báo cáo giữa kỳ; phân công công việc cụ thể; chuẩn bị bài thuyết trình; đánh giá hiệu quả làm việc nhóm.
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
<%@ include file="footer.jsp" %>
