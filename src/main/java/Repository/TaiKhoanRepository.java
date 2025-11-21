package Repository;

import Model.Quay;
import Model.TaiKhoan;

public interface TaiKhoanRepository extends Repository<TaiKhoan> {
    TaiKhoan findByUsername(String username);
    boolean addaccount(TaiKhoan taiKhoan);
}
