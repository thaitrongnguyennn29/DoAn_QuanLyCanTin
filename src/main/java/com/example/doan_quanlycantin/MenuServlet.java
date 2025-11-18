package com.example.doan_quanlycantin;

import Model.MonAn;
import Model.Quay;

import ServiceImp.MonAnServiceImp;
import ServiceImp.QuayServiceImp;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/thucdon")
public class MenuServlet extends HttpServlet {

    private MonAnServiceImp monAnService;
    private QuayServiceImp quayService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        monAnService = new MonAnServiceImp();
        quayService = new QuayServiceImp();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số filter từ request
        String filter = request.getParameter("filter");

        List<MonAn> listMonAn;
        if (filter == null || filter.equals("all")) {
            listMonAn = monAnService.getAll();
        } else {
            try {
                int maQuay = Integer.parseInt(filter);
                listMonAn = monAnService.getByQuayId(maQuay);
            } catch (NumberFormatException e) {
                listMonAn = monAnService.getAll(); // fallback
            }
        }

        List<Quay> listQuay = quayService.getAll();

        request.setAttribute("listMonAn", listMonAn);
        request.setAttribute("listQuay", listQuay);
        request.getRequestDispatcher("/menu.jsp").forward(request, response);
    }
}

