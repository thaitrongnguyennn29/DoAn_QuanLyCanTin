package Service;

import Model.TaiKhoan;

public interface TaiKhoanService {
    TaiKhoan login(String username, String password);
    boolean register(String username, String password, String fullname);
}