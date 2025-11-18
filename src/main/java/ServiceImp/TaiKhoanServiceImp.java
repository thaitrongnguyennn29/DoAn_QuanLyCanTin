package ServiceImp;

import Model.Page;
import Model.PageRequest;
import Model.TaiKhoan;
import Repository.TaiKhoanRepository;
import RepositoryImp.TaiKhoanRepositoryImp;
import Service.TaiKhoanService;

import java.util.List;

public class TaiKhoanServiceImp implements TaiKhoanService {
    private final TaiKhoanRepository taiKhoanRepository;
    public TaiKhoanServiceImp() {
        this.taiKhoanRepository = new TaiKhoanRepositoryImp();
    }

    @Override
    public List<TaiKhoan> finAll() {
        return taiKhoanRepository.findAll();
    }

    @Override
    public Page<TaiKhoan> finAll(PageRequest pageRequest) {
        List<TaiKhoan> data = taiKhoanRepository.findAll(pageRequest).getData();
        int totalItems = taiKhoanRepository.countSearch(pageRequest.getKeyword());
        return new Page<>(data, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public TaiKhoan findById(int id) {
        return taiKhoanRepository.findById(id);
    }

    @Override
    public boolean create(TaiKhoan taiKhoan) {
        return taiKhoanRepository.create(taiKhoan) != null;
    }

    @Override
    public boolean update(TaiKhoan taiKhoan) {
        return taiKhoanRepository.update(taiKhoan);
    }

    @Override
    public boolean delete(TaiKhoan taiKhoan) {
        return taiKhoanRepository.delete(taiKhoan);
    }
}
