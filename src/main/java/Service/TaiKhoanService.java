package Service;

import Model.Page;
import Model.PageRequest;
import Model.TaiKhoan;

import java.util.List;

public interface TaiKhoanService {
    List<TaiKhoan> finAll();
    Page<TaiKhoan> finAll(PageRequest pageRequest);
    TaiKhoan findById(int id);
    boolean create(TaiKhoan taiKhoan);
    boolean update(TaiKhoan taiKhoan);
    boolean delete(TaiKhoan taiKhoan);
    TaiKhoan login(String username, String password);
    boolean register(String username, String password, String fullname);
}