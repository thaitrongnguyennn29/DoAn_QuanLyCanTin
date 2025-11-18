package Repository;

import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface Repository <T>{
    List<T> findAll();
    T findById(int id);
}
