package Repository;

import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface MenuNgayRepository extends Repository<MenuNgay> {
    public List<MenuNgayDTO> findAllMenuNgayDTO();
    public Page<MenuNgayDTO> findAllMenuNgayDTO(PageRequest pageRequest);
}
