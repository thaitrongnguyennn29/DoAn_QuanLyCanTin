package DTO;

public class ThongKeDTO {
    private String label;  // Dùng để chứa Ngày (2023-11-21) hoặc Tên món (Cơm gà)
    private double value;  // Dùng để chứa Doanh thu hoặc Số lượng bán

    public ThongKeDTO() {
    }

    public ThongKeDTO(String label, double value) {
        this.label = label;
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }
}