package Service;

import Model.DonHang;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface DonHangService {
    List<DonHang> finAll();
    Page<DonHang> finAll(PageRequest pageRequest);
    DonHang findById(int id);
    boolean create(DonHang donHang);
    boolean update(DonHang donHang);
    boolean delete(DonHang donHang);
    boolean autoUpdateTrangThai(int maDonHang);
}
