package Filter;

import Model.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath(); // Lấy tên project, ví dụ /DoAn_QuanLyCanTin

        // 1. WHITELIST: Danh sách các trang CÔNG KHAI (Ai cũng xem được)
        // Bạn cần bổ sung: thucdon, lienhe, gioithieu vào đây
        boolean isStaticResource = requestURI.endsWith(".css") || requestURI.endsWith(".js") ||
                requestURI.endsWith(".png") || requestURI.endsWith(".jpg") ||
                requestURI.contains("/assets/");

        boolean isPublicPage = requestURI.equals(contextPath + "/") || // Trang gốc
                requestURI.contains("/trangchu") ||
                requestURI.contains("/dangnhap") ||
                requestURI.contains("/dangky") ||
                requestURI.contains("login.jsp") ||
                requestURI.contains("/thucdon") ||   // Map với MenuServlet
                requestURI.contains("/lienhe") ||    // Map với ContactServlet
                requestURI.contains("/giohang") ||
                requestURI.contains("/gioithieu");   // Map với AboutServlet

        if (isStaticResource || isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 2. KIỂM TRA SESSION (Các trang còn lại bắt buộc phải đăng nhập)
        HttpSession session = req.getSession(false); // Dùng false để không tự tạo session mới nếu chưa có
        TaiKhoan user = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;

        if (user == null) {
            // Chưa đăng nhập -> Đá về trang login
            resp.sendRedirect(req.getContextPath() + "/dangnhap?mess=Vui long dang nhap");
            return;
        }

        String role = user.getVaiTro(); // "admin" hoặc "seller" hoặc "user"

        // 3. KIỂM TRA QUYỀN ADMIN
        if (requestURI.contains("/Admin")) {
            if (!"admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/trangchu?mess=Ban khong co quyen truy cap Admin");
                return;
            }
        }

        // 4. KIỂM TRA QUYỀN SELLER
        else if (requestURI.contains("/Seller")) {
            if (!"seller".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/trangchu?mess=Ban khong co quyen truy cap Seller");
                return;
            }
        }

        // Cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy
    }
}
