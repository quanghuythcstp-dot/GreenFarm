package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import utils.DBContext;

public class CategoryDAO {

    private final DBContext dbContext = new DBContext();

    private Category mapRow(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("categoryId"),
                rs.getString("categoryName"),
                rs.getString("description")
        );
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT categoryId, categoryName, description FROM Category";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllCategories error: " + e.getMessage());
        }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT categoryId, categoryName, description FROM Category WHERE categoryId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("getCategoryById error: " + e.getMessage());
        }
        return null;
    }

    public void insert(Category category) {
        String sql = "INSERT INTO Category (categoryName, description) VALUES (?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insert category error: " + e.getMessage());
        }
    }

    public void update(Category category) {
        String sql = "UPDATE Category SET categoryName = ?, description = ? WHERE categoryId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("update category error: " + e.getMessage());
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Category WHERE categoryId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("delete category error: " + e.getMessage());
        }
    }

    // Returns true if a category with the given name already exists.
    // excludeId is the categoryId to ignore (used during edit to allow keeping the same name).
    // Pass 0 when inserting a new category.
    public boolean isCategoryNameExists(String categoryName, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Category WHERE categoryName = ? AND categoryId != ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("isCategoryNameExists error: " + e.getMessage());
        }
        return false;
    }

    // Returns the number of products belonging to a given category.
    // Used to prevent deletion of a category that still has products.
    public int countProductsByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Product WHERE categoryId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("countProductsByCategory error: " + e.getMessage());
        }
        return 0;
    }
}
