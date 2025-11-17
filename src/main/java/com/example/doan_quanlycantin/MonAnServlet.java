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

    private static final String PROJECT_PATH = "D:/Program Files/SPKT/Web/DoAn_QuanLyCantin";

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

        // ========== 1. LƯU VÀO DEPLOY (Tomcat webapps) ==========
        String webappPath = getServletContext().getRealPath("/");
        String deployDir = webappPath + "assets" + File.separator + "images" + File.separator + "MonAn" + File.separator;

        File deployFolder = new File(deployDir);
        if (!deployFolder.exists()) {
            deployFolder.mkdirs();
        }

        Path deployFilePath = Paths.get(deployDir + originalFileName);
        try (InputStream input = part.getInputStream()) {
            Files.copy(input, deployFilePath, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Đã lưu vào DEPLOY: " + deployFilePath.toAbsolutePath());
        }

        // ========== 2. COPY VÀO SOURCE CODE ==========
        try {
            // DÙNG ĐƯỜNG DẪN CỐ ĐỊNH thay vì user.dir
            String sourceDir = PROJECT_PATH + File.separator + "src" + File.separator + "main"
                    + File.separator + "webapp" + File.separator + "assets"
                    + File.separator + "images" + File.separator + "MonAn" + File.separator;

            File sourceFolder = new File(sourceDir);
            if (!sourceFolder.exists()) {
                boolean created = sourceFolder.mkdirs();
                if (created) {
                    System.out.println("Đã tạo thư mục SOURCE: " + sourceDir);
                } else {
                    System.err.println("Không thể tạo thư mục SOURCE: " + sourceDir);
                }
            }

            Path sourceFilePath = Paths.get(sourceDir + originalFileName);
            Files.copy(deployFilePath, sourceFilePath, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Đã copy vào SOURCE: " + sourceFilePath.toAbsolutePath());

        } catch (Exception e) {
            System.err.println("Không thể copy vào source: " + e.getMessage());
            System.err.println("Kiểm tra lại PROJECT_PATH trong MonAnServlet.java");
            e.printStackTrace();
        }

        return originalFileName;
    }

    // ====================== DELETE IMAGE ==========================
    private void deleteImageFromSource(String imageName) {
        if (imageName == null || imageName.trim().isEmpty()) {
            return;
        }

        try {
            // 1. Xóa từ DEPLOY
            String webappPath = getServletContext().getRealPath("/");
            String deployPath = webappPath + "assets" + File.separator + "images"
                    + File.separator + "MonAn" + File.separator + imageName;

            File deployFile = new File(deployPath);
            if (deployFile.exists() && deployFile.delete()) {
                System.out.println("Đã xóa từ DEPLOY: " + deployPath);
            }

            // 2. Xóa từ SOURCE
            String sourcePath = PROJECT_PATH + File.separator + "src" + File.separator + "main"
                    + File.separator + "webapp" + File.separator + "assets"
                    + File.separator + "images" + File.separator + "MonAn"
                    + File.separator + imageName;

            File sourceFile = new File(sourcePath);
            if (sourceFile.exists() && sourceFile.delete()) {
                System.out.println("Đã xóa từ SOURCE: " + sourcePath);
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi xóa ảnh: " + e.getMessage());
        }
    }
}