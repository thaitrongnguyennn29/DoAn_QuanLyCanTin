package ServiceImp;

import DTO.ChiTietDonHangDTO;
import Model.ChiTietDonHang;
import Repository.ChiTietDonHangRepository;
import RepositoryImp.ChiTietDonHangRepositoryImp;
import Service.ChiTietDonHangService;

import java.util.List;

public class ChiTietDonHangServiceImp implements ChiTietDonHangService {
    private final ChiTietDonHangRepository chiTietDonHangRepository;
    public ChiTietDonHangServiceImp() {
        this.chiTietDonHangRepository = new ChiTietDonHangRepositoryImp();
    }
    @Override
    public List<ChiTietDonHang> finAll() {
        return chiTietDonHangRepository.findAll();
    }

    @Override
    public List<ChiTietDonHang> finAllByMaDon(int maDonHang) {
        return chiTietDonHangRepository.findAllByMaDon(maDonHang);
    }

    @Override
    public ChiTietDonHang findById(int id) {
        return chiTietDonHangRepository.findById(id);
    }

    @Override
    public boolean update(ChiTietDonHang chiTietDonHang) {
        return chiTietDonHangRepository.update(chiTietDonHang);
    }

    @Override
    public List<ChiTietDonHangDTO> findAllByMaDon(int maDon) {
        return chiTietDonHangRepository.findDTOByMaDon(maDon);
    }
}
