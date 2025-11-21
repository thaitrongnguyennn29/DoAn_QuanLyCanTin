package Filter;

import Model.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Áp dụng cho trang login và các link liên quan
@WebFilter(urlPatterns = {"/dangnhap", "/dangky", "/login.jsp", "/register.jsp"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // 1. Lấy user hiện tại
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        // 2. Kiểm tra xem có phải đang Đăng xuất không?
        String action = req.getParameter("action");
        boolean isLogout = "logout".equals(action);

        if (user != null && !isLogout) {
            // === ĐÃ ĐĂNG NHẬP RỒI MÀ CỐ TÌNH VÀO LẠI TRANG LOGIN ===

            String role = user.getVaiTro(); // Lấy vai trò

            // Kiểm tra vai trò để điều hướng đúng chỗ
            if ("admin".equalsIgnoreCase(role)) {
                // Nếu là Admin -> Về trang quản trị
                resp.sendRedirect(req.getContextPath() + "/Admin");

            } else if ("seller".equalsIgnoreCase(role)) {
                // === [MỚI] Nếu là Seller -> Về trang kênh người bán ===
                // Bạn hãy thay "/Seller" bằng đường dẫn thực tế của bạn (ví dụ: /SellerDashboard, /kenhnguoiban, v.v.)
                resp.sendRedirect(req.getContextPath() + "/Seller");

            } else {
                // Các trường hợp còn lại (User thường) -> Về trang chủ
                resp.sendRedirect(req.getContextPath() + "/trangchu");
            }
            return; // Dừng lại
        }

        // Nếu chưa đăng nhập (hoặc đang logout) thì cho đi tiếp
        chain.doFilter(request, response);
    }
}