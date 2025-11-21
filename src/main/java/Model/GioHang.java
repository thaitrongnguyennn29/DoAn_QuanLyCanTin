package Model;

public class GioHang {

    private MonAn monAn;
    private int quantity;

    public GioHang(MonAn monAn, int quantity) {
        this.monAn = monAn;
        this.quantity = quantity;
    }

    public MonAn getMonAn() {
        return monAn;
    }

    public void setMonAn(MonAn monAn) {
        this.monAn = monAn;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return monAn.getGia() * quantity;
    }
}
