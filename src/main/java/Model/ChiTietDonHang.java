package Model;

import java.math.BigDecimal;

public class ChiTietDonHang {
    private int maCT;
    private int MaDonHang;
    private int maMonAn;
    private int soLuong;
    private BigDecimal donGia;
    private String trangThai;

    public ChiTietDonHang(int maCT, int maDonHang, int maMonAn, BigDecimal donGia, int soLuong, String trangThai) {
        this.maCT = maCT;
        MaDonHang = maDonHang;
        this.maMonAn = maMonAn;
        this.donGia = donGia;
        this.soLuong = soLuong;
        this.trangThai = trangThai;
    }

    public ChiTietDonHang() {
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

    public int getMaCT() {
        return maCT;
    }

    public void setMaCT(int maCT) {
        this.maCT = maCT;
    }

    public int getMaDonHang() {
        return MaDonHang;
    }

    public void setMaDonHang(int maDonHang) {
        MaDonHang = maDonHang;
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

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
