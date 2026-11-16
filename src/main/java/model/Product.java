package model;

public class Product {

    private int productId;
    private int categoryId;
    private String productName;
    private double price;
    private int quantity;
    private String description;
    private String image;

    public Product() {
    }

    public Product(int productId, int categoryId, String productName,
                   double price, int quantity, String description, String image) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.image = image;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "Product{"
                + "productId=" + productId
                + ", categoryId=" + categoryId
                + ", productName='" + productName + '\''
                + ", price=" + price
                + ", quantity=" + quantity
                + ", description='" + description + '\''
                + ", image='" + image + '\''
                + '}';
    }
}
