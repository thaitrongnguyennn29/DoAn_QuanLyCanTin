package ServiceImp;

import Model.TaiKhoan;
import Repository.TaiKhoanRepository;
import RepositoryImp.TaiKhoanRepositoryImp;
import Service.TaiKhoanService;

public class TaiKhoanServiceImp implements TaiKhoanService {

    private TaiKhoanRepository taiKhoanRepositoryImp;

    public TaiKhoanServiceImp() {
        this.taiKhoanRepositoryImp = new TaiKhoanRepositoryImp();
    }

    @Override
    public TaiKhoan login(String username, String password) {
        TaiKhoan tk = taiKhoanRepositoryImp.findByUsername(username);
        if (tk != null) {
            // Logic kiểm tra mật khẩu
            if (tk.getMatKhau().equals(password)) {
                return tk;
            }
        }
        return null;
    }

    @Override
    public boolean register(String username, String password, String fullname) {
        // 1. Kiểm tra tên đăng nhập đã tồn tại chưa
        if (taiKhoanRepositoryImp.findByUsername(username) != null) {
            return false;
        }

        // 2. Tạo đối tượng mới
        TaiKhoan newTk = new TaiKhoan();
        newTk.setTenNguoiDung(fullname);
        newTk.setTenDangNhap(username);
        newTk.setMatKhau(password);
        newTk.setVaiTro("user"); // Mặc định người đăng ký là USER

        // 3. Gọi Repo để lưu
        return taiKhoanRepositoryImp.addaccount(newTk);
    }
}
