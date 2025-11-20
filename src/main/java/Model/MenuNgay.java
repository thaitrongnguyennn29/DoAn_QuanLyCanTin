package Model;

import java.time.LocalDate;

public class MenuNgay {
    private int maMenu;
    private LocalDate ngay;
    private int maQuay;
    private int maMon;

    public MenuNgay(int maMenu, LocalDate ngay, int maQuay, int maMon) {
        this.maMenu = maMenu;
        this.ngay = ngay;
        this.maQuay = maQuay;
        this.maMon = maMon;
    }

    public MenuNgay() {
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

}
