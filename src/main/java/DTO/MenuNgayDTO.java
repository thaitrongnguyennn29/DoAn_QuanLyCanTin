package DTO;

import java.time.LocalDate;

public class MenuNgayDTO {
    private LocalDate ngay;
    private int soMon;

    public MenuNgayDTO() {
    }

    public MenuNgayDTO(LocalDate ngay, int soMon) {
        this.ngay = ngay;
        this.soMon = soMon;
    }

    public LocalDate getNgay() {
        return ngay;
    }

    public void setNgay(LocalDate ngay) {
        this.ngay = ngay;
    }

    public int getSoMon() {
        return soMon;
    }

    public void setSoMon(int soMon) {
        this.soMon = soMon;
    }
}
