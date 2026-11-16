package controller;

import dao.DeliveryConfigDAO;
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

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO            orderDAO            = new OrderDAO();
    private final OrderDetailDAO      orderDetailDAO      = new OrderDetailDAO();
    private final ProductDAO          productDAO          = new ProductDAO();
    private final DeliveryConfigDAO   deliveryConfigDAO   = new DeliveryConfigDAO();

    // Fallback fees used only if DB is unreachable
    private static final double FEE_STANDARD_DEFAULT = 2000.0;
    private static final double FEE_EXPRESS_DEFAULT  = 5000.0;

    // ── GET: show checkout page ─────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>) request.getSession().getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double cartTotal = cart.values().stream()
                .mapToDouble(CartItem::getSubtotal).sum();

        // Pass current fees from DB so checkout.jsp shows correct prices
        double feeStandard = deliveryConfigDAO.getFeeByKey("standard", FEE_STANDARD_DEFAULT);
        double feeExpress  = deliveryConfigDAO.getFeeByKey("express",  FEE_EXPRESS_DEFAULT);

        request.setAttribute("cart",        cart);
        request.setAttribute("cartTotal",   cartTotal);
        request.setAttribute("feeStandard", feeStandard);
        request.setAttribute("feeExpress",  feeExpress);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    // ── POST: confirm order ─────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Auth check
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // ── Read form fields ────────────────────────────────────
        String receiverName    = request.getParameter("receiverName");
        String phone           = request.getParameter("phone");
        String address         = request.getParameter("address");
        String deliveryMethod  = request.getParameter("deliveryMethod");
        String paymentMethod   = request.getParameter("paymentMethod");
        String orderNote       = request.getParameter("orderNote");

        // Normalise
        if (deliveryMethod == null || deliveryMethod.isEmpty()) deliveryMethod = "Standard";
        if (paymentMethod  == null || paymentMethod.isEmpty())  paymentMethod  = "COD";
        if (orderNote      == null) orderNote = "";

        // ── Server-side validation ──────────────────────────────
        if (receiverName == null || receiverName.trim().isEmpty()) {
            forwardWithError(request, response, cart, "Receiver name is required.");
            return;
        }
        if (phone == null || !phone.matches("^0\\d{9}$")) {
            forwardWithError(request, response, cart, "Please enter a valid phone number (10 digits starting with 0).");
            return;
        }
        if (address == null || address.trim().isEmpty()) {
            forwardWithError(request, response, cart, "Delivery address is required.");
            return;
        }

        // ── Shipping fee — read from DB ─────────────────────────
        double shippingFee = "express".equalsIgnoreCase(deliveryMethod)
                ? deliveryConfigDAO.getFeeByKey("express",  FEE_EXPRESS_DEFAULT)
                : deliveryConfigDAO.getFeeByKey("standard", FEE_STANDARD_DEFAULT);

        // ── Pre-flight stock check ──────────────────────────────
        for (CartItem item : cart.values()) {
            Product p = productDAO.getProductById(item.getProduct().getProductId());
            if (p == null || p.getQuantity() < item.getQuantity()) {
                session.setAttribute("stockError",
                        "Some products are no longer available in the requested quantity. "
                        + "Please review your cart.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        // ── Calculate totals ────────────────────────────────────
        double cartTotal   = cart.values().stream().mapToDouble(CartItem::getSubtotal).sum();
        double finalTotal  = cartTotal + shippingFee;

        // ── Create order ────────────────────────────────────────
        Order order = new Order(
                0,
                customer.getCustomerId(),
                new Date(),
                receiverName.trim(),
                phone.trim(),
                address.trim(),
                finalTotal,
                "Pending",
                deliveryMethod,
                paymentMethod,
                shippingFee,
                orderNote.trim()
        );

        int orderId = orderDAO.createOrder(order);
        if (orderId == -1) {
            forwardWithError(request, response, cart, "Failed to create order. Please try again.");
            return;
        }

        // ── Save order details + deduct stock ───────────────────
        for (CartItem item : cart.values()) {
            int productId = item.getProduct().getProductId();
            orderDetailDAO.addOrderDetail(new OrderDetail(
                    0, orderId, productId,
                    item.getProduct().getPrice(),
                    item.getQuantity(),
                    item.getSubtotal()
            ));
            productDAO.decreaseStock(productId, item.getQuantity());
        }

        // ── Clear cart ──────────────────────────────────────────
        session.removeAttribute("cart");

        // ── Route by payment method ─────────────────────────────
        if ("bank".equalsIgnoreCase(paymentMethod)) {
            // Store orderId for the payment page
            session.setAttribute("pendingOrderId",    orderId);
            session.setAttribute("pendingOrderTotal", finalTotal);
            response.sendRedirect(request.getContextPath() + "/payment");
        } else {
            // Cash on Delivery — go straight to success
            session.setAttribute("successMessage", "Your order has been placed successfully!");
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    // Re-forwards to checkout.jsp keeping cart data and showing an error
    private void forwardWithError(HttpServletRequest request,
                                   HttpServletResponse response,
                                   Map<Integer, CartItem> cart,
                                   String error)
            throws ServletException, IOException {
        double cartTotal = cart.values().stream().mapToDouble(CartItem::getSubtotal).sum();
        request.setAttribute("cart",      cart);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("error",     error);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
}
