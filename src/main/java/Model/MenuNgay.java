package Model;

import java.time.LocalDate;

public class MenuNgay {
    private int maMenuNgay;
    private LocalDate ngay;
    private int maQuay;
    private int maMonAn;
    private String trangThai;

    public MenuNgay(int maMenuNgay, LocalDate ngay, int maQuay, int maMonAn, String trangThai) {
        this.maMenuNgay = maMenuNgay;
        this.ngay = ngay;
        this.maQuay = maQuay;
        this.maMonAn = maMonAn;
        this.trangThai = trangThai;
    }

    public MenuNgay() {
    }

    public int getMaMenuNgay() {
        return maMenuNgay;
    }

    public void setMaMenuNgay(int maMenuNgay) {
        this.maMenuNgay = maMenuNgay;
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

    public int getMaMonAn() {
        return maMonAn;
    }

    public void setMaMonAn(int maMonAn) {
        this.maMonAn = maMonAn;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
