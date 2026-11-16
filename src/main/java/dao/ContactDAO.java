package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ContactMessage;
import utils.DBContext;

public class ContactDAO {

    private final DBContext dbContext = new DBContext();

    private ContactMessage mapRow(ResultSet rs) throws SQLException {
        return new ContactMessage(
                rs.getInt("messageId"),
                rs.getString("fullName"),
                rs.getString("phoneNumber"),
                rs.getString("email"),
                rs.getString("subject"),
                rs.getString("message"),
                rs.getDate("createdAt"),
                rs.getString("status")
        );
    }

    // Inserts a new contact message with default status 'New'.
    public void save(ContactMessage cm) {
        String sql = "INSERT INTO ContactMessage (fullName, phoneNumber, email, subject, message) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cm.getFullName());
            ps.setString(2, cm.getPhoneNumber());
            ps.setString(3, cm.getEmail());
            ps.setString(4, cm.getSubject());
            ps.setString(5, cm.getMessage());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ContactDAO.save error: " + e.getMessage());
        }
    }

    // Returns all messages ordered by newest first — used by the Admin panel.
    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT messageId, fullName, phoneNumber, email, subject, "
                   + "message, createdAt, status "
                   + "FROM ContactMessage ORDER BY createdAt DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("ContactDAO.getAllMessages error: " + e.getMessage());
        }
        return list;
    }

    // Updates the status of a single message (New → Read → Replied).
    public void updateStatus(int messageId, String status) {
        String sql = "UPDATE ContactMessage SET status = ? WHERE messageId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, messageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ContactDAO.updateStatus error: " + e.getMessage());
        }
    }

    // Returns a single message by its ID.
    public ContactMessage getMessageById(int messageId) {
        String sql = "SELECT messageId, fullName, phoneNumber, email, subject, "
                   + "message, createdAt, status "
                   + "FROM ContactMessage WHERE messageId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.out.println("ContactDAO.getMessageById error: " + e.getMessage());
        }
        return null;
    }

    // Permanently deletes a message by its ID.
    public void deleteMessage(int messageId) {
        String sql = "DELETE FROM ContactMessage WHERE messageId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ContactDAO.deleteMessage error: " + e.getMessage());
        }
    }

    // Returns the count of messages with status = 'New'.
    // Used by the Admin Dashboard and nav badge.
    public int countNewMessages() {
        String sql = "SELECT COUNT(*) FROM ContactMessage WHERE status = 'New'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("ContactDAO.countNewMessages error: " + e.getMessage());
        }
        return 0;
    }
}
