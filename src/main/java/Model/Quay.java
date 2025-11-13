package Model;

public class Quay {
    private int maQuay;
    private String tenQuay;
    private String moTa;
    private int maTaiKhoan;

    public Quay(int maQuay, String tenQuay, String moTa, int maTaiKhoan) {
        this.maQuay = maQuay;
        this.tenQuay = tenQuay;
        this.moTa = moTa;
        this.maTaiKhoan = maTaiKhoan;
    }

    public Quay() {
    }

    public String getTenQuay() {
        return tenQuay;
    }

    public void setTenQuay(String tenQuay) {
        this.tenQuay = tenQuay;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public int getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(int maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public int getMaQuay() {
        return maQuay;
    }

    public void setMaQuay(int maQuay) {
        this.maQuay = maQuay;
    }
}
