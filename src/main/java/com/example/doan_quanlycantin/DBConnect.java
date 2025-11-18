package com.example.doan_quanlycantin;

import Util.DataSourceUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBConnect {
    public static Connection getConnection() {
        try {
            return DataSourceUtil.getDataSource().getConnection();
        } catch (Exception e) {
            throw new RuntimeException("Không thể kết nối database!", e);
        }
    }

    // Hàm đóng connection an toàn
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
}
