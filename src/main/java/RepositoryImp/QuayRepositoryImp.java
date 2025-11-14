package RepositoryImp;

import Model.MonAn;
import Model.Quay;
import Repository.QuayRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuayRepositoryImp extends DBConnect implements QuayRepository {
    @Override
    public List<Quay> findAll() {
        List<Quay> quays = new ArrayList<>();
        String sql = "SELECT * FROM Quay";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Quay q = new Quay(
                        rs.getInt("MaQuay"),
                        rs.getString("TenQuay"),
                        rs.getString("MoTa"),
                        rs.getInt("MaTK")
                );
                quays.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quays;
    }

    @Override
    public Quay findById(int id) {
        String sql = "SELECT * FROM Quay WHERE MaQuay = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Quay(
                            rs.getInt("MaQuay"),
                            rs.getString("TenQuay"),
                            rs.getString("MoTa"),
                            rs.getInt("MaTK")
                    );
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
}
