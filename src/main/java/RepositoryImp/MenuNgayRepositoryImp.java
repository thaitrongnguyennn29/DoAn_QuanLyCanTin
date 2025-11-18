package RepositoryImp;

import DTO.MenuNgayDTO;
import Model.MenuNgay;
import Model.Page;
import Model.PageRequest;
import Repository.MenuNgayRepository;

import java.sql.*;
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

        menu.setMaMenuNgay(rs.getInt("MaMenu"));
        menu.setMaQuay(rs.getInt("MaQuay"));
        menu.setMaMonAn(rs.getInt("MaMon"));
        menu.setTrangThai(rs.getString("TrangThai"));

        Date ngaySql = rs.getDate("Ngay");
        if (ngaySql != null) {
            menu.setNgay(ngaySql.toLocalDate());
        }

        return menu;
    }
    private MenuNgayDTO mapRowToMenuNgayDTO(ResultSet rs) throws SQLException {
        MenuNgayDTO menu = new MenuNgayDTO();

        // Thuộc tính từ MenuNgay
        menu.setMaMenu(rs.getInt("MaMenu"));
        Date ngaySql = rs.getDate("Ngay");
        if (ngaySql != null) {
            menu.setNgay(ngaySql.toLocalDate());
        }
        menu.setMaQuay(rs.getInt("MaQuay"));
        menu.setMaMon(rs.getInt("MaMon"));
        menu.setTrangThai(rs.getString("TrangThai"));

        menu.setTenMon(rs.getString("TenMon"));
        menu.setHinhAnh(rs.getString("HinhAnh"));
        menu.setTenQuay(rs.getString("TenQuay"));
        menu.setGiaMon(rs.getBigDecimal("Gia"));

        return menu;
    }
    private String getBaseSelectDTOQuery(boolean isCount) {
        StringBuilder sql = new StringBuilder();
        if (isCount) {
            sql.append("SELECT COUNT(mn.MaMenu) ");
        } else {
            sql.append("SELECT mn.*, ma.TenMon, ma.HinhAnh, ma.Gia, q.TenQuay ");
        }

        sql.append("FROM MenuNgay mn ");
        sql.append("JOIN MonAn ma ON mn.MaMon = ma.MaMon ");
        sql.append("JOIN Quay q ON mn.MaQuay = q.MaQuay ");

        return sql.toString();
    }
    @Override
    public List<MenuNgay> findAll() {
        List<MenuNgay> menuList = new ArrayList<>();
        String sql = "SELECT * FROM MenuNgay ORDER BY Ngay DESC, MaQuay ASC";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                menuList.add(mapRowToMenuNgay(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menuList;
    }

    @Override
    public Page<MenuNgay> findAll(PageRequest pageRequest) {
        List<MenuNgay> list = new ArrayList<>();

        // Cần JOIN với MonAn và Quay để tìm kiếm theo tên món/tên quầy
        StringBuilder sql = new StringBuilder("SELECT mn.* FROM MenuNgay mn JOIN MonAn ma ON mn.MaMon = ma.MaMon JOIN Quay q ON mn.MaQuay = q.MaQuay WHERE 1=1");

        // Lấy các tham số lọc từ PageRequest
        String keyword = pageRequest.getKeyword();
        String trangThai = pageRequest.getTrangThai(); // Dùng trường trangThai cho trạng thái MenuNgay
        String filterQuay = pageRequest.getLocNgay(); // Dùng trường locNgay cho lọc MaQuay (hoặc bạn có thể thêm trường MaQuay vào PageRequest)
        String filterNgay = pageRequest.getSortOrder(); // Dùng trường sortOrder cho lọc Ngày (Hoặc bạn có thể thêm trường Ngay vào PageRequest)

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        // 1. Điều kiện tìm kiếm theo keyword (Tên món, Tên quầy)
        if (hasKeyword) {
            sql.append(" AND (ma.TenMon LIKE ? OR q.TenQuay LIKE ?)");
        }

        // 2. Lọc theo Quầy
        if (filterQuay != null && !filterQuay.isEmpty() && filterQuay.matches("\\d+")) {
            sql.append(" AND mn.MaQuay = ?");
        }

        // 3. Lọc theo Ngày
        if (filterNgay != null && !filterNgay.isEmpty()) {
            sql.append(" AND DATE(mn.Ngay) = ?");
        }

        // 4. Lọc theo trạng thái
        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND mn.TrangThai = ?");
        }

        // 5. Sắp xếp (Mặc định là theo Ngày và MaQuay)
        String sortField = pageRequest.getSortField() != null ? pageRequest.getSortField() : "Ngay";
        String sqlSortField;

        if (sortField.equalsIgnoreCase("ngay")) {
            sqlSortField = "mn.Ngay";
        } else if (sortField.equalsIgnoreCase("mon")) {
            sqlSortField = "ma.TenMon";
        } else {
            sqlSortField = "mn.MaMenu";
        }

        String sortOrder = pageRequest.getSortOrder().toUpperCase();
        sql.append(" ORDER BY ").append(sqlSortField).append(" ").append(sortOrder);

        // 6. Phân trang
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TenMon (cho LIKE)
                ps.setString(paramIndex++, kw); // TenQuay (cho LIKE)
            }

            // Gán tham số LỌC QUẦY
            if (filterQuay != null && !filterQuay.isEmpty() && filterQuay.matches("\\d+")) {
                ps.setInt(paramIndex++, Integer.parseInt(filterQuay));
            }

            // Gán tham số LỌC NGÀY
            if (filterNgay != null && !filterNgay.isEmpty()) {
                ps.setString(paramIndex++, filterNgay);
            }

            // Gán tham số LỌC TRẠNG THÁI
            if (trangThai != null && !trangThai.isEmpty()) {
                ps.setString(paramIndex++, trangThai);
            }

            // Gán tham số PHÂN TRANG
            ps.setInt(paramIndex++, pageRequest.getPageSize());
            ps.setInt(paramIndex++, pageRequest.getOffset());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToMenuNgay(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Lấy tổng số item
        int totalItems = countSearch(keyword, filterQuay, filterNgay, trangThai);
        return new Page<>(list, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

    @Override
    public MenuNgay findById(int id) {
        String sql = "SELECT * FROM MenuNgay WHERE MaMenu = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToMenuNgay(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public MenuNgay create(MenuNgay menuNgay) {
        String sql = "INSERT INTO MenuNgay (Ngay, MaQuay, MaMon, TrangThai) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, menuNgay.getNgay().format(SQL_DATE_FORMATTER));
            ps.setInt(2, menuNgay.getMaQuay());
            ps.setInt(3, menuNgay.getMaMonAn());
            ps.setString(4, menuNgay.getTrangThai());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        menuNgay.setMaMenuNgay(keys.getInt(1));
                    }
                }
                return menuNgay;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(MenuNgay menuNgay) {
        // Cập nhật trạng thái
        String sql = "UPDATE MenuNgay SET Ngay = ?, MaQuay = ?, MaMon = ?, TrangThai = ? WHERE MaMenu = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, menuNgay.getNgay().format(SQL_DATE_FORMATTER));
            ps.setInt(2, menuNgay.getMaQuay());
            ps.setInt(3, menuNgay.getMaMonAn());
            ps.setString(4, menuNgay.getTrangThai());
            ps.setInt(5, menuNgay.getMaMenuNgay());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(MenuNgay menuNgay) {
        String sql = "DELETE FROM MenuNgay WHERE MaMenu = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, menuNgay.getMaMenuNgay());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countSearch(String keyword) {
        return countSearch(keyword, null, null, null);
    }

    public int countSearch(String keyword, String filterQuay, String filterNgay, String trangThai) {
        int count = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(mn.MaMenu) FROM MenuNgay mn JOIN MonAn ma ON mn.MaMon = ma.MaMon JOIN Quay q ON mn.MaQuay = q.MaQuay WHERE 1=1");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (ma.TenMon LIKE ? OR q.TenQuay LIKE ?)");
        }

        if (filterQuay != null && !filterQuay.isEmpty() && filterQuay.matches("\\d+")) {
            sql.append(" AND mn.MaQuay = ?");
        }

        if (filterNgay != null && !filterNgay.isEmpty()) {
            sql.append(" AND DATE(mn.Ngay) = ?");
        }

        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND mn.TrangThai = ?");
        }


        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TenMon
                ps.setString(paramIndex++, kw); // TenQuay
            }

            // Gán tham số LỌC QUẦY
            if (filterQuay != null && !filterQuay.isEmpty() && filterQuay.matches("\\d+")) {
                ps.setInt(paramIndex++, Integer.parseInt(filterQuay));
            }

            // Gán tham số LỌC NGÀY
            if (filterNgay != null && !filterNgay.isEmpty()) {
                ps.setString(paramIndex++, filterNgay);
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
    public List<MenuNgayDTO> findAllMenuNgayDTO() {
        List<MenuNgayDTO> menuList = new ArrayList<>();

        String sql = getBaseSelectDTOQuery(false) + " ORDER BY mn.Ngay DESC, mn.MaQuay ASC";

        try (Connection conn = getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                menuList.add(mapRowToMenuNgayDTO(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menuList;
    }

    @Override
    public Page<MenuNgayDTO> findAllMenuNgayDTO(PageRequest pageRequest) {
        List<MenuNgayDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(getBaseSelectDTOQuery(false));
        sql.append(" WHERE 1=1"); // Bắt đầu các điều kiện WHERE

        // Lấy các tham số lọc từ PageRequest
        String keyword = pageRequest.getKeyword();
        String trangThai = pageRequest.getTrangThai();
        // Giả sử:
        // - filterQuay dùng cho lọc MaQuay
        String filterQuay = pageRequest.getLocNgay();
        // - filterNgay dùng cho lọc Ngày
        String filterNgay = pageRequest.getSortOrder();

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        // 1. Điều kiện tìm kiếm theo keyword (TenMon, TenQuay)
        if (hasKeyword) {
            sql.append(" AND (ma.TenMon LIKE ? OR q.TenQuay LIKE ?)");
        }

        // 2. Lọc theo Quầy
        if (filterQuay != null && !filterQuay.isEmpty() && filterQuay.matches("\\d+")) {
            sql.append(" AND mn.MaQuay = ?");
        }

        // 3. Lọc theo Ngày
        if (filterNgay != null && !filterNgay.isEmpty()) {
            sql.append(" AND DATE(mn.Ngay) = ?");
        }

        // 4. Lọc theo trạng thái
        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND mn.TrangThai = ?");
        }

        // 5. Sắp xếp (Mặc định là theo Ngày và MaQuay)
        String sortField = pageRequest.getSortField() != null ? pageRequest.getSortField() : "Ngay";
        String sqlSortField;

        if (sortField.equalsIgnoreCase("ngay")) {
            sqlSortField = "mn.Ngay";
        } else if (sortField.equalsIgnoreCase("mon")) {
            sqlSortField = "ma.TenMon";
        } else {
            sqlSortField = "mn.MaMenu"; // Hoặc một trường mặc định khác
        }

        // Giả sử sortOrder trong PageRequest có thể là "ASC" hoặc "DESC"
        String sortOrder = pageRequest.getSortOrder() != null && (pageRequest.getSortOrder().equalsIgnoreCase("ASC") || pageRequest.getSortOrder().equalsIgnoreCase("DESC"))
                ? pageRequest.getSortOrder().toUpperCase() : "DESC";

        sql.append(" ORDER BY ").append(sqlSortField).append(" ").append(sortOrder);
        // Thêm sắp xếp phụ để đảm bảo thứ tự ổn định
        if (!sqlSortField.equals("mn.MaMenu")) {
            sql.append(", mn.MaMenu ASC");
        }


        // 6. Phân trang
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            String kw = "%" + keyword + "%";

            // Gán tham số TÌM KIẾM
            if (hasKeyword) {
                ps.setString(paramIndex++, kw); // TenMon (cho LIKE)
                ps.setString(paramIndex++, kw); // TenQuay (cho LIKE)
            }

            // Gán tham số LỌC QUẦY
            if (filterQuay != null && !filterQuay.isEmpty() && filterQuay.matches("\\d+")) {
                ps.setInt(paramIndex++, Integer.parseInt(filterQuay));
            }

            // Gán tham số LỌC NGÀY
            if (filterNgay != null && !filterNgay.isEmpty()) {
                // Đảm bảo định dạng ngày phù hợp với cơ sở dữ liệu (ví dụ: "yyyy-MM-dd")
                ps.setString(paramIndex++, filterNgay);
            }

            // Gán tham số LỌC TRẠNG THÁI
            if (trangThai != null && !trangThai.isEmpty()) {
                ps.setString(paramIndex++, trangThai);
            }

            // Gán tham số PHÂN TRANG
            ps.setInt(paramIndex++, pageRequest.getPageSize());
            ps.setInt(paramIndex++, pageRequest.getOffset());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToMenuNgayDTO(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        int totalItems = countSearch(keyword, filterQuay, filterNgay, trangThai);

        return new Page<>(list, pageRequest.getPage(), pageRequest.getPageSize(), totalItems);
    }

}
