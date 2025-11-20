package ServiceImp;

import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.Page;
import Model.PageRequest;
import Repository.MenuNgayRepository;
import RepositoryImp.MenuNgayRepositoryImp;
import Service.MenuNgayService;

import java.time.LocalDate;
import java.util.List;

public class MenuNgayServiceImp implements MenuNgayService {
    private final MenuNgayRepository menuNgayRepository;
    public MenuNgayServiceImp() {
        this.menuNgayRepository = new MenuNgayRepositoryImp();
    }
    @Override
    public List<MenuNgay> finAll() {
        return menuNgayRepository.findAll();
    }

    @Override
    public Page<MenuNgay> finAll(PageRequest pageRequest) {
        List<MenuNgay> data = menuNgayRepository.findAll(pageRequest).getData();
        int totalItems = menuNgayRepository.countSearch(pageRequest.getKeyword());
        return new Page<>(data, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public MenuNgay findById(int id) {
        return menuNgayRepository.findById(id);
    }

    @Override
    public boolean create(MenuNgay menuNgay) {
        return menuNgayRepository.create(menuNgay) != null;
    }

    @Override
    public boolean update(MenuNgay menuNgay) {
        return menuNgayRepository.update(menuNgay);
    }

    @Override
    public boolean delete(MenuNgay menuNgay) {
        return menuNgayRepository.delete(menuNgay)  ;
    }

    @Override
    public boolean luuMenuNgay(LocalDate ngay, int maQuay, List<Integer> danhSachMaMon) throws IllegalArgumentException {
        // Chỉ cho phép thêm/sửa menu từ hôm nay trở đi
        LocalDate today = LocalDate.now();
        if (ngay.isBefore(today)) {
            throw new IllegalArgumentException("Không thể tạo hoặc cập nhật menu cho ngày quá khứ!");
        }

        //  Phải có ít nhất 1 món
        if (danhSachMaMon == null || danhSachMaMon.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn ít nhất một món ăn!");
        }

        return menuNgayRepository.luuMenuNgay(ngay, maQuay, danhSachMaMon);
    }

    @Override
    public boolean xoaMenuNgay(LocalDate ngay, int maQuay) {
        return menuNgayRepository.xoaMenuNgay(ngay, maQuay);
    }

    @Override
    public Page<MenuNgayDTO> layDanhSachMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay, int page, int size) {
        List<MenuNgayDTO> data = menuNgayRepository.layDanhSachMenuNgay(maQuay, tuNgay, denNgay, page, size);
        int totalItems = menuNgayRepository.demTongSoMenuNgay(maQuay, tuNgay, denNgay);
        return new Page<>(data, page, size, totalItems);
    }

    @Override
    public boolean kiemTraMenuTonTai(LocalDate ngay, int maQuay) {
        return menuNgayRepository.kiemTraMenuTonTai(ngay, maQuay);
    }
}
