package com.example.doan_quanlycantin;

import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;
import Model.TaiKhoan;
import Service.ThongKeService;
import Service.ExcelExportService;
import ServiceImp.ThongKeServiceImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/ExportExcel")
public class ExportExcelServlet extends HttpServlet {

    private ThongKeService thongKeService;
    private ExcelExportService excelExportService;

    @Override
    public void init() throws ServletException {
        this.thongKeService = new ThongKeServiceImp();
        this.excelExportService = new ExcelExportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Check quyền Admin (Bảo mật)
        HttpSession session = request.getSession();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getVaiTro())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        try {
            // 2. Lấy dữ liệu thống kê (Giống hệt Dashboard)
            ThongKeTongQuatDTO kpi = thongKeService.getThongKeTongQuat();
            List<ThongKeDTO> listDoanhThu = thongKeService.getDoanhThuToanSan();
            List<ThongKeDTO> listTopQuay = thongKeService.getTopQuayDoanhThuCao();

            if (kpi == null) kpi = new ThongKeTongQuatDTO(); // Null safety

            // 3. Gọi Service xuất Excel
            excelExportService.exportThongKe(response, kpi, listDoanhThu, listTopQuay);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xuất file: " + e.getMessage());
        }
    }
}