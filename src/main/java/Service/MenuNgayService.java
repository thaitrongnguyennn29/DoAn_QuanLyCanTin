package Service;
import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.MonAn;
import Model.Page;
import Model.PageRequest;

import java.time.LocalDate;
import java.util.List;

public interface MenuNgayService {
    List<MenuNgay> finAll();
    Page<MenuNgay> finAll(PageRequest pageRequest);
    MenuNgay findById(int id);
    boolean create(MenuNgay menuNgay);
    boolean update(MenuNgay menuNgay);
    boolean delete(MenuNgay menuNgay);


    boolean luuMenuNgay(LocalDate ngay, int maQuay, List<Integer> danhSachMaMon) throws IllegalArgumentException;
    boolean xoaMenuNgay(LocalDate ngay, int maQuay);
    Page<MenuNgayDTO> layDanhSachMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay, int page, int size);
    boolean kiemTraMenuTonTai(LocalDate ngay, int maQuay);

    //Load menu ngày trên thực đơn
    List<MonAn> getMonAnTheoNgay(LocalDate date);
    List<MonAn> getMonAnTheoNgayVaQuay(LocalDate date, int maQuay);
}
