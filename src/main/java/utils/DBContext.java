package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    private static final String URL =
            "jdbc:sqlserver://localhost:1433;databaseName=GreenFarm;encrypt=true;trustServerCertificate=true";

    private static final String USER = "sa";
    private static final String PASSWORD = "sa";

    public Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connected to GreenFarm successfully!");
            return conn;
        } catch (Exception e) {
            System.err.println("=== DB CONNECTION FAILED ===");
            System.err.println("URL: " + URL);
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}