<%@ page import="java.util.List" %>
<%@ page import="Model.MonAn" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Khởi tạo formatter để định dạng giá: 55,000đ
    // #,###đ sẽ định dạng: 45000.0 thành 45,000đ (loại bỏ .0)
    DecimalFormat formatter = new DecimalFormat("#,###đ");

    request.setAttribute("pageTitle", "Thực Đơn");
%>

<%@ include file="header.jsp" %>

<section class="hero-section text-center position-relative">
    <div class="container position-relative z-2">
        <h1 class="hero-title">Thực Đơn Mỗi Ngày</h1>
        <p class="hero-subtitle mb-4">Chọn món ngon – Chuẩn vị – Giá sinh viên</p>
        <a href="#menu-list" class="btn btn-hero">Khám phá ngay</a>
    </div>
</section>
<%
    // Lấy danh sách món ăn từ Servlet (đã sửa tên thuộc tính thành "danhSachMon")
    List<MonAn> monAns = (List<MonAn>) request.getAttribute("DanhSachMon");
%>

<section id="menu-list" class="py-5">
    <div class="container">
        <h2 class="section-title mb-4">Phân Loại Món Ăn</h2>
        <p class="section-subtitle text-center mb-4">Tươi ngon, dinh dưỡng và chuẩn vị căn tin sinh viên.</p>
        <div class="d-flex flex-wrap justify-content-center gap-3 mb-5">
            <button class="btn btn-gradient filter-btn active" data-filter="all">Tất cả</button>
            <button class="btn btn-gradient filter-btn" data-filter="com">Cơm</button>
            <button class="btn btn-gradient filter-btn" data-filter="mi" >Mì</button>
            <button class="btn btn-gradient filter-btn" data-filter="pho">Phở</button>
            <button class="btn btn-gradient filter-btn" data-filter="do-uong">Đồ Uống</button>
        </div>

        <div class="row g-4">
            <%
                if (monAns != null && !monAns.isEmpty()) {
                    for (MonAn mon : monAns) {
                        // Logic xác định data-category dựa trên MaQuay (1:Phở, 2:Cơm, 3:Mì, 4:Nước)
                        String categoryName = "";
                        switch (mon.getMaQuay()) {
                            case 2: categoryName = "com"; break;
                            case 3: categoryName = "mi"; break;
                            case 1: categoryName = "pho"; break;
                            case 4: categoryName = "do-uong"; break;
                            default: categoryName = "khac"; break;
                        }

                        // Định dạng giá (Ví dụ: 55,000đ)
                        String formattedPrice = formatter.format(mon.getGia());

                        // Sửa đường dẫn hình ảnh (Đảm bảo đường dẫn tuyệt đối)
                        String imagePath = mon.getHinhAnh();

                        // Nếu đường dẫn trong DB là 'images/MonAn/...'
                        if (imagePath.startsWith("images/MonAn/")) {
                            imagePath = "assets/" + imagePath;
                        } else if (!imagePath.startsWith("assets/")) {
                            // Trường hợp không xác định, dùng placeholder
                            imagePath = "assets/images/placeholder.jpg";
                        }
            %>
            <div class="col-lg-3 col-md-6 menu-item" data-category="<%= categoryName %>">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <img src="<%= request.getContextPath() %>/<%= imagePath %>"
                             class="card-img-top dish-image"
                             alt="<%= mon.getTenMonAn() %>">
                    </div>
                    <div class="card-body">
                        <h5 class="dish-name"><%= mon.getTenMonAn() %></h5>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="dish-price"><%= formattedPrice %></span>
                            <button class="btn btn-add-cart" onclick="addToCart(<%= mon.getMaMonAn() %>)">
                                <i class="bi bi-cart-plus"></i> Thêm
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                } // Kết thúc vòng lặp for
            } else {
            %>
            <div class="col-12 text-center text-muted">
                <p>Thực đơn hôm nay chưa có món nào.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</section>

<section id = "menu-about" class="about-section">
    <div class="container">
        <div class="row align-items-center gy-4">
            <div class="col-md-6">
                <img src="${pageContext.request.contextPath}/assets/images/canteen.jpg"
                     class="about-image w-100" alt="Căn tin VN">
            </div>

            <div class="col-md-6">
                <h2 class="about-title mb-3">Vì sao chọn NTC Canteen?</h2>
                <p class="about-text mb-4">
                    Mỗi món ăn đều được chế biến từ nguyên liệu tươi ngon, đảm bảo an toàn và dinh dưỡng.
                    Chúng tôi mang đến hương vị quen thuộc, phục vụ nhanh chóng với giá cả hợp lý cho sinh viên và tất cả mọi người.
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