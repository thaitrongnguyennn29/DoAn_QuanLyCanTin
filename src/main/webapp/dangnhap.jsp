<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng Nhập & Đăng Ký</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">

    <style>
        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #005C97, #363795);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .form-container {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
            border: none;
        }

        .form-header {
            background: linear-gradient(135deg, #363795, #005C97);
            padding: 30px;
            text-align: center;
            color: #fff;
        }

        .form-header h2 {
            margin: 0;
            font-size: 26px;
            font-weight: 600;
        }

        .form-tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 1px solid #ddd;
        }

        .tab-btn {
            flex: 1;
            padding: 15px;
            background: none;
            border: none;
            font-size: 16px;
            font-weight: 600;
            color: #777;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .tab-btn.active {
            color: #005C97;
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #005C97, #363795);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
            animation: fadeIn 0.4s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #ccc;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: #005C97;
            box-shadow: 0 0 0 0.2rem rgba(0, 92, 151, 0.25);
        }

        /* === CSS CHO HIỆU ỨNG FLOATING LABEL === */
        .form-floating-group {
            position: relative;
        }

        .form-floating-group .form-label {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #999;
            background-color: transparent;
            padding: 0 5px;
            transition: all 0.2s ease-out;
            pointer-events: none;
            font-size: 16px;
        }

        .form-floating-group .form-control:focus ~ .form-label,
        .form-floating-group .form-control:not(:placeholder-shown) ~ .form-label {
            top: 0;
            font-size: 13px;
            color: #005C97;
            background-color: #ffffff;
            font-weight: 600;
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            background: linear-gradient(90deg, #005C97, #363795);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            background: linear-gradient(90deg, #363795, #005C97);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 92, 151, 0.35);
        }

        a {
            color: #005C97;
            text-decoration: none;
            transition: color 0.2s;
        }

        a:hover {
            color: #363795;
            text-decoration: underline;
        }

        .form-check-label {
            color: #555;
        }
    </style>
</head>
<body>
<div class="form-container">
    <div class="form-header">
        <h2>Chào Mừng!</h2>
    </div>

    <div class="form-body p-4">
        <div class="form-tabs">
            <button class="tab-btn active" onclick="showTab('login', event)">Đăng Nhập</button>
            <button class="tab-btn" onclick="showTab('register', event)">Đăng Ký</button>
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
<script>
    function showTab(tabName, evt) {
        const contents = document.querySelectorAll('.tab-content');
        contents.forEach(c => c.classList.remove('active'));
        const buttons = document.querySelectorAll('.tab-btn');
        buttons.forEach(b => b.classList.remove('active'));
        document.getElementById(tabName).classList.add('active');
        evt.currentTarget.classList.add('active');
    }
</script>
</body>
</html>