<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Căn Tin VN - Trang Chủ</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- Google Fonts - Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * {
            font-family: 'Inter', sans-serif;
        }

        :root {
            --primary-gradient: linear-gradient(135deg, #005C97 0%, #363795 100%);
            --primary-color: #005C97;
            --secondary-color: #363795;
        }

        body {
            overflow-x: hidden;
        }

        /* Navigation */
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            background: white !important;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-link {
            font-weight: 500;
            color: #333 !important;
            transition: all 0.3s;
            position: relative;
        }

        .nav-link:hover {
            color: #005C97 !important;
        }

        .nav-link.active {
            color: #005C97 !important;
        }

        .nav-link.active::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--primary-gradient);
            border-radius: 2px;
        }

        .btn-gradient {
            background: var(--primary-gradient);
            border: none;
            color: white;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0, 92, 151, 0.3);
        }

        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 92, 151, 0.4);
            color: white;
        }

        .cart-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* Hero Section */
        .hero-section {
            background: var(--primary-gradient);
            color: white;
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 50%;
            height: 100%;
            background: rgba(255,255,255,0.05);
            transform: skewX(-15deg);
            z-index: 1;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1.5rem;
        }

        .hero-subtitle {
            font-size: 1.3rem;
            font-weight: 400;
            opacity: 0.95;
            margin-bottom: 2rem;
        }

        .btn-hero {
            background: white;
            color: #005C97;
            font-weight: 700;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 1.1rem;
            transition: all 0.3s;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
            background: linear-gradient(135deg, #00467F 0%, #002E73 100%);
            color: #fff;
        }


        .hero-image {
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            transition: all 0.5s;
            position: relative;
            z-index: 2;
        }

        .hero-image:hover {
            transform: scale(1.05) rotate(2deg);
        }

        /* Featured Dishes */
        .section-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .section-subtitle {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 3rem;
        }

        .dish-card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            height: 100%;
        }

        .dish-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }

        .dish-image {
            height: 250px;
            object-fit: cover;
            transition: all 0.5s;
        }

        .dish-card:hover .dish-image {
            transform: scale(1.1);
        }

        .dish-image-wrapper {
            overflow: hidden;
            position: relative;
        }

        .hot-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #dc3545;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85rem;
            z-index: 10;
        }

        .dish-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .dish-price {
            font-size: 1.5rem;
            font-weight: 800;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .btn-add-cart {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-add-cart:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0, 92, 151, 0.3);
            color: white;
        }

        /* About Section */
        .about-section {
            background: linear-gradient(135deg, rgba(0, 92, 151, 0.05) 0%, rgba(54, 55, 149, 0.05) 100%);
            padding: 80px 0;
        }

        .about-image {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            transition: all 0.3s;
            height: 200px;
            object-fit: cover;
        }

        .about-image:hover {
            transform: scale(1.05);
        }

        .about-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .about-text {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #555;
        }

        .stats-box {
            text-align: center;
            padding: 20px;
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 800;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stats-label {
            color: #666;
            font-size: 1rem;
            font-weight: 500;
        }

        /* Footer */
        .footer {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            padding: 60px 0 20px;
        }

        .footer-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: white;
        }

        .footer-brand {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, #005C97 0%, #00d4ff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }

        .footer-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: all 0.3s;
            display: block;
            margin-bottom: 10px;
        }

        .footer-link:hover {
            color: #00d4ff;
            padding-left: 5px;
        }

        .social-icon {
            width: 45px;
            height: 45px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            transition: all 0.3s;
            color: white;
            text-decoration: none;
        }

        .social-icon:hover {
            background: var(--primary-gradient);
            transform: translateY(-5px);
            color: white;
        }

        .footer-input {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: white;
            padding: 12px 15px;
        }

        .footer-input:focus {
            background: rgba(255,255,255,0.15);
            border-color: #00d4ff;
            color: white;
            box-shadow: none;
        }

        .footer-input::placeholder {
            color: rgba(255,255,255,0.5);
        }

        .btn-subscribe {
            background: var(--primary-gradient);
            border: none;
            padding: 12px 25px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .hero-subtitle {
                font-size: 1.1rem;
            }

            .section-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="bi bi-cup-hot-fill"></i> Căn Tin VN
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="#">Trang Chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Thực Đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Theo Dõi Đơn Hàng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Giới Thiệu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Liên Hệ</a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <a href="#" class="text-dark">
                    <i class="bi bi-search fs-5"></i>
                </a>
                <a href="#" class="text-dark position-relative">
                    <i class="bi bi-cart3 fs-5"></i>
                    <span class="cart-badge" id="cartCount">0</span>
                </a>
                <button class="btn btn-gradient">Đăng Nhập / Đăng Ký</button>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <h1 class="hero-title">Bữa Trưa Năng Lượng,<br>Khởi Đầu Thành Công</h1>
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
            <h2 class="section-title">Món Ăn Nổi Bật Hôm Nay</h2>
            <p class="section-subtitle">Được yêu thích nhất bởi thực khách</p>
        </div>
        <div class="row g-4">
            <div class="col-lg-3 col-md-6">
                <div class="card dish-card">
                    <div class="dish-image-wrapper">
                        <span class="hot-badge">HOT</span>
                        <img src="https://images.unsplash.com/photo-1569562211093-4ed0d0758f12?w=400&h=300&fit=crop"
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
                    Căn Tin VN tự hào là địa chỉ tin cậy cung cấp bữa ăn sạch, ngon và tiện lợi cho cộng đồng.
                    Với đội ngũ đầu bếp giàu kinh nghiệm và nguyên liệu tươi ngon được tuyển chọn kỹ lưỡng,
                    chúng tôi cam kết mang đến những món ăn chất lượng nhất với giá cả phải chăng.
                </p>
                <div class="row mt-4">
                    <div class="col-4">
                        <div class="stats-box">
                            <div class="stats-number">500+</div>
                            <div class="stats-label">Món ăn</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="stats-box">
                            <div class="stats-number">10k+</div>
                            <div class="stats-label">Khách hàng</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="stats-box">
                            <div class="stats-number">5⭐</div>
                            <div class="stats-label">Đánh giá</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="footer-brand">
                    <i class="bi bi-cup-hot-fill"></i> Căn Tin VN
                </div>
                <p style="color: rgba(255,255,255,0.7);">Nơi hội tụ hương vị Việt Nam truyền thống</p>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="footer-title">Liên Hệ</h5>
                <p style="color: rgba(255,255,255,0.7);">
                    <i class="bi bi-geo-alt-fill me-2"></i> 123 Đường ABC, Quận 1, TP.HCM
                </p>
                <p style="color: rgba(255,255,255,0.7);">
                    <i class="bi bi-telephone-fill me-2"></i> 0901 234 567
                </p>
                <p style="color: rgba(255,255,255,0.7);">
                    <i class="bi bi-envelope-fill me-2"></i> contact@cantinvn.com
                </p>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="footer-title">Liên Kết Nhanh</h5>
                <a href="#" class="footer-link">Chính sách bảo mật</a>
                <a href="#" class="footer-link">Điều khoản sử dụng</a>
                <a href="#" class="footer-link">Hướng dẫn đặt hàng</a>
                <a href="#" class="footer-link">Câu hỏi thường gặp</a>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="footer-title">Theo Dõi Chúng Tôi</h5>
                <div class="mb-3">
                    <a href="#" class="social-icon"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-icon"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="social-icon"><i class="bi bi-envelope"></i></a>
                </div>
                <p style="color: rgba(255,255,255,0.7); font-size: 0.9rem;">
                    Đăng ký nhận tin tức và ưu đãi mới nhất
                </p>
                <div class="input-group">
                    <input type="email" class="form-control footer-input" placeholder="Email của bạn">
                    <button class="btn btn-subscribe" type="button">Gửi</button>
                </div>
            </div>
        </div>
        <div class="border-top pt-4 mt-4 text-center" style="border-color: rgba(255,255,255,0.1) !important;">
            <p style="color: rgba(255,255,255,0.5); margin: 0;">
                &copy; 2025 Căn Tin VN. Tất cả quyền được bảo lưu.
            </p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let cartCount = 0;

    function addToCart() {
        cartCount++;
        document.getElementById('cartCount').textContent = cartCount;

        // Animation effect
        const badge = document.getElementById('cartCount');
        badge.style.transform = 'scale(1.3)';
        setTimeout(() => {
            badge.style.transform = 'scale(1)';
        }, 200);
    }
</script>
</body>
</html>