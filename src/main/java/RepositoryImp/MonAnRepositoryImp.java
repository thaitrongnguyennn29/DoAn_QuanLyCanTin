package RepositoryImp;
import Model.MonAn;
import Repository.MonAnRepository;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MonAnRepositoryImp implements MonAnRepository {

    private DataSource dataSource;

    public MonAnRepositoryImp() {
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
}
