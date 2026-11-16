package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetail;
import utils.DBContext;

public class OrderDetailDAO {

    private final DBContext dbContext = new DBContext();

    private OrderDetail mapRow(ResultSet rs) throws SQLException {
        return new OrderDetail(
                rs.getInt("detailId"),
                rs.getInt("orderId"),
                rs.getInt("productId"),
                rs.getDouble("price"),
                rs.getInt("quantity"),
                rs.getDouble("subtotal")
        );
    }

    public void addOrderDetail(OrderDetail detail) {
        String sql = "INSERT INTO OrderDetail (orderId, productId, price, quantity, subtotal) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, detail.getOrderId());
            ps.setInt(2, detail.getProductId());
            ps.setDouble(3, detail.getPrice());
            ps.setInt(4, detail.getQuantity());
            ps.setDouble(5, detail.getSubtotal());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addOrderDetail error: " + e.getMessage());
        }
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT detailId, orderId, productId, price, quantity, subtotal "
                   + "FROM OrderDetail WHERE orderId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("getOrderDetailsByOrderId error: " + e.getMessage());
        }
        return list;
    }

    public void deleteOrderDetails(int orderId) {
        String sql = "DELETE FROM OrderDetail WHERE orderId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("deleteOrderDetails error: " + e.getMessage());
        }
    }
}
