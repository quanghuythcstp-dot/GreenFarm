package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import utils.DBContext;

public class CustomerDAO {

    private final DBContext dbContext = new DBContext();

    private Customer mapRow(ResultSet rs) throws SQLException {
    return new Customer(
            rs.getInt("customerId"),
            rs.getString("username"),
            rs.getString("password"),
            rs.getString("fullName"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("address"),
            rs.getString("role")
    );
}

    public Customer login(String username, String password) {
        String sql = "SELECT customerId, username, password, fullName, email, phone, address, role "
                   + "FROM Customer WHERE username = ? AND password = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("login error: " + e.getMessage());
        }
        return null;
    }

    public void register(Customer customer) {
        String sql = "INSERT INTO Customer (username, password, fullName, email, phone, address, role) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getUsername());
            ps.setString(2, customer.getPassword());
            ps.setString(3, customer.getFullName());
            ps.setString(4, customer.getEmail());
            ps.setString(5, customer.getPhone());
            ps.setString(6, customer.getAddress());
            ps.setString(7, customer.getRole());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("register error: " + e.getMessage());
        }
    }

    public Customer getCustomerById(int id) {
        String sql = "SELECT customerId, username, password, fullName, email, phone, address, role "
                   + "FROM Customer WHERE customerId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("getCustomerById error: " + e.getMessage());
        }
        return null;
    }

    // Returns the total number of registered customers.
    public int countCustomers() {
        String sql = "SELECT COUNT(*) FROM Customer";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countCustomers error: " + e.getMessage());
        }
        return 0;
    }

    // Returns all registered customers ordered by customerId ascending.
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT customerId, username, password, fullName, email, phone, address, role "
                   + "FROM Customer ORDER BY customerId ASC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllCustomers error: " + e.getMessage());
        }
        return list;
    }

    // Updates fullName, phone and address only.
    // username, email, password and role are never touched by this method.
    public void updateProfile(Customer customer) {
        String sql = "UPDATE Customer SET fullName = ?, phone = ?, address = ? "
                   + "WHERE customerId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getAddress());
            ps.setInt(4, customer.getCustomerId());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateProfile error: " + e.getMessage());
        }
    }

    // Updates the password for the given customer.
    public void changePassword(int customerId, String newPassword) {
        String sql = "UPDATE Customer SET password = ? WHERE customerId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, customerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("changePassword error: " + e.getMessage());
        }
    }

    // Finds a customer by email — used for Google OAuth login.
    public Customer findByEmail(String email) {
        String sql = "SELECT customerId, username, password, fullName, email, phone, address, role "
                   + "FROM Customer WHERE email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("findByEmail error: " + e.getMessage());
        }
        return null;
    }

    // Registers a new customer created from Google OAuth profile.
    // Returns the newly created Customer with its generated ID.
    public Customer registerGoogleUser(String email, String fullName) {
        // Username = part before @ in email, made unique by appending _g
        String username = email.split("@")[0] + "_google";
        String sql = "INSERT INTO Customer (username, password, fullName, email, phone, address, role) "
                   + "VALUES (?, '', ?, ?, '', '', 'customer')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql,
                     java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return getCustomerById(keys.getInt(1));
                }
            }
        } catch (SQLException e) {
            System.out.println("registerGoogleUser error: " + e.getMessage());
        }
        return null;
    }
}
