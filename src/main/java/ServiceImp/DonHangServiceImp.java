package ServiceImp;

import DTO.ChiTietDonHangDTO;
import DTO.ChiTietDonHangDTO;
import Model.*;
import Repository.ChiTietDonHangRepository;
import Repository.DonHangRepository;
import RepositoryImp.ChiTietDonHangRepositoryImp;
import RepositoryImp.DonHangRepositoryImp;
import Service.DonHangService;

import java.math.BigDecimal;
import java.math.BigDecimal;
import java.util.List;

public class DonHangServiceImp implements DonHangService {

    private final DonHangRepository donHangRepository;
    private final ChiTietDonHangRepository chiTietDonHangRepository;

    public DonHangServiceImp() {
        this.donHangRepository = new DonHangRepositoryImp();
        this.chiTietDonHangRepository = new ChiTietDonHangRepositoryImp();
    }

    @Override
    public List<DonHang> finAll() {
        return donHangRepository.findAll();
    }

    @Override
    public Page<DonHang> finAll(PageRequest pageRequest) {
        List<DonHang> data = donHangRepository.findAll(pageRequest).getData();
        int totalItems = donHangRepository.countSearch(pageRequest.getKeyword());
        return new Page<>(data, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public DonHang findById(int id) {
        return donHangRepository.findById(id);
    }

    @Override
    public boolean create(DonHang donHang) {
        return donHangRepository.create(donHang) != null;
    }

    @Override
    public boolean update(DonHang donHang) {
        return donHangRepository.update(donHang);
    }

    @Override
    public boolean delete(DonHang donHang) {
        return donHangRepository.delete(donHang);
    }

    // --- [QUAN TRỌNG] HÀM TỰ ĐỘNG CẬP NHẬT TRẠNG THÁI ---
    @Override
    public boolean autoUpdateTrangThai(int maDonHang) {
        try {
            // 1. Lấy thông tin đơn hàng
            DonHang donHang = donHangRepository.findById(maDonHang);
            if (donHang == null) return false;

            // 2. Lấy danh sách chi tiết
            List<ChiTietDonHang> danhSachChiTiet = chiTietDonHangRepository.findAllByMaDon(maDonHang);
            if (danhSachChiTiet == null || danhSachChiTiet.isEmpty()) return false;

            // 3. Biến cờ để kiểm tra
            boolean conMonDangXuLy = false; // Có món nào chưa xong không?
            boolean coMonDaGiao = false;    // Có món nào giao thành công chưa?

            for (ChiTietDonHang ct : danhSachChiTiet) {
                String tt = ct.getTrangThai();

                // Kiểm tra nhóm "Đang thực hiện"
                if ("Mới đặt".equals(tt) || "Đã xác nhận".equals(tt) || "Đang giao".equals(tt)) {
                    conMonDangXuLy = true;
                    // Nếu thấy có món đang làm, thì chắc chắn đơn cha chưa xong -> Break luôn cho nhanh
                    break;
                }

                // Kiểm tra xem có món nào giao thành công không
                if ("Đã giao".equals(tt)) {
                    coMonDaGiao = true;
                }
            }

            // 4. Quyết định trạng thái mới cho Đơn Cha
            String trangThaiMoi = "";

            if (conMonDangXuLy) {
                // Trường hợp 1: Vẫn còn món đang làm -> Đơn cha Đang xử lí
                trangThaiMoi = "Đang xử lí";
            } else {
                // Trường hợp 2: Không còn món nào đang làm (Tất cả đã xong)
                if (coMonDaGiao) {
                    // Có ít nhất 1 món giao thành công (dù các món khác bị hủy) -> Đã hoàn thành
                    trangThaiMoi = "Đã hoàn thành";
                } else {
                    // Không có món nào giao thành công (nghĩa là Toàn bộ đã Hủy) -> Đã hủy
                    trangThaiMoi = "Đã hủy";
                }
            }

            // 5. Cập nhật vào DB nếu trạng thái thay đổi
            if (!trangThaiMoi.equals(donHang.getTrangThai())) {
                donHang.setTrangThai(trangThaiMoi);
                return donHangRepository.update(donHang);
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Page<DonHang> findDonHangByMaQuay(int maQuay, PageRequest pageRequest) {
        return donHangRepository.findDonHangByMaQuay(maQuay, pageRequest);
    }

    @Override
    public boolean placeOrder(TaiKhoan user, List<GioHang> cart) {
        if (user == null || cart == null || cart.isEmpty()) {
            return false;
        }

        double totalAmount = 0;
        for (GioHang item : cart) {
            totalAmount += item.getTotalPrice();
        }

        DonHang donHang = new DonHang();
        donHang.setMaTaiKhoan(user.getMaTaiKhoan());
        donHang.setTongTien(BigDecimal.valueOf(totalAmount));
        donHang.setTrangThai("Đang xử lí"); // [LƯU Ý] DB dùng 'lí'

        return donHangRepository.createOrderbyCart(donHang, cart);
    }

    @Override
    public List<DonHang> getOrdersByUserId(int userId) {
        return donHangRepository.findByUserId(userId);
    }

    @Override
    public List<ChiTietDonHangDTO> getOrderDetailsDTO(int orderId) {
        // Bạn có thể ép kiểu hoặc thêm hàm vào Interface nếu cần dùng logic lọc theo Quầy
        return chiTietDonHangRepository.findDTOByOrderId(orderId);
    }
}
