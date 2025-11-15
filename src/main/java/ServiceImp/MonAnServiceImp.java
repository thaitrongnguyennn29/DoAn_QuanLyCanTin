package ServiceImp;

import Model.MonAn;
import Model.Page;
import Model.PageRequest;
import Repository.MonAnRepository;
import RepositoryImp.MonAnRepositoryImp;
import Service.MonAnService;

import java.util.List;

public class MonAnServiceImp implements MonAnService {
    private final MonAnRepository monAnRepository;
    public MonAnServiceImp() {
        this.monAnRepository = new MonAnRepositoryImp();
    }
    @Override
    public List<MonAn> finAll() {
        return monAnRepository.findAll();
    }

    @Override
    public Page<MonAn> finAll(PageRequest pageRequest) {
        List<MonAn> data = monAnRepository.findAll(pageRequest).getData();
        int totalItems = monAnRepository.countSearch(pageRequest.getKeyword());
        return new Page<>(data, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public MonAn findById(int id) {
        return monAnRepository.findById(id);
    }

    @Override
    public boolean create(MonAn monAn) {
        return monAnRepository.create(monAn) != null;
    }

    @Override
    public boolean update(MonAn monAn) {
        return monAnRepository.update(monAn);
    }

    @Override
    public boolean delete(MonAn monAn) {
        return monAnRepository.delete(monAn);
    }
}
