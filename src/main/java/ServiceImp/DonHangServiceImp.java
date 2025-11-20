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

    @Override
    public boolean autoUpdateTrangThai(int maDonHang) {
        try {
            // 1. Lấy thông tin đơn hàng
            DonHang donHang = donHangRepository.findById(maDonHang);
            if (donHang == null) {
                return false;
            }

            // 2. Lấy tất cả chi tiết của đơn hàng
            ChiTietDonHangRepository ctdhRepo = new ChiTietDonHangRepositoryImp();
            List<ChiTietDonHang> danhSachChiTiet = ctdhRepo.findAllByMaDon(maDonHang);

            if (danhSachChiTiet == null || danhSachChiTiet.isEmpty()) {
                return false;
            }

            // 3. Kiểm tra trạng thái của tất cả chi tiết
            boolean tatCaDaGiao = true;
            boolean tatCaHuy = true;
            boolean coItNhatMotDangXuLy = false;

            for (ChiTietDonHang ct : danhSachChiTiet) {
                String trangThai = ct.getTrangThai();

                if (!"Đã giao".equals(trangThai)) {
                    tatCaDaGiao = false;
                }

                if (!"Đã hủy".equals(trangThai)) {
                    tatCaHuy = false;
                }

                if ("Mới đặt".equals(trangThai) || "Đã xác nhận".equals(trangThai) || "Đang giao".equals(trangThai)) {
                    coItNhatMotDangXuLy = true;
                }
            }

            // 4. Quyết định trạng thái mới của đơn hàng
            String trangThaiMoi = null;

            if (tatCaDaGiao) {
                // Tất cả món đã giao → Đơn hàng hoàn thành
                trangThaiMoi = "Đã hoàn thành";
            } else if (tatCaHuy) {
                // Tất cả món đều hủy → Đơn hàng hủy
                trangThaiMoi = "Đã hủy";
            } else if (coItNhatMotDangXuLy) {
                // Có ít nhất 1 món đang xử lý → Đơn hàng đang xử lý
                trangThaiMoi = "Đang xử lý";
            }

            // 5. Cập nhật nếu trạng thái thay đổi
            if (trangThaiMoi != null && !trangThaiMoi.equals(donHang.getTrangThai())) {
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

        // 1. Nghiệp vụ: Tính tổng tiền server-side (Bảo mật)
        double totalAmount = 0;
        for (GioHang item : cart) {
            totalAmount += item.getTotalPrice();
        }

        // 2. Tạo object DonHang
        DonHang donHang = new DonHang();
        donHang.setMaTaiKhoan(user.getMaTaiKhoan());
        donHang.setTongTien(BigDecimal.valueOf(totalAmount));
        donHang.setTrangThai("Đang xử lí");
        // Nếu bạn có trường ghi chú trong DonHang thì set ở đây: donHang.setGhiChu(note);

        // 3. Gọi Repository để lưu xuống DB
        return donHangRepository.createOrderbyCart(donHang, cart);
    }

    @Override
    public List<DonHang> getOrdersByUserId(int userId) {
        return donHangRepository.findByUserId(userId);
    }

    @Override
    public List<ChiTietDonHangDTO> getOrderDetailsDTO(int orderId) {
        return chiTietDonHangRepository.findDTOByOrderId(orderId);
    }
}
