package com.example.doan_quanlycantin;

import java.io.IOException;
import java.util.List;

import Model.MonAn;
import Model.Quay;
import Repository.MonAnRepository;
import RepositoryImp.MonAnRepositoryImp;
import Service.MonAnService;
import Service.QuayService;
import ServiceImp.MonAnServiceImp;
import ServiceImp.QuayServiceImp;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/thucdon")
public class MenuServlet extends HttpServlet {
    private MonAnService monAnService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MonAn> monAns = monAnService.finAll();
        request.setAttribute("DanhSachMon", monAns);
        request.setAttribute("pageTitle", "Thực Đơn");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/menu.jsp");
        dispatcher.forward(request, response);
    }
}
