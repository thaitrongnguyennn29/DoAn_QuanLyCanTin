package com.example.doan_quanlycantin;

import Model.TaiKhoan;
import Service.TaiKhoanService;
import ServiceImp.TaiKhoanServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/thongtin-taikhoan")
public class ProfileServlet extends HttpServlet {
    private final TaiKhoanService taiKhoanService = new TaiKhoanServiceImp();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("dangnhap");
            return;
        }
        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("dangnhap");
            return;
        }

        // --- TRƯỜNG HỢP 1: CẬP NHẬT THÔNG TIN ---
        if ("updateInfo".equals(action)) {
            String fullname = req.getParameter("fullname");

            // 1. Tìm user gốc từ DB
            TaiKhoan userInDb = taiKhoanService.findById(user.getMaTaiKhoan());

            if (userInDb != null) {
                // 2. Chỉ sửa tên
                userInDb.setTenNguoiDung(fullname);

                // 3. Gọi hàm update chung
                boolean success = taiKhoanService.update(userInDb);

                if (success) {
                    // Cập nhật lại session
                    user.setTenNguoiDung(fullname);
                    session.setAttribute("user", user);
                    req.setAttribute("message", "Cập nhật thành công!");
                } else {
                    req.setAttribute("error", "Cập nhật thất bại!");
                }
            }

            // Giữ tab Info
            req.setAttribute("activeTab", "info");
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        }

        // --- TRƯỜNG HỢP 2: ĐỔI MẬT KHẨU ---
        else if ("changePass".equals(action)) {
            // 1. KHAI BÁO BIẾN (Lấy dữ liệu từ Form) - ĐÂY LÀ CHỖ BẠN THIẾU
            String currentPass = req.getParameter("currentPass");
            String newPass = req.getParameter("newPass");
            String confirmPass = req.getParameter("confirmPass");

            // 2. VALIDATE DỮ LIỆU
            if (!user.getMatKhau().equals(currentPass)) {
                req.setAttribute("errorPass", "Mật khẩu hiện tại không đúng!");
            }
            else if (!newPass.equals(confirmPass)) {
                req.setAttribute("errorPass", "Mật khẩu xác nhận không khớp!");
            }
            else {
                // 3. LOGIC CẬP NHẬT
                // Tìm lại user gốc để đảm bảo có đủ thông tin (Vai trò, Tên...)
                TaiKhoan userInDb = taiKhoanService.findById(user.getMaTaiKhoan());

                if (userInDb != null) {
                    // Set mật khẩu mới
                    userInDb.setMatKhau(newPass);

                    // Gọi hàm update chung
                    boolean success = taiKhoanService.update(userInDb);

                    if (success) {
                        // Cập nhật lại session để không bị logout
                        user.setMatKhau(newPass);
                        session.setAttribute("user", user);
                        req.setAttribute("messagePass", "Đổi mật khẩu thành công!");
                    } else {
                        req.setAttribute("errorPass", "Lỗi hệ thống, cập nhật thất bại.");
                    }
                }
            }

            // Giữ người dùng ở tab Security
            req.setAttribute("activeTab", "security");
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        }
    }
}
