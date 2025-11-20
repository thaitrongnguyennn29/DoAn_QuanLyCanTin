<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.TaiKhoan" %>
<% request.setAttribute("pageTitle", "Thông Tin Tài Khoản"); %>
<%@ include file="header.jsp" %>

<div class="profile-page">
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="hero-title">Hồ Sơ Của Tôi</h1>
            <p class="hero-subtitle mb-0">Quản lý thông tin cá nhân và bảo mật.</p>
        </div>
    </section>

    <div class="profile-content-wrapper py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">

                    <div class="card profile-card mb-4">
                        <div class="card-body p-4">
                            <div class="user-header d-flex flex-column align-items-center text-center">

                                <div class="user-avatar mb-3"> <i class="bi bi-person"></i>
                                </div>

                                <div class="user-details d-flex flex-wrap align-items-center justify-content-center gap-3">

                                    <h4 class="user-name mb-0"><%= user.getTenNguoiDung() %></h4>

                                    <div class="vr text-muted opacity-25 d-none d-sm-block"></div>

                                    <div class="user-meta mb-0"> <i class="bi bi-person-badge me-1"></i>
                                        <span>@<%= user.getTenDangNhap() %></span>
                                    </div>

                                    <div class="vr text-muted opacity-25 d-none d-sm-block"></div>

                                    <span class="role-badge">
                                        <%= user.getVaiTro().toUpperCase() %>
                                    </span>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="card profile-card mb-4">
                        <div class="card-body p-4">
                            <h5 class="card-heading mb-4">
                                <i class="bi bi-person-lines-fill me-2"></i>Thông Tin Cá Nhân
                            </h5>

                            <% if (request.getAttribute("message") != null) { %>
                            <div class="alert alert-success fade show">
                                <i class="bi bi-check-circle me-2"></i><%= request.getAttribute("message") %>
                            </div>
                            <% } %>
                            <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger fade show">
                                <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                            <form action="thongtin-taikhoan" method="post">
                                <input type="hidden" name="action" value="updateInfo">

                                <div class="mb-3">
                                    <label class="form-label">Tên hiển thị</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-fonts"></i></span>
                                        <input type="text" class="form-control" name="fullname" value="<%= user.getTenNguoiDung() %>" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Tên đăng nhập</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-hash"></i></span>
                                        <input type="text" class="form-control readonly-input" value="<%= user.getTenDangNhap() %>" readonly>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 py-2">
                                    <i class="bi bi-save me-2"></i>Lưu Thay Đổi
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="card profile-card">
                        <div class="card-body p-4">
                            <h5 class="card-heading text-danger mb-4">
                                <i class="bi bi-shield-lock-fill me-2"></i>Bảo Mật & Mật Khẩu
                            </h5>

                            <% if (request.getAttribute("messagePass") != null) { %>
                            <div class="alert alert-success fade show">
                                <i class="bi bi-check-circle me-2"></i><%= request.getAttribute("messagePass") %>
                            </div>
                            <% } %>
                            <% if (request.getAttribute("errorPass") != null) { %>
                            <div class="alert alert-danger fade show">
                                <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("errorPass") %>
                            </div>
                            <% } %>

                            <form action="thongtin-taikhoan" method="post">
                                <input type="hidden" name="action" value="changePass">

                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu hiện tại</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-key"></i></span>
                                        <input type="password" class="form-control" name="currentPass" required placeholder="••••••">
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Mật khẩu mới</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                            <input type="password" class="form-control" name="newPass" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-4">
                                        <label class="form-label">Xác nhận lại</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                            <input type="password" class="form-control" name="confirmPass" required>
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-danger w-100 py-2">
                                    <i class="bi bi-arrow-repeat me-2"></i>Đổi Mật Khẩu
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>