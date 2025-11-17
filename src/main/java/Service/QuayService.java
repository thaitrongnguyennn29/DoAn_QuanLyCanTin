package Service;

import Model.Page;
import Model.PageRequest;
import Model.Quay;

import java.util.List;

public interface QuayService {
    List<Quay> finAll();
    Page<Quay> finAll(PageRequest pageRequest);
    Quay findById(int id);
    boolean create(Quay quay);
    boolean update(Quay quay);
    boolean delete(Quay quay);
}
