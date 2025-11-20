package RepositoryImp;

import DTO.ChiTietDonHangDTO;
import Model.ChiTietDonHang;
import Model.Page;
import Model.PageRequest;
import Repository.ChiTietDonHangRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChiTietDonHangRepositoryImp extends DBConnect implements ChiTietDonHangRepository {
    public ChiTietDonHangRepositoryImp() {
        super();
    }
    private ChiTietDonHang mapRowToChiTietDonHang(ResultSet rs) throws SQLException {
        ChiTietDonHang ctdh = new ChiTietDonHang();

        ctdh.setMaCT(rs.getInt("MaCT"));
        ctdh.setMaDonHang(rs.getInt("MaDon"));
        ctdh.setMaMonAn(rs.getInt("MaMon"));
        ctdh.setSoLuong(rs.getInt("SoLuong"));
        // Sử dụng BigDecimal cho tiền tệ
        ctdh.setDonGia(rs.getBigDecimal("DonGia"));
        ctdh.setTrangThai(rs.getString("TrangThai"));

        return ctdh;
    }
    @Override
    public List<ChiTietDonHang> findAll() {
        List<ChiTietDonHang> ctdhs = new ArrayList<>();
        String sql = "SELECT * FROM ChiTietDonHang";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                ctdhs.add(mapRowToChiTietDonHang(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ctdhs;
    }

    @Override
    public Page<ChiTietDonHang> findAll(PageRequest pageRequest) {
        return null;
    }

    @Override
    public ChiTietDonHang findById(int id) {
        String sql = "SELECT * FROM ChiTietDonHang WHERE MaCT = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToChiTietDonHang(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public ChiTietDonHang create(ChiTietDonHang ctdh) {
        String sql = "INSERT INTO ChiTietDonHang (MaDon, MaMon, SoLuong, DonGia, TrangThai) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, ctdh.getMaDonHang());
            ps.setInt(2, ctdh.getMaMonAn());
            ps.setInt(3, ctdh.getSoLuong());
            ps.setBigDecimal(4, ctdh.getDonGia()); // Dùng setBigDecimal
            ps.setString(5, ctdh.getTrangThai());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        ctdh.setMaCT(keys.getInt(1));
                    }
                }
                return ctdh;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(ChiTietDonHang ctdh) {
        // Cập nhật Chi Tiết Đơn Hàng (thường là Số lượng, Đơn giá, hoặc Trạng thái)
        String sql = "UPDATE ChiTietDonHang SET MaDon = ?, MaMon = ?, SoLuong = ?, DonGia = ?, TrangThai = ? WHERE MaCT = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ctdh.getMaDonHang());
            ps.setInt(2, ctdh.getMaMonAn());
            ps.setInt(3, ctdh.getSoLuong());
            ps.setBigDecimal(4, ctdh.getDonGia()); // Dùng setBigDecimal
            ps.setString(5, ctdh.getTrangThai());
            ps.setInt(6, ctdh.getMaCT());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(ChiTietDonHang ctdh) {
        String sql = "DELETE FROM ChiTietDonHang WHERE MaCT = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ctdh.getMaCT());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countSearch(String keyword) {
        return 0;
    }

    @Override
    public List<ChiTietDonHang> findAllByMaDon(int maDonHang) {
        List<ChiTietDonHang> ctdhs = new ArrayList<>();
        String sql = "SELECT * FROM ChiTietDonHang WHERE MaDon = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ctdhs.add(mapRowToChiTietDonHang(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ctdhs;
    }

    @Override
    public List<ChiTietDonHangDTO> findDTOByOrderId(int orderId) {
        List<ChiTietDonHangDTO> list = new ArrayList<>();

        // JOIN 3 bảng để lấy đủ thông tin cho DTO
        String sql = "SELECT ct.*, m.TenMon, m.HinhAnh, q.MaQuay, q.TenQuay " +
                "FROM ChiTietDonHang ct " +
                "JOIN MonAn m ON ct.MaMon = m.MaMon " +
                "JOIN Quay q ON m.MaQuay = q.MaQuay " +
                "WHERE ct.MaDon = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChiTietDonHangDTO dto = new ChiTietDonHangDTO();

                    // 1. Set thông tin từ ChiTietDonHang
                    dto.setMaCT(rs.getInt("MaCT"));
                    dto.setMaDonHang(rs.getInt("MaDon"));
                    dto.setMaMonAn(rs.getInt("MaMon"));
                    dto.setSoLuong(rs.getInt("SoLuong"));
                    dto.setDonGia(rs.getBigDecimal("DonGia"));
                    dto.setTrangThai(rs.getString("TrangThai"));

                    // 2. Set thông tin từ MonAn
                    dto.setTenMonAn(rs.getString("TenMon"));
                    dto.setHinhAnhMonAn(rs.getString("HinhAnh")); // Map cột HinhAnh vào hinhAnhMonAn

                    // 3. Set thông tin từ Quay
                    dto.setMaQuay(rs.getInt("MaQuay"));
                    dto.setTenQuay(rs.getString("TenQuay"));

                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
