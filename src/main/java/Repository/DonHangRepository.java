package Repository;

import Model.DonHang;
import Model.GioHang;
import com.mysql.cj.x.protobuf.MysqlxCrud;

import java.util.List;

public interface DonHangRepository extends Repository<DonHang>{
    boolean createOrderbyCart(DonHang donHang, List<GioHang> listGioHang);
    List<DonHang> findByUserId(int userId);
}
