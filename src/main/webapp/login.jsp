<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng Nhập & Đăng Ký</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
<div class="form-container">

    <input type="hidden" id="serverActiveTab" value="${activeTab}">

    <div class="form-header">
        <h2>Chào Mừng!</h2>
    </div>

    <div class="form-body p-4">
        <div class="text-center mb-2">
            <p class="text-danger mb-0">${messLogin}</p>
            <p class="text-danger mb-0">${messRegister}</p>
            <p class="text-success mb-0">${messSuccess}</p>
        </div>

        <div class="form-tabs">
            <button id="tabLogin" class="tab-btn active" onclick="showTab('login', event)">Đăng nhập</button>
            <button id="tabRegister" class="tab-btn" onclick="showTab('register', event)">Đăng ký</button>
        </div>

        <div id="login" class="tab-content active">
            <form action="${pageContext.request.contextPath}/dangnhap" method="post">
                <input type="hidden" name="action" value="login">
                <div class="form-floating-group mb-3">
                    <input type="text" class="form-control" id="loginUser" name="username" placeholder=" " required>
                    <label for="loginUser" class="form-label">Tên đăng nhập</label>
                </div>
                <div class="form-floating-group mb-4">
                    <input type="password" class="form-control" id="loginPass" name="password" placeholder=" " required>
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
            <form action="${pageContext.request.contextPath}/dangnhap" method="post">
                <input type="hidden" name="action" value="register">
                <div class="form-floating-group mb-3">
                    <input type="text" class="form-control" id="regName" name="fullname" placeholder=" " required>
                    <label for="regName" class="form-label">Họ và tên</label>
                </div>
                <div class="form-floating-group mb-3">
                    <input type="text" class="form-control" id="regUser" name="username" placeholder=" " required>
                    <label for="regUser" class="form-label">Tên đăng nhập</label>
                </div>
                <div class="form-floating-group mb-3">
                    <input type="password" class="form-control" id="regPass" name="password" placeholder=" " required>
                    <label for="regPass" class="form-label">Mật khẩu</label>
                </div>
                <div class="form-floating-group mb-4">
                    <input type="password" class="form-control" id="regConfirmPass" name="confirmPassword" placeholder=" " required>
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
<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>