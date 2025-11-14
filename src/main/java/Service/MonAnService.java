package Service;

import Model.MonAn;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface MonAnService {
    List<MonAn> finAll();
    MonAn findById(int id);
    boolean create(MonAn monAn);
    boolean update(MonAn monAn);
    boolean delete(MonAn monAn);
}
