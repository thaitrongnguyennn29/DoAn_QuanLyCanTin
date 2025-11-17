package RepositoryImp;

import Model.Page;
import Model.PageRequest;
import Model.TaiKhoan;
import Repository.TaiKhoanRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaiKhoanRepositoryImp extends DBConnect implements TaiKhoanRepository {
    public TaiKhoanRepositoryImp() {
        super();
    }
    private TaiKhoan mapRowToTaiKhoan(ResultSet rs) throws SQLException {
        return new TaiKhoan(
                rs.getInt("MaTK"),
                rs.getString("TenDangNhap"),
                rs.getString("MatKhau"),
                rs.getString("VaiTro")
        );
    }
    @Override
    public List findAll() {
        List<TaiKhoan> taiKhoans = new ArrayList<>();
        String sql = "SELECT * FROM TaiKhoan";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                taiKhoans.add(mapRowToTaiKhoan(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return taiKhoans;
    }

    @Override
    public Page findAll(PageRequest pageRequest) {
        List<TaiKhoan> list = new ArrayList<>();

        // 1. Xây dựng SQL với điều kiện tìm kiếm
        StringBuilder sql = new StringBuilder("SELECT * FROM TaiKhoan WHERE 1=1");

        String keyword = pageRequest.getKeyword();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        if (hasKeyword) {
            // Tìm kiếm theo TenDangNhap (tương tự TenMon/MoTa)
            sql.append(" AND (TenDangNhap LIKE ? OR VaiTro LIKE ?");

            // Tìm kiếm theo MaTK nếu keyword là số (tương tự MaMon)
            if (keyword.matches("\\d+")) {
                sql.append(" OR MaTK = ?");
            }
            sql.append(")");
        }

        // 2. Sắp xếp
        String sortField = pageRequest.getSortField() != null ? pageRequest.getSortField() : "MaTK";

        // Điều chỉnh tên cột SQL từ PageRequest.getSortField()
        String sqlSortField;
        if (sortField.equalsIgnoreCase("tenDangNhap")) {
            sqlSortField = "TenDangNhap";
        } else if (sortField.equalsIgnoreCase("vaiTro")) {
            sqlSortField = "VaiTro";
        } else {
            sqlSortField = "MaTK"; // Mặc định
        }

        String sortOrder = pageRequest.getSortOrder().toUpperCase();
        sql.append(" ORDER BY ").append(sqlSortField).append(" ").append(sortOrder);

        // 3. Phân trang
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TenDangNhap
                ps.setString(paramIndex++, kw); // VaiTro

                if (keyword.matches("\\d+")) {
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaTK
                }
            }

            // Gán tham số PHÂN TRANG
            ps.setInt(paramIndex++, pageRequest.getPageSize()); // LIMIT
            ps.setInt(paramIndex++, pageRequest.getOffset());   // OFFSET

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToTaiKhoan(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        int totalItems = countSearch(pageRequest.getKeyword());
        return new Page<>(list, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public TaiKhoan findById(int id) {
        String sql = "SELECT * FROM TaiKhoan WHERE MaTK = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToTaiKhoan(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public TaiKhoan create(TaiKhoan taiKhoan) {
        String sql = "INSERT INTO TaiKhoan (TenDangNhap, MatKhau, VaiTro) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, taiKhoan.getTenDangNhap());
            ps.setString(2, taiKhoan.getMatKhau());
            ps.setString(3, taiKhoan.getVaiTro());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        taiKhoan.setMaTaiKhoan(keys.getInt(1));
                    }
                }
                return taiKhoan;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(TaiKhoan taiKhoan) {
        // Lưu ý: Mật khẩu (MatKhau) nên được hash trước khi update
        String sql = "UPDATE TaiKhoan SET TenDangNhap = ?, MatKhau = ?, VaiTro = ? WHERE MaTK = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, taiKhoan.getTenDangNhap());
            ps.setString(2, taiKhoan.getMatKhau());
            ps.setString(3, taiKhoan.getVaiTro());
            ps.setInt(4, taiKhoan.getMaTaiKhoan());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(TaiKhoan taiKhoan) {
        String sql = "DELETE FROM TaiKhoan WHERE MaTK = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taiKhoan.getMaTaiKhoan());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countSearch(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM TaiKhoan WHERE 1=1");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (TenDangNhap LIKE ? OR VaiTro LIKE ?");

            if (keyword.matches("\\d+")) {
                sql.append(" OR MaTK = ?");
            }
            sql.append(")");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (hasKeyword) {
                String kw = "%" + keyword + "%";
                int paramIndex = 1;

                ps.setString(paramIndex++, kw); // TenDangNhap
                ps.setString(paramIndex++, kw); // VaiTro

                if (keyword.matches("\\d+")) {
                    // Chỉ gán nếu là số nguyên
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaTK
                }
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
