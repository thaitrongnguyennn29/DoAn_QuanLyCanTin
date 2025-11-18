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
                        <img src="${pageContext.request.contextPath}/assets/images/Nguyen.png"
                             class="team-avatar card-img-top">

                        <div class="card-body">
                            <h5 class="fw-bold">Nguyễn Văn A</h5>
                            <p class="mb-1">Team Leader / Back-end</p>
                            <p class="text-muted">MSSV: 20012345</p>

                            <p class="mb-1">
                                <i class="bi bi-envelope-fill text-primary"></i> an.nguyen@student.edu.vn
                            </p>
                            <p>
                                <i class="bi bi-telephone-fill text-primary"></i> 0900 111 222
                            </p>

                            <div class="d-flex justify-content-center gap-3 fs-5 social-links">
                                <a href="#" class="text-primary"><i class="bi bi-facebook"></i></a>
                                <a href="#" class="text-dark"><i class="bi bi-github"></i></a>
                                <a href="#" class="text-danger"><i class="bi bi-google"></i></a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MEMBER 2 -->
                <div class="col-lg-4 col-md-6">
                    <div class="card team-card text-center shadow-sm border-0">
                        <img src="https://via.placeholder.com/300x300/363795/FFFFFF?text=Avatar+2"
                             class="team-avatar card-img-top">

                        <div class="card-body">
                            <h5 class="fw-bold">Trần Thị B</h5>
                            <p class="mb-1">Front-end Developer</p>
                            <p class="text-muted">MSSV: 20054321</p>

                            <p class="mb-1">
                                <i class="bi bi-envelope-fill text-primary"></i> b.tran@student.edu.vn
                            </p>
                            <p>
                                <i class="bi bi-telephone-fill text-primary"></i> 0900 333 444
                            </p>

                            <div class="d-flex justify-content-center gap-3 fs-5 social-links">
                                <a href="#" class="text-primary"><i class="bi bi-facebook"></i></a>
                                <a href="#" class="text-dark"><i class="bi bi-github"></i></a>
                                <a href="#" class="text-danger"><i class="bi bi-google"></i></a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MEMBER 3 -->
                <div class="col-lg-4 col-md-6">
                    <div class="card team-card text-center shadow-sm border-0">
                        <img src="https://via.placeholder.com/300x300/6c757d/FFFFFF?text=Avatar+3"
                             class="team-avatar card-img-top">

                        <div class="card-body">
                            <h5 class="fw-bold">Lê Văn C</h5>
                            <p class="mb-1">Database / Tester</p>
                            <p class="text-muted">MSSV: 20098765</p>

                            <p class="mb-1">
                                <i class="bi bi-envelope-fill text-primary"></i> c.le@student.edu.vn
                            </p>
                            <p>
                                <i class="bi bi-telephone-fill text-primary"></i> 0900 555 666
                            </p>

                            <div class="d-flex justify-content-center gap-3 fs-5 social-links">
                                <a href="#" class="text-primary"><i class="bi bi-facebook"></i></a>
                                <a href="#" class="text-dark"><i class="bi bi-github"></i></a>
                                <a href="#" class="text-danger"><i class="bi bi-google"></i></a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

</div>

<%@ include file="footer.jsp" %>
