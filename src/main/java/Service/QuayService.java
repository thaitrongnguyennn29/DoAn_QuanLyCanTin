package Service;

import Model.Quay;

import java.util.List;

public interface QuayService {
    List<Quay> finAll();
    Quay findById(int id);
    boolean create(Quay quay);
    boolean update(Quay quay);
    boolean delete(Quay quay);
}
