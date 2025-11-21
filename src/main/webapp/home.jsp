<%@ page import="Model.MonAn" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Trang Chủ");
%>
<%@ include file="header.jsp" %>

<div class="home-page">
    <!-- Hero Section -->
    <section class="hero-section position-relative">
        <div class="hero-overlay"></div>

        <div class="container position-relative z-2">
            <div class="row align-items-center">

                <div class="col-lg-6">
                    <h1 class="hero-title">Bữa Ăn Chất Lượng,<br>Khởi Đầu Thành Công</h1>
                    <p class="hero-subtitle">Thưởng thức món ăn Việt Nam đậm chất truyền thống, được chế biến tươi mới mỗi ngày</p>

                    <a class="btn btn-hero" href = "thucdon">
                        Xem Thực Đơn Ngay <i class="bi bi-arrow-right ms-2"></i>
                    </a>
                </div>

                <div class="col-lg-6 text-center mt-4 mt-lg-0">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&h=400&fit=crop"
                         class="hero-image img-fluid"
                         alt="Món ăn đặc sắc">
                </div>

            </div>
        </div>
    </section>

    <!-- Featured Menu -->
    <section class="feature-section py-5 bg-light">
        <div class="container">

            <div class="text-center mb-5">
                <h2 class="section-title">Món Ăn Nổi Bật</h2>
                <p class="section-subtitle">Được yêu thích nhất bởi thực khách</p>
            </div>

            <div class="row g-4">
                <%
                    // Lấy list từ Servlet
                    List<MonAn> listNoiBat = (List<MonAn>) request.getAttribute("listNoiBat");
                    NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

                    if (listNoiBat != null) {
                        for (MonAn mon : listNoiBat) {
                            String imgPath = request.getContextPath() + "/assets/images/MonAn/" +
                                    (mon.getHinhAnh() != null ? mon.getHinhAnh() : "no-image.png");
                %>

                <div class="col-lg-3 col-md-6">
                    <div class="dish-card">

                        <div class="dish-image-wrapper">
                            <span class="hot-badge">HOT</span>
                            <img src="<%= imgPath %>"
                                 class="dish-image w-100"
                                 alt="<%= mon.getTenMonAn() %>"
                                 style="height: 200px; object-fit: cover;"> </div>

                        <div class="p-3">
                            <h5 class="dish-name text-truncate" title="<%= mon.getTenMonAn() %>">
                                <%= mon.getTenMonAn() %>
                            </h5>

                            <div class="d-flex justify-content-between align-items-center">
                            <span class="dish-price text-danger fw-bold">
                                <%= vnFormat.format(mon.getGia()) %>
                            </span>
                                <button class="btn-add-cart btn-sm" onclick="addToCart(<%= mon.getMaMonAn() %>)">
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
                <div class="col-12 text-center"><p>Đang cập nhật món ăn nổi bật...</p></div>
                <%
                    }
                %>
            </div>

        </div>
    </section>

    <!-- About -->
    <section class="about-section py-5">
        <div class="container">
            <div class="row align-items-center">

                <div class="col-lg-6 mb-4 mb-lg-0">
                    <div class="row g-3 ">
                        <div class="col-6">
                            <img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=300&h=300&fit=crop"
                                 class="about-img img-fluid">
                        </div>
                        <div class="col-6 pt-5">
                            <img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=300&h=300&fit=crop"
                                 class="about-img img-fluid">
                        </div>
                        <div class="col-6">
                            <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&h=300&fit=crop"
                                 class="about-img img-fluid">
                        </div>
                        <div class="col-6 pt-5">
                            <img src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300&h=300&fit=crop"
                                 class="about-img img-fluid">
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
</div>

<%@ include file="footer.jsp" %>
