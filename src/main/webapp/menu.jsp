<%@ page import="Model.MonAn" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // 1. Xử lý ngày hiện tại
    LocalDate today = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String ngayHienTai = today.format(formatter);

    // 2. Set tiêu đề page
    request.setAttribute("pageTitle", "Thực Đơn");
%>

<%@ include file="header.jsp" %>

<div class="menu-page">

    <section class="menu-hero position-relative py-5">
        <div class="container position-relative z-2 text-center">
            <h1 class="menu-hero-title fw-bold display-5 mb-3">Thực Đơn Hôm Nay</h1>

            <div class="d-flex justify-content-center mb-4">
                <div class="hero-date-badge">
                    <i class="bi bi-calendar2-week me-2"></i>
                    <span>Hôm nay: <strong><%= ngayHienTai %></strong></span>
                </div>
            </div>
            <p class="menu-hero-subtitle lead mb-4">Chọn món ngon – Chuẩn vị – Giá sinh viên</p>
            <a href="#menulist" class="btn menu-hero-btn">
                Khám phá ngay <i class="bi bi-arrow-down-short"></i>
            </a>
        </div>
    </section>

    <section class="menu-filter py-5">
        <div class="container">

            <h2 class="menu-section-title fw-bold mb-3 text-center">Phân Loại Món Ăn</h2>
            <p class="menu-section-subtitle text-muted text-center mb-4">Tươi ngon, dinh dưỡng và chuẩn vị căn tin sinh viên.</p>

            <div id="menulist" class="menu-filter-btn d-flex flex-wrap justify-content-center gap-2 mb-5">
                <a class="btn btn-outline-primary filter-btn
                    <%= (request.getParameter("filter") == null
                    || "all".equals(request.getParameter("filter"))) ? "active" : "" %>"
                   href="thucdon?filter=all"
                   data-filter="all">
                    Tất cả
                </a>

                <%
                    List<Model.Quay> listQuay = (List<Model.Quay>) request.getAttribute("listQuay");
                    if(listQuay != null) {
                        for(Model.Quay q : listQuay) {
                %>
                <a class="btn btn-outline-primary filter-btn
                    <%= String.valueOf(q.getMaQuay()).equals(request.getParameter("filter")) ? "active" : "" %>"
                   href="thucdon?filter=<%= q.getMaQuay() %>"
                   data-filter="<%= q.getMaQuay() %>">
                    <%= q.getTenQuay() %>
                </a>
                <%
                        }
                    }
                %>
            </div>

            <div class="row g-4">
                <%
                    List<MonAn> list = (List<Model.MonAn>) request.getAttribute("listMonAn");
                    String imageDirectory = "assets/images/MonAn/";

                    if (list != null && !list.isEmpty()) {
                        for (Model.MonAn mon : list) {
                            String fullImagePath = imageDirectory + mon.getHinhAnh();
                %>

                <div class="col-lg-3 col-md-6 menu-card-item"
                     data-category="<%= mon.getMaQuay() %>">

                    <div class="dish-card">
                        <div class="dish-image-wrapper">
                            <img src="<%= request.getContextPath() + "/" + fullImagePath %>"
                                 class="dish-image w-100"
                                 alt="<%= mon.getTenMonAn() %>">
                        </div>

                        <div class="p-3">
                            <h5 class="dish-name text-truncate" title="<%= mon.getTenMonAn() %>"><%= mon.getTenMonAn() %></h5>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="dish-price">
                                    <%= String.format("%,.0f", mon.getGia()) %>đ
                                </span>

                                <button class="btn-add-cart btn-sm" data-mamon="<%= mon.getMaMonAn() %>">
                                    <i class="bi bi-cart-plus"></i> Thêm
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <%
                    }
                } else {
                %>
                <div class="col-12 text-center py-5">
                    <div class="bg-light rounded p-5 d-inline-block">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="mt-3 text-muted mb-0">Chưa có thực đơn cho ngày hôm nay (<%= ngayHienTai %>).</p>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </section>

    <section class="menu-about py-5 bg-light"> <div class="container">
        <div class="row align-items-center gy-4">

            <div class="col-md-6">
                <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&h=400&fit=crop"
                     class="menu-about-img img-fluid rounded shadow" alt="Căn tin VN">
            </div>

            <div class="col-md-6">
                <h2 class="menu-about-title fw-bold mb-3">Vì sao chọn NTC Canteen?</h2>
                <p class="menu-about-text mb-4">
                    Mỗi món ăn đều được chế biến từ nguyên liệu tươi ngon, đảm bảo an toàn và dinh dưỡng.
                    Chúng tôi mang đến hương vị quen thuộc, phục vụ nhanh chóng với giá cả hợp lý.
                </p>

                <div class="row menu-about-features g-3"> <div class="col-6">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-shield-check text-primary fs-4 me-2"></i>
                        <span>ATVSTP</span>
                    </div>
                </div>

                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-clock-history text-primary fs-4 me-2"></i>
                            <span>Nhanh chóng</span>
                        </div>
                    </div>

                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-heart-fill text-danger fs-4 me-2"></i>
                            <span>Tươi ngon</span>
                        </div>
                    </div>

                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-currency-exchange text-success fs-4 me-2"></i>
                            <span>Giá rẻ</span>
                        </div>
                    </div>
                </div>

                <a href="#menulist" class="btn btn-gradient menu-about-btn mt-4 px-4">Xem Thực Đơn</a>
            </div>

        </div>
    </div>
    </section>

</div>
<%@ include file="footer.jsp" %>