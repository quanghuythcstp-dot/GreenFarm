package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import utils.DBContext;

public class OrderDAO {

    private final DBContext dbContext = new DBContext();

    private Order mapRow(ResultSet rs) throws SQLException {
        // Read new checkout columns defensively — fall back to defaults
        // if the migration has not been run yet
        String deliveryMethod = "Standard";
        String paymentMethod  = "COD";
        double shippingFee    = 2.0;
        String orderNote      = "";
        try { deliveryMethod = rs.getString("deliveryMethod"); } catch (SQLException ignored) {}
        try { paymentMethod  = rs.getString("paymentMethod");  } catch (SQLException ignored) {}
        try { shippingFee    = rs.getDouble("shippingFee");    } catch (SQLException ignored) {}
        try { orderNote      = rs.getString("orderNote");      } catch (SQLException ignored) {}

        return new Order(
                rs.getInt("orderId"),
                rs.getInt("customerId"),
                rs.getDate("orderDate"),
                rs.getString("receiverName"),
                rs.getString("phone"),
                rs.getString("address"),
                rs.getDouble("totalAmount"),
                rs.getString("status"),
                deliveryMethod,
                paymentMethod,
                shippingFee,
                orderNote
        );
    }

    public int createOrder(Order order) {
        String sql = "INSERT INTO Orders (customerId, orderDate, receiverName, phone, address, "
                   + "totalAmount, status, deliveryMethod, paymentMethod, shippingFee, orderNote) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getCustomerId());
            ps.setDate(2, new java.sql.Date(order.getOrderDate().getTime()));
            ps.setString(3, order.getReceiverName());
            ps.setString(4, order.getPhone());
            ps.setString(5, order.getAddress());
            ps.setDouble(6, order.getTotalAmount());
            ps.setString(7, order.getStatus() != null ? order.getStatus() : "Pending");
            ps.setString(8, order.getDeliveryMethod() != null ? order.getDeliveryMethod() : "Standard");
            ps.setString(9, order.getPaymentMethod()  != null ? order.getPaymentMethod()  : "COD");
            ps.setDouble(10, order.getShippingFee());
            ps.setString(11, order.getOrderNote());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("createOrder error: " + e.getMessage());
            System.out.println("createOrder SQLState: " + e.getSQLState());
            System.out.println("createOrder ErrorCode: " + e.getErrorCode());
        }
        return -1;
    }

    public List<Order> getOrdersByCustomer(int customerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT orderId, customerId, orderDate, receiverName, phone, address, "
                   + "totalAmount, status, deliveryMethod, paymentMethod, shippingFee, orderNote "
                   + "FROM Orders WHERE customerId = ? ORDER BY orderDate DESC, orderId DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("getOrdersByCustomer error: " + e.getMessage());
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT orderId, customerId, orderDate, receiverName, phone, address, "
                   + "totalAmount, status, deliveryMethod, paymentMethod, shippingFee, orderNote "
                   + "FROM Orders WHERE orderId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("getOrderById error: " + e.getMessage());
        }
        return null;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT orderId, customerId, orderDate, receiverName, phone, address, "
                   + "totalAmount, status, deliveryMethod, paymentMethod, shippingFee, orderNote "
                   + "FROM Orders ORDER BY orderDate DESC, orderId DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllOrders error: " + e.getMessage());
        }
        return list;
    }

    // Updates the status of a single order.
    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE orderId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateOrderStatus error: " + e.getMessage());
        }
    }

    // Returns the sum of totalAmount across all orders.
    // Returns 0.0 if there are no orders yet.
    // Counts Confirmed, Shipping and Completed — excludes Pending and Cancelled.
    public double getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(totalAmount), 0) FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed')";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.out.println("getTotalRevenue error: " + e.getMessage());
        }
        return 0.0;
    }

    // Revenue from active orders placed today.
    public double getTodayRevenue() {
        String sql = "SELECT ISNULL(SUM(totalAmount), 0) FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed') "
                   + "AND CAST(orderDate AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.out.println("getTodayRevenue error: " + e.getMessage());
        }
        return 0.0;
    }

    // Revenue from active orders in the current calendar month.
    public double getMonthlyRevenue() {
        String sql = "SELECT ISNULL(SUM(totalAmount), 0) FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed') "
                   + "AND MONTH(orderDate) = MONTH(GETDATE()) "
                   + "AND YEAR(orderDate)  = YEAR(GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.out.println("getMonthlyRevenue error: " + e.getMessage());
        }
        return 0.0;
    }

    // Revenue from active orders in the current calendar year.
    public double getYearlyRevenue() {
        String sql = "SELECT ISNULL(SUM(totalAmount), 0) FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed') "
                   + "AND YEAR(orderDate) = YEAR(GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.out.println("getYearlyRevenue error: " + e.getMessage());
        }
        return 0.0;
    }

    // Revenue from active orders within an inclusive date range.
    // Both dateFrom and dateTo are in "yyyy-MM-dd" format.
    public double getRevenueByDateRange(String dateFrom, String dateTo) {
        String sql = "SELECT ISNULL(SUM(totalAmount), 0) FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed') "
                   + "AND CAST(orderDate AS DATE) BETWEEN ? AND ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.out.println("getRevenueByDateRange error: " + e.getMessage());
        }
        return 0.0;
    }

    // Returns monthly revenue for the current year grouped by month (1-12).
    // Result: double[12] where index 0 = January ... index 11 = December.
    public double[] getMonthlyRevenueChart() {
        double[] data = new double[12];
        String sql = "SELECT MONTH(orderDate) AS mo, ISNULL(SUM(totalAmount), 0) AS rev "
                   + "FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed') "
                   + "AND YEAR(orderDate) = YEAR(GETDATE()) "
                   + "GROUP BY MONTH(orderDate)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int month = rs.getInt("mo");
                data[month - 1] = rs.getDouble("rev");
            }
        } catch (SQLException e) {
            System.out.println("getMonthlyRevenueChart error: " + e.getMessage());
        }
        return data;
    }

    // Returns top-N best-selling products by revenue (excludes Cancelled/Pending).
    // Each row: productName (String), qtySold (int), revenue (double).
    public List<Object[]> getTopSellingProducts(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.productName, "
                   + "       SUM(od.quantity) AS qtySold, "
                   + "       SUM(od.subtotal) AS revenue "
                   + "FROM OrderDetail od "
                   + "JOIN Orders  o ON od.orderId  = o.orderId "
                   + "JOIN Product p ON od.productId = p.productId "
                   + "WHERE o.status IN ('Confirmed','Shipping','Completed') "
                   + "GROUP BY p.productId, p.productName "
                   + "ORDER BY revenue DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Object[]{
                        rs.getString("productName"),
                        rs.getInt("qtySold"),
                        rs.getDouble("revenue")
                    });
                }
            }
        } catch (SQLException e) {
            System.out.println("getTopSellingProducts error: " + e.getMessage());
        }
        return list;
    }

    // Returns the most recent orders (all active statuses), newest first.
    public List<Order> getRecentCompletedOrders(int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT TOP (?) orderId, customerId, orderDate, receiverName, "
                   + "phone, address, totalAmount, status, deliveryMethod, paymentMethod, shippingFee, orderNote "
                   + "FROM Orders "
                   + "WHERE status IN ('Confirmed','Shipping','Completed') "
                   + "ORDER BY orderDate DESC, orderId DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("getRecentCompletedOrders error: " + e.getMessage());
        }
        return list;
    }
}
