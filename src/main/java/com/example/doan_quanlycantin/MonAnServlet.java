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

    // ====================== HANDLE GET (DELETE) ==========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("DELETE".equalsIgnoreCase(action)) {
            deleteMon(req, resp);
        } else {
            redirectBasedOnOrigin(req, resp);
        }
    }

    // ====================== HANDLE POST (ADD/EDIT) ==========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("ADD".equalsIgnoreCase(action)) {
            addMon(req, resp);
        } else if ("EDIT".equalsIgnoreCase(action)) {
            updateMon(req, resp);
        } else {
            redirectBasedOnOrigin(req, resp);
        }
    }

    // ====================== ADD ==========================
    private void addMon(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String tenMon = req.getParameter("tenMon");
            double gia = Double.parseDouble(req.getParameter("gia"));
            String moTa = req.getParameter("moTa");
            int maQuay = Integer.parseInt(req.getParameter("maQuay"));

            // Upload ảnh có kiểm tra định dạng
            String imageName = uploadImageToSource(req.getPart("hinhAnh"));

            MonAn mon = new MonAn();
            mon.setTenMonAn(tenMon);
            mon.setGia(gia);
            mon.setMoTa(moTa);
            mon.setMaQuay(maQuay);
            mon.setHinhAnh(imageName);

            monAnService.create(mon);

            req.getSession().setAttribute("message", "Thêm món ăn thành công!");

            // Điều hướng thông minh
            redirectBasedOnOrigin(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi thêm món: " + e.getMessage());
            redirectBasedOnOrigin(req, resp);
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

            // Kiểm tra nếu có upload ảnh mới
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

            // Điều hướng thông minh
            redirectBasedOnOrigin(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi cập nhật món: " + e.getMessage());
            redirectBasedOnOrigin(req, resp);
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

            // Điều hướng thông minh
            redirectBasedOnOrigin(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi xóa món: " + e.getMessage());
            redirectBasedOnOrigin(req, resp);
        }
    }

    // ====================== HELPER: ĐIỀU HƯỚNG THÔNG MINH (QUAN TRỌNG) ==========================
    private void redirectBasedOnOrigin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Lấy tham số "origin" từ URL hoặc Form (vd: MonAnServlet?origin=seller)
        String origin = req.getParameter("origin");

        if ("seller".equalsIgnoreCase(origin)) {
            // Nếu là Seller -> Trả về trang Seller
            resp.sendRedirect("Seller?page=quanlymenungay");
        } else {
            // Mặc định -> Trả về trang Admin
            resp.sendRedirect("Admin");
        }
    }

    // ====================== UPLOAD IMAGE (BẢO MẬT) ==========================
    private String uploadImageToSource(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        // 1. Kiểm tra MIME type
        String contentType = part.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IOException("File tải lên không hợp lệ! Chỉ chấp nhận định dạng ảnh.");
        }

        // 2. Kiểm tra đuôi file
        String fileNameCheck = part.getSubmittedFileName().toLowerCase();
        if (!fileNameCheck.endsWith(".jpg") && !fileNameCheck.endsWith(".png") &&
                !fileNameCheck.endsWith(".jpeg") && !fileNameCheck.endsWith(".gif") && !fileNameCheck.endsWith(".webp")) {
            throw new IOException("Đuôi file không hợp lệ! Vui lòng chọn file ảnh.");
        }

        String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String safeFileName = System.currentTimeMillis() + "_" + originalFileName;

        String webappPath = getServletContext().getRealPath("/");
        String deployDir = webappPath + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator;

        // Lưu vào Deploy
        saveFile(part.getInputStream(), deployDir, safeFileName);

        // Lưu vào Source
        File sourceRoot = getProjectSourceDir(webappPath);
        if (sourceRoot != null) {
            String sourceDir = sourceRoot.getAbsolutePath() + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator;
            Path sourcePath = Paths.get(sourceDir + safeFileName);
            Path deployPath = Paths.get(deployDir + safeFileName);
            try {
                new File(sourceDir).mkdirs();
                Files.copy(deployPath, sourcePath, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                System.err.println("Lỗi copy sang Source: " + e.getMessage());
            }
        }

        return safeFileName;
    }

    private void saveFile(InputStream input, String dir, String fileName) throws IOException {
        File folder = new File(dir);
        if (!folder.exists()) folder.mkdirs();
        Path filePath = Paths.get(dir + fileName);
        Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
    }

    private File getProjectSourceDir(String webappPath) {
        File current = new File(webappPath);
        for (int i = 0; i < 10 && current != null; i++) {
            if (new File(current, "src" + File.separator + "main" + File.separator + "webapp").exists()) {
                return new File(current, "src" + File.separator + "main" + File.separator + "webapp");
            }
            File siblingProject = new File(current, PROJECT_DIR_NAME);
            if (siblingProject.exists() && siblingProject.isDirectory()) {
                File srcCheck = new File(siblingProject, "src" + File.separator + "main" + File.separator + "webapp");
                if (srcCheck.exists()) return srcCheck;
            }
            current = current.getParentFile();
        }
        return null;
    }

    private void deleteImageFromSource(String imageName) {
        if (imageName == null || imageName.trim().isEmpty()) return;
        try {
            String webappPath = getServletContext().getRealPath("/");
            String deployPath = webappPath + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator + imageName;
            new File(deployPath).delete();
            File sourceRoot = getProjectSourceDir(webappPath);
            if (sourceRoot != null) {
                String sourcePath = sourceRoot.getAbsolutePath() + File.separator + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator + imageName;
                new File(sourcePath).delete();
            }
        } catch (Exception e) {
            System.err.println("Lỗi xóa ảnh: " + e.getMessage());
        }
    }
}