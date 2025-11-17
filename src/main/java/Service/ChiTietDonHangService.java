package Service;

import Model.ChiTietDonHang;

import java.util.List;

public interface ChiTietDonHangService {
    List<ChiTietDonHang> finAll();
    List<ChiTietDonHang> finAllByMaDon(int maDonHang);
    ChiTietDonHang findById(int id);
    boolean update(ChiTietDonHang chiTietDonHang);
}
