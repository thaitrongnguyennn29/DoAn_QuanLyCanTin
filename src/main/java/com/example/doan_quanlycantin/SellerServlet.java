package com.example.doan_quanlycantin;

import DTO.ChiTietDonHangDTO;
import DTO.MenuNgayDTO;
import Model.*;
import Service.*;
import ServiceImp.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/Seller")
public class SellerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MonAnService monAnService;
    private MenuNgayService menuNgayService;
    // Đã xóa ThongKeService
    private QuayService quayService;
    private DonHangService donHangService;
    private ChiTietDonHangService  chiTietDonHangService;
    private TaiKhoanService taiKhoanService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
        this.menuNgayService = new MenuNgayServiceImp();
        // Đã xóa khởi tạo ThongKeService
        this.quayService = new QuayServiceImp();
        this.donHangService = new DonHangServiceImp();
        this.chiTietDonHangService = new ChiTietDonHangServiceImp();
        this.taiKhoanService = new TaiKhoanServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String page = request.getParameter("page");

        // [THAY ĐỔI] Mặc định vào trang QuanLyDonHang vì đã xóa Dashboard
        if (page == null || page.isEmpty()) {
            page = "quanlymenungay";
        }

        try {
            loadDataForPage(page, request);
            request.setAttribute("contentPage", getContentPage(page));
            request.getRequestDispatcher("/seller-layout.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/seller-layout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void loadDataForPage(String page, HttpServletRequest request) {
        switch (page) {
            case "quanlymenungay":
                loadQuanLyMenuData(request);
                break;
            case "quanlydonhang":
                loadQuanLyDonHangData(request);
                break;
            default:
                // [THAY ĐỔI] Mặc định load đơn hàng
                loadQuanLyDonHangData(request);
                break;
        }
    }

    private String getContentPage(String page) {
        switch (page) {
            case "quanlymenungay":
                return "/quan-ly-menu-ngay-seller.jsp";
            case "quanlydonhang":
                return "/quan-ly-don-hang-seller.jsp";
            default:
                // [THAY ĐỔI] Mặc định trả về trang đơn hàng
                return "/quan-ly-don-hang-seller.jsp";
        }
    }

    private void loadQuanLyMenuData(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            TaiKhoan user = (TaiKhoan) session.getAttribute("user");

            Quay quay = quayService.findByMaTK(user.getMaTaiKhoan());
            if (quay == null) {
                request.setAttribute("error", "Tài khoản này chưa được liên kết với Quầy nào!");
                request.setAttribute("maQuay", 0);
                request.setAttribute("tenQuay", "Chưa xác định");
                request.setAttribute("danhSachMon", new ArrayList<>());
                return;
            }

            int maQuay = quay.getMaQuay();
            List<MonAn> danhSachMon = monAnService.getByQuayId(maQuay);
            request.setAttribute("danhSachMon", danhSachMon);
            request.setAttribute("maQuay", maQuay);
            request.setAttribute("tenQuay", quay.getTenQuay());

            String ngayChon = request.getParameter("ngay");
            LocalDate dateToCheck = (ngayChon != null && !ngayChon.isEmpty()) ? LocalDate.parse(ngayChon) : LocalDate.now();
            List<MonAn> menuDaChon = menuNgayService.getMonAnTheoNgayVaQuay(dateToCheck, maQuay);

            List<Integer> selectedMenuIds = new ArrayList<>();
            if (menuDaChon != null) {
                for (MonAn m : menuDaChon) selectedMenuIds.add(m.getMaMonAn());
            }
            request.setAttribute("selectedMenuIds", selectedMenuIds);
            request.setAttribute("currentDate", dateToCheck.toString());

            String view = request.getParameter("view");
            if ("list".equalsIgnoreCase(view)) {
                loadMenuList(request, maQuay);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu: " + e.getMessage());
        }
    }

    private void loadMenuList(HttpServletRequest request, int maQuay) {
        int pageNum = 1;
        try {
            String p = request.getParameter("pageNum");
            if (p != null) pageNum = Integer.parseInt(p);
        } catch (Exception e) {}

        LocalDate tuNgay = null; LocalDate denNgay = null;
        try {
            String t = request.getParameter("tuNgay");
            String d = request.getParameter("denNgay");
            if (t != null && !t.isEmpty()) tuNgay = LocalDate.parse(t);
            if (d != null && !d.isEmpty()) denNgay = LocalDate.parse(d);
        } catch (Exception e) {}

        Page<MenuNgayDTO> menuPage = menuNgayService.layDanhSachMenuNgay(maQuay, tuNgay, denNgay, pageNum, 10);
        request.setAttribute("menuPage", menuPage);
        request.setAttribute("view", "list");
    }

    // ĐÃ XÓA HÀM loadDashboardData

    private void loadQuanLyDonHangData(HttpServletRequest request) {
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        Quay quay = quayService.findByMaTK(user.getMaTaiKhoan());
        if (quay == null) {
            request.setAttribute("error", "Bạn chưa có quầy hàng!");
            return;
        }
        int maQuay = quay.getMaQuay();

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("pageIdx")); } catch (Exception e) {}
        if (page < 1) page = 1;
        String keyword = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");
        PageRequest pageRequest = new PageRequest(keyword, "desc", "ngayDat", 10, page, trangThai, null);

        String maDonParam = request.getParameter("maDon");
        if (maDonParam != null && !maDonParam.isEmpty()) {
            try {
                int maDon = Integer.parseInt(maDonParam);
                DonHang donHangDetail = donHangService.findById(maDon);
                List<ChiTietDonHangDTO> chiTietDTOList = ((ChiTietDonHangServiceImp)chiTietDonHangService)
                        .findDTOByOrderIdAndMaQuay(maDon, maQuay);
                TaiKhoan khachHang = taiKhoanService.findById(donHangDetail.getMaTaiKhoan());

                request.setAttribute("donHangDetail", donHangDetail);
                request.setAttribute("chiTietDTOList", chiTietDTOList);
                request.setAttribute("khachHang", khachHang);
                request.setAttribute("viewMode", "detail");
            } catch (Exception e) { e.printStackTrace(); }
        } else {
            Page<DonHang> donHangPage = ((DonHangServiceImp)donHangService)
                    .findDonHangByMaQuay(maQuay, pageRequest);
            List<TaiKhoan> dsTaiKhoan = taiKhoanService.finAll();

            request.setAttribute("donHangPage", donHangPage);
            request.setAttribute("DanhSachTK", dsTaiKhoan);
            request.setAttribute("pageRequest", pageRequest);
            request.setAttribute("viewMode", "list");
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String maDon = request.getParameter("maDon");
        try {
            int maCT = Integer.parseInt(request.getParameter("maCT"));
            String trangThaiMoi = request.getParameter("trangThai");
            chiTietDonHangService.updateStatus(maCT, trangThaiMoi);
            donHangService.autoUpdateTrangThai(Integer.parseInt(maDon));
            request.getSession().setAttribute("success", "Cập nhật thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("Seller?page=quanlydonhang&maDon=" + maDon);
    }
}