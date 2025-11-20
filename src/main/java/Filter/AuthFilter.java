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
        // (Nếu đang logout thì phải cho qua để Servlet xử lý xóa session)
        String action = req.getParameter("action");
        boolean isLogout = "logout".equals(action);

        if (user != null && !isLogout) {
            // === ĐÃ ĐĂNG NHẬP RỒI MÀ CỐ TÌNH VÀO LẠI TRANG LOGIN ===

            // Kiểm tra vai trò để điều hướng đúng chỗ
            if ("admin".equalsIgnoreCase(user.getVaiTro())) {
                resp.sendRedirect(req.getContextPath() + "/Admin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/trangchu");
            }
            return; // Dừng lại, không cho vào trang login nữa
        }

        // Nếu chưa đăng nhập (hoặc đang logout) thì cho đi tiếp
        chain.doFilter(request, response);
    }
}