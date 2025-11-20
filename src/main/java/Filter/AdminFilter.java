package Filter;

import Model.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Chặn mọi đường dẫn bắt đầu bằng /Admin
@WebFilter(urlPatterns = {"/Admin", "/Admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // 1. Lấy user từ session (Key "user" khớp với LoginServlet của bạn)
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        // 2. Kiểm tra: Chưa đăng nhập?
        if (user == null) {
            // Lưu lại trang hiện tại để sau khi login xong thì quay lại (nếu muốn)
            // req.getSession().setAttribute("redirectUrl", req.getRequestURI());

            // Chuyển hướng về trang đăng nhập
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        // 3. Kiểm tra quyền: Có phải admin không?
        // Lưu ý: So sánh chuỗi an toàn bằng cách để "admin" ra trước
        if (!"admin".equalsIgnoreCase(user.getVaiTro())) {
            // Đã đăng nhập nhưng là User/Seller -> Đá về trang chủ hoặc trang lỗi
            resp.sendRedirect(req.getContextPath() + "/trangchu");
            return;
        }

        // 4. Nếu OK hết -> Cho phép đi tiếp vào AdminServlet
        chain.doFilter(request, response);
    }
}