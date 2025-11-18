package com.example.doan_quanlycantin;

import Model.ChiTietDonHang;
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
            return;
        }

        try {
            switch (action) {
                case "updateStatus":
                    capNhatTrangThaiDon(request, response);
                    break;

                // Đã loại bỏ case "updateMultiple"

                default:
                    response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * Cập nhật trạng thái cho 1 chi tiết đơn hàng
     */
    private void capNhatTrangThaiDon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maCTParam = request.getParameter("maCT");
        String trangThaiMoi = request.getParameter("trangThai");
        String maDonParam = request.getParameter("maDon");

        if (maCTParam == null || trangThaiMoi == null) {
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
            return;
        }

        try {
            int maCT = Integer.parseInt(maCTParam);
            ChiTietDonHang chiTiet = chiTietDonHangService.findById(maCT);

            if (chiTiet != null) {
                chiTiet.setTrangThai(trangThaiMoi);
                boolean success = chiTietDonHangService.update(chiTiet);

                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Cập nhật trạng thái thành công!");

                    // TỰ ĐỘNG CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG
                    int maDon = chiTiet.getMaDonHang();
                    donHangService.autoUpdateTrangThai(maDon);
                } else {
                    session.setAttribute("error", "Cập nhật trạng thái thất bại!");
                }
            }

            // Chuyển hướng về trang chi tiết đơn hàng (nếu có maDonParam)
            if (maDonParam != null) {
                response.sendRedirect(request.getContextPath() +
                        "/Admin?activeTab=quanlydonhang&viewMode=detail&maDon=" + maDonParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
        }
    }
}