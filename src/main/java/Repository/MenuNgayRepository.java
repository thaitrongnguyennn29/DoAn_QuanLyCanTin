package Repository;

import DTO.MenuNgayDTO;
import Model.MenuNgay;

import java.time.LocalDate;
import java.util.List;

public interface MenuNgayRepository extends Repository<MenuNgay> {
    boolean luuMenuNgay(LocalDate ngay, int maQuay, List<Integer> danhSachMaMon);

    boolean xoaMenuNgay(LocalDate ngay, int maQuay);

    List<MenuNgayDTO> layDanhSachMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay, int page, int size);

    int demTongSoMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay);

    boolean kiemTraMenuTonTai(LocalDate ngay, int maQuay);
}
