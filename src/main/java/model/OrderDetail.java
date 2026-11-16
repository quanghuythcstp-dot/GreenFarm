package model;

public class OrderDetail {

    private int detailId;
    private int orderId;
    private int productId;
    private double price;
    private int quantity;
    private double subtotal;

    public OrderDetail() {
    }

    public OrderDetail(int detailId, int orderId, int productId,
                       double price, int quantity, double subtotal) {
        this.detailId = detailId;
        this.orderId = orderId;
        this.productId = productId;
        this.price = price;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    @Override
    public String toString() {
        return "OrderDetail{"
                + "detailId=" + detailId
                + ", orderId=" + orderId
                + ", productId=" + productId
                + ", price=" + price
                + ", quantity=" + quantity
                + ", subtotal=" + subtotal
                + '}';
    }
}
