package DTO;

import java.math.BigDecimal;
import java.time.LocalDate;

public class MenuNgayDTO {
    private int maMenu;
    private LocalDate ngay;
    private int maQuay;
    private int maMon;
    private String trangThai;

    private String tenMon;
    private String hinhAnh;
    private String tenQuay;
    private BigDecimal giaMon;

    public MenuNgayDTO(int maMenu, LocalDate ngay, int maMon, int maQuay, String trangThai, String tenMon, String hinhAnh, String tenQuay, BigDecimal giaMon) {
        this.maMenu = maMenu;
        this.ngay = ngay;
        this.maMon = maMon;
        this.maQuay = maQuay;
        this.trangThai = trangThai;
        this.tenMon = tenMon;
        this.hinhAnh = hinhAnh;
        this.tenQuay = tenQuay;
        this.giaMon = giaMon;
    }

    public MenuNgayDTO() {
    }

    public int getMaMenu() {
        return maMenu;
    }

    public void setMaMenu(int maMenu) {
        this.maMenu = maMenu;
    }

    public LocalDate getNgay() {
        return ngay;
    }

    public void setNgay(LocalDate ngay) {
        this.ngay = ngay;
    }

    public int getMaQuay() {
        return maQuay;
    }

    public void setMaQuay(int maQuay) {
        this.maQuay = maQuay;
    }

    public int getMaMon() {
        return maMon;
    }

    public void setMaMon(int maMon) {
        this.maMon = maMon;
    }

    public String getTenMon() {
        return tenMon;
    }

    public void setTenMon(String tenMon) {
        this.tenMon = tenMon;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public String getTenQuay() {
        return tenQuay;
    }

    public void setTenQuay(String tenQuay) {
        this.tenQuay = tenQuay;
    }

    public BigDecimal getGiaMon() {
        return giaMon;
    }

    public void setGiaMon(BigDecimal giaMon) {
        this.giaMon = giaMon;
    }
}
