package ServiceImp;

import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.MonAn;
import Model.Page;
import Model.PageRequest;
import Repository.MenuNgayRepository;
import RepositoryImp.MenuNgayRepositoryImp;
import Service.MenuNgayService;

import java.time.LocalDate;
import java.util.List;

public class MenuNgayServiceImp implements MenuNgayService {
    private MenuNgayRepository menuNgayRepository = new MenuNgayRepositoryImp();
    @Override
    public boolean luuMenuNgay(LocalDate ngay, int maQuay, List<Integer> danhSachMaMon) throws IllegalArgumentException {
        // Validate dữ liệu đầu vào
        if (ngay == null) throw new IllegalArgumentException("Ngày không được để trống");
        if (danhSachMaMon == null || danhSachMaMon.isEmpty()) throw new IllegalArgumentException("Danh sách món ăn trống");

        // Gọi Repo thực hiện Transaction (Xóa cũ -> Thêm mới)
        return menuNgayRepository.luuMenuNgay(ngay, maQuay, danhSachMaMon);
    }

    @Override
    public boolean xoaMenuNgay(LocalDate ngay, int maQuay) {
        return menuNgayRepository.xoaMenuNgay(ngay, maQuay);
    }

    @Override
    public Page<MenuNgayDTO> layDanhSachMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay, int page, int size) {
        List<MenuNgayDTO> data = menuNgayRepository.layDanhSachMenuNgay(maQuay, tuNgay, denNgay, page, size);
        // Tạm thời trả về 0 hoặc implement hàm count trong Repo sau
        int totalItems = 0;
        return new Page<>(data, page, size, totalItems);
    }

    // Các hàm override khác trả về null/false nếu chưa dùng tới
    @Override public List<MenuNgay> finAll() { return null; }
    @Override public Page<MenuNgay> finAll(PageRequest pageRequest) { return null; }
    @Override public MenuNgay findById(int id) { return null; }
    @Override public boolean create(MenuNgay menuNgay) { return false; }
    @Override public boolean update(MenuNgay menuNgay) { return false; }
    @Override public boolean delete(MenuNgay menuNgay) { return false; }
    @Override public boolean kiemTraMenuTonTai(LocalDate ngay, int maQuay) { return false; }

    @Override
    public List<MonAn> getMonAnTheoNgay(LocalDate date) {
        return menuNgayRepository.getMonAnTheoNgay(date);
    }

    @Override
    public List<MonAn> getMonAnTheoNgayVaQuay(LocalDate date, int maQuay) {
        return menuNgayRepository.getMonAnTheoNgayVaQuay(date, maQuay);
    }
}
