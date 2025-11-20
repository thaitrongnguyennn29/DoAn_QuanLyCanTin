package com.example.doan_quanlycantin;

import Service.MenuNgayService;
import ServiceImp.MenuNgayServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/MenuNgayServlet")
public class MenuNgayServlet extends HttpServlet {

    private MenuNgayService menuNgayService;

    @Override
    public void init() throws ServletException {
        this.menuNgayService = new MenuNgayServiceImp();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // Dù là SAVE hay UPDATE thì logic backend vẫn là: Xóa cũ -> Thêm mới
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
            String ngayStr = req.getParameter("ngay");
            String maQuayStr = req.getParameter("maQuay");
            LocalDate ngay = LocalDate.parse(ngayStr);
            int maQuay = Integer.parseInt(maQuayStr);

            // Lấy mảng ID món ăn từ input hidden
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

            // Logic: Service sẽ tự động xóa menu cũ của ngày này (nếu có) và insert mới
            boolean success = menuNgayService.luuMenuNgay(ngay, maQuay, danhSachMaMon);

            if (success) {
                req.getSession().setAttribute("message", "Lưu menu thành công!");
                // Lưu xong chuyển về xem danh sách
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
            String ngayStr = req.getParameter("ngay");
            int maQuay = Integer.parseInt(req.getParameter("maQuay"));
            LocalDate ngay = LocalDate.parse(ngayStr);

            boolean success = menuNgayService.xoaMenuNgay(ngay, maQuay);
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