package com.example.doan_quanlycantin;

import Model.MonAn;
import Service.MonAnService;
import ServiceImp.MonAnServiceImp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/MonAnServlet")
@MultipartConfig
public class MonAnServlet extends HttpServlet {

    private MonAnService monAnService;

    private static final String PROJECT_DIR_NAME = "DoAn_QuanLyCanTin";

    @Override
    public void init() throws ServletException {
        this.monAnService = new MonAnServiceImp();
    }

    // ====================== HANDLE GET ==========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("DELETE".equalsIgnoreCase(action)) {
            deleteMon(req, resp);
        } else {
            resp.sendRedirect("Admin");
        }
    }

    // ====================== HANDLE POST ==========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("ADD".equalsIgnoreCase(action)) {
            addMon(req, resp);
        } else if ("EDIT".equalsIgnoreCase(action)) {
            updateMon(req, resp);
        }
    }

    // ====================== ADD ==========================
    private void addMon(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String tenMon = req.getParameter("tenMon");
            double gia = Double.parseDouble(req.getParameter("gia"));
            String moTa = req.getParameter("moTa");
            int maQuay = Integer.parseInt(req.getParameter("maQuay"));

            String imageName = uploadImageToSource(req.getPart("hinhAnh"));

            MonAn mon = new MonAn();
            mon.setTenMonAn(tenMon);
            mon.setGia(gia);
            mon.setMoTa(moTa);
            mon.setMaQuay(maQuay);
            mon.setHinhAnh(imageName);

            monAnService.create(mon);

            req.getSession().setAttribute("message", "Thêm món ăn thành công!");
            resp.sendRedirect("Admin");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi thêm món: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }

    // ====================== UPDATE ==========================
    private void updateMon(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            int maMon = Integer.parseInt(req.getParameter("maMon"));
            String tenMon = req.getParameter("tenMon");
            double gia = Double.parseDouble(req.getParameter("gia"));
            String moTa = req.getParameter("moTa");
            int maQuay = Integer.parseInt(req.getParameter("maQuay"));

            String oldImage = req.getParameter("hinhAnhHienTai");
            Part imagePart = req.getPart("hinhAnh");
            String finalImage;

            if (imagePart != null && imagePart.getSize() > 0) {
                if (oldImage != null && !oldImage.trim().isEmpty()) {
                    deleteImageFromSource(oldImage);
                }
                finalImage = uploadImageToSource(imagePart);
            } else {
                finalImage = oldImage;
            }

            MonAn mon = new MonAn();
            mon.setMaMonAn(maMon);
            mon.setTenMonAn(tenMon);
            mon.setGia(gia);
            mon.setMoTa(moTa);
            mon.setMaQuay(maQuay);
            mon.setHinhAnh(finalImage);

            monAnService.update(mon);

            req.getSession().setAttribute("message", "Cập nhật món ăn thành công!");
            resp.sendRedirect("Admin");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi cập nhật món: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }

    // ====================== DELETE ==========================
    private void deleteMon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int maMon = Integer.parseInt(req.getParameter("maMon"));
            MonAn monAn = monAnService.findById(maMon);

            if (monAn != null) {
                String imageName = monAn.getHinhAnh();

                monAnService.delete(monAn);

                if (imageName != null && !imageName.trim().isEmpty()) {
                    deleteImageFromSource(imageName);
                }

                req.getSession().setAttribute("message", "Xóa món ăn thành công!");
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy món ăn!");
            }

            resp.sendRedirect("Admin");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi xóa món: " + e.getMessage());
            resp.sendRedirect("Admin");
        }
    }

    // ====================== UPLOAD IMAGE ==========================
    private String uploadImageToSource(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

        // Làm sạch tên file để tránh lỗi ký tự đặc biệt hoặc trùng lặp (Optional)
        String safeFileName = System.currentTimeMillis() + "_" + originalFileName;

        // ========== 1. LƯU VÀO THƯ MỤC DEPLOY (Để hiển thị ngay lập tức) ==========
        // Đường dẫn thực tế nơi Tomcat đang chạy (thường là trong folder target)
        String webappPath = getServletContext().getRealPath("/");
        String deployDir = webappPath + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator;

        saveFile(part.getInputStream(), deployDir, safeFileName);
        System.out.println("Đã lưu vào DEPLOY: " + deployDir + safeFileName);

        // ========== 2. LƯU VÀO THƯ MỤC SOURCE CODE (Để giữ ảnh không bị mất khi Rebuild) ==========
        // Tự động tìm đường dẫn source code thay vì hardcode
        File sourceRoot = getProjectSourceDir(webappPath);

        if (sourceRoot != null) {
            String sourceDir = sourceRoot.getAbsolutePath() + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator;
            // Chúng ta cần mở lại InputStream vì stream cũ đã được đọc hết ở bước 1
            // Tuy nhiên, Part.getInputStream() có thể không hỗ trợ đọc lại tuỳ server.
            // Cách an toàn là copy từ file đã lưu ở bước 1 sang source.

            Path sourcePath = Paths.get(sourceDir + safeFileName);
            Path deployPath = Paths.get(deployDir + safeFileName);

            try {
                // Tạo thư mục nếu chưa có
                new File(sourceDir).mkdirs();

                // Copy từ deploy sang source
                Files.copy(deployPath, sourcePath, StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Đã copy vào SOURCE: " + sourcePath.toAbsolutePath());
            } catch (IOException e) {
                System.err.println("Lỗi copy sang Source: " + e.getMessage());
            }
        } else {
            System.err.println("Cảnh báo: Không tìm thấy thư mục Source code. Ảnh chỉ được lưu tạm thời.");
        }

        return safeFileName;
    }

    // Hàm hỗ trợ lưu file
    private void saveFile(InputStream input, String dir, String fileName) throws IOException {
        File folder = new File(dir);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        Path filePath = Paths.get(dir + fileName);
        Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
    }

    /**
     * Hàm thông minh để tìm thư mục src/main/webapp dựa trên thư mục chạy thực tế
     */
    /**
     * Hàm thông minh tìm thư mục Source Code (src/main/webapp)
     * Hỗ trợ tìm cả trong thư mục cha và thư mục anh em (Sibling)
     */
    private File getProjectSourceDir(String webappPath) {
        File current = new File(webappPath);

        // Đi ngược lên tối đa 10 cấp thư mục
        for (int i = 0; i < 10 && current != null; i++) {

            // TRƯỜNG HỢP 1: Chạy trực tiếp trong folder project (target)
            // Kiểm tra xem folder hiện tại có chứa "src" không
            if (new File(current, "src" + File.separator + "main" + File.separator + "webapp").exists()) {
                return new File(current, "src" + File.separator + "main" + File.separator + "webapp");
            }

            // TRƯỜNG HỢP 2: Chạy Tomcat bên ngoài (Thư mục anh em)
            // Kiểm tra xem folder hiện tại có chứa folder con nào trùng tên PROJECT_DIR_NAME không
            File siblingProject = new File(current, PROJECT_DIR_NAME);
            if (siblingProject.exists() && siblingProject.isDirectory()) {
                // Nếu tìm thấy folder tên project, kiểm tra xem nó có chứa src không
                File srcCheck = new File(siblingProject, "src" + File.separator + "main" + File.separator + "webapp");
                if (srcCheck.exists()) {
                    return srcCheck;
                }
            }

            // Đi lên 1 cấp
            current = current.getParentFile();
        }

        return null; // Không tìm thấy
    }

    // ====================== DELETE IMAGE ==========================
    private void deleteImageFromSource(String imageName) {
        if (imageName == null || imageName.trim().isEmpty()) return;

        try {
            String webappPath = getServletContext().getRealPath("/");

            // 1. Xóa ở Deploy
            String deployPath = webappPath + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator + imageName;
            new File(deployPath).delete();

            // 2. Xóa ở Source
            File sourceRoot = getProjectSourceDir(webappPath);
            if (sourceRoot != null) {
                String sourcePath = sourceRoot.getAbsolutePath() + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator + imageName;
                new File(sourcePath).delete();
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi xóa ảnh: " + e.getMessage());
        }
    }
}