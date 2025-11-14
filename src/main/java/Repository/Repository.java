package Repository;

import Model.Page;
import Model.PageRequest;

import java.util.List;

public interface Repository <T>{
    List<T> findAll();
    //Page<T> findAll(PageRequest pageRequest);
    T findById(int id);
    T create(T entity);
    boolean update(T entity);
    boolean delete(T entity);
}
