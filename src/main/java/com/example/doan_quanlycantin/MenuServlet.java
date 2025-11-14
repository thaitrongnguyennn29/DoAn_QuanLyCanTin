package com.example.doan_quanlycantin;

import java.io.IOException;
import java.util.List;

import Model.MonAn;
import Repository.MonAnRepository;
import RepositoryImp.MonAnRepositoryImp;
import Service.MonAnService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/thucdon")
public class MenuServlet extends HttpServlet {
    private MonAnRepository monAnRepository;

    @Override
    public void init() throws ServletException {
        this.monAnRepository = new MonAnRepositoryImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MonAn> monAns = monAnRepository.findAll();
        request.setAttribute("DanhSachMon", monAns);
        request.setAttribute("pageTitle", "Thực Đơn");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/menu.jsp");
        dispatcher.forward(request, response);
    }
}
