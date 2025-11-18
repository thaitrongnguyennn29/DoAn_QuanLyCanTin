package RepositoryImp;

import Model.Quay;
import Repository.Repository;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuayRepositoryImp implements Repository<Quay> {

    private DataSource dataSource;

    public QuayRepositoryImp() {
        try {
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/quanly_cantin");
            this.dataSource = ds;
        } catch (Exception e) {
            throw new RuntimeException("Cannot initialize DataSource", e);
        }
    }

    @Override
    public List<Quay> findAll() {
        List<Quay> list = new ArrayList<>();
        String sql = "SELECT * FROM Quay";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Quay q = new Quay(
                        rs.getInt("maQuay"),
                        rs.getString("tenQuay"),
                        rs.getString("moTa"),
                        rs.getInt("maTK")
                );
                list.add(q);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    @Override
    public Quay findById(int id) {
        String sql = "SELECT * FROM Quay WHERE MaQuay = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Quay(
                            rs.getInt("maQuay"),
                            rs.getString("tenQuay"),
                            rs.getString("moTa"),
                            rs.getInt("maTK")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
