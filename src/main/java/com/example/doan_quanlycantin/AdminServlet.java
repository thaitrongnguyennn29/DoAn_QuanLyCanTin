package com.example.doan_quanlycantin;

import Model.MonAn;
import Model.Page;
import Model.PageRequest;
import Model.Quay;
import Repository.MonAnRepository;
import RepositoryImp.MonAnRepositoryImp;
import Service.MonAnService;
import Service.QuayService;
import ServiceImp.MonAnServiceImp;
import ServiceImp.QuayServiceImp;
import Util.RequestUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/Admin")
public class AdminServlet extends HttpServlet {
    private MonAnService monAnService;
    private QuayService quayService;

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
        this.quayService = new QuayServiceImp();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Quay> quays = quayService.finAll();

        int page = RequestUtil.getInt(request, "page", 1);
        int size = RequestUtil.getInt(request, "size", 10);
        String sort = RequestUtil.getString(request, "sort", "gia");
        String order = RequestUtil.getString(request, "order", "asc");
        String keyword = RequestUtil.getString(request, "keyword", "");
        PageRequest pageRequest = new PageRequest(keyword, order, sort, size, page);
        Page<MonAn> result = monAnService.finAll(pageRequest);

        request.setAttribute("result", result);
        request.setAttribute("DanhSachQuay", quays);
        request.setAttribute("pageRequest", pageRequest);
        request.getRequestDispatcher("admin.jsp").forward(request,response);
    }
}
