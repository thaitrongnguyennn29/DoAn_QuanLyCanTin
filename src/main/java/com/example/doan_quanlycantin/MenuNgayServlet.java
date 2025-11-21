package com.example.doan_quanlycantin;

import Model.Quay;
import Model.TaiKhoan;
import Service.MenuNgayService;
import Service.QuayService;
import ServiceImp.MenuNgayServiceImp;
import ServiceImp.QuayServiceImp;
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

@WebServlet("/MenuNgayServlet")
public class MenuNgayServlet extends HttpServlet {

    private MenuNgayService menuNgayService;
    private QuayService quayService; // [Mới]

    @Override
    public void init() throws ServletException {
        this.menuNgayService = new MenuNgayServiceImp();
        this.quayService = new QuayServiceImp(); // [Mới]
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("SAVE".equalsIgnoreCase(action)) {
            saveMenuOverwrite(req, resp);
        } else {
            resp.sendRedirect("Seller?page=quanlymenungay");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("DELETE".equalsIgnoreCase(action)) {
            deleteMenu(req, resp);
        }
    }

    private void saveMenuOverwrite(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // 1. BẢO MẬT: Lấy User từ Session
            HttpSession session = req.getSession();
            TaiKhoan user = (TaiKhoan) session.getAttribute("user");

            if (user == null) {
                resp.sendRedirect("dangnhap");
                return;
            }

            // 2. TỰ TÌM QUẦY (Không dùng req.getParameter("maQuay") từ form để tránh bị hack)
            Quay quay = quayService.findByMaTK(user.getMaTaiKhoan());
            if (quay == null) {
                req.getSession().setAttribute("error", "Tài khoản chưa có Quầy!");
                resp.sendRedirect("Seller?page=quanlymenungay");
                return;
            }
            int maQuay = quay.getMaQuay(); // ID chính chủ

            // 3. Lấy dữ liệu Form
            String ngayStr = req.getParameter("ngay");
            LocalDate ngay = LocalDate.parse(ngayStr);

            String[] maMons = req.getParameterValues("danhSachMaMon[]");
            List<Integer> danhSachMaMon = new ArrayList<>();
            if (maMons != null) {
                for (String s : maMons) {
                    if (!s.isEmpty()) danhSachMaMon.add(Integer.parseInt(s));
                }
            }

            if (danhSachMaMon.isEmpty()) {
                req.getSession().setAttribute("error", "Vui lòng chọn ít nhất 1 món ăn!");
                resp.sendRedirect("Seller?page=quanlymenungay");
                return;
            }

            // 4. Lưu
            boolean success = menuNgayService.luuMenuNgay(ngay, maQuay, danhSachMaMon);

            if (success) {
                req.getSession().setAttribute("message", "Lưu menu thành công!");
                resp.sendRedirect("Seller?page=quanlymenungay&view=list");
            } else {
                req.getSession().setAttribute("error", "Lưu thất bại!");
                resp.sendRedirect("Seller?page=quanlymenungay");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect("Seller?page=quanlymenungay");
        }
    }

    private void deleteMenu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // 1. BẢO MẬT: Check User & Quay
            HttpSession session = req.getSession();
            TaiKhoan user = (TaiKhoan) session.getAttribute("user");
            if (user == null) { resp.sendRedirect("dangnhap"); return; }

            Quay quay = quayService.findByMaTK(user.getMaTaiKhoan());
            if (quay == null) { resp.sendRedirect("Seller"); return; }

            // 2. Lấy ngày cần xóa
            String ngayStr = req.getParameter("ngay");
            LocalDate ngay = LocalDate.parse(ngayStr);

            // 3. Xóa (Dùng ID Quay chính chủ)
            boolean success = menuNgayService.xoaMenuNgay(ngay, quay.getMaQuay());

            if(success) {
                req.getSession().setAttribute("message", "Xóa menu thành công!");
            } else {
                req.getSession().setAttribute("error", "Xóa thất bại!");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi xóa: " + e.getMessage());
        }
        resp.sendRedirect("Seller?page=quanlymenungay&view=list");
    }
}