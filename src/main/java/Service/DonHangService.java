package Service;

import DTO.ChiTietDonHangDTO;
import Model.*;

import java.util.List;

public interface DonHangService {
    List<DonHang> finAll();
    Page<DonHang> finAll(PageRequest pageRequest);
    DonHang findById(int id);
    boolean create(DonHang donHang);
    boolean update(DonHang donHang);
    boolean delete(DonHang donHang);
    boolean autoUpdateTrangThai(int maDonHang);
    boolean placeOrder(TaiKhoan user, List<GioHang> cart);
    List<DonHang> getOrdersByUserId(int userId);
    List<ChiTietDonHangDTO> getOrderDetailsDTO(int orderId);
    Page<DonHang>  findDonHangByMaQuay(int maQuay, PageRequest pageRequest);
    boolean cancelOrderUser(int maDonHang, int maTaiKhoan);
}
