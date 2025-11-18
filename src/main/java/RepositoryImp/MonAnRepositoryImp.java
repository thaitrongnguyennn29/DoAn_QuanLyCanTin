package RepositoryImp;

import Model.MonAn;
import Model.Page;
import Model.PageRequest;
import Repository.MonAnRepository;
import com.example.doan_quanlycantin.DBConnect;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MonAnRepositoryImp extends DBConnect implements MonAnRepository {

    private DataSource dataSource;

    public MonAnRepositoryImp() {
        super();
        try {
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/quanly_cantin");
            this.dataSource = ds;
        } catch (Exception e) {
            throw new RuntimeException("Cannot initialize DataSource", e);
        }
    }

    @Override
    public List<MonAn> findAll() {
        List<MonAn> list = new ArrayList<>();
        String sql = "SELECT * FROM MonAn";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MonAn mon = new MonAn(
                        rs.getInt("MaMon"),
                        rs.getString("TenMon"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getString("HinhAnh"),
                        rs.getInt("MaQuay")
                );
                list.add(mon);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<MonAn> findByQuayId(int maQuay) {
        List<MonAn> list = new ArrayList<>();
        String sql = "SELECT * FROM MonAn WHERE MaQuay = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maQuay);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MonAn mon = new MonAn(
                            rs.getInt("MaMon"),
                            rs.getString("TenMon"),
                            rs.getDouble("Gia"),
                            rs.getString("MoTa"),
                            rs.getString("HinhAnh"),
                            rs.getInt("MaQuay")
                    );
                    list.add(mon);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Page<MonAn> findAll(PageRequest pageRequest) {
        List<MonAn> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM MonAn WHERE 1=1");

        String keyword = pageRequest.getKeyword();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (TenMon LIKE ? OR MoTa LIKE ? OR CAST(Gia AS CHAR) LIKE ?");

            if (keyword.matches("\\d+")) {
                sql.append(" OR MaMon = ?");
            }
            sql.append(")");
        }
        if ("gia".equals(pageRequest.getSortField())) {
            sql.append(" ORDER BY gia ").append(pageRequest.getSortOrder().toUpperCase());
        } else if ("tenMonAn".equals(pageRequest.getSortField())) {
            sql.append(" ORDER BY TenMon ").append(pageRequest.getSortOrder().toUpperCase());
        } else {
            // Mặc định: gia ASC
            sql.append(" ORDER BY gia ASC");
        }

        // 3. PHÂN TRANG
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TenMon
                ps.setString(paramIndex++, kw); // MoTa
                ps.setString(paramIndex++, kw); // Gia (CAST AS CHAR)

                if (keyword.matches("\\d+")) {
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaMon
                }
            }
            ps.setInt(paramIndex++, pageRequest.getPageSize()); // LIMIT
            ps.setInt(paramIndex++, pageRequest.getOffset());   // OFFSET

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new MonAn(
                        rs.getInt("MaMon"),
                        rs.getString("TenMon"),
                        rs.getDouble("gia"),
                        rs.getString("MoTa"),
                        rs.getString("HinhAnh"),
                        rs.getInt("MaQuay")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Hàm countSearch đã được đồng bộ hóa và hoạt động đúng
        int totalItems = countSearch(pageRequest.getKeyword());
        return new Page<>(list, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public MonAn findById(int id) {
        String sql = "SELECT * FROM MonAn WHERE MaMon = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new MonAn(
                            rs.getInt("MaMon"),
                            rs.getString("TenMon"),
                            rs.getDouble("Gia"),
                            rs.getString("MoTa"),
                            rs.getString("HinhAnh"),
                            rs.getInt("MaQuay")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public MonAn create(MonAn monAn) {
        String sql = "INSERT INTO MonAn (TenMon, Gia, MoTa, HinhAnh, MaQuay) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, monAn.getTenMonAn());
            ps.setDouble(2, monAn.getGia());
            ps.setString(3, monAn.getMoTa());
            ps.setString(4, monAn.getHinhAnh());
            ps.setInt(5, monAn.getMaQuay());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        monAn.setMaMonAn(keys.getInt(1));
                    }
                }
                return monAn;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(MonAn monAn) {
        String sql = "UPDATE MonAn SET TenMon = ?, Gia = ?, MoTa = ?, HinhAnh = ?, MaQuay = ? WHERE MaMon = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, monAn.getTenMonAn());
            ps.setDouble(2, monAn.getGia());
            ps.setString(3, monAn.getMoTa());
            ps.setString(4, monAn.getHinhAnh());
            ps.setInt(5, monAn.getMaQuay());
            ps.setInt(6, monAn.getMaMonAn());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(MonAn monAn) {
        String sql = "DELETE FROM MonAn WHERE MaMon = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, monAn.getMaMonAn());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countSearch(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM MonAn WHERE 1=1");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (TenMon LIKE ? OR MoTa LIKE ? OR CAST(Gia AS CHAR) LIKE ?)");

            // Bạn có thể tùy chọn thêm tìm kiếm theo MaMon nếu keyword là số nguyên
            if (keyword.matches("\\d+")) {
                sql.append(" OR MaMon = ?");
            }
            sql.append(")");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (hasKeyword) {
                String kw = "%" + keyword + "%";
                int paramIndex = 1;

                ps.setString(paramIndex++, kw); // TenMon
                ps.setString(paramIndex++, kw); // MoTa
                ps.setString(paramIndex++, kw); // Gia (đã ép kiểu sang chuỗi)

                if (keyword.matches("\\d+")) {
                    // Chỉ gán nếu là số nguyên
                    ps.setInt(paramIndex++, Integer.parseInt(keyword)); // MaMon
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
