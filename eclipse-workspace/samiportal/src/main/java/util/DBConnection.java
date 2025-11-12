package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://localhost:3306/job_portal?useSSL=false&serverTimezone=UTC";

    private static final String USER = "samuel";
    private static final String PASS = "1997";   // if you set password, put it here

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");   // loads MySQL driver
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found!");
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
