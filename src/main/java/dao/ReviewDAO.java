package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Review;
import utils.DBContext;

public class ReviewDAO {

    private final DBContext dbContext = new DBContext();

    // Maps a ResultSet row to a Review object.
    // Expects the query to JOIN Customer so customerFullName is available.
    private Review mapRow(ResultSet rs) throws SQLException {
        return new Review(
                rs.getInt("reviewId"),
                rs.getInt("orderId"),
                rs.getInt("productId"),
                rs.getInt("customerId"),
                rs.getInt("rating"),
                rs.getString("comment"),
                rs.getDate("reviewDate"),
                rs.getString("customerFullName")
             
        );
    }

    // Returns all reviews for a product, newest first.
    // JOINs Customer to populate customerFullName.
    public List<Review> getReviewsByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.reviewId, r.orderId, r.productId, r.customerId, r.rating, "
           + "       r.comment, r.reviewDate, c.fullName AS customerFullName "
                   + "FROM Review r "
                   + "JOIN Customer c ON r.customerId = c.customerId "
                   + "WHERE r.productId = ? "
                   + "ORDER BY r.reviewDate DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("getReviewsByProduct error: " + e.getMessage());
        }
        return list;
    }

    // Returns the review left by a specific customer for a specific product.
    // Returns null if the customer has not reviewed this product yet.
    public Review getCustomerReview(int orderId, int productId, int customerId) {

    String sql =
        "SELECT r.reviewId, r.orderId, r.productId, r.customerId, " +
        "r.rating, r.comment, r.reviewDate, c.fullName AS customerFullName " +
        "FROM Review r " +
        "JOIN Customer c ON r.customerId = c.customerId " +
        "WHERE r.orderId = ? " +
        "AND r.productId = ? " +
        "AND r.customerId = ?";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, orderId);
        ps.setInt(2, productId);
        ps.setInt(3, customerId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return mapRow(rs);
            }

        }

    } catch (SQLException e) {
        System.out.println("getCustomerReview error: " + e.getMessage());
    }

    return null;
}
    
    public Review getReviewByOrder(int orderId, int productId) {
    String sql = "SELECT r.reviewId, r.orderId, r.productId, r.customerId, "
               + "r.rating, r.comment, r.reviewDate, "
               + "c.fullName AS customerFullName "
               + "FROM Review r "
               + "JOIN Customer c ON r.customerId = c.customerId "
               + "WHERE r.orderId = ? AND r.productId = ?";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, orderId);
        ps.setInt(2, productId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return mapRow(rs);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

    // Returns the average rating for a product, rounded to one decimal place.
    // Returns 0.0 if the product has no reviews yet.
    public double getAverageRating(int productId) {
        String sql = "SELECT ISNULL(AVG(CAST(rating AS FLOAT)), 0.0) "
                   + "FROM Review WHERE productId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("getAverageRating error: " + e.getMessage());
        }
        return 0.0;
    }

    // Returns the total number of reviews for a product.
    public int getReviewCount(int productId) {
        String sql = "SELECT COUNT(*) FROM Review WHERE productId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("getReviewCount error: " + e.getMessage());
        }
        return 0;
    }

    // Returns true if the customer has at least one COMPLETED order
    // that contains the given product.
    // customerId comes from the server session — never from the browser.
    // Returns the latest confirmed order containing this product
// that has not yet been reviewed.
public int getReviewableOrderId(int customerId, int productId) {

    String sql =
            "SELECT TOP 1 o.orderId "
          + "FROM Orders o "
          + "JOIN OrderDetail od ON o.orderId = od.orderId "
          + "WHERE o.customerId = ? "
          + "AND od.productId = ? "
          + "AND o.status = 'Confirmed' "
          + "AND NOT EXISTS ("
          + "    SELECT 1 "
          + "    FROM Review r "
          + "    WHERE r.orderId = o.orderId "
          + "      AND r.productId = od.productId"
          + ") "
          + "ORDER BY o.orderId DESC";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, customerId);
        ps.setInt(2, productId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("orderId");
            }
        }

    } catch (SQLException e) {
        System.out.println("getReviewableOrderId error: " + e.getMessage());
    }

    return -1;
}
    public boolean hasPurchasedProduct(int customerId, int productId) {
        String sql = "SELECT COUNT(*) "
           + "FROM Orders o "
           + "JOIN OrderDetail od ON o.orderId = od.orderId "
           + "WHERE o.customerId = ? "
           + "AND od.productId = ? "
           + "AND o.status = 'Confirmed'";        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("hasPurchasedProduct error: " + e.getMessage());
        }
        return false;
    }

    // Inserts a new review.
    // The UNIQUE constraint on (productId, customerId) in the DB
    // acts as a second safety net against duplicates.
    public void addReview(int orderId, int productId, int customerId, int rating, String comment) {

    String sql = "INSERT INTO Review (orderId, productId, customerId, rating, comment) "
               + "VALUES (?, ?, ?, ?, ?)";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, orderId);
        ps.setInt(2, productId);
        ps.setInt(3, customerId);
        ps.setInt(4, rating);
        ps.setString(5, comment);

        int rows = ps.executeUpdate();

        System.out.println("Rows inserted = " + rows);

    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    
}
