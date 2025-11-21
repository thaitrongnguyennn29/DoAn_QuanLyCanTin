package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class DonHang {
    private int maDonHang;
    private int maTaiKhoan;
    private LocalDateTime ngayDat;
    private BigDecimal tongTien;
    private String trangThai;

    public DonHang(int maTaiKhoan, LocalDateTime ngayDat, int maDonHang, BigDecimal tongTien, String trangThai) {
        this.maTaiKhoan = maTaiKhoan;
        this.ngayDat = ngayDat;
        this.maDonHang = maDonHang;
        this.tongTien = tongTien;
        this.trangThai = trangThai;
    }

    public DonHang() {
    }

    public int getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(int maDonHang) {
        this.maDonHang = maDonHang;
    }

    public int getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(int maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public LocalDateTime getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(LocalDateTime ngayDat) {
        this.ngayDat = ngayDat;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
