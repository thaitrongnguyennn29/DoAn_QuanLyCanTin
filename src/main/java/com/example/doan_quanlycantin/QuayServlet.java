package com.example.doan_quanlycantin;

import Model.Quay;
import Service.QuayService;
import ServiceImp.QuayServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/QuayServlet")
public class QuayServlet extends HttpServlet {
    private QuayService quayService;
    public QuayServlet() {
        this.quayService = new QuayServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("DELETE".equalsIgnoreCase(action)) {
            deleteQuay(req, resp);
        } else {
            resp.sendRedirect("Admin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("ADD".equalsIgnoreCase(action)) {
            addQuay(req, resp);
        } else if ("EDIT".equalsIgnoreCase(action)) {
            updateQuay(req, resp);
        }
    }
    private void addQuay(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            String tenQuay = req.getParameter("tenQuay");
            String moTa = req.getParameter("moTa");
            int maTK = Integer.parseInt(req.getParameter("maTK"));

            Quay q = new Quay();
            q.setTenQuay(tenQuay);
            q.setMoTa(moTa);
            q.setMaTaiKhoan(maTK);

            quayService.create(q);

            req.getSession().setAttribute("message", "Thêm quầy thành công!");
            resp.sendRedirect("Admin");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error",
                    "Lỗi khi thêm quầy: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }
    private void updateQuay(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int maQuay = Integer.parseInt(req.getParameter("maQuay"));
            String tenQuay = req.getParameter("tenQuay");
            String moTa = req.getParameter("moTa");
            int maTK = Integer.parseInt(req.getParameter("maTK"));

            Quay q = new Quay();
            q.setMaQuay(maQuay);
            q.setTenQuay(tenQuay);
            q.setMoTa(moTa);
            q.setMaTaiKhoan(maTK);

            quayService.update(q);

            req.getSession().setAttribute("message", "Cập nhật quầy thành công!");
            resp.sendRedirect("Admin");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error",
                    "Lỗi khi cập nhật quầy: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }
    private void deleteQuay(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int maQuay = Integer.parseInt(req.getParameter("maQuay"));
            Quay q = quayService.findById(maQuay);

            if (q != null) {
                quayService.delete(q);
                req.getSession().setAttribute("message", "Xóa quầy thành công!");
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy quầy!");
            }

            resp.sendRedirect("Admin");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error",
                    "Lỗi khi xóa quầy: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }
}
