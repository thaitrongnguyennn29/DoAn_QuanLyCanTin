package Repository;

import Model.DonHang;
import Model.GioHang;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface DonHangRepository extends Repository<DonHang>{
    Page<DonHang> findDonHangByMaQuay(int maQuay, PageRequest pageRequest);
    int countDonHangByMaQuay(int maQuay, PageRequest pageRequest);
    boolean createOrderbyCart(DonHang donHang, List<GioHang> listGioHang);
    List<DonHang> findByUserId(int userId);
}
