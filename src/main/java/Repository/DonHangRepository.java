package Repository;

import Model.DonHang;
import Model.Page;
import Model.PageRequest;

public interface DonHangRepository extends Repository<DonHang>{
    Page<DonHang> findDonHangByMaQuay(int maQuay, PageRequest pageRequest);
    int countDonHangByMaQuay(int maQuay, PageRequest pageRequest);
}
