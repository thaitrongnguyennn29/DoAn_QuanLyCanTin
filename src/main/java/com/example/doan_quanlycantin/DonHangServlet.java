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

                case "updateMultiple":
                    capNhatNhieuTrangThai(request, response);
                    break;

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

            // Lấy chi tiết đơn hàng hiện tại
            ChiTietDonHang chiTiet = chiTietDonHangService.findById(maCT);

            if (chiTiet != null) {
                // Cập nhật trạng thái
                chiTiet.setTrangThai(trangThaiMoi);
                boolean success = chiTietDonHangService.update(chiTiet);

                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("error", "Cập nhật trạng thái thất bại!");
                }
            }

            // Redirect về trang chi tiết đơn hàng
            if (maDonParam != null) {
                response.sendRedirect(request.getContextPath() +
                        "/Admin?activeTab=quanlydonhang&maDon=" + maDonParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
        }
    }

    /**
     * Cập nhật trạng thái cho nhiều chi tiết đơn hàng cùng lúc
     */
    private void capNhatNhieuTrangThai(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] maCTArray = request.getParameterValues("maCT[]");
        String trangThaiMoi = request.getParameter("trangThai");
        String maDonParam = request.getParameter("maDon");

        if (maCTArray == null || maCTArray.length == 0 || trangThaiMoi == null) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Vui lòng chọn ít nhất một món và trạng thái!");

            if (maDonParam != null) {
                response.sendRedirect(request.getContextPath() +
                        "/Admin?activeTab=quanlydonhang&maDon=" + maDonParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
            }
            return;
        }

        try {
            int successCount = 0;
            int failCount = 0;

            // Cập nhật từng chi tiết
            for (String maCTStr : maCTArray) {
                try {
                    int maCT = Integer.parseInt(maCTStr);
                    ChiTietDonHang chiTiet = chiTietDonHangService.findById(maCT);

                    if (chiTiet != null) {
                        chiTiet.setTrangThai(trangThaiMoi);
                        boolean success = chiTietDonHangService.update(chiTiet);

                        if (success) {
                            successCount++;
                        } else {
                            failCount++;
                        }
                    }
                } catch (NumberFormatException e) {
                    failCount++;
                    e.printStackTrace();
                }
            }

            // Thông báo kết quả
            HttpSession session = request.getSession();
            if (successCount > 0) {
                session.setAttribute("success",
                        "Đã cập nhật " + successCount + " món thành công!" +
                                (failCount > 0 ? " (" + failCount + " món thất bại)" : ""));
            } else {
                session.setAttribute("error", "Cập nhật thất bại!");
            }

            // Redirect về trang chi tiết đơn hàng
            if (maDonParam != null) {
                response.sendRedirect(request.getContextPath() +
                        "/Admin?activeTab=quanlydonhang&maDon=" + maDonParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
        }
    }
}