package ServiceImp;

import DTO.ChiTietDonHangDTO;
import Model.ChiTietDonHang;
import Repository.ChiTietDonHangRepository;
import RepositoryImp.ChiTietDonHangRepositoryImp;
import Service.ChiTietDonHangService;

import java.util.Arrays;
import java.util.List;

public class ChiTietDonHangServiceImp implements ChiTietDonHangService {
    private final ChiTietDonHangRepository chiTietDonHangRepository;
    public ChiTietDonHangServiceImp() {
        this.chiTietDonHangRepository = new ChiTietDonHangRepositoryImp();
    }
    @Override
    public List<ChiTietDonHang> finAll() {
        return chiTietDonHangRepository.findAll();
    }

    @Override
    public List<ChiTietDonHang> finAllByMaDon(int maDonHang) {
        return chiTietDonHangRepository.findAllByMaDon(maDonHang);
    }

    @Override
    public ChiTietDonHang findById(int id) {
        return chiTietDonHangRepository.findById(id);
    }

    @Override
    public boolean update(ChiTietDonHang chiTietDonHang) {
        return chiTietDonHangRepository.update(chiTietDonHang);
    }

    @Override
    public List<ChiTietDonHangDTO> findAllByMaDon(int maDon) {
        return chiTietDonHangRepository.findDTOByOrderId(maDon);
    }

    @Override
    public List<ChiTietDonHangDTO> findDTOByOrderIdAndMaQuay(int maDon, int maQuay) {
        return chiTietDonHangRepository.findDTOByOrderIdAndMaQuay(maDon, maQuay);
    }

    private static final List<String> TRANG_THAI_ORDER = Arrays.asList(
            "Mới đặt",      // 0
            "Đã xác nhận",  // 1
            "Đang giao",    // 2
            "Đã giao"       // 3
    );

    @Override
    public void updateStatus(int maCT, String trangThaiMoi) throws Exception {
        // 1. Lấy thông tin hiện tại trong DB
        ChiTietDonHang ct = chiTietDonHangRepository.findById(maCT);
        if (ct == null) {
            throw new Exception("Món ăn không tồn tại!");
        }

        String trangThaiCu = ct.getTrangThai();

        // 2. Nếu trạng thái không thay đổi -> Bỏ qua
        if (trangThaiCu.equals(trangThaiMoi)) return;

        // 3. KIỂM TRA LOGIC CHẶN (State Machine)

        // RULE 1: Nếu đã "Đã giao" hoặc "Đã hủy" -> Không cho sửa nữa (Final State)
        if ("Đã giao".equals(trangThaiCu) || "Đã hủy".equals(trangThaiCu)) {
            throw new Exception("Món này đã kết thúc (" + trangThaiCu + "), không thể thay đổi!");
        }

        // RULE 2: Xử lý trường hợp HỦY
        if ("Đã hủy".equals(trangThaiMoi)) {
            // Chỉ cho phép hủy nếu chưa giao thành công
            if ("Đã giao".equals(trangThaiCu)) {
                throw new Exception("Đã giao hàng thành công, không thể hủy!");
            }
            // Cho phép hủy
        }
        else {
            // RULE 3: Kiểm tra luồng đi xuôi (Tiến lên)
            int levelCu = TRANG_THAI_ORDER.indexOf(trangThaiCu);
            int levelMoi = TRANG_THAI_ORDER.indexOf(trangThaiMoi);

            if (levelCu == -1 || levelMoi == -1) {
                // Trường hợp trạng thái lạ (ví dụ Đã hủy muốn quay lại Mới đặt)
                throw new Exception("Trạng thái không hợp lệ hoặc không thể hoàn tác từ 'Đã hủy'");
            }

            if (levelMoi < levelCu) {
                throw new Exception("Không thể quay ngược trạng thái từ '" + trangThaiCu + "' về '" + trangThaiMoi + "'");
            }
        }

        // 4. Nếu hợp lệ -> Gọi Repo lưu xuống DB
        ct.setTrangThai(trangThaiMoi);
        boolean success = chiTietDonHangRepository.update(ct);
        if (!success) throw new Exception("Lỗi Database, không cập nhật được!");
    }
}
