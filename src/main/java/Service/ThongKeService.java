package Service;
import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;

import java.util.List;

public interface ThongKeService {
    List<ThongKeDTO> getDoanhThu7Ngay(int maSeller);
    List<ThongKeDTO> getTopMonBanChay(int maSeller);
    List<ThongKeDTO> getDoanhThuToanSan();
    List<ThongKeDTO> getTopQuayDoanhThuCao();

    ThongKeTongQuatDTO getThongKeTongQuat();
}