package Model;

public class MonAn {
    private int maMonAn;
    private String tenMonAn;
    private double gia;
    private String moTa;
    private String hinhAnh;
    private int maQuay;

    public MonAn(int maMonAn, String tenMonAn, double gia, String moTa, String hinhAnh, int maQuay) {
        this.maMonAn = maMonAn;
        this.tenMonAn = tenMonAn;
        this.moTa = moTa;
        this.gia = gia;
        this.hinhAnh = hinhAnh;
        this.maQuay = maQuay;
    }

    public MonAn() {
    }

    public int getMaMonAn() {
        return maMonAn;
    }

    public void setMaMonAn(int maMonAn) {
        this.maMonAn = maMonAn;
    }

    public String getTenMonAn() {
        return tenMonAn;
    }

    public void setTenMonAn(String tenMonAn) {
        this.tenMonAn = tenMonAn;
    }

    public double getGia() {
        return   gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public int getMaQuay() {
        return maQuay;
    }

    public void setMaQuay(int maQuay) {
        this.maQuay = maQuay;
    }
}
