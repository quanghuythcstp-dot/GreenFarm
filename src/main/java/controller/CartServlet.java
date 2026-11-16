package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import model.CartItem;
import model.Product;
import dao.ProductDAO;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showCart(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            showCart(request, response);
            return;
        }

        switch (action) {
            case "add":
                addToCart(request, response);
                break;
            case "update":
                updateCart(request, response);
                break;
            case "remove":
                removeFromCart(request, response);
                break;
            default:
                showCart(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        String productName   = request.getParameter("productName");
        String priceParam    = request.getParameter("price");
        String quantityParam = request.getParameter("quantity");

        if (productIdParam == null || priceParam == null) {
            showCart(request, response);
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        double price  = Double.parseDouble(priceParam);
        int quantity  = (quantityParam != null && quantityParam.matches("\\d+"))
                        ? Integer.parseInt(quantityParam) : 1;

        ProductDAO productDAO = new ProductDAO();
Product product = productDAO.getProductById(productId);

if (product == null) {
    response.sendRedirect(request.getContextPath() + "/home");
    return;
}
// Kiểm tra số lượng tồn kho
if (quantity > product.getQuantity()) {
    request.getSession().setAttribute("errorMessage",
            "Only " + product.getQuantity() + " item(s) of " 
            + product.getProductName() + " left in stock.");
    response.sendRedirect(request.getContextPath() + "/product?productId=" + productId);
    return;
}
        Map<Integer, CartItem> cart = getCart(request);

        if (cart.containsKey(productId)) {
            // Increase quantity if product already in cart
            CartItem existing = cart.get(productId);
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            cart.put(productId, new CartItem(product, quantity));
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        String quantityParam  = request.getParameter("quantity");

        if (productIdParam == null || quantityParam == null) {
            showCart(request, response);
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int quantity  = Integer.parseInt(quantityParam);

        Map<Integer, CartItem> cart = getCart(request);

        Product product = new ProductDAO().getProductById(productId);

if (quantity <= 0) {
    cart.remove(productId);

} else if (cart.containsKey(productId)) {

    CartItem item = cart.get(productId);

    if (quantity > product.getQuantity()) {

        // Đặt lại bằng số lượng tồn kho
        item.setQuantity(product.getQuantity());

        request.getSession().setAttribute(
                "stockError",
                product.getProductName()
                + " only has "
                + product.getQuantity()
                + " item(s) in stock."
        );

    } else {
        item.setQuantity(quantity);
    }
}
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");

        if (productIdParam != null && productIdParam.matches("\\d+")) {
            int productId = Integer.parseInt(productIdParam);
            getCart(request).remove(productId);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void showCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<Integer, CartItem> cart = getCart(request);

        double totalPrice = cart.values().stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();

        request.setAttribute("cart", cart);
        request.setAttribute("totalPrice", totalPrice);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    // Retrieve cart from session, create a new one if it does not exist
    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
