package model;

import java.util.Date;

public class Order {

    private int    orderId;
    private int    customerId;
    private Date   orderDate;
    private String receiverName;
    private String phone;
    private String address;
    private double totalAmount;
    private String status;
    private String deliveryMethod;
    private String paymentMethod;
    private double shippingFee;
    private String orderNote;

    public Order() {
    }

    // Full constructor including new checkout fields
    public Order(int orderId, int customerId, Date orderDate,
                 String receiverName, String phone, String address,
                 double totalAmount, String status,
                 String deliveryMethod, String paymentMethod,
                 double shippingFee, String orderNote) {
        this.orderId        = orderId;
        this.customerId     = customerId;
        this.orderDate      = orderDate;
        this.receiverName   = receiverName;
        this.phone          = phone;
        this.address        = address;
        this.totalAmount    = totalAmount;
        this.status         = status;
        this.deliveryMethod = deliveryMethod;
        this.paymentMethod  = paymentMethod;
        this.shippingFee    = shippingFee;
        this.orderNote      = orderNote;
    }

    // Backward-compatible constructor without new fields
    public Order(int orderId, int customerId, Date orderDate,
                 String receiverName, String phone, String address,
                 double totalAmount, String status) {
        this(orderId, customerId, orderDate, receiverName, phone, address,
             totalAmount, status, "Standard", "COD", 2.0, "");
    }

    public int    getOrderId()          { return orderId; }
    public void   setOrderId(int v)     { this.orderId = v; }

    public int    getCustomerId()       { return customerId; }
    public void   setCustomerId(int v)  { this.customerId = v; }

    public Date   getOrderDate()        { return orderDate; }
    public void   setOrderDate(Date v)  { this.orderDate = v; }

    public String getReceiverName()           { return receiverName; }
    public void   setReceiverName(String v)   { this.receiverName = v; }

    public String getPhone()            { return phone; }
    public void   setPhone(String v)    { this.phone = v; }

    public String getAddress()          { return address; }
    public void   setAddress(String v)  { this.address = v; }

    public double getTotalAmount()          { return totalAmount; }
    public void   setTotalAmount(double v)  { this.totalAmount = v; }

    public String getStatus()           { return status; }
    public void   setStatus(String v)   { this.status = v; }

    public String getDeliveryMethod()           { return deliveryMethod; }
    public void   setDeliveryMethod(String v)   { this.deliveryMethod = v; }

    public String getPaymentMethod()            { return paymentMethod; }
    public void   setPaymentMethod(String v)    { this.paymentMethod = v; }

    public double getShippingFee()          { return shippingFee; }
    public void   setShippingFee(double v)  { this.shippingFee = v; }

    public String getOrderNote()            { return orderNote; }
    public void   setOrderNote(String v)    { this.orderNote = v; }

    @Override
    public String toString() {
        return "Order{orderId=" + orderId
                + ", customerId=" + customerId
                + ", orderDate=" + orderDate
                + ", receiverName='" + receiverName + '\''
                + ", phone='" + phone + '\''
                + ", address='" + address + '\''
                + ", totalAmount=" + totalAmount
                + ", status='" + status + '\''
                + ", deliveryMethod='" + deliveryMethod + '\''
                + ", paymentMethod='" + paymentMethod + '\''
                + ", shippingFee=" + shippingFee
                + ", orderNote='" + orderNote + '\''
                + '}';
    }
}
