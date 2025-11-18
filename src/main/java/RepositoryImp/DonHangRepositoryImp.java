package RepositoryImp;

import Model.DonHang;
import Model.Page;
import Model.PageRequest;
import Repository.DonHangRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangRepositoryImp extends DBConnect implements DonHangRepository{
    public DonHangRepositoryImp() {
        super();
    }
    private DonHang mapRowToDonHang(ResultSet rs) throws SQLException {
        DonHang dh = new DonHang();

        // 1. Lấy dữ liệu cơ bản
        dh.setMaDonHang(rs.getInt("MaDon"));
        dh.setMaTaiKhoan(rs.getInt("MaTK"));
        dh.setTongTien(rs.getBigDecimal("TongTien"));
        dh.setTrangThai(rs.getString("TrangThai"));

        // 2. Xử lý DATETIME
        Timestamp ngayDatTimestamp = rs.getTimestamp("NgayDat");
        if (ngayDatTimestamp != null) {
            dh.setNgayDat(ngayDatTimestamp.toLocalDateTime());
        }

        return dh;
    }
    @Override
    public List<DonHang> findAll() {
        List<DonHang> donHangs = new ArrayList<>();
        String sql = "SELECT * FROM DonHang ORDER BY NgayDat DESC";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                donHangs.add(mapRowToDonHang(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return donHangs;
    }

    @Override
    public Page<DonHang> findAll(PageRequest pageRequest) {
        List<DonHang> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT dh.* FROM DonHang dh JOIN TaiKhoan tk ON dh.MaTK = tk.MaTK WHERE 1=1");

        String keyword = pageRequest.getKeyword();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        // 1. Điều kiện tìm kiếm theo keyword
        if (hasKeyword) {
            sql.append(" AND (dh.TrangThai LIKE ? OR tk.TenDangNhap LIKE ?");
            if (keyword.matches("\\d+")) {
                sql.append(" OR dh.MaDon = ?");
            }
            sql.append(")");
        }

        // 2. Lọc theo ngày (locNgay từ request parameter)
        String locNgay = pageRequest.getLocNgay();
        if (locNgay != null && !locNgay.isEmpty()) {
            switch (locNgay) {
                case "today":
                    sql.append(" AND DATE(dh.NgayDat) = CURDATE()");
                    break;
                case "yesterday":
                    sql.append(" AND DATE(dh.NgayDat) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)");
                    break;
                case "week":
                    sql.append(" AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
                    break;
                case "month":
                    sql.append(" AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 30 DAY)");
                    break;
            }
        }

        // 3. Lọc theo trạng thái (trangThai từ request parameter)
        String trangThai = pageRequest.getTrangThai();
        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND dh.TrangThai = ?");
        }

        // 4. Sắp xếp
        String sortField = pageRequest.getSortField() != null ? pageRequest.getSortField() : "MaDon";
        String sqlSortField;

        if (sortField.equalsIgnoreCase("ngayDat")) {
            sqlSortField = "dh.NgayDat";
        } else {
            sqlSortField = "dh.MaDon";
        }

        String sortOrder = pageRequest.getSortOrder().toUpperCase();
        sql.append(" ORDER BY ").append(sqlSortField).append(" ").append(sortOrder);

        // 5. Phân trang
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TrangThai (cho LIKE)
                ps.setString(paramIndex++, kw); // TenDangNhap (cho LIKE)
                if (keyword.matches("\\d+")) {
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaDon
                }
            }

            // Gán tham số LỌC TRẠNG THÁI (chỉ gán nếu có)
            if (trangThai != null && !trangThai.isEmpty()) {
                ps.setString(paramIndex++, trangThai);
            }

            // Gán tham số PHÂN TRANG
            ps.setInt(paramIndex++, pageRequest.getPageSize());
            ps.setInt(paramIndex++, pageRequest.getOffset());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToDonHang(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Lấy tổng số item: Gọi phiên bản countSearch với 3 tham số
        int totalItems = countSearch(pageRequest.getKeyword(), pageRequest.getTrangThai(), pageRequest.getLocNgay());
        return new Page<>(list, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public DonHang findById(int id) {
        String sql = "SELECT * FROM DonHang WHERE MaDon = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToDonHang(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public DonHang create(DonHang donHang) {
        String sql = "INSERT INTO DonHang (MaTK, TongTien) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, donHang.getMaTaiKhoan());
            ps.setBigDecimal(2, donHang.getTongTien());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        donHang.setMaDonHang(keys.getInt(1));
                    }
                }
                return donHang;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(DonHang donHang) {
        // Cập nhật đơn hàng (thường là cập nhật trạng thái)
        String sql = "UPDATE DonHang SET MaTK = ?, TongTien = ?, TrangThai = ? WHERE MaDon = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donHang.getMaTaiKhoan());
            ps.setBigDecimal(2, donHang.getTongTien());
            ps.setString(3, donHang.getTrangThai());
            ps.setInt(4, donHang.getMaDonHang());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(DonHang donHang) {
        // Đây là phương thức xóa vật lý theo yêu cầu của interface.
        String sql = "DELETE FROM DonHang WHERE MaDon = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donHang.getMaDonHang());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countSearch(String keyword, String trangThai, String locNgay) {
        int count = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(dh.MaDon) FROM DonHang dh ");
        sql.append("JOIN TaiKhoan tk ON dh.MaTK = tk.MaTK WHERE 1=1");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        // 1. Điều kiện tìm kiếm (Keyword)
        if (hasKeyword) {
            sql.append(" AND (dh.TrangThai LIKE ? OR tk.TenDangNhap LIKE ?");
            if (keyword.matches("\\d+")) {
                sql.append(" OR dh.MaDon = ?");
            }
            sql.append(")");
        }

        // 2. Lọc theo ngày
        if (locNgay != null && !locNgay.isEmpty()) {
            switch (locNgay) {
                case "today":
                    sql.append(" AND DATE(dh.NgayDat) = CURDATE()");
                    break;
                case "yesterday":
                    sql.append(" AND DATE(dh.NgayDat) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)");
                    break;
                case "week":
                    sql.append(" AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
                    break;
                case "month":
                    sql.append(" AND dh.NgayDat >= DATE_SUB(NOW(), INTERVAL 30 DAY)");
                    break;
            }
        }

        // 3. Lọc theo trạng thái
        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND dh.TrangThai = ?");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TrangThai
                ps.setString(paramIndex++, kw); // TenDangNhap
                if (keyword.matches("\\d+")) {
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaDon
                }
            }

            // Gán tham số LỌC TRẠNG THÁI
            if (trangThai != null && !trangThai.isEmpty()) {
                ps.setString(paramIndex++, trangThai);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    @Override
    public int countSearch(String keyword) {
        return countSearch(keyword, null, null);
    }
}