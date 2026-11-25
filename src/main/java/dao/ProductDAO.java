package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import utils.DBContext;

public class ProductDAO {

    private final DBContext dbContext = new DBContext();

    private Product mapRow(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("productId"),
                rs.getInt("categoryId"),
                rs.getString("productName"),
                rs.getDouble("price"),
                rs.getInt("quantity"),
                rs.getString("description"),
                rs.getString("image")
        );
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT productId, categoryId, productName, price, quantity, description, image FROM Product";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllProducts error: " + e.getMessage());
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "SELECT productId, categoryId, productName, price, quantity, description, image FROM Product WHERE productId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("getProductById error: " + e.getMessage());
        }
        return null;
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT productId, categoryId, productName, price, quantity, description, image FROM Product WHERE productName LIKE ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("searchProducts error: " + e.getMessage());
        }
        return list;
    }

    // Search by keyword AND category — used when the user has both a search
    // term and a category selected at the same time.
    public List<Product> searchProducts(String keyword, int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT productId, categoryId, productName, price, quantity, description, image "
                   + "FROM Product WHERE productName LIKE ? AND categoryId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("searchProducts(keyword, categoryId) error: " + e.getMessage());
        }
        return list;
    }

    public void insert(Product product) {
        String sql = "INSERT INTO Product (categoryId, productName, price, quantity, description, image) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getQuantity());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getImage());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insert product error: " + e.getMessage());
        }
    }

    public void update(Product product) {
        String sql = "UPDATE Product SET categoryId = ?, productName = ?, price = ?, quantity = ?, description = ?, image = ? WHERE productId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getQuantity());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getImage());
            ps.setInt(7, product.getProductId());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("update product error: " + e.getMessage());
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Product WHERE productId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("delete product error: " + e.getMessage());
        }
    }

    // Reduces stock by the given quantity only if enough stock exists.
    // The WHERE quantity >= ? clause prevents the stock from going negative.
    // Returns true if the update affected a row (sufficient stock),
    // false if stock was insufficient or the product was not found.
    public boolean decreaseStock(int productId, int quantity) {
        String sql = "UPDATE Product SET quantity = quantity - ? "
                   + "WHERE productId = ? AND quantity >= ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("decreaseStock error: " + e.getMessage());
        }
        return false;
    }

    // Restores stock when an order is cancelled.
    // No upper bound is applied — cancelled orders simply return their units.
    public void increaseStock(int productId, int quantity) {
        String sql = "UPDATE Product SET quantity = quantity + ? WHERE productId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("increaseStock error: " + e.getMessage());
        }
    }

    // Returns products whose category name contains the given keyword.
    // Used by the chatbot to handle category-based intents.
    public List<Product> getProductsByCategoryName(String categoryKeyword) {        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.productId, p.categoryId, p.productName, p.price, "
                   + "       p.quantity, p.description, p.image "
                   + "FROM Product p "
                   + "JOIN Category c ON p.categoryId = c.categoryId "
                   + "WHERE c.categoryName LIKE ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + categoryKeyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("getProductsByCategoryName error: " + e.getMessage());
        }
        return list;
    }

    // Returns all in-stock products sorted by price.
    // ascending=true -> cheapest first, ascending=false -> most expensive first.
    // Used by the chatbot to handle price-based intents.
    public List<Product> getProductsSortedByPrice(boolean ascending) {
        List<Product> list = new ArrayList<>();
        String order = ascending ? "ASC" : "DESC";
        String sql = "SELECT productId, categoryId, productName, price, quantity, description, image "
                   + "FROM Product WHERE quantity > 0 "
                   + "ORDER BY price " + order;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getProductsSortedByPrice error: " + e.getMessage());
        }
        return list;
    }

    // ----------------------------------------------------------------
    // Pagination helpers
    // ----------------------------------------------------------------

    // Returns total number of products matching the given filters.
    // keyword may be empty string (matches all). categoryId = 0 means no category filter.
    public int countProducts(String keyword, int categoryId) {
        String sql;
        boolean hasKeyword  = keyword != null && !keyword.isEmpty();
        boolean hasCategory = categoryId > 0;

        if (hasKeyword && hasCategory) {
            sql = "SELECT COUNT(*) FROM Product WHERE productName LIKE ? AND categoryId = ?";
        } else if (hasKeyword) {
            sql = "SELECT COUNT(*) FROM Product WHERE productName LIKE ?";
        } else if (hasCategory) {
            sql = "SELECT COUNT(*) FROM Product WHERE categoryId = ?";
        } else {
            sql = "SELECT COUNT(*) FROM Product";
        }

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (hasKeyword)  ps.setString(idx++, "%" + keyword + "%");
            if (hasCategory) ps.setInt(idx, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countProducts error: " + e.getMessage());
        }
        return 0;
    }

    // Returns one page of products with OFFSET/FETCH (SQL Server 2012+).
    // offset = (page - 1) * pageSize.  pageSize = number of rows per page.
    public List<Product> getProductsPaged(String keyword, int categoryId,
                                          int offset, int pageSize) {
        List<Product> list = new ArrayList<>();
        boolean hasKeyword  = keyword != null && !keyword.isEmpty();
        boolean hasCategory = categoryId > 0;

        StringBuilder sql = new StringBuilder(
            "SELECT productId, categoryId, productName, price, quantity, description, image "
          + "FROM Product ");

        if (hasKeyword && hasCategory) {
            sql.append("WHERE productName LIKE ? AND categoryId = ? ");
        } else if (hasKeyword) {
            sql.append("WHERE productName LIKE ? ");
        } else if (hasCategory) {
            sql.append("WHERE categoryId = ? ");
        }

        sql.append("ORDER BY productId ")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        Connection conn = dbContext.getConnection();
        if (conn == null) {
            System.err.println("getProductsPaged: DB connection is null, returning empty list");
            return list;
        }
        try (conn;
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasKeyword)  ps.setString(idx++, "%" + keyword + "%");
            if (hasCategory) ps.setInt(idx++, categoryId);
            ps.setInt(idx++, offset);
            ps.setInt(idx,   pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("getProductsPaged error: " + e.getMessage());
        }
        return list;
    }
}
