package com.example.doan_quanlycantin;

import DTO.ChiTietDonHangDTO;
import Model.*;
import Service.*;
import ServiceImp.*;
import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/Admin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MonAnService monAnService;
    private QuayService quayService;
    private TaiKhoanService taiKhoanService;
    private DonHangService donHangService;
    private ChiTietDonHangService chiTietDonHangService;
    // TODO: Thêm các service khác khi cần
    // private DonHangService donHangService;
    // private MenuService menuService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
        this.quayService = new QuayServiceImp();
        this.taiKhoanService = new TaiKhoanServiceImp();
        this.donHangService = new DonHangServiceImp();
        this.chiTietDonHangService = new ChiTietDonHangServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

////        // Kiểm tra session đăng nhập
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("taiKhoan") == null) {
//            response.sendRedirect(request.getContextPath() + "/dangnhap");
//            return;
//        }
//
//        // Lấy tab hiện tại từ URL
//        String activeTab = request.getParameter("activeTab");
//        if (activeTab == null || activeTab.isEmpty()) {
//            activeTab = "dashboard";
//        }
//
//        try {
//            // Load data theo tab
//            loadDataForTab(activeTab, request);
//
//            // Set content page
//            request.setAttribute("contentPage", getContentPage(activeTab));
//
//            // Forward to main layout
//            request.getRequestDispatcher("admin-layout-old.jsp")
//                    .forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
//            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=dashboard");
//        }
//        request.setAttribute("contentPage", getContentPage(activeTab));
//        request.getRequestDispatcher("admin-layout-old.jsp")
//                .forward(request, response);
        String activeTab = request.getParameter("activeTab");
        if (activeTab == null || activeTab.isEmpty()) {
            activeTab = "dashboard";
        }

        try {
            // Load data theo tab
            loadDataForTab(activeTab, request);

            // Set content page
            request.setAttribute("contentPage", getContentPage(activeTab));

            // ✅ SỬA ĐƯỜNG DẪN THEO CẤU TRÚC CỦA BẠN
            request.getRequestDispatcher("admin-layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // ✅ BỎ session.setAttribute vì chưa có đăng nhập
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Load data tương ứng với từng tab
     */
    private void loadDataForTab(String activeTab, HttpServletRequest request) {
        switch (activeTab) {
            case "dashboard":
                loadDashboardData(request);
                break;

            case "quanlymonan":
                loadMonAnData(request);
                break;

            case "quanlyquay":
                loadQuayData(request);
                break;

            case "quanlytaikhoan":
                loadTaiKhoanData(request);
                break;

            case "quanlydonhang":
                loadDonHangData(request);
                break;

            case "quanlymenu":
                loadMenuData(request);
                break;

            case "thongke":
                loadThongKeData(request);
                break;

            default:
                loadDashboardData(request);
                break;
        }
    }

    /**
     * Trả về đường dẫn file JSP tương ứng với tab
     */
    private String getContentPage(String activeTab) {
        switch (activeTab) {
            case "dashboard":
                return "/dashboard-admin.jsp";
            case "quanlymonan":
                return "/quan-ly-mon-an-admin.jsp";
            case "quanlyquay":
                return "/quan-ly-quay-admin.jsp";
            case "quanlytaikhoan":
                return "/quan-ly-tai-khoan-admin.jsp";
            case "quanlydonhang":
                return "/quan-ly-don-hang-admin.jsp";
            case "quanlymenu":
                return "/quan-ly-menu-ngay-admin.jsp";
//            case "thongke":
//                return "/WEB-INF/views/admin/pages/thong-ke.jsp";
            default:
                return "dashboard-admin.jsp";
        }
    }

    // ========== LOAD DATA CHO TỪNG TAB ==========

    /**
     * Load data cho Dashboard
     */
    private void loadDashboardData(HttpServletRequest request) {
        // Dashboard chỉ cần các con số thống kê
        // Không cần phân trang

        // Đếm tổng số món ăn
        //int totalMonAn = monAnService.count();
        //request.setAttribute("totalMonAn", totalMonAn);

        // TODO: Thêm các thống kê khác khi có service
        // long totalDonHang = donHangService.count();
        // double totalDoanhThu = donHangService.getTotalRevenue();
        // request.setAttribute("totalDonHang", totalDonHang);
        // request.setAttribute("totalDoanhThu", totalDoanhThu);

        // Có thể load thêm một số data mẫu cho dashboard
        //int totalQuay = quayService.count();
        //int totalTaiKhoan = taiKhoanService.count();

        //request.setAttribute("totalQuay", totalQuay);
        //request.setAttribute("totalTaiKhoan", totalTaiKhoan);
    }

    /**
     * Load data cho trang Quản Lý Món Ăn
     */
    private void loadMonAnData(HttpServletRequest request) {
        // Build PageRequest từ parameters
        PageRequest pageRequest = buildPageRequest(request, "gia");

        // Load Page<MonAn> - đã có data + pagination
        Page<MonAn> monAnPage = monAnService.finAll(pageRequest);

        // Load List<Quay> cho dropdown (cần full list)
        List<Quay> danhSachQuay = quayService.finAll();

        // Set attributes
        request.setAttribute("monAnPage", monAnPage);
        request.setAttribute("DanhSachQuay", danhSachQuay);
        request.setAttribute("pageRequest", pageRequest);
    }

    /**
     * Load data cho trang Quản Lý Quầy
     */
    private void loadQuayData(HttpServletRequest request) {
        // Build PageRequest
        PageRequest pageRequest = buildPageRequest(request, "tenQuay");

        // Load Page<Quay>
        Page<Quay> quayPage = quayService.finAll(pageRequest);
        List<TaiKhoan> taiKhoans = taiKhoanService.finAll();
        // Set attributes
        request.setAttribute("DanhSachTK", taiKhoans);
        request.setAttribute("quayPage", quayPage);
        request.setAttribute("pageRequest", pageRequest);
    }

    /**
     * Load data cho trang Quản Lý Tài Khoản
     */
    private void loadTaiKhoanData(HttpServletRequest request) {
        // Build PageRequest
        PageRequest pageRequest = buildPageRequest(request, "tenTaiKhoan");

        // Load Page<TaiKhoan>
        Page<TaiKhoan> taiKhoanPage = taiKhoanService.finAll(pageRequest);

        // Set attributes
        request.setAttribute("taiKhoanPage", taiKhoanPage);
        request.setAttribute("pageRequest", pageRequest);
    }

    /**
     * Load data cho trang Quản Lý Đơn Hàng
     */
    private void loadDonHangData(HttpServletRequest request) {
        PageRequest pageRequest = buildPageRequest(request, "ngayDat");

        // Load Page<DonHang> - Danh sách đơn hàng
        Page<DonHang> donHangPage = donHangService.finAll(pageRequest);

        // Load danh sách tài khoản (để hiển thị tên khách hàng)
        List<TaiKhoan> taiKhoans = taiKhoanService.finAll();

        // Set attributes cho danh sách
        request.setAttribute("donHangPage", donHangPage);
        request.setAttribute("DanhSachTK", taiKhoans);
        request.setAttribute("pageRequest", pageRequest);

        // ===== PHẦN MỚI: XỬ LÝ CHI TIẾT ĐƠN HÀNG =====
        String maDonParam = request.getParameter("maDon");

        if (maDonParam != null && !maDonParam.isEmpty()) {
            try {
                int maDon = Integer.parseInt(maDonParam);

                // 1. Load thông tin đơn hàng
                DonHang donHangDetail = donHangService.findById(maDon);

                // 2. Load chi tiết món ăn
                List<ChiTietDonHang> chiTietList = chiTietDonHangService.finAllByMaDon(maDon);

                // 3. Load danh sách món ăn và quầy (để JOIN thông tin)
                List<MonAn> danhSachMonAn = monAnService.finAll();
                List<Quay> danhSachQuay = quayService.finAll();

                // 4. Tạo List<ChiTietDonHangDTO> để hiển thị
                List<ChiTietDonHangDTO> chiTietDTOList = new ArrayList<>();

                for (ChiTietDonHang ct : chiTietList) {
                    // Tìm thông tin món ăn
                    String tenMon = "";
                    String hinhAnh = "";
                    int maQuay = 0;

                    for (MonAn mon : danhSachMonAn) {
                        if (mon.getMaMonAn() == ct.getMaMonAn()) {
                            tenMon = mon.getTenMonAn();
                            hinhAnh = mon.getHinhAnh();
                            maQuay = mon.getMaQuay();
                            break;
                        }
                    }

                    // Tìm thông tin quầy
                    String tenQuay = "";
                    for (Quay quay : danhSachQuay) {
                        if (quay.getMaQuay() == maQuay) {
                            tenQuay = quay.getTenQuay();
                            break;
                        }
                    }

                    // Tạo DTO
                    ChiTietDonHangDTO dto = new ChiTietDonHangDTO(
                            ct, tenMon, hinhAnh, maQuay, tenQuay
                    );
                    chiTietDTOList.add(dto);
                }

                // 5. Tìm thông tin khách hàng
                TaiKhoan khachHang = null;
                if (donHangDetail != null) {
                    for (TaiKhoan tk : taiKhoans) {
                        if (tk.getMaTaiKhoan() == donHangDetail.getMaTaiKhoan()) {
                            khachHang = tk;
                            break;
                        }
                    }
                }

                // 6. Set attributes cho chi tiết
                request.setAttribute("donHangDetail", donHangDetail);
                request.setAttribute("chiTietDTOList", chiTietDTOList);
                request.setAttribute("khachHang", khachHang);
                request.setAttribute("viewMode", "detail"); // Flag để hiển thị chi tiết

            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Mã đơn hàng không hợp lệ");
            }
        } else {
            request.setAttribute("viewMode", "list"); // Flag để hiển thị danh sách
        }
    }

    /**
     * Load data cho trang Quản Lý Menu Theo Ngày
     */
    private void loadMenuData(HttpServletRequest request) {
        // TODO: Implement khi có MenuService
        /*
        PageRequest pageRequest = buildPageRequest(request, "ngay");
        Page<Menu> menuPage = menuService.finAll(pageRequest);

        // Có thể cần load thêm List<MonAn> để chọn món cho menu
        List<MonAn> danhSachMonAn = monAnService.finAll();

        request.setAttribute("menuPage", menuPage);
        request.setAttribute("danhSachMonAn", danhSachMonAn);
        request.setAttribute("pageRequest", pageRequest);
        */
    }

    /**
     * Load data cho trang Thống Kê
     */
    private void loadThongKeData(HttpServletRequest request) {
        // TODO: Implement khi có các service thống kê
        /*
        // Lấy tham số ngày tháng từ request
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        // Load các thống kê
        Map<String, Object> thongKe = thongKeService.getStatistics(fromDate, toDate);
        request.setAttribute("thongKe", thongKe);
        */
    }

    // ========== HELPER METHODS ==========

    /**
     * Build PageRequest từ HTTP parameters
     * @param request HttpServletRequest
     * @param defaultSort Cột sắp xếp mặc định
     * @return PageRequest object
     */
    private PageRequest buildPageRequest(HttpServletRequest request, String defaultSort) {
        int page = RequestUtil.getInt(request, "page", 1);
        int size = RequestUtil.getInt(request, "size", 10);
        String sort = RequestUtil.getString(request, "sort", defaultSort);
        String order = RequestUtil.getString(request, "order", "asc");
        String keyword = RequestUtil.getString(request, "keyword", "");

        // Lấy thêm tham số lọc cho đơn hàng
        String trangThai = RequestUtil.getString(request, "trangThai", "");
        String locNgay = RequestUtil.getString(request, "locNgay", "");

        // Tạo PageRequest với constructor mới
        PageRequest pageRequest = new PageRequest(keyword, order, sort, size, page, trangThai, locNgay);

        return pageRequest;
    }
}