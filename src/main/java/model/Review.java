package model;

import java.util.Date;

public class Review {

    private int reviewId;
    private int productId;
    private int customerId;
    private int rating;
    private String comment;
    private Date reviewDate;
    // Populated by JOIN with Customer table — not a DB column
    private String customerFullName;
    private int orderId;

    public Review() {
    }

    public Review(int reviewId,int orderId, int productId, int customerId,
                  int rating, String comment, Date reviewDate,
                  String customerFullName) {
        this.reviewId         = reviewId;
        this.orderId          = orderId;
        this.productId        = productId;
        this.customerId       = customerId;
        this.rating           = rating;
        this.comment          = comment;
        this.reviewDate       = reviewDate;
        this.customerFullName = customerFullName;
      
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getCustomerFullName() {
        return customerFullName;
    }

    public void setCustomerFullName(String customerFullName) {
        this.customerFullName = customerFullName;
    }
     public int getOrderId() {
    return orderId;
}

public void setOrderId(int orderId) {
    this.orderId = orderId;
}
    @Override
    public String toString() {
        return "Review{"
                + "reviewId=" + reviewId
                + ", productId=" + productId
                + ", customerId=" + customerId
                + ", rating=" + rating
                + ", comment='" + comment + '\''
                + ", reviewDate=" + reviewDate
                + ", customerFullName='" + customerFullName + '\''
                + ", orderId=" + orderId
                + '}';
    }
}
