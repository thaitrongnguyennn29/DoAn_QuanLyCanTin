package com.example.doan_quanlycantin;

import Model.TaiKhoan;
import Service.TaiKhoanService;
import ServiceImp.TaiKhoanServiceImp;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// 1. SỬA: Map cả 2 đường dẫn vào Servlet này
@WebServlet(urlPatterns = {"/dangnhap", "/dangky"})
public class LoginServlet extends HttpServlet {

    private TaiKhoanService taiKhoanService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        taiKhoanService = new TaiKhoanServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // --- XỬ LÝ ĐĂNG XUẤT Ở ĐÂY ---
        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            // 1. Xóa session
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            // 2. Quay lại trang cũ (Referer) hoặc về trang chủ
            String urlCu = req.getHeader("Referer");
            if (urlCu != null && !urlCu.isEmpty()) {
                resp.sendRedirect(urlCu);
            } else {
                resp.sendRedirect(req.getContextPath() + "/trangchu");
            }
            return; // Kết thúc hàm luôn, không chạy phần bên dưới nữa
        }
        // ------------------------------------

        // 2. SỬA: Kiểm tra đường dẫn để set tab mặc định
        String path = req.getServletPath(); // Lấy phần đuôi URL (/dangnhap hoặc /dangky)

        if (path.equals("/dangky")) {
            req.setAttribute("activeTab", "register");
        } else {
            req.setAttribute("activeTab", "login");
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // (Giữ nguyên code doPost cũ của bạn không thay đổi gì)
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(req, resp);
        } else {
            handleLogin(req, resp);
        }
    }

    // ... (Giữ nguyên các hàm handleLogin, handleRegister cũ) ...
    // Lưu ý: Trong handleRegister, đoạn if (!pass.equals(confirmPass)) {...}
    // Bạn không cần sửa gì cả, vì biến activeTab="register" đã lo việc hiển thị rồi.

    // Code handleLogin và handleRegister của bạn ở đây...
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String u = req.getParameter("username");
        String p = req.getParameter("password");

        TaiKhoan tk = taiKhoanService.login(u, p);

        if (tk != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", tk);
            String role = tk.getVaiTro();
            if ("admin".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            } else if ("seller".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            }
        } else {
            req.setAttribute("messLogin", "Sai tên đăng nhập hoặc mật khẩu!");
            req.setAttribute("activeTab", "login");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullname");
        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        String confirmPass = req.getParameter("confirmPassword");

        if (!pass.equals(confirmPass)) {
            req.setAttribute("messRegister", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("activeTab", "register");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        boolean isSuccess = taiKhoanService.register(user, pass, fullName);

        if (isSuccess) {
            req.setAttribute("messSuccess", "Đăng ký thành công! Vui lòng đăng nhập.");
            req.setAttribute("activeTab", "login");
        } else {
            req.setAttribute("messRegister", "Tên đăng nhập đã tồn tại!");
            req.setAttribute("activeTab", "register");
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}