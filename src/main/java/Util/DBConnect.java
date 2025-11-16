package Util;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public abstract class  DBConnect {
    private final DataSource dataSource;

    public DBConnect() {
        this.dataSource = DataSourceUtil.getDataSource();

        if (this.dataSource == null) {
            System.err.println("DataSource chưa được khởi tạo!");
        }
    }
    protected Connection getConnection() throws SQLException {
        if (dataSource == null) {
            // Ném ngoại lệ nếu DataSource bị null
            throw new SQLException("DataSource chưa được khởi tạo. Lỗi cấu hình JNDI.");
        }
        // Trả về Connection từ Pool
        return dataSource.getConnection();
    }
    protected void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close(); // Trả kết nối về Pool
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đóng Connection: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
