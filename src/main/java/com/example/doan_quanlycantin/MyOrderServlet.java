package com.example.doan_quanlycantin;

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

@WebServlet("/donhang-cuatoi")
public class MyOrderServlet extends HttpServlet {
    private final DonHangService donHangService = new DonHangServiceImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Lấy tất cả đơn hàng
        List<DonHang> allOrders = donHangService.getOrdersByUserId(user.getMaTaiKhoan());

        // 2. Phân loại đơn hàng để hiển thị ra 2 Tab
        List<DonHang> activeOrders = new ArrayList<>(); // Đơn đang mua
        List<DonHang> pastOrders = new ArrayList<>();   // Đơn đã mua (Hoàn thành/Hủy)

        for (DonHang dh : allOrders) {
            String status = dh.getTrangThai();
            if ("Đã hoàn thành".equals(status) || "Đã hủy".equals(status)) {
                pastOrders.add(dh);
            } else {
                activeOrders.add(dh); // Bao gồm: Đang xử lí, Đang giao, Mới đặt...
            }
        }

        request.setAttribute("activeOrders", activeOrders);
        request.setAttribute("pastOrders", pastOrders);

        request.getRequestDispatcher("my-order.jsp").forward(request, response);
    }
}