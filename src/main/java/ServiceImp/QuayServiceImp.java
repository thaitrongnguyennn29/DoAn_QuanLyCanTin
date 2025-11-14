package ServiceImp;

import Model.MonAn;
import Model.Quay;
import Repository.MonAnRepository;
import Repository.QuayRepository;
import RepositoryImp.MonAnRepositoryImp;
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
