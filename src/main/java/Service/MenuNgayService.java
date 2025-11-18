package Service;
import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface MenuNgayService {
    List<MenuNgay> finAll();
    Page<MenuNgay> finAll(PageRequest pageRequest);
    List<MenuNgayDTO> finAllDTO();
    Page<MenuNgayDTO> finAllDTO(PageRequest pageRequest);
    MenuNgay findById(int id);
    boolean create(MenuNgay menuNgay);
    boolean update(MenuNgay menuNgay);
    boolean delete(MenuNgay menuNgay);
}
