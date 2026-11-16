package controller;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.Map;
import model.CartItem;
import model.Customer;
import model.Order;
import model.OrderDetail;
import model.Product;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO             = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    private final ProductDAO productDAO         = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Step 1: Check if the customer is logged in
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Step 2: Get shopping cart from session
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Step 3: Receive checkout information from the form
        String receiverName = request.getParameter("receiverName");
        String phone        = request.getParameter("phone");
        String address      = request.getParameter("address");

        // Step 4: Pre-flight stock validation — check every cart item BEFORE
        // creating the order so we never create a half-fulfilled order
        for (CartItem item : cart.values()) {
            int productId     = item.getProduct().getProductId();
            int requestedQty  = item.getQuantity();
            Product product   = productDAO.getProductById(productId);

            if (product == null || product.getQuantity() < requestedQty) {
                System.out.println(">>> STOCK ERROR");
System.out.println(product.getProductName());
System.out.println(product.getQuantity());
System.out.println(requestedQty);
                // Stock insufficient — abort without touching Orders or OrderDetail
                session.setAttribute("stockError",
                        "Some products are no longer available in the requested quantity. "
                        + "Please review your cart.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

              // Step 5: Calculate total amount from cart items
        double totalAmount = cart.values().stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();

        // Step 6: Create and save the Order
Order order = new Order(
        0,
        customer.getCustomerId(),
        new Date(),
        receiverName,
        phone,
        address,
        totalAmount,
        "Pending"
);

int orderId = orderDAO.createOrder(order);

        // Step 7: Save each cart item as an OrderDetail and deduct stock
        for (CartItem item : cart.values()) {
            int productId = item.getProduct().getProductId();
            int quantity  = item.getQuantity();

            OrderDetail detail = new OrderDetail(
                    0,
                    orderId,
                    productId,
                    item.getProduct().getPrice(),
                    quantity,
                    item.getSubtotal()
            );
            orderDetailDAO.addOrderDetail(detail);

            // Deduct stock — the WHERE quantity >= ? clause in decreaseStock()
            // ensures the value can never go negative at the database level
            productDAO.decreaseStock(productId, quantity);
        }

        // Step 8: Clear the cart from session
        session.removeAttribute("cart");

        // Step 9: Redirect to home page after successful order
        session.setAttribute("successMessage", "Your order has been placed successfully!");
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
