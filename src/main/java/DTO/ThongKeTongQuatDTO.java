package DTO;

import java.math.BigDecimal;

public class ThongKeTongQuatDTO {
    private BigDecimal tongDoanhThu;
    private int tongDonHang;
    private int tongThanhVien;

    public ThongKeTongQuatDTO() {
        this.tongDoanhThu = BigDecimal.ZERO;
        this.tongDonHang = 0;
        this.tongThanhVien = 0;
    }

    public ThongKeTongQuatDTO(BigDecimal tongDoanhThu, int tongDonHang, int tongThanhVien) {
        this.tongDoanhThu = tongDoanhThu;
        this.tongDonHang = tongDonHang;
        this.tongThanhVien = tongThanhVien;
    }

    // Getter & Setter
    public BigDecimal getTongDoanhThu() { return tongDoanhThu; }
    public void setTongDoanhThu(BigDecimal tongDoanhThu) { this.tongDoanhThu = tongDoanhThu; }

    public int getTongDonHang() { return tongDonHang; }
    public void setTongDonHang(int tongDonHang) { this.tongDonHang = tongDonHang; }

    public int getTongThanhVien() { return tongThanhVien; }
    public void setTongThanhVien(int tongThanhVien) { this.tongThanhVien = tongThanhVien; }
}