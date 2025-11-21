package RepositoryImp;

import DTO.ThongKeDTO;
import DTO.ThongKeTongQuatDTO;
import Repository.ThongKeRepository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ThongKeRepositoryImp extends DBConnect implements ThongKeRepository {
    @Override
    public List<ThongKeDTO> getDoanhThu7Ngay(int maSeller) {
        List<ThongKeDTO> list = new ArrayList<>();
        // Query: Lấy doanh thu 7 ngày gần nhất của Seller
        String sql = "SELECT DATE(dh.NgayDat) as Ngay, SUM(ct.SoLuong * ct.DonGia) as TongTien " +
                "FROM ChiTietDonHang ct " +
                "JOIN DonHang dh ON ct.MaDon = dh.MaDon " +
                "JOIN MonAn m ON ct.MaMon = m.MaMon " +
                "JOIN Quay q ON m.MaQuay = q.MaQuay " +
                "WHERE q.MaTK = ? " + // Lọc theo ID người bán
                "AND ct.TrangThai IN ('Đã giao', 'Đã hoàn thành') " +
                "AND dh.NgayDat >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                "GROUP BY DATE(dh.NgayDat) " +
                "ORDER BY Ngay ASC";

        try (Connection conn = getConnection(); // Dùng dataSource đã lookup
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSeller);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ThongKeDTO(
                            rs.getString("Ngay"),
                            rs.getDouble("TongTien")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<ThongKeDTO> getTopMonBanChay(int maSeller) {
        List<ThongKeDTO> list = new ArrayList<>();
        // Query: Top 5 món bán chạy
        String sql = "SELECT m.TenMon, SUM(ct.SoLuong) as SoLuongBan " +
                "FROM ChiTietDonHang ct " +
                "JOIN MonAn m ON ct.MaMon = m.MaMon " +
                "JOIN Quay q ON m.MaQuay = q.MaQuay " +
                "WHERE q.MaTK = ? " +
                "AND ct.TrangThai IN ('Đã giao', 'Đã hoàn thành') " +
                "GROUP BY m.MaMon, m.TenMon " +
                "ORDER BY SoLuongBan DESC " +
                "LIMIT 5";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSeller);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ThongKeDTO(
                            rs.getString("TenMon"),
                            rs.getDouble("SoLuongBan")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<ThongKeDTO> getDoanhThuToanSan() {
        List<ThongKeDTO> list = new ArrayList<>();
        // SQL: Tính tổng tiền tất cả đơn hàng đã hoàn thành trong 7 ngày qua
        String sql = "SELECT DATE(NgayDat) as Ngay, SUM(TongTien) as TongTien " +
                "FROM DonHang " +
                "WHERE TrangThai = 'Đã hoàn thành' " +
                "AND NgayDat >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                "GROUP BY DATE(NgayDat) " +
                "ORDER BY Ngay ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new ThongKeDTO(rs.getString("Ngay"), rs.getDouble("TongTien")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<ThongKeDTO> getTopQuayDoanhThuCao() {
        List<ThongKeDTO> list = new ArrayList<>();
        // SQL: Join bảng để tính tổng tiền theo từng Quầy
        String sql = "SELECT q.TenQuay, SUM(ct.SoLuong * ct.DonGia) as DoanhThu " +
                "FROM ChiTietDonHang ct " +
                "JOIN MonAn m ON ct.MaMon = m.MaMon " +
                "JOIN Quay q ON m.MaQuay = q.MaQuay " +
                "WHERE ct.TrangThai IN ('Đã giao', 'Đã hoàn thành') " +
                "GROUP BY q.MaQuay, q.TenQuay " +
                "ORDER BY DoanhThu DESC " +
                "LIMIT 5";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new ThongKeDTO(rs.getString("TenQuay"), rs.getDouble("DoanhThu")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ThongKeTongQuatDTO getThongKeTongQuat() {
        ThongKeTongQuatDTO data = new ThongKeTongQuatDTO();

        // 1. Tính tổng doanh thu (Chỉ đơn đã hoàn thành)
        String sql1 = "SELECT COALESCE(SUM(TongTien), 0) FROM DonHang WHERE TrangThai = 'Đã hoàn thành'";

        // 2. Đếm tổng đơn hàng (Chỉ đơn đã hoàn thành)
        String sql2 = "SELECT COUNT(*) FROM DonHang WHERE TrangThai = 'Đã hoàn thành'";

        // 3. Đếm tổng thành viên (VaiTro = user)
        String sql3 = "SELECT COUNT(*) FROM TaiKhoan WHERE VaiTro = 'user'";

        try (Connection conn = getConnection()) {
            // Query 1: Doanh thu
            try (PreparedStatement ps = conn.prepareStatement(sql1);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.setTongDoanhThu(rs.getBigDecimal(1));
            }

            // Query 2: Số đơn
            try (PreparedStatement ps = conn.prepareStatement(sql2);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.setTongDonHang(rs.getInt(1));
            }

            // Query 3: Số user
            try (PreparedStatement ps = conn.prepareStatement(sql3);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.setTongThanhVien(rs.getInt(1));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}
