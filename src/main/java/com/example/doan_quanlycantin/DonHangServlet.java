package com.example.doan_quanlycantin;

import Model.TaiKhoan;
import Service.ChiTietDonHangService;
import Service.DonHangService;
import ServiceImp.ChiTietDonHangServiceImp;
import ServiceImp.DonHangServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/DonHangServlet")
public class DonHangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ChiTietDonHangService chiTietDonHangService;
    private DonHangService donHangService;

    @Override
    public void init() throws ServletException {
        this.chiTietDonHangService = new ChiTietDonHangServiceImp();
        this.donHangService = new DonHangServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Bắt action cancel ở đây
        if ("cancel".equals(action)) {
            cancelOrderUser(request, response);
        } else {
            // Nếu không phải cancel thì chuyển sang doPost hoặc logic khác
            doPost(request, response);
        }
    }

    private void cancelOrderUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int maDon = Integer.parseInt(request.getParameter("id"));

            // Gọi Service
            boolean result = donHangService.cancelOrderUser(maDon, user.getMaTaiKhoan());

            if (result) {
                session.setAttribute("successMessage", "Đã hủy đơn hàng thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể hủy đơn này (Trạng thái không hợp lệ).");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Chuyển hướng về trang danh sách đơn hàng của bạn
        // Dựa vào code cũ của bạn, trang danh sách đang nằm ở 'chitiet-donhang'
        response.sendRedirect("chitiet-donhang");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            capNhatTrangThaiDon(request, response);
        } else {
            // Mặc định quay về trang quản lý đơn hàng của Admin
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
        }
    }


    // ... (Hàm capNhatTrangThaiDon của Admin giữ nguyên) ...
    private void capNhatTrangThaiDon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... Code cũ ...
        String maCTParam = request.getParameter("maCT");
        String trangThaiMoi = request.getParameter("trangThai");
        String maDonParam = request.getParameter("maDon");

        HttpSession session = request.getSession();

        try {
            int maCT = Integer.parseInt(maCTParam);
            int maDon = Integer.parseInt(maDonParam);

            chiTietDonHangService.updateStatus(maCT, trangThaiMoi);
            donHangService.autoUpdateTrangThai(maDon);

            session.setAttribute("success", "Cập nhật trạng thái thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() +
                "/Admin?activeTab=quanlydonhang&viewMode=detail&maDon=" + maDonParam);
    }
}