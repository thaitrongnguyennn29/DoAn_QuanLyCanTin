package Repository;

import Model.ChiTietDonHang;

import java.util.List;

public interface ChiTietDonHangRepository extends Repository<ChiTietDonHang>{
    List<ChiTietDonHang> findAllByMaDon(int maDonHang);
}
