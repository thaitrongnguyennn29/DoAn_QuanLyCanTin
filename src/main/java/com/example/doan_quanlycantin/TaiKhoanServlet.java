package com.example.doan_quanlycantin;

import Model.TaiKhoan;
import Service.TaiKhoanService;
import ServiceImp.TaiKhoanServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/TaiKhoanServlet")
public class TaiKhoanServlet extends HttpServlet {
    private TaiKhoanService taiKhoanService;
    public TaiKhoanServlet() {
        this.taiKhoanService = new TaiKhoanServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("DELETE".equalsIgnoreCase(action)) {
            deleteTaiKhoan(req, resp);
        } else {
            resp.sendRedirect("Admin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("ADD".equalsIgnoreCase(action)) {
            addTaiKhoan(req, resp);
        } else if ("EDIT".equalsIgnoreCase(action)) {
            updateTaiKhoan(req, resp);
        }
    }
    private void addTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String tenNguoiDung = req.getParameter("tenNguoiDung");
            String tenDangNhap = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            String vaiTro = req.getParameter("vaiTro");
            TaiKhoan tk = new TaiKhoan();
            tk.setTenNguoiDung(tenNguoiDung);
            tk.setTenDangNhap(tenDangNhap);
            tk.setMatKhau(matKhau);
            tk.setVaiTro(vaiTro);

            taiKhoanService.create(tk);

            req.getSession().setAttribute("message", "Thêm tài khoản thành công!");
            resp.sendRedirect("Admin");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi thêm tài khoản: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }

    private void updateTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int maTK = Integer.parseInt(req.getParameter("maTK"));
            String tenNguoiDung = req.getParameter("tenNguoiDung");
            String tenDangNhap = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            String vaiTro = req.getParameter("vaiTro");

            TaiKhoan tk = new TaiKhoan();
            tk.setTenNguoiDung(tenNguoiDung);
            tk.setMaTaiKhoan(maTK);
            tk.setTenDangNhap(tenDangNhap);
            tk.setMatKhau(matKhau);
            tk.setVaiTro(vaiTro);

            taiKhoanService.update(tk);

            req.getSession().setAttribute("message", "Cập nhật tài khoản thành công!");
            resp.sendRedirect("Admin");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi cập nhật tài khoản: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }

    private void deleteTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int maTK = Integer.parseInt(req.getParameter("maTK"));
            TaiKhoan tk = taiKhoanService.findById(maTK);
            if (tk != null) {
                taiKhoanService.delete(tk);
                req.getSession().setAttribute("message", "Xóa tài khoản thành công!");
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy tài khoản!");
            }
            resp.sendRedirect("Admin");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi xóa tài khoản: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }
}
