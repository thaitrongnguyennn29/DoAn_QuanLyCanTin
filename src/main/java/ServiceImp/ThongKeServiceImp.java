package ServiceImp;

import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;
import Repository.ThongKeRepository;
import RepositoryImp.ThongKeRepositoryImp;
import Service.ThongKeService;

import java.util.List;

public class ThongKeServiceImp implements ThongKeService {

    private final ThongKeRepository thongKeRepository = new ThongKeRepositoryImp();

    @Override
    public List<ThongKeDTO> getDoanhThu7Ngay(int maSeller) {
        return thongKeRepository.getDoanhThu7Ngay(maSeller);
    }

    @Override
    public List<ThongKeDTO> getTopMonBanChay(int maSeller) {
        return thongKeRepository.getTopMonBanChay(maSeller);
    }

    @Override
    public List<ThongKeDTO> getDoanhThuToanSan() {
        return thongKeRepository.getDoanhThuToanSan();
    }

    @Override
    public List<ThongKeDTO> getTopQuayDoanhThuCao() {
        return thongKeRepository.getTopQuayDoanhThuCao();
    }

    @Override
    public ThongKeTongQuatDTO getThongKeTongQuat() {
        return thongKeRepository.getThongKeTongQuat();
    }
}
