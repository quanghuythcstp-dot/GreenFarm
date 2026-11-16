package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DeliveryConfig;
import utils.DBContext;

public class DeliveryConfigDAO {

    private final DBContext dbContext = new DBContext();

    private DeliveryConfig mapRow(ResultSet rs) throws SQLException {
        return new DeliveryConfig(
                rs.getInt("configId"),
                rs.getString("methodKey"),
                rs.getString("methodName"),
                rs.getDouble("fee"),
                rs.getString("description")
        );
    }

    // Returns all delivery options.
    public List<DeliveryConfig> getAll() {
        List<DeliveryConfig> list = new ArrayList<>();
        String sql = "SELECT configId, methodKey, methodName, fee, description "
                   + "FROM DeliveryConfig ORDER BY configId";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.out.println("DeliveryConfigDAO.getAll error: " + e.getMessage());
        }
        return list;
    }

    // Returns one delivery option by methodKey ('standard' or 'express').
    // Falls back to defaultFee if not found so checkout never breaks.
    public double getFeeByKey(String methodKey, double defaultFee) {
        String sql = "SELECT fee FROM DeliveryConfig WHERE methodKey = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, methodKey.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("fee");
            }
        } catch (SQLException e) {
            System.out.println("DeliveryConfigDAO.getFeeByKey error: " + e.getMessage());
        }
        return defaultFee;
    }

    // Updates the fee and description for a single delivery method.
    public void update(int configId, double fee, String description) {
        String sql = "UPDATE DeliveryConfig SET fee = ?, description = ? WHERE configId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, fee);
            ps.setString(2, description);
            ps.setInt(3, configId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("DeliveryConfigDAO.update error: " + e.getMessage());
        }
    }

    // Adds a new delivery method.
    public void insert(String methodKey, String methodName, double fee, String description) {
        String sql = "INSERT INTO DeliveryConfig (methodKey, methodName, fee, description) "
                   + "VALUES (?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, methodKey.toLowerCase().replaceAll("\\s+", "_"));
            ps.setString(2, methodName);
            ps.setDouble(3, fee);
            ps.setString(4, description);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("DeliveryConfigDAO.insert error: " + e.getMessage());
        }
    }

    // Deletes a delivery method by configId.
    public void delete(int configId) {
        String sql = "DELETE FROM DeliveryConfig WHERE configId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, configId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("DeliveryConfigDAO.delete error: " + e.getMessage());
        }
    }
}
