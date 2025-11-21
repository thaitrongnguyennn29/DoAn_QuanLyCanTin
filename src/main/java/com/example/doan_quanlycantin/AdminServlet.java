package com.example.doan_quanlycantin;

import DTO.ChiTietDonHangDTO;
import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;
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
    private ThongKeService thongKeService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
        this.quayService = new QuayServiceImp();
        this.taiKhoanService = new TaiKhoanServiceImp();
        this.donHangService = new DonHangServiceImp();
        this.chiTietDonHangService = new ChiTietDonHangServiceImp();
        this.thongKeService = new ThongKeServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- ĐÃ XÓA PHẦN KIỂM TRA SESSION Ở ĐÂY ---
        // Servlet này mặc định tin tưởng là Filter đã kiểm tra rồi.

        // Vẫn lấy user để hiển thị tên "Xin chào..." nếu cần
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        request.setAttribute("currentUser", user);

        // 2. XỬ LÝ TAB
        String activeTab = request.getParameter("activeTab");
        if (activeTab == null || activeTab.isEmpty()) {
            activeTab = "dashboard";
        }

        try {
            loadDataForTab(activeTab, request);
            request.setAttribute("contentPage", getContentPage(activeTab));
            request.getRequestDispatcher("/admin-layout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Fallback
            response.sendRedirect(request.getContextPath() + "/Admin?activeTab=dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ... GIỮ NGUYÊN CÁC HÀM LOAD DATA DƯỚI ĐÂY KHÔNG THAY ĐỔI ...
    private void loadDataForTab(String activeTab, HttpServletRequest request) {
        switch (activeTab) {
            case "dashboard": loadDashboardData(request); break;
            case "quanlymonan": loadMonAnData(request); break;
            case "quanlyquay": loadQuayData(request); break;
            case "quanlytaikhoan": loadTaiKhoanData(request); break;
            case "quanlydonhang": loadDonHangData(request); break;
            default: loadDashboardData(request); break;
        }
    }

    private String getContentPage(String activeTab) {
        switch (activeTab) {
            case "dashboard": return "/dashboard-admin.jsp";
            case "quanlymonan": return "/quan-ly-mon-an-admin.jsp";
            case "quanlyquay": return "/quan-ly-quay-admin.jsp";
            case "quanlytaikhoan": return "/quan-ly-tai-khoan-admin.jsp";
            case "quanlydonhang": return "/quan-ly-don-hang-admin.jsp";
            default: return "/dashboard-admin.jsp";
        }
    }

    private void loadDashboardData(HttpServletRequest request) {
        ThongKeTongQuatDTO thongKeTong = thongKeService.getThongKeTongQuat();
        if (thongKeTong == null) thongKeTong = new ThongKeTongQuatDTO();
        request.setAttribute("thongKeTong", thongKeTong);

        List<ThongKeDTO> listDoanhThu = thongKeService.getDoanhThuToanSan();
        List<ThongKeDTO> listTopQuay = thongKeService.getTopQuayDoanhThuCao();

        request.setAttribute("dataDoanhThu", listDoanhThu);
        request.setAttribute("dataTopQuay", listTopQuay);
    }

    private void loadMonAnData(HttpServletRequest request) {
        PageRequest pageRequest = buildPageRequest(request, "gia");
        Page<MonAn> monAnPage = monAnService.finAll(pageRequest);
        List<Quay> danhSachQuay = quayService.finAll();
        request.setAttribute("monAnPage", monAnPage);
        request.setAttribute("DanhSachQuay", danhSachQuay);
        request.setAttribute("pageRequest", pageRequest);
    }

    private void loadQuayData(HttpServletRequest request) {
        PageRequest pageRequest = buildPageRequest(request, "tenQuay");
        Page<Quay> quayPage = quayService.finAll(pageRequest);
        List<TaiKhoan> taiKhoans = taiKhoanService.finAll();
        request.setAttribute("DanhSachTK", taiKhoans);
        request.setAttribute("quayPage", quayPage);
        request.setAttribute("pageRequest", pageRequest);
    }

    private void loadTaiKhoanData(HttpServletRequest request) {
        PageRequest pageRequest = buildPageRequest(request, "tenTaiKhoan");
        Page<TaiKhoan> taiKhoanPage = taiKhoanService.finAll(pageRequest);
        request.setAttribute("taiKhoanPage", taiKhoanPage);
        request.setAttribute("pageRequest", pageRequest);
    }

    private void loadDonHangData(HttpServletRequest request) {
        PageRequest pageRequest = buildPageRequest(request, "ngayDat");
        Page<DonHang> donHangPage = donHangService.finAll(pageRequest);
        List<TaiKhoan> taiKhoans = taiKhoanService.finAll();

        request.setAttribute("donHangPage", donHangPage);
        request.setAttribute("DanhSachTK", taiKhoans);
        request.setAttribute("pageRequest", pageRequest);

        String maDonParam = request.getParameter("maDon");
        if (maDonParam != null && !maDonParam.isEmpty()) {
            try {
                int maDon = Integer.parseInt(maDonParam);
                DonHang donHangDetail = donHangService.findById(maDon);
                List<ChiTietDonHang> chiTietList = chiTietDonHangService.finAllByMaDon(maDon);
                List<MonAn> danhSachMonAn = monAnService.finAll();
                List<Quay> danhSachQuay = quayService.finAll();
                List<ChiTietDonHangDTO> chiTietDTOList = new ArrayList<>();

                for (ChiTietDonHang ct : chiTietList) {
                    String tenMon = ""; String hinhAnh = ""; int maQuay = 0;
                    for (MonAn mon : danhSachMonAn) {
                        if (mon.getMaMonAn() == ct.getMaMonAn()) {
                            tenMon = mon.getTenMonAn(); hinhAnh = mon.getHinhAnh(); maQuay = mon.getMaQuay(); break;
                        }
                    }
                    String tenQuay = "";
                    for (Quay quay : danhSachQuay) {
                        if (quay.getMaQuay() == maQuay) { tenQuay = quay.getTenQuay(); break; }
                    }
                    ChiTietDonHangDTO dto = new ChiTietDonHangDTO(ct, tenMon, hinhAnh, maQuay, tenQuay);
                    chiTietDTOList.add(dto);
                }
                TaiKhoan khachHang = null;
                if (donHangDetail != null) {
                    for (TaiKhoan tk : taiKhoans) {
                        if (tk.getMaTaiKhoan() == donHangDetail.getMaTaiKhoan()) { khachHang = tk; break; }
                    }
                }
                request.setAttribute("donHangDetail", donHangDetail);
                request.setAttribute("chiTietDTOList", chiTietDTOList);
                request.setAttribute("khachHang", khachHang);
                request.setAttribute("viewMode", "detail");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Mã đơn hàng không hợp lệ");
            }
        } else {
            request.setAttribute("viewMode", "list");
        }
    }

    private PageRequest buildPageRequest(HttpServletRequest request, String defaultSort) {
        int page = RequestUtil.getInt(request, "page", 1);
        int size = RequestUtil.getInt(request, "size", 10);
        String sort = RequestUtil.getString(request, "sort", defaultSort);
        String order = RequestUtil.getString(request, "order", "asc");
        String keyword = RequestUtil.getString(request, "keyword", "");
        String trangThai = RequestUtil.getString(request, "trangThai", "");
        String locNgay = RequestUtil.getString(request, "locNgay", "");
        return new PageRequest(keyword, order, sort, size, page, trangThai, locNgay);
    }
}