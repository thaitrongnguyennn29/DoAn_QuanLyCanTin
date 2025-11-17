package ServiceImp;

import Model.Page;
import Model.PageRequest;
import Model.Quay;
import Repository.QuayRepository;
import RepositoryImp.QuayRepositoryImp;
import Service.QuayService;

import java.util.List;

public class QuayServiceImp implements QuayService {
    private final QuayRepository quayRepository;
    public QuayServiceImp() {
        this.quayRepository = new QuayRepositoryImp();
    }
    @Override
    public List<Quay> finAll() {
        return quayRepository.findAll();
    }

    @Override
    public Page<Quay> finAll(PageRequest pageRequest) {
        List<Quay> data = quayRepository.findAll(pageRequest).getData();
        int totalItems = quayRepository.countSearch(pageRequest.getKeyword());
        return new Page<>(data, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public Quay findById(int id) {
        return quayRepository.findById(id);
    }

    @Override
    public boolean create(Quay quay) {
        return quayRepository.create(quay) != null;
    }

    @Override
    public boolean update(Quay quay) {
        return quayRepository.update(quay);
    }

    @Override
    public boolean delete(Quay quay) {
        return quayRepository.delete(quay);
    }
}
