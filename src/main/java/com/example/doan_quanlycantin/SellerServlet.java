package com.example.doan_quanlycantin;

import DTO.MenuNgayDTO;
import Model.MonAn;
import Model.Page;
import Service.MenuNgayService;
import Service.MonAnService;
import ServiceImp.MenuNgayServiceImp;
import ServiceImp.MonAnServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/Seller")
public class SellerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MonAnService monAnService;
    private MenuNgayService menuNgayService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
        this.menuNgayService = new MenuNgayServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String page = request.getParameter("page");
        if (page == null || page.isEmpty()) page = "quanlymenungay"; // Default page

        try {
            loadDataForPage(page, request);
            request.setAttribute("contentPage", getContentPage(page));
            request.getRequestDispatcher("seller-layout.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback về trang an toàn
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("seller-layout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void loadDataForPage(String page, HttpServletRequest request) {
        switch (page) {
            case "quanlymenungay":
                loadQuanLyMenuData(request);
                break;
            case "x`":
                loadQuanLyDonHangData(request);
                break;
            default:
                loadQuanLyMenuData(request); // Default
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
                return "/dashboard-admin.jsp";
        }
    }

    private void loadQuanLyMenuData(HttpServletRequest request) {
        try {
            // 1. Cấu hình thông tin Quầy (Sau này lấy từ Session)
            int maQuay = 1;
            String tenQuay = "Quầy Cơm Rang";

            // 2. Luôn load danh sách món ăn để hiển thị ở cột bên trái
            List<MonAn> danhSachMon = monAnService.getByQuayId(maQuay);
            request.setAttribute("danhSachMon", danhSachMon);
            request.setAttribute("maQuay", maQuay);
            request.setAttribute("tenQuay", tenQuay);

            // 3. Kiểm tra xem có phải đang xem danh sách không
            String view = request.getParameter("view");
            if ("list".equalsIgnoreCase(view)) {
                loadMenuList(request, maQuay);
            }
            // Mặc định là hiện form tạo mới (không cần logic editDate nữa)

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
        request.setAttribute("view", "list"); // Cờ để JSP biết hiện danh sách
    }
    private void loadQuanLyDonHangData(HttpServletRequest request) {

    }
}