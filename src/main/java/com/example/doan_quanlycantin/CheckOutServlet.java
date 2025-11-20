package com.example.doan_quanlycantin;

import Model.GioHang;
import Model.TaiKhoan;
import Service.DonHangService;
import ServiceImp.DonHangServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// ĐÂY LÀ ĐƯỜNG DẪN BẠN MUỐN DÙNG
@WebServlet("/kiemtradonhang")
public class CheckOutServlet extends HttpServlet {

    // Chỉ gọi Service, xóa khai báo Repository thừa để code sạch hơn
    private final DonHangService donHangService = new DonHangServiceImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        List<GioHang> cart = (List<GioHang>) session.getAttribute("cart");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/giohang");
            return;
        }

        double subtotal = 0;
        for (GioHang item : cart) {
            subtotal += item.getTotalPrice();
        }

        request.setAttribute("subtotal", subtotal);
        request.setAttribute("total", subtotal);
        request.setAttribute("user", user);

        // Forward sang trang giao diện checkout.jsp
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        List<GioHang> cart = (List<GioHang>) session.getAttribute("cart");

        if (user != null && cart != null && !cart.isEmpty()) {
            // Gọi Service
            boolean success = donHangService.placeOrder(user, cart /*, note */);

            if (success) {
                // 1. Xóa giỏ hàng
                session.removeAttribute("cart");

                // 2. Lưu thông báo vào SESSION (để nó tồn tại sau khi redirect)
                session.setAttribute("successMessage", "Đặt hàng thành công! Cảm ơn bạn đã ủng hộ.");

                // 3. Chuyển hướng về trang Thực Đơn (hoặc trang chủ)
                // Thay "/thucdon" bằng đường dẫn trang chủ hoặc menu của bạn
                response.sendRedirect(request.getContextPath() + "/thucdon");
            } else {
                request.setAttribute("errorMessage", "Đặt hàng thất bại. Vui lòng thử lại.");
                doGet(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/giohang");
        }
    }
}