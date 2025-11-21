package com.example.doan_quanlycantin;

import Model.MonAn;
import Model.Quay;

import Service.MenuNgayService;
import ServiceImp.MenuNgayServiceImp;
import ServiceImp.MonAnServiceImp;
import ServiceImp.QuayServiceImp;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/thucdon")
public class MenuServlet extends HttpServlet {

    private MenuNgayService menuNgayService;
    private QuayServiceImp quayService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.menuNgayService = new MenuNgayServiceImp();
        this.quayService = new QuayServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy ngày hiện tại
        LocalDate today = LocalDate.now();

        // 2. Lấy tham số filter từ request
        String filter = request.getParameter("filter");
        List<MonAn> listMonAn;

        // 3. Logic lấy dữ liệu từ bảng MenuNgay
        if (filter == null || filter.equals("all")) {
            // Lấy tất cả món CÓ TRONG MENU NGÀY HÔM NAY
            listMonAn = menuNgayService.getMonAnTheoNgay(today);
        } else {
            try {
                int maQuay = Integer.parseInt(filter);
                // Lấy món của Quầy X trong MENU NGÀY HÔM NAY
                listMonAn = menuNgayService.getMonAnTheoNgayVaQuay(today, maQuay);
            } catch (NumberFormatException e) {
                listMonAn = menuNgayService.getMonAnTheoNgay(today); // Fallback
            }
        }

        // 4. Lấy danh sách quầy để hiển thị nút Filter
        List<Quay> listQuay = quayService.finAll();

        // 5. Gửi dữ liệu sang JSP
        request.setAttribute("listMonAn", listMonAn);
        request.setAttribute("listQuay", listQuay);

        // Gửi ngày hiện tại sang để hiển thị tiêu đề (như tôi đã hướng dẫn ở câu trả lời trước)
        // (Phần này bạn đã có trong JSP rồi hoặc set attribute ở đây cũng được)

        request.getRequestDispatcher("/menu.jsp").forward(request, response);
    }
}

