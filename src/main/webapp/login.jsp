<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng Nhập & Đăng Ký</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
<div class="form-container">
    <div class="form-header">
        <h2>Chào Mừng!</h2>
    </div>

    <div class="form-body p-4">
        <div class="form-tabs">
            <button class="tab-btn active" onclick="showTab('login', event)">Đăng nhập</button>
            <button class="tab-btn" onclick="showTab('register', event)">Đăng ký</button>
        </div>

        <div id="login" class="tab-content active">
            <form onsubmit="handleLogin(event)">
                <div class="form-floating-group mb-3">
                    <input type="text" class="form-control" id="loginUser" placeholder=" " required>
                    <label for="loginUser" class="form-label">Tên đăng nhập</label>
                </div>
                <div class="form-floating-group mb-4">
                    <input type="password" class="form-control" id="loginPass" placeholder=" " required>
                    <label for="loginPass" class="form-label">Mật khẩu</label>
                </div>
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="remember">
                    <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                </div>
                <button type="submit" class="btn btn-submit">Đăng Nhập</button>
            </form>

            <div class="text-center mt-3">
                <a href="#">Quên mật khẩu?</a>
            </div>
        </div>

        <div id="register" class="tab-content">
            <form onsubmit="handleRegister(event)">
                <div class="form-floating-group mb-3">
                    <input type="text" class="form-control" id="regName" placeholder=" " required>
                    <label for="regName" class="form-label">Họ và tên</label>
                </div>
                <div class="form-floating-group mb-3">
                    <input type="text" class="form-control" id="regUser" placeholder=" " required>
                    <label for="regUser" class="form-label">Tên đăng nhập</label>
                </div>
                <div class="form-floating-group mb-3">
                    <input type="password" class="form-control" id="regPass" placeholder=" " required>
                    <label for="regPass" class="form-label">Mật khẩu</label>
                </div>
                <div class="form-floating-group mb-4">
                    <input type="password" class="form-control" id="regConfirmPass" placeholder=" " required>
                    <label for="regConfirmPass" class="form-label">Xác nhận mật khẩu</label>
                </div>
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="terms" required>
                    <label class="form-check-label" for="terms">
                        Tôi đồng ý với <a href="#">điều khoản sử dụng</a>
                    </label>
                </div>
                <button type="submit" class="btn btn-submit">Đăng Ký</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scritp.js"></script>
</body>
</html>