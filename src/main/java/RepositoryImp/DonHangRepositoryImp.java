package RepositoryImp;

import Model.DonHang;
import Model.GioHang;
import Model.Page;
import Model.PageRequest;
import Repository.DonHangRepository;

import java.math.BigDecimal;
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

    @Override
    public boolean createOrderbyCart(DonHang donHang, List<GioHang> listGioHang) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        boolean result = false;

        try {
            conn = getConnection();
            if (conn == null) return false;

            // 1. Bắt đầu Transaction
            conn.setAutoCommit(false);

            // 2. Insert bảng DonHang
            String sqlOrder = "INSERT INTO DonHang (MaTK, TongTien, TrangThai, NgayDat) VALUES (?, ?, ?, NOW())";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, donHang.getMaTaiKhoan());
            psOrder.setBigDecimal(2, donHang.getTongTien());
            psOrder.setString(3, donHang.getTrangThai());

            if (psOrder.executeUpdate() == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            // 3. Lấy MaDon vừa tạo
            int maDonHang = 0;
            try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    maDonHang = generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }

            // 4. Insert bảng ChiTietDonHang (Dùng Batch)
            String sqlDetail = "INSERT INTO ChiTietDonHang (MaDon, MaMon, SoLuong, DonGia, TrangThai) VALUES (?, ?, ?, ?, ?)";
            psDetail = conn.prepareStatement(sqlDetail);

            for (GioHang item : listGioHang) {
                psDetail.setInt(1, maDonHang);
                psDetail.setInt(2, item.getMonAn().getMaMonAn());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setBigDecimal(4, BigDecimal.valueOf(item.getMonAn().getGia()));
                psDetail.setString(5, "Mới đặt");
                psDetail.addBatch();
            }

            psDetail.executeBatch();

            // 5. Commit Transaction
            conn.commit();
            result = true;

        } catch (SQLException e) {
            e.printStackTrace();
            // Rollback nếu có lỗi
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            // Đóng kết nối và trả về chế độ auto-commit mặc định
            try {
                if (psOrder != null) psOrder.close();
                if (psDetail != null) psDetail.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    closeConnection(conn);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    @Override
    public List<DonHang> findByUserId(int userId) {
        List<DonHang> list = new ArrayList<>();
        // Lấy đơn hàng của user, đơn mới nhất lên đầu
        String sql = "SELECT * FROM DonHang WHERE MaTK = ? ORDER BY NgayDat DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToDonHang(rs)); // Hàm mapRowToDonHang bạn đã có sẵn
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Page<DonHang> findDonHangByMaQuay(int maQuay, PageRequest pageRequest) {
        List<DonHang> list = new ArrayList<>();
        int limit = pageRequest.getPageSize();
        int offset = (pageRequest.getPage() - 1) * limit;

        // SQL: Lấy đơn hàng có chứa ít nhất 1 món của Quầy này
        // Dùng DISTINCT vì 1 đơn có thể có nhiều món của cùng 1 quầy -> tránh trùng đơn
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT dh.MaDon, dh.MaTK, dh.NgayDat, dh.TongTien, dh.TrangThai " +
                        "FROM DonHang dh " +
                        "JOIN ChiTietDonHang ct ON dh.MaDon = ct.MaDon " +
                        "JOIN MonAn m ON ct.MaMon = m.MaMon " +
                        "WHERE m.MaQuay = ? "
        );

        // Logic tìm kiếm/lọc
        if (pageRequest.getTrangThai() != null && !pageRequest.getTrangThai().isEmpty()) {
            sql.append(" AND dh.TrangThai = ? ");
        }

        // Tìm kiếm theo Mã đơn hoặc (cần join thêm TaiKhoan nếu muốn tìm tên khách)
        // Ở đây tìm theo Mã Đơn cho đơn giản và nhanh
        if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
            sql.append(" AND CAST(dh.MaDon AS CHAR) LIKE ? ");
        }

        sql.append(" ORDER BY dh.NgayDat DESC LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setInt(i++, maQuay);

            if (pageRequest.getTrangThai() != null && !pageRequest.getTrangThai().isEmpty()) {
                ps.setString(i++, pageRequest.getTrangThai());
            }
            if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
                ps.setString(i++, "%" + pageRequest.getKeyword() + "%");
            }

            ps.setInt(i++, limit);
            ps.setInt(i++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tái sử dụng hàm mapRow hoặc set thủ công (Lưu ý tên cột trong DB của bạn)
                DonHang dh = new DonHang();
                dh.setMaDonHang(rs.getInt("MaDon"));
                dh.setMaTaiKhoan(rs.getInt("MaTK"));

                Timestamp ts = rs.getTimestamp("NgayDat");
                if(ts != null) dh.setNgayDat(ts.toLocalDateTime());

                dh.setTongTien(rs.getBigDecimal("TongTien"));
                dh.setTrangThai(rs.getString("TrangThai"));
                list.add(dh);
            }
        } catch (Exception e) { e.printStackTrace(); }

        int total = countDonHangByMaQuay(maQuay, pageRequest);
        return new Page<>(list, pageRequest.getPage(), limit, total);
    }

    @Override
    public int countDonHangByMaQuay(int maQuay, PageRequest pageRequest) {
        int count = 0;
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT dh.MaDon) " +
                        "FROM DonHang dh " +
                        "JOIN ChiTietDonHang ct ON dh.MaDon = ct.MaDon " +
                        "JOIN MonAn m ON ct.MaMon = m.MaMon " +
                        "WHERE m.MaQuay = ? "
        );

        if (pageRequest.getTrangThai() != null && !pageRequest.getTrangThai().isEmpty()) {
            sql.append(" AND dh.TrangThai = ? ");
        }
        if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
            sql.append(" AND CAST(dh.MaDon AS CHAR) LIKE ? ");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setInt(i++, maQuay);

            if (pageRequest.getTrangThai() != null && !pageRequest.getTrangThai().isEmpty()) {
                ps.setString(i++, pageRequest.getTrangThai());
            }
            if (pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
                ps.setString(i++, "%" + pageRequest.getKeyword() + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
}