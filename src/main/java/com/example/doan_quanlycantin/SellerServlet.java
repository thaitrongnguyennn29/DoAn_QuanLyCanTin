package com.example.doan_quanlycantin;

import DTO.ChiTietDonHangDTO;
import DTO.MenuNgayDTO;
import DTO.ThongKeDTO;
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
    private ThongKeService thongKeService;
    private QuayService quayService;
    private DonHangService donHangService;
    private ChiTietDonHangService  chiTietDonHangService;
    private TaiKhoanService taiKhoanService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
        this.menuNgayService = new MenuNgayServiceImp();
        this.thongKeService = new ThongKeServiceImp();
        this.quayService = new QuayServiceImp();
        this.donHangService = new DonHangServiceImp();
        this.chiTietDonHangService = new ChiTietDonHangServiceImp();
        this.taiKhoanService = new TaiKhoanServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String page = request.getParameter("page");
        if (page == null || page.isEmpty()) page = "dashboard";

        try {
            loadDataForPage(page, request);

            String contentPage = getContentPage(page);
            request.setAttribute("contentPage", contentPage);

            // Chuyển hướng về Layout (Lưu ý đường dẫn file JSP của bạn)
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
            case "dashboard":
                loadDashboardData(request);
                break;
            case "quanlymenungay":
                loadQuanLyMenuData(request);
                break;
            case "quanlydonhang":
                loadQuanLyDonHangData(request);
                break;
            default:
                loadDashboardData(request);
                break;
        }
    }

    private String getContentPage(String page) {
        switch (page) {
            case "dashboard": return "/dashboard-seller.jsp";
            case "quanlymenungay": return "/quan-ly-menu-ngay-seller.jsp";
            case "quanlydonhang": return "/quan-ly-don-hang-seller.jsp";
            default: return "/dashboard-seller.jsp";
        }
    }

    // --- [QUAN TRỌNG] LOGIC LẤY MENU ĐỘNG THEO USER ---
    private void loadQuanLyMenuData(HttpServletRequest request) {
        try {
            // 1. Lấy User từ Session
            HttpSession session = request.getSession();
            TaiKhoan user = (TaiKhoan) session.getAttribute("user");

            if (user == null) {
                request.setAttribute("error", "Vui lòng đăng nhập!");
                return;
            }

            // 2. Tìm Quầy của User này
            Quay quay = quayService.findByMaTK(user.getMaTaiKhoan());

            if (quay == null) {
                // User này là Seller nhưng chưa được Admin tạo Quầy
                request.setAttribute("error", "Tài khoản này chưa được liên kết với Quầy nào!");
                request.setAttribute("maQuay", 0);
                request.setAttribute("tenQuay", "Chưa xác định");
                request.setAttribute("danhSachMon", new ArrayList<>());
                return;
            }

            // 3. Lấy thông tin chính xác
            int maQuay = quay.getMaQuay();
            String tenQuay = quay.getTenQuay();

            // 4. Load danh sách món của Quầy đó
            List<MonAn> danhSachMon = monAnService.getByQuayId(maQuay);

            request.setAttribute("danhSachMon", danhSachMon);
            request.setAttribute("maQuay", maQuay); // Đẩy xuống JSP để dùng trong Form
            request.setAttribute("tenQuay", tenQuay);

            // 5. Xử lý xem danh sách (Filter)
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

        LocalDate tuNgay = null;
        LocalDate denNgay = null;
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

    private void loadDashboardData(HttpServletRequest request) {
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        if (user != null) {
            int sellerId = user.getMaTaiKhoan();
            // Lưu ý: Service ThongKe hiện đang dùng sellerId (MaTK) chứ không phải MaQuay
            // Nếu logic thống kê của bạn đổi sang MaQuay thì cần gọi quayService ở đây nữa
            List<ThongKeDTO> listDoanhThu = thongKeService.getDoanhThu7Ngay(sellerId);
            List<ThongKeDTO> listTopMon = thongKeService.getTopMonBanChay(sellerId);
            request.setAttribute("dataDoanhThu", listDoanhThu);
            request.setAttribute("dataTopMon", listTopMon);
        }
    }

    private void loadQuanLyDonHangData(HttpServletRequest request) {
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        if (user == null) return;

        // 1. Lấy Quầy của Seller
        Quay quay = quayService.findByMaTK(user.getMaTaiKhoan());
        if (quay == null) {
            request.setAttribute("error", "Bạn chưa có quầy hàng!");
            return;
        }
        int maQuay = quay.getMaQuay();

        // 2. Xử lý Pagination & Filter
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("pageIdx")); } catch (Exception e) {}
        if (page < 1) page = 1;

        String keyword = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");

        // Tạo PageRequest
        PageRequest pageRequest = new PageRequest(keyword, "desc", "ngayDat", 10, page, trangThai, null);

        // 3. Kiểm tra xem đang xem List hay Detail
        String maDonParam = request.getParameter("maDon");

        if (maDonParam != null && !maDonParam.isEmpty()) {
            // === XEM CHI TIẾT ĐƠN HÀNG ===
            try {
                int maDon = Integer.parseInt(maDonParam);

                // Lấy thông tin chung đơn hàng
                DonHang donHangDetail = donHangService.findById(maDon);

                // [QUAN TRỌNG] Chỉ lấy chi tiết món của QUẦY NÀY
                // Bạn cần ép kiểu Service sang ServiceImp nếu Interface chưa update hàm mới
                // Hoặc tốt nhất là update Interface ChiTietDonHangService thêm hàm này
                List<ChiTietDonHangDTO> chiTietDTOList = ((ChiTietDonHangServiceImp)chiTietDonHangService)
                        .findDTOByOrderIdAndMaQuay(maDon, maQuay);

                // Lấy thông tin khách hàng
                TaiKhoan khachHang = taiKhoanService.findById(donHangDetail.getMaTaiKhoan());

                request.setAttribute("donHangDetail", donHangDetail);
                request.setAttribute("chiTietDTOList", chiTietDTOList);
                request.setAttribute("khachHang", khachHang);
                request.setAttribute("viewMode", "detail");

            } catch (Exception e) { e.printStackTrace(); }
        } else {
            // === XEM DANH SÁCH ĐƠN HÀNG ===
            // Gọi hàm tìm đơn hàng theo MaQuay
            Page<DonHang> donHangPage = ((DonHangServiceImp)donHangService)
                    .findDonHangByMaQuay(maQuay, pageRequest);

            // Để hiển thị tên khách hàng, cần load danh sách tài khoản (hoặc tối ưu hơn là dùng Map)
            List<TaiKhoan> dsTaiKhoan = taiKhoanService.finAll(); // Hoặc findByIds trong list đơn

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

            // [THAY ĐỔI] Gọi hàm updateStatus thay vì setTrangThai + update thủ công
            chiTietDonHangService.updateStatus(maCT, trangThaiMoi);

            // [THAY ĐỔI] Sau khi cập nhật chi tiết, gọi cập nhật đơn cha
            donHangService.autoUpdateTrangThai(Integer.parseInt(maDon));

            request.getSession().setAttribute("success", "Cập nhật thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            // Bắt lỗi Logic từ Service ném ra (Ví dụ: Không thể quay ngược...)
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        // Redirect giữ nguyên
        response.sendRedirect("Seller?page=quanlydonhang&maDon=" + maDon);
    }
}