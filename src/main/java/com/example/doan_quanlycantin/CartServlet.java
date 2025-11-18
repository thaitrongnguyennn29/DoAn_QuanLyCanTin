package com.example.doan_quanlycantin;

import Model.GioHang;
import Model.MonAn;
import Service.MonAnService;
import ServiceImp.MonAnServiceImp;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/giohang")
public class CartServlet extends HttpServlet {

    private MonAnService monAnService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        monAnService = new MonAnServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<GioHang> cart = getCart(request);

        // Đếm số món (không phải tổng số lượng)
        request.setAttribute("cartItemCount", cart.size());

        calculateOrderSummary(request, cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đặt encoding để tránh lỗi font tiếng Việt nếu có thông báo
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        List<GioHang> cart = getCart(request);

        try {
            // Kiểm tra null để tránh lỗi
            int maMon = Integer.parseInt(request.getParameter("maMon"));

            // Mặc định là 1 nếu không có quantity
            String qtyStr = request.getParameter("quantity");
            int quantity = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 1;

            switch (action) {
                case "add":
                    // Logic thêm món
                    addOrUpdate(cart, maMon, quantity, true);
                    break;
                case "update":
                    // Logic cập nhật số lượng (ở trang giỏ hàng)
                    addOrUpdate(cart, maMon, quantity, false);
                    break;
                case "remove":
                    // Logic xóa món
                    cart.removeIf(item -> item.getMonAn().getMaMonAn() == maMon);
                    break;
            }

            // Cập nhật lại session
            request.getSession().setAttribute("cart", cart);

            // --- PHẦN QUAN TRỌNG ĐÃ SỬA ---
            // Thay vì redirect, ta trả về TEXT chứa số lượng loại món ăn (cart.size())
            response.setContentType("text/plain");
            response.getWriter().write(String.valueOf(cart.size()));

        } catch (Exception e) {
            e.printStackTrace();
            // Trả về mã lỗi để Ajax bên Client bắt được (catch)
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private List<GioHang> getCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<GioHang> cart = (List<GioHang>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void addOrUpdate(List<GioHang> cart, int maMon, int quantity, boolean isAdd) {
        for (GioHang item : cart) {
            if (item.getMonAn().getMaMonAn() == maMon) {
                item.setQuantity(isAdd ? item.getQuantity() + quantity : quantity);
                return;
            }
        }
        if (isAdd) {
            MonAn mon = monAnService.findById(maMon);
            if (mon != null) cart.add(new GioHang(mon, quantity));
        }
    }

    private void calculateOrderSummary(HttpServletRequest request, List<GioHang> cart) {
        double subtotal = cart.stream().mapToDouble(GioHang::getTotalPrice).sum();
        double discount = 0;

        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discount", discount);
        request.setAttribute("total", subtotal - discount);
    }
}