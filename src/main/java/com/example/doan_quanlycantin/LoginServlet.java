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

@WebServlet(urlPatterns = {"/dangnhap", "/dangky"})
public class LoginServlet extends HttpServlet {

    private TaiKhoanService taiKhoanService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        taiKhoanService = new TaiKhoanServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        // =================================================================
        // 1. XỬ LÝ ĐĂNG XUẤT (Ưu tiên xử lý trước)
        // =================================================================
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate(); // 1. Hủy session server
            }

            // 2. Bắt buộc trình duyệt xóa cache để không hiện lại trang cũ
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
            resp.setHeader("Pragma", "no-cache"); // HTTP 1.0.
            resp.setDateHeader("Expires", 0); // Proxies.

            // 3. Luôn chuyển hướng về Trang Chủ (Tránh lỗi khi quay lại trang cần quyền Admin/Seller)
            resp.sendRedirect(req.getContextPath() + "/trangchu");
            return;
        }

        // =================================================================
        // 2. [MỚI] KIỂM TRA ĐÃ ĐĂNG NHẬP CHƯA?
        // Nếu đã đăng nhập rồi -> Không cho xem form Login nữa -> Đá về trang chủ
        // =================================================================
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            TaiKhoan user = (TaiKhoan) session.getAttribute("user");
            String role = user.getVaiTro();

            // Điều hướng dựa trên vai trò (Giống lúc đăng nhập thành công)
            if ("admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/Admin");
            } else if ("seller".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/Seller");
            } else {
                resp.sendRedirect(req.getContextPath() + "/trangchu");
            }
            return; // Quan trọng: Kết thúc hàm ngay, không chạy xuống phần hiển thị JSP
        }

        // =================================================================
        // 3. HIỂN THỊ TRANG ĐĂNG NHẬP/ĐĂNG KÝ (Nếu chưa đăng nhập)
        // =================================================================
        String path = req.getServletPath();

        if (path.equals("/dangky")) {
            req.setAttribute("activeTab", "register");
        } else {
            req.setAttribute("activeTab", "login");
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(req, resp);
        } else {
            handleLogin(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String u = req.getParameter("username");
        String p = req.getParameter("password");

        TaiKhoan tk = taiKhoanService.login(u, p);

        if (tk != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", tk);

            // Lưu giỏ hàng vào session nếu cần (ví dụ logic giỏ hàng của bạn)
            // session.setAttribute("cart", ...);

            String role = tk.getVaiTro();

            // PHÂN LUỒNG
            if ("admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/Admin");
            } else if ("seller".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/Seller");
            } else {
                resp.sendRedirect(req.getContextPath() + "/trangchu");
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