package Service;

import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

public class ExcelExportService {

    public void exportThongKe(HttpServletResponse response, ThongKeTongQuatDTO kpi,
                              List<ThongKeDTO> listDoanhThu, List<ThongKeDTO> listTopQuay) throws IOException {

        // 1. Khởi tạo Workbook (File Excel)
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Báo Cáo Thống Kê");

            // --- CẤU HÌNH STYLE ---
            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle currencyStyle = createCurrencyStyle(workbook);
            CellStyle boldStyle = createBoldStyle(workbook);

            int rowIndex = 0;

            // --- PHẦN 1: TIÊU ĐỀ ---
            Row titleRow = sheet.createRow(rowIndex++);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("BÁO CÁO TỔNG QUAN CĂN TIN");
            titleCell.setCellStyle(headerStyle);
            // Gộp ô cho tiêu đề đẹp
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));
            rowIndex++; // Cách 1 dòng

            // --- PHẦN 2: CHỈ SỐ TỔNG QUÁT (KPI) ---
            Row kpiHeaderRow = sheet.createRow(rowIndex++);
            kpiHeaderRow.createCell(0).setCellValue("Tổng Doanh Thu");
            kpiHeaderRow.createCell(1).setCellValue("Tổng Đơn Hàng");
            kpiHeaderRow.createCell(2).setCellValue("Tổng Thành Viên");
            // Set style đậm
            for(int i=0; i<3; i++) kpiHeaderRow.getCell(i).setCellStyle(boldStyle);

            Row kpiValueRow = sheet.createRow(rowIndex++);
            Cell cDoanhThu = kpiValueRow.createCell(0);
            cDoanhThu.setCellValue(kpi.getTongDoanhThu().doubleValue());
            cDoanhThu.setCellStyle(currencyStyle);

            kpiValueRow.createCell(1).setCellValue(kpi.getTongDonHang());
            kpiValueRow.createCell(2).setCellValue(kpi.getTongThanhVien());
            rowIndex++;

            // --- PHẦN 3: CHI TIẾT DOANH THU 7 NGÀY ---
            Row revTitleRow = sheet.createRow(rowIndex++);
            revTitleRow.createCell(0).setCellValue("CHI TIẾT DOANH THU (7 NGÀY QUA)");
            revTitleRow.getCell(0).setCellStyle(boldStyle);

            Row revHeaderRow = sheet.createRow(rowIndex++);
            revHeaderRow.createCell(0).setCellValue("Ngày");
            revHeaderRow.createCell(1).setCellValue("Doanh Thu (VNĐ)");
            revHeaderRow.getCell(0).setCellStyle(boldStyle);
            revHeaderRow.getCell(1).setCellStyle(boldStyle);

            for (ThongKeDTO item : listDoanhThu) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(item.getLabel());
                Cell cellMoney = row.createCell(1);
                cellMoney.setCellValue(item.getValue());
                cellMoney.setCellStyle(currencyStyle);
            }
            rowIndex++;

            // --- PHẦN 4: TOP QUẦY BÁN CHẠY ---
            Row topTitleRow = sheet.createRow(rowIndex++);
            topTitleRow.createCell(0).setCellValue("TOP QUẦY BÁN CHẠY");
            topTitleRow.getCell(0).setCellStyle(boldStyle);

            Row topHeaderRow = sheet.createRow(rowIndex++);
            topHeaderRow.createCell(0).setCellValue("Tên Quầy");
            topHeaderRow.createCell(1).setCellValue("Doanh Thu (VNĐ)");
            topHeaderRow.getCell(0).setCellStyle(boldStyle);
            topHeaderRow.getCell(1).setCellStyle(boldStyle);

            for (ThongKeDTO item : listTopQuay) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(item.getLabel());
                Cell cellMoney = row.createCell(1);
                cellMoney.setCellValue(item.getValue());
                cellMoney.setCellStyle(currencyStyle);
            }

            // --- AUTO SIZE COLUMN ---
            sheet.autoSizeColumn(0);
            sheet.autoSizeColumn(1);
            sheet.autoSizeColumn(2);
            sheet.autoSizeColumn(3);

            // --- XUẤT FILE RA BROWSER ---
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=BaoCao_CanTin.xlsx");

            OutputStream out = response.getOutputStream();
            workbook.write(out);
            out.close();
        }
    }

    // Helper: Style Tiêu đề lớn
    private CellStyle createHeaderStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 16);
        font.setColor(IndexedColors.BLUE.getIndex());
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);
        return style;
    }

    // Helper: Style Tiền tệ
    private CellStyle createCurrencyStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        DataFormat format = wb.createDataFormat();
        style.setDataFormat(format.getFormat("#,##0 ₫"));
        return style;
    }

    // Helper: Style Chữ đậm
    private CellStyle createBoldStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }
}