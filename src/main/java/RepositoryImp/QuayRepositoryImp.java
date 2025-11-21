package RepositoryImp;

import Model.Page;
import Model.PageRequest;
import Model.Quay;
import Repository.QuayRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuayRepositoryImp extends DBConnect implements QuayRepository {
    public QuayRepositoryImp() {
        super();
    }
    private Quay mapRowToQuay(ResultSet rs) throws SQLException {
        return new Quay(
                rs.getInt("MaQuay"),
                rs.getString("TenQuay"),
                rs.getString("MoTa"),
                rs.getInt("MaTK")
        );
    }
    @Override
    public List<Quay> findAll() {
        List<Quay> quays = new ArrayList<>();
        String sql = "SELECT * FROM Quay";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                quays.add(mapRowToQuay(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quays;
    }

    @Override
    public Page<Quay> findAll(PageRequest pageRequest) {
        List<Quay> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Quay WHERE 1=1");

        String keyword = pageRequest.getKeyword();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        // 1. Điều kiện tìm kiếm (WHERE clause)
        if (hasKeyword) {
            // Tìm kiếm theo TenQuay, MoTa
            sql.append(" AND (TenQuay LIKE ? OR MoTa LIKE ?");

            // Tìm kiếm theo MaQuay nếu keyword là số
            if (keyword.matches("\\d+")) {
                sql.append(" OR MaQuay = ?");
            }
            sql.append(")");
        }

        // 2. Sắp xếp
        String sortField = pageRequest.getSortField() != null ? pageRequest.getSortField() : "MaQuay";
        // Ánh xạ tên trường JSP sang tên cột SQL
        String sqlSortField;
        if (sortField.equalsIgnoreCase("tenQuay")) {
            sqlSortField = "TenQuay";
        } else {
            sqlSortField = "MaQuay"; // Mặc định hoặc khi sort field không khớp
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
                ps.setString(paramIndex++, kw); // TenQuay
                ps.setString(paramIndex++, kw); // MoTa

                if (keyword.matches("\\d+")) {
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaQuay
                }
            }

            // Gán tham số PHÂN TRANG
            ps.setInt(paramIndex++, pageRequest.getPageSize()); // LIMIT
            ps.setInt(paramIndex++, pageRequest.getOffset());   // OFFSET

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToQuay(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Lấy tổng số item (cần dùng countSearch)
        int totalItems = countSearch(pageRequest.getKeyword());
        return new Page<>(list, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public Quay findById(int id) {
        String sql = "SELECT * FROM Quay WHERE MaQuay = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuay(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Quay create(Quay quay) {
        String sql = "INSERT INTO Quay (TenQuay, MoTa, MaTK) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, quay.getTenQuay());
            ps.setString(2, quay.getMoTa());
            ps.setInt(3, quay.getMaTaiKhoan());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        quay.setMaQuay(keys.getInt(1));
                    }
                }
                return quay;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(Quay quay) {
        String sql = "UPDATE Quay SET TenQuay = ?, MoTa = ?, MaTK = ? WHERE MaQuay = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quay.getTenQuay());
            ps.setString(2, quay.getMoTa());
            ps.setInt(3, quay.getMaTaiKhoan());
            ps.setInt(4, quay.getMaQuay());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(Quay quay) {
        String sql = "DELETE FROM Quay WHERE MaQuay = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quay.getMaQuay());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countSearch(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Quay WHERE 1=1");
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        int count = 0;

        // 1. Xây dựng điều kiện tìm kiếm (WHERE clause)
        if (hasKeyword) {
            // Phải khớp với logic tìm kiếm trong findAll(PageRequest)
            sql.append(" AND (TenQuay LIKE ? OR MoTa LIKE ?");

            // Tìm kiếm theo MaQuay nếu keyword là số
            if (keyword.matches("\\d+")) {
                sql.append(" OR MaQuay = ?");
            }
            sql.append(")");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TenQuay
                ps.setString(paramIndex++, kw); // MoTa

                if (keyword.matches("\\d+")) {
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaQuay
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Lấy giá trị của COUNT(*)
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Trả về 0 nếu có lỗi
        }
        return count;
    }

    @Override
    public Quay findByMaTK(int maTK) {
        Quay quay = null;
        String sql = "SELECT * FROM Quay WHERE MaTK = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maTK);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                quay = new Quay();
                quay.setMaQuay(rs.getInt("MaQuay"));
                quay.setTenQuay(rs.getString("TenQuay"));
                quay.setMoTa(rs.getString("MoTa"));
                quay.setMaTaiKhoan(rs.getInt("MaTK"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return quay; // Trả về null nếu không tìm thấy
    }
}
