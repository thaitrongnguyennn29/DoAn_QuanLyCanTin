package com.example.doan_quanlycantin;

import java.io.IOException;
import java.util.List;

import Model.MonAn;
import Service.MonAnService;
import ServiceImp.MonAnServiceImp;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/trangchu")
public class HomeServlet extends HttpServlet {
    private MonAnService monAnService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy Top 4 món bán chạy nhất
        List<MonAn> listNoiBat = monAnService.getMonAnNoiBat(4);

        // 2. Gửi sang JSP
        request.setAttribute("listNoiBat", listNoiBat);
        request.setAttribute("pageTitle", "Trang Chủ");

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
