package com.example.doan_quanlycantin;

import Model.*;
import DTO.ChiTietDonHangDTO; // Import DTO
import Service.*;
import ServiceImp.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/Seller/DonHang")
public class SellerDonHangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DonHangService donHangService;
    private ChiTietDonHangService chiTietService;
    private QuayService quayService;
    private TaiKhoanService taiKhoanService;
    private MonAnService monAnService; // Cần cái này để lấy tên món

    @Override
    public void init() throws ServletException {
        this.donHangService = new DonHangServiceImp();
        this.chiTietService = new ChiTietDonHangServiceImp();
        this.quayService = new QuayServiceImp();
        this.taiKhoanService = new TaiKhoanServiceImp();
        this.monAnService = new MonAnServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        // 1. Check quyền
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Xác định Quầy của Seller
        Quay currentQuay = quayService.findByMaTK(user.getMaTaiKhoan());
        if (currentQuay == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Tài khoản chưa được gán Quầy.");
            return;
        }

        // 3. Setup cơ bản
        String viewMode = request.getParameter("viewMode");
        if (viewMode == null) viewMode = "list";
        request.setAttribute("baseUrl", request.getContextPath() + "/Seller/DonHang");

        // 4. Điều hướng
        if ("detail".equals(viewMode)) {
            xemChiTietDonHang(request, response, currentQuay);
        } else {
            xemDanhSachDonHang(request, response, currentQuay);
        }
    }

    // --- 1. XEM DANH SÁCH ĐƠN HÀNG ---
    private void xemDanhSachDonHang(HttpServletRequest request, HttpServletResponse response, Quay currentQuay)
            throws ServletException, IOException {

        // Lấy tham số lọc
        String keyword = request.getParameter("keyword");
        String trangThai = request.getParameter("trangThai");
        String locNgay = request.getParameter("locNgay");

        String pageStr = request.getParameter("page");
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;

        PageRequest pageRequest = new PageRequest(keyword, "desc", "ngayDat", 10, page);
        pageRequest.setTrangThai(trangThai);
        pageRequest.setLocNgay(locNgay);

        // Gọi hàm SQL lọc đơn hàng theo MaQuay (Bạn đã sửa hàm này ở bước trước chưa?)
        Page<DonHang> donHangPage = donHangService.findDonHangByMaQuay(currentQuay.getMaQuay(), pageRequest);

        // Map tên khách hàng
        List<TaiKhoan> allTaiKhoan = taiKhoanService.finAll();
        // Lưu ý: Admin dùng finAll() lấy hết tài khoản rồi map, ta làm giống vậy

        request.setAttribute("donHangPage", donHangPage);
        request.setAttribute("pageRequest", pageRequest);
        request.setAttribute("DanhSachTK", allTaiKhoan);
        request.setAttribute("viewMode", "list");

        request.getRequestDispatcher("/seller/quanlydonhang.jsp").forward(request, response);
    }

    // --- 2. XEM CHI TIẾT (LOGIC JAVA MAPPING GIỐNG ADMIN) ---
    private void xemChiTietDonHang(HttpServletRequest request, HttpServletResponse response, Quay currentQuay)
            throws ServletException, IOException {

        try {
            int maDon = Integer.parseInt(request.getParameter("maDon"));

            // A. Load thông tin Header
            DonHang donHangDetail = donHangService.findById(maDon);

            // B. Load chi tiết thô (Chưa có tên món)
            // Dùng hàm finAllByMaDon giống hệt Admin (trả về List<ChiTietDonHang>)
            List<ChiTietDonHang> chiTietRaw = chiTietService.finAllByMaDon(maDon);

            // C. Load danh sách món ăn (để tra cứu tên)
            List<MonAn> danhSachMonAn = monAnService.finAll();

            // D. Xử lý Mapping sang DTO và LỌC
            List<ChiTietDonHangDTO> chiTietDTOList = new ArrayList<>();

            for (ChiTietDonHang ct : chiTietRaw) {
                // Tìm thông tin món ăn tương ứng
                String tenMon = "";
                String hinhAnh = "";
                int maQuayCuaMon = 0;

                for (MonAn mon : danhSachMonAn) {
                    if (mon.getMaMonAn() == ct.getMaMonAn()) { // Sửa getMaMonAn() cho khớp Model của bạn
                        tenMon = mon.getTenMonAn();
                        hinhAnh = mon.getHinhAnh();
                        maQuayCuaMon = mon.getMaQuay();
                        break;
                    }
                }

                // --- ĐIỂM KHÁC BIỆT VỚI ADMIN NẰM Ở ĐÂY ---
                // Chỉ thêm vào list nếu món này thuộc Quầy của Seller
                if (maQuayCuaMon == currentQuay.getMaQuay()) {

                    // Tạo DTO (Sử dụng constructor bạn đang có)
                    ChiTietDonHangDTO dto = new ChiTietDonHangDTO(
                            ct,
                            tenMon,
                            hinhAnh,
                            maQuayCuaMon,
                            currentQuay.getTenQuay() // Tên quầy chính là quầy của Seller
                    );

                    // Nếu Constructor của bạn không tính thành tiền, ta tính thủ công ở đây hoặc JSP
                    // dto.setThanhTien(ct.getDonGia() * ct.getSoLuong());

                    chiTietDTOList.add(dto);
                }
            }

            // E. Tìm thông tin khách hàng
            TaiKhoan khachHang = null;
            if (donHangDetail != null) {
                khachHang = taiKhoanService.findById(donHangDetail.getMaTaiKhoan());
            }

            // F. Gửi dữ liệu sang JSP
            request.setAttribute("donHangDetail", donHangDetail);
            request.setAttribute("chiTietDTOList", chiTietDTOList); // JSP Seller đang chờ biến này
            request.setAttribute("khachHang", khachHang);
            request.setAttribute("viewMode", "detail");

            request.getRequestDispatcher("/seller/quanlydonhang.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Seller/DonHang");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}