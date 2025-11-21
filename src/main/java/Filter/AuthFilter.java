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
        String contextPath = req.getContextPath();

        // 1. WHITELIST: Các trang CÔNG KHAI
        boolean isStaticResource = requestURI.endsWith(".css") || requestURI.endsWith(".js") ||
                requestURI.endsWith(".png") || requestURI.endsWith(".jpg") ||
                requestURI.contains("/assets/");

        boolean isPublicPage = requestURI.equals(contextPath + "/") ||
                requestURI.contains("/trangchu") ||
                requestURI.contains("/dangnhap") ||
                requestURI.contains("/dangky") ||
                requestURI.contains("login.jsp") ||
                requestURI.contains("/thucdon") ||
                requestURI.contains("/lienhe") ||
                requestURI.contains("/giohang") ||
                requestURI.contains("/gioithieu");

        if (isStaticResource || isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 2. KIỂM TRA SESSION
        HttpSession session = req.getSession(false);
        TaiKhoan user = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap?mess=Vui long dang nhap");
            return;
        }

        String role = user.getVaiTro(); // "admin", "seller", "user"

        // 3. KIỂM TRA QUYỀN ADMIN (Các trang chỉ Admin được vào)
        if (requestURI.contains("/Admin")) {
            if (!"admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/trangchu?mess=Ban khong co quyen Admin");
                return;
            }
        }

        // 4. KIỂM TRA QUYỀN SELLER (Các trang chỉ Seller được vào)
        else if (requestURI.contains("/Seller")) {
            if (!"seller".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/trangchu?mess=Ban khong co quyen Seller");
                return;
            }
        }

        // ================= [ĐOẠN MỚI CẦN THÊM] =================
        // 5. KIỂM TRA CÁC SERVLET DÙNG CHUNG (Cho phép cả Admin và Seller)
        // Ngăn chặn User thường truy cập vào Servlet xử lý dữ liệu
        else if (requestURI.contains("/MonAnServlet") || requestURI.contains("/MenuNgayServlet")) {
            boolean isAdmin = "admin".equalsIgnoreCase(role);
            boolean isSeller = "seller".equalsIgnoreCase(role);

            if (!isAdmin && !isSeller) {
                // Nếu là User thường -> Chặn ngay
                resp.sendRedirect(req.getContextPath() + "/trangchu?mess=Hanh dong khong duoc phep");
                return;
            }
        }
        // =======================================================

        // Cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}