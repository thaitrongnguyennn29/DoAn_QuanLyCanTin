package ServiceImp;

import Model.MonAn;
import Repository.MonAnRepository;
import RepositoryImp.MonAnRepositoryImp;
import Service.MonAnService;

import java.util.List;

public class MonAnServiceImp implements MonAnService {

    private MonAnRepositoryImp monAnRepositoryImp;

    public MonAnServiceImp() {
        this.monAnRepositoryImp = new MonAnRepositoryImp();
    }

    public List<MonAn> getAll() {
        return monAnRepositoryImp.findAll();
    }

    public List<MonAn> getByQuayId(int maQuay) {
        return monAnRepositoryImp.findByQuayId(maQuay);
    }

    @Override
    public MonAn getById(int maMon) {
        return monAnRepositoryImp.findById(maMon);
    }
}
