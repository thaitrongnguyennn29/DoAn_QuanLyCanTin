package ServiceImp;

import DTO.MenuNgayDTO;
import Model.DonHang;
import Model.MenuNgay;
import Model.Page;
import Model.PageRequest;
import Repository.MenuNgayRepository;
import RepositoryImp.MenuNgayRepositoryImp;
import Service.MenuNgayService;

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
    public List<MenuNgayDTO> finAllDTO() {
        return menuNgayRepository.findAllMenuNgayDTO();
    }

    @Override
    public Page<MenuNgayDTO> finAllDTO(PageRequest pageRequest) {
        List<MenuNgayDTO> data = menuNgayRepository.findAllMenuNgayDTO(pageRequest).getData();
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
}
