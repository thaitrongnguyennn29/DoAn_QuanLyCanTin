<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Liên Hệ");
%>
<%@ include file="header.jsp" %>

<div class="contact-page">

    <!-- ================= HERO SECTION ================= -->
    <section class="hero-section text-white text-center">
        <div class="container">
            <div class="row align-items-center">
                <!-- LEFT TEXT -->
                <div class="col-lg-6 text-start">
                    <h2 class="hero-title">NTC Team</h2>
                    <p class="hero-subtitle">
                        Chúng tôi là những sinh viên UTE đứng sau dự án này.
                        Hãy liên hệ nếu bạn có bất kỳ câu hỏi nào!
                    </p>
                </div>

                <!-- RIGHT IMAGE -->
                <div class="col-lg-6 text-center mt-4 mt-lg-0">
                    <img src="${pageContext.request.contextPath}/assets/images/UTE.png"
                         alt="UTE"
                         class="hero-image img-fluid">
                </div>
            </div>
        </div>
    </section>

    <!-- ================= TEAM MEMBER SECTION ================= -->
    <section class="py-5 bg-light" id="team-section">
        <div class="container">

            <div class="text-center mb-5">
                <h2 class="section-title">Thành Viên Nhóm</h2>
                <p class="section-subtitle">Những thành viên thực hiện đồ án này.</p>
            </div>

            <div class="row g-4 justify-content-center">

                <!-- MEMBER 1 -->
                <div class="col-lg-4 col-md-6">
                    <div class="card team-card text-center shadow-sm border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/Nguyen.jpg"
                             class="team-avatar card-img-top">

                        <div class="card-body">
                            <h5 class="fw-bold">Thái Trọng Nguyễn</h5>
                            <p class="mb-1">Font-end Developer</p>
                            <p class="text-muted">MSSV: 24810118</p>

                            <p class="mb-1">
                                <i class="bi bi-envelope-fill text-primary"></i> thaitrongnguyennn29@gmail.com
                            </p>
                            <p>
                                <i class="bi bi-telephone-fill text-primary"></i> 0833 644 646
                            </p>

                            <div class="d-flex justify-content-center gap-3 fs-5 social-links">
                                <a href="https://www.facebook.com/thainguyenn1710" class="text-primary"><i class="bi bi-facebook"></i></a>
                                <a href="https://github.com/thaitrongnguyennn29" class="text-dark"><i class="bi bi-github"></i></a>
                                <a href="https://mail.google.com/mail/?view=cm&fs=1&to=thaitrongnguyennn29@gmail.com&su=Liên hệ với tôi" class="text-danger"><i class="bi bi-google"></i></a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MEMBER 2 -->
                <div class="col-lg-4 col-md-6">
                    <div class="card team-card text-center shadow-sm border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/Tan.jpg"
                             class="team-avatar card-img-top">

                        <div class="card-body">
                            <h5 class="fw-bold">Trần Hoàng Tấn</h5>
                            <p class="mb-1">Back-end Developer</p>
                            <p class="text-muted">MSSV: 24810126</p>

                            <p class="mb-1">
                                <i class="bi bi-envelope-fill text-primary"></i> oxygiang123@gmail.com
                            </p>
                            <p>
                                <i class="bi bi-telephone-fill text-primary"></i> 0866 604 057
                            </p>

                            <div class="d-flex justify-content-center gap-3 fs-5 social-links">
                                <a href="https://www.facebook.com/hoang.tan.735972" class="text-primary"><i class="bi bi-facebook"></i></a>
                                <a href="https://github.com/htan03" class="text-dark"><i class="bi bi-github"></i></a>
                                <a href="https://mail.google.com/mail/?view=cm&fs=1&to=oxygiang123@gmail.com&su=Liên hệ với tôi" class="text-danger"><i class="bi bi-google"></i></a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MEMBER 3 -->
                <div class="col-lg-4 col-md-6">
                    <div class="card team-card text-center shadow-sm border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/Chien.jpg"
                             class="team-avatar card-img-top">

                        <div class="card-body">
                            <h5 class="fw-bold">Trần Minh Chiến</h5>
                            <p class="mb-1">Database / Tester</p>
                            <p class="text-muted">MSSV: 24810106</p>

                            <p class="mb-1">
                                <i class="bi bi-envelope-fill text-primary"></i> chien180203@gmail.com
                            </p>
                            <p>
                                <i class="bi bi-telephone-fill text-primary"></i> 0786 160 270
                            </p>

                            <div class="d-flex justify-content-center gap-3 fs-5 social-links">
                                <a href="https://www.facebook.com/chien.tran.89693" class="text-primary"><i class="bi bi-facebook"></i></a>
                                <a href="https://github.com/tranminhchien1802" class="text-dark"><i class="bi bi-github"></i></a>
                                <a href="https://mail.google.com/mail/?view=cm&fs=1&to=chien180203@gmail.com&su=Liên hệ với tôi" class="text-danger"><i class="bi bi-google"></i></a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

</div>

<%@ include file="footer.jsp" %>
