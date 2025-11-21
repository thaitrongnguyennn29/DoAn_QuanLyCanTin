package Repository;

import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;

import java.util.List;

public interface ThongKeRepository {

    List<ThongKeDTO> getDoanhThu7Ngay(int maSeller);
    List<ThongKeDTO> getTopMonBanChay(int maSeller);
    List<ThongKeDTO> getDoanhThuToanSan();      // Admin: Doanh thu cả căn tin
    List<ThongKeDTO> getTopQuayDoanhThuCao();


    ThongKeTongQuatDTO getThongKeTongQuat();
}
