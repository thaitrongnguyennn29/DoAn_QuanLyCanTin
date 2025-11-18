package Service;

import Model.MonAn;
import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface MonAnService {
    List<MonAn> getAll();
    List<MonAn> getByQuayId(int maQuay);
    MonAn getById(int maMon);
}