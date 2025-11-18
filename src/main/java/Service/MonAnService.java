package Service;

import Model.MonAn;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface MonAnService {
    List<MonAn> finAll();
    Page<MonAn> finAll(PageRequest pageRequest);
    MonAn findById(int id);
    boolean create(MonAn monAn);
    boolean update(MonAn monAn);
    boolean delete(MonAn monAn);
    List<MonAn> getByQuayId(int maQuay);
}