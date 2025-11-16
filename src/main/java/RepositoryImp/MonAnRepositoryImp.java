package RepositoryImp;

import Model.MonAn;
import Repository.MonAnRepository;
import Util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MonAnRepositoryImp extends DBConnect implements MonAnRepository {
    public MonAnRepositoryImp() {
        super();
    }
    @Override
    public List<MonAn> findAll() {
        List<MonAn> monAns = new ArrayList<>();
        String sql = "SELECT * FROM MonAn";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                MonAn book = new MonAn(
                        rs.getInt("MaMon"),
                        rs.getString("TenMon"),
                        rs.getDouble("gia"),
                        rs.getString("MoTa"),
                        rs.getString("HinhAnh"),
                        rs.getInt("MaQuay")
                );
                monAns.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monAns;
    }

    @Override
    public MonAn findById(int id) {
        String sql = "SELECT * FROM MonAn WHERE MaMon = ?";
        try (Connection conn = getConnection();
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
}
