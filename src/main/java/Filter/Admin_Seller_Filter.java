package Filter;

import Model.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/Admin/*", "/Seller/*"})
public class Admin_Seller_Filter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        String requestURI = req.getRequestURI();

        // 1. Kiểm tra đăng nhập
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String role = user.getVaiTro();

        // 2. LOGIC PHÂN QUYỀN

        // --- TRƯỜNG HỢP A: Vào trang ADMIN ---
        if (requestURI.contains("/Admin")) {
            if (!"admin".equalsIgnoreCase(role)) {
                // Seller hoặc User thường cố vào Admin -> Đá về trang chủ (hoặc trang Seller của họ)
                if ("seller".equalsIgnoreCase(role)) {
                    resp.sendRedirect(req.getContextPath() + "/Seller");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/trangchu");
                }
                return;
            }
        }

        // --- TRƯỜNG HỢP B: Vào trang SELLER ---
        else if (requestURI.contains("/Seller")) {

            // [SỬA Ở ĐÂY] Chỉ cho phép đúng vai trò "seller" mới được vào
            // Nếu là Admin -> Cũng chặn luôn (để Admin ở yên trang quản trị)
            if (!"seller".equalsIgnoreCase(role)) {

                if ("admin".equalsIgnoreCase(role)) {
                    // Admin mà vào Seller -> Đá về Admin
                    resp.sendRedirect(req.getContextPath() + "/Admin");
                } else {
                    // User thường -> Đá về trang chủ
                    resp.sendRedirect(req.getContextPath() + "/trangchu");
                }
                return;
            }
        }

        chain.doFilter(request, response);
    }
}