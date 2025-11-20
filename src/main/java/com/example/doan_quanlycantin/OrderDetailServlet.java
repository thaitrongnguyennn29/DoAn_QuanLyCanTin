package com.example.doan_quanlycantin;

import DTO.ChiTietDonHangDTO;
import Model.DonHang;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/chitiet-donhang")
public class OrderDetailServlet extends HttpServlet {
    private final DonHangService donHangService = new DonHangServiceImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null) { response.sendRedirect("donhang-cuatoi"); return; }
            int orderId = Integer.parseInt(idParam);

            HttpSession session = request.getSession();
            TaiKhoan user = (TaiKhoan) session.getAttribute("user");
            if (user == null) { response.sendRedirect("login.jsp"); return; }

            // 1. Lấy chi tiết đơn hàng (Để hiển thị trong Modal)
            DonHang donHang = donHangService.findById(orderId);
            if (donHang == null || donHang.getMaTaiKhoan() != user.getMaTaiKhoan()) {
                response.sendRedirect("donhang-cuatoi");
                return;
            }
            List<ChiTietDonHangDTO> details = donHangService.getOrderDetailsDTO(orderId);

            // Đẩy dữ liệu chi tiết vào request
            request.setAttribute("donHang", donHang);
            request.setAttribute("details", details);

            // 2. Kiểm tra xem là Ajax hay F5
            String xRequestedWith = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);

            if (isAjax) {
                // === TRƯỜNG HỢP AJAX (Bấm nút xem) ===
                // Chỉ trả về đoạn HTML chi tiết
                request.getRequestDispatcher("order-detail.jsp").forward(request, response);
            } else {
                // === TRƯỜNG HỢP F5 (Load lại trang) ===
                // Phải chuẩn bị dữ liệu cho trang nền (Danh sách đơn hàng)
                prepareOrderList(user.getMaTaiKhoan(), request);

                // Bật cờ để JSP biết là cần tự mở Modal
                request.setAttribute("autoOpenModal", true);

                // Forward về trang danh sách (nhưng URL vẫn giữ là chitiet-donhang)
                request.getRequestDispatcher("my-order.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("donhang-cuatoi");
        }
    }

    // Hàm phụ trợ: Lấy danh sách đơn hàng (Copy logic từ MyOrderServlet)
    private void prepareOrderList(int userId, HttpServletRequest request) {
        List<DonHang> allOrders = donHangService.getOrdersByUserId(userId);
        List<DonHang> activeOrders = new ArrayList<>();
        List<DonHang> pastOrders = new ArrayList<>();

        for (DonHang dh : allOrders) {
            String status = dh.getTrangThai();
            if ("Đã hoàn thành".equals(status) || "Đã hủy".equals(status)) {
                pastOrders.add(dh);
            } else {
                activeOrders.add(dh);
            }
        }
        request.setAttribute("activeOrders", activeOrders);
        request.setAttribute("pastOrders", pastOrders);
    }
}