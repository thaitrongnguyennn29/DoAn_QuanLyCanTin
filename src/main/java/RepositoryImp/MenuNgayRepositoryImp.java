package RepositoryImp;

import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.MonAn;
import Model.Page;
import Model.PageRequest;
import Repository.MenuNgayRepository;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.time.format.DateTimeFormatter;

public class MenuNgayRepositoryImp extends DBConnect implements MenuNgayRepository {

    public MenuNgayRepositoryImp() {
        super();
    }

    private static final DateTimeFormatter SQL_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private MenuNgay mapRowToMenuNgay(ResultSet rs) throws SQLException {
        MenuNgay menu = new MenuNgay();
        menu.setMaMenu(rs.getInt("MaMenu"));
        menu.setMaQuay(rs.getInt("MaQuay"));
        menu.setMaMon(rs.getInt("MaMon"));

        Date ngaySql = rs.getDate("Ngay");
        if (ngaySql != null) {
            menu.setNgay(ngaySql.toLocalDate());
        }
        return menu;
    }
    private Model.MonAn mapRowToMonAn(ResultSet rs) throws SQLException {
        return new Model.MonAn(
                rs.getInt("MaMon"),      // Tên cột trong Database
                rs.getString("TenMon"),  // Tên cột trong Database
                rs.getDouble("Gia"),     // Tên cột trong Database
                rs.getString("MoTa"),    // Tên cột trong Database
                rs.getString("HinhAnh"), // Tên cột trong Database
                rs.getInt("MaQuay")      // Tên cột trong Database
        );
    }

    @Override
    public boolean luuMenuNgay(LocalDate ngay, int maQuay, List<Integer> danhSachMaMon) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            List<Integer> currentList = getCurrentMaMonList(conn, ngay, maQuay);

            List<Integer> toInsert = new ArrayList<>(danhSachMaMon);
            toInsert.removeAll(currentList);

            List<Integer> toDelete = new ArrayList<>(currentList);
            toDelete.removeAll(danhSachMaMon);

            themMenuMoi(conn, ngay, maQuay, toInsert);
            xoaMonKhoiMenu(conn, ngay, maQuay, toDelete);

            conn.commit();
            return true;

        } catch (SQLException e) {
            rollbackQuietly(conn);
            e.printStackTrace();
            return false;
        } finally {
            closeQuietly(conn);
        }
    }

    private void themMenuMoi(Connection conn, LocalDate ngay, int maQuay, List<Integer> listMon) throws SQLException {
        if (listMon == null || listMon.isEmpty()) return;

        String sql = "INSERT INTO MenuNgay (Ngay, MaQuay, MaMon) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer maMon : listMon) {
                ps.setDate(1, Date.valueOf(ngay));
                ps.setInt(2, maQuay);
                ps.setInt(3, maMon);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void xoaMonKhoiMenu(Connection conn, LocalDate ngay, int maQuay, List<Integer> listMon) throws SQLException {
        if (listMon == null || listMon.isEmpty()) return;

        String sql = "DELETE FROM MenuNgay WHERE Ngay = ? AND MaQuay = ? AND MaMon = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer maMon : listMon) {
                ps.setDate(1, Date.valueOf(ngay));
                ps.setInt(2, maQuay);
                ps.setInt(3, maMon);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }


    @Override
    public boolean xoaMenuNgay(LocalDate ngay, int maQuay) {
        String sql = "DELETE FROM MenuNgay WHERE Ngay = ? AND MaQuay = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(ngay));
            ps.setInt(2, maQuay);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<MenuNgayDTO> layDanhSachMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay, int page, int size) {
        List<MenuNgayDTO> danhSach = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT Ngay, COUNT(MaMon) as SoMon FROM MenuNgay WHERE MaQuay = ? "
        );

        if (tuNgay != null) sql.append(" AND Ngay >= ?");
        if (denNgay != null) sql.append(" AND Ngay <= ?");

        sql.append(" GROUP BY Ngay ORDER BY Ngay DESC LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            ps.setInt(paramIndex++, maQuay);

            if (tuNgay != null) ps.setDate(paramIndex++, Date.valueOf(tuNgay));
            if (denNgay != null) ps.setDate(paramIndex++, Date.valueOf(denNgay));

            int offset = (page - 1) * size;
            ps.setInt(paramIndex++, size);
            ps.setInt(paramIndex++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuNgayDTO dto = new MenuNgayDTO();
                    Date ngaySql = rs.getDate("Ngay");
                    if (ngaySql != null) dto.setNgay(ngaySql.toLocalDate());
                    dto.setSoMon(rs.getInt("SoMon"));
                    danhSach.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    private List<Integer> getCurrentMaMonList(Connection conn, LocalDate ngay, int maQuay) throws SQLException {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT MaMon FROM MenuNgay WHERE Ngay = ? AND MaQuay = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(ngay));
            ps.setInt(2, maQuay);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("MaMon"));
                }
            }
        }
        return list;
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) try { conn.rollback(); } catch (SQLException e) {}
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) {}
    }

    @Override
    public Page<MenuNgay> findAll(PageRequest pageRequest) {
        List<MenuNgay> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT mn.* FROM MenuNgay mn JOIN MonAn ma ON mn.MaMon = ma.MaMon JOIN Quay q ON mn.MaQuay = q.MaQuay WHERE 1=1");

        return new Page<>(new ArrayList<>(), 1, 10, 0);
    }

    @Override
    public List<MenuNgay> findAll() { return new ArrayList<>(); }
    @Override
    public MenuNgay findById(int id) { return null; }
    @Override
    public MenuNgay create(MenuNgay menuNgay) { return null; }
    @Override
    public boolean update(MenuNgay menuNgay) { return false; }
    @Override
    public boolean delete(MenuNgay menuNgay) { return false; }
    @Override
    public int countSearch(String keyword) { return 0; }
    @Override
    public int demTongSoMenuNgay(int maQuay, LocalDate tuNgay, LocalDate denNgay) { return 0; }
    @Override
    public boolean kiemTraMenuTonTai(LocalDate ngay, int maQuay) { return false; }

    @Override
    public List<MonAn> getMonAnTheoNgay(LocalDate date) {
        List<Model.MonAn> list = new ArrayList<>();
        // JOIN bảng MonAn và MenuNgay để lấy chi tiết món của ngày hôm đó
        String sql = "SELECT m.* FROM MonAn m " +
                "JOIN MenuNgay mn ON m.MaMon = mn.MaMon " +
                "WHERE mn.Ngay = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(date));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMonAn(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<MonAn> getMonAnTheoNgayVaQuay(LocalDate date, int maQuay) {
        List<MonAn> list = new ArrayList<>();
        // Lọc thêm theo Mã Quầy
        String sql = "SELECT m.* FROM MonAn m " +
                "JOIN MenuNgay mn ON m.MaMon = mn.MaMon " +
                "WHERE mn.Ngay = ? AND mn.MaQuay = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(date));
            ps.setInt(2, maQuay);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMonAn(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}