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

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            capNhatTrangThaiDon(request, response);
        } else {
            // Mặc định quay về trang quản lý đơn hàng của Admin
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=quanlydonhang");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * Cập nhật trạng thái cho 1 chi tiết đơn hàng (Dành cho ADMIN)
     */
    private void capNhatTrangThaiDon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maCTParam = request.getParameter("maCT");
        String trangThaiMoi = request.getParameter("trangThai");
        String maDonParam = request.getParameter("maDon");

        HttpSession session = request.getSession();

        try {
            int maCT = Integer.parseInt(maCTParam);
            int maDon = Integer.parseInt(maDonParam);

            // [THAY ĐỔI QUAN TRỌNG]
            // Sử dụng hàm updateStatus của Service để có logic chặn trạng thái không hợp lệ
            // Hàm này sẽ ném Exception nếu vi phạm rule (ví dụ: Đã giao -> Mới đặt)
            chiTietDonHangService.updateStatus(maCT, trangThaiMoi);

            // Sau khi update chi tiết thành công, gọi hàm tự động cập nhật trạng thái đơn cha
            donHangService.autoUpdateTrangThai(maDon);

            session.setAttribute("success", "Cập nhật trạng thái thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            // Bắt lỗi logic từ Service (ví dụ: "Không thể quay ngược trạng thái...")
            session.setAttribute("error", "Lỗi: " + e.getMessage());
        }

        // Redirect lại trang chi tiết
        response.sendRedirect(request.getContextPath() +
                "/Admin?activeTab=quanlydonhang&viewMode=detail&maDon=" + maDonParam);
    }
}