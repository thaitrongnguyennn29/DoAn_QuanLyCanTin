package DTO;

import Model.ChiTietDonHang;
import java.math.BigDecimal;

/**
 * DTO để hiển thị chi tiết đơn hàng kèm thông tin món ăn và quầy
 */
public class ChiTietDonHangDTO {
    // Thông tin từ ChiTietDonHang
    private int maCT;
    private int maDonHang;
    private int maMonAn;
    private int soLuong;
    private BigDecimal donGia;
    private String trangThai;

    // Thông tin bổ sung từ MonAn
    private String tenMonAn;
    private String hinhAnhMonAn;

    // Thông tin bổ sung từ Quay
    private int maQuay;
    private String tenQuay;

    // Constructor mặc định
    public ChiTietDonHangDTO() {
    }

    // Constructor đầy đủ
    public ChiTietDonHangDTO(ChiTietDonHang chiTiet, String tenMonAn, String hinhAnhMonAn,
                             int maQuay, String tenQuay) {
        this.maCT = chiTiet.getMaCT();
        this.maDonHang = chiTiet.getMaDonHang();
        this.maMonAn = chiTiet.getMaMonAn();
        this.soLuong = chiTiet.getSoLuong();
        this.donGia = chiTiet.getDonGia();
        this.trangThai = chiTiet.getTrangThai();
        this.tenMonAn = tenMonAn;
        this.hinhAnhMonAn = hinhAnhMonAn;
        this.maQuay = maQuay;
        this.tenQuay = tenQuay;
    }

    // Tính thành tiền
    public BigDecimal getThanhTien() {
        return donGia.multiply(BigDecimal.valueOf(soLuong));
    }

    // Getters and Setters
    public int getMaCT() {
        return maCT;
    }

    public void setMaCT(int maCT) {
        this.maCT = maCT;
    }

    public int getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(int maDonHang) {
        this.maDonHang = maDonHang;
    }

    public int getMaMonAn() {
        return maMonAn;
    }

    public void setMaMonAn(int maMonAn) {
        this.maMonAn = maMonAn;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getTenMonAn() {
        return tenMonAn;
    }

    public void setTenMonAn(String tenMonAn) {
        this.tenMonAn = tenMonAn;
    }

    public String getHinhAnhMonAn() {
        return hinhAnhMonAn;
    }

    public void setHinhAnhMonAn(String hinhAnhMonAn) {
        this.hinhAnhMonAn = hinhAnhMonAn;
    }

    public int getMaQuay() {
        return maQuay;
    }

    public void setMaQuay(int maQuay) {
        this.maQuay = maQuay;
    }

    public String getTenQuay() {
        return tenQuay;
    }

    public void setTenQuay(String tenQuay) {
        this.tenQuay = tenQuay;
    }
}