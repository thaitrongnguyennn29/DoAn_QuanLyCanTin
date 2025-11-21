package Service;

import DTO.ChiTietDonHangDTO;
import Model.ChiTietDonHang;

import java.util.List;

public interface ChiTietDonHangService {
    List<ChiTietDonHang> finAll();
    List<ChiTietDonHang> finAllByMaDon(int maDonHang);
    ChiTietDonHang findById(int id);
    boolean update(ChiTietDonHang chiTietDonHang);
    List<ChiTietDonHangDTO> findAllByMaDon(int maDon);
    List<ChiTietDonHangDTO> findDTOByOrderIdAndMaQuay(int maDon, int maQuay);
    void updateStatus(int maCT, String trangThaiMoi) throws Exception;
}
