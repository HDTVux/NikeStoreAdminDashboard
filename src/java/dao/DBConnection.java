package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Đã sửa lại thông tin hosting, giữ nguyên cấu trúc
    private static final String URL = "jdbc:mysql://202.92.5.23:3306/ylvqitishosting_nike_store";
    private static final String USER = "ylvqitishosting_hdtvux";
    private static final String PASSWORD = "Vucoi123!"; 

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy driver MySQL", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}