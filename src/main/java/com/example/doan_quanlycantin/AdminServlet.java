package com.example.doan_quanlycantin;

import Model.MonAn;
import Model.Quay;
import Repository.MonAnRepository;
import RepositoryImp.MonAnRepositoryImp;
import Service.QuayService;
import ServiceImp.QuayServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/Admin")
public class AdminServlet extends HttpServlet {
    private MonAnRepository monAnRepository;
    private QuayService quayService;

    @Override
    public void init() throws ServletException {
        this.monAnRepository = new MonAnRepositoryImp();
        this.quayService = new QuayServiceImp();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MonAn> monAns = monAnRepository.findAll();
        List<Quay> quays = quayService.finAll();
        request.setAttribute("DanhSachMon", monAns);
        request.setAttribute("DanhSachQuay", quays);
        request.getRequestDispatcher("admin.jsp").forward(request,response);
    }
}
