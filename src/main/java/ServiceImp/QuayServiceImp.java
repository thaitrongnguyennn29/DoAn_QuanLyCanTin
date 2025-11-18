package ServiceImp;

import Model.Quay;
import RepositoryImp.MonAnRepositoryImp;
import RepositoryImp.QuayRepositoryImp;

import java.util.List;

public class QuayServiceImp {
    private QuayRepositoryImp quayRepositoryImp;

    public QuayServiceImp() {
        this.quayRepositoryImp = new QuayRepositoryImp();
    }

    public List<Quay> getAll() {
        return quayRepositoryImp.findAll();
    }
}
