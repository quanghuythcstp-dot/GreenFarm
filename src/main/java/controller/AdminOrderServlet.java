package controller;

import dao.CustomerDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;
import model.Order;
import model.OrderDetail;
import model.Product;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO       orderDAO       = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    private final CustomerDAO    customerDAO    = new CustomerDAO();
    private final ProductDAO     productDAO     = new ProductDAO();

    // Valid status values in progression order
    private static final List<String> STATUS_FLOW =
            Arrays.asList("Pending", "Confirmed", "Shipping", "Completed");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin guard
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewOrder(request, response);
                break;
            case "list":
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin guard
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    // ----------------------------------------------------------------
    // List all orders, newest first
    // ----------------------------------------------------------------
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orderList = orderDAO.getAllOrders();

        Map<Integer, Customer> customerMap = new HashMap<>();
        for (Order order : orderList) {
            int cid = order.getCustomerId();
            if (!customerMap.containsKey(cid)) {
                Customer c = customerDAO.getCustomerById(cid);
                if (c != null) {
                    customerMap.put(cid, c);
                }
            }
        }

        request.setAttribute("orderList", orderList);
        request.setAttribute("customerMap", customerMap);
        request.getRequestDispatcher("/admin/order-list.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------
    // View a single order with its line items
    // ----------------------------------------------------------------
    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        int orderId = Integer.parseInt(idParam);
        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        List<OrderDetail> detailList = orderDetailDAO.getOrderDetailsByOrderId(orderId);

        Map<Integer, Product> productMap = new HashMap<>();
        for (OrderDetail detail : detailList) {
            int pid = detail.getProductId();
            if (!productMap.containsKey(pid)) {
                Product p = productDAO.getProductById(pid);
                if (p != null) {
                    productMap.put(pid, p);
                }
            }
        }

        Customer orderCustomer = customerDAO.getCustomerById(order.getCustomerId());

        // All five statuses are always available — admin has no restrictions
        List<String> allowedStatuses = Arrays.asList(
                "Pending", "Confirmed", "Shipping", "Completed", "Cancelled");

        request.setAttribute("order", order);
        request.setAttribute("detailList", detailList);
        request.setAttribute("productMap", productMap);
        request.setAttribute("orderCustomer", orderCustomer);
        request.setAttribute("allowedStatuses", allowedStatuses);
        request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------
    // POST: update order status with transition validation
    // ----------------------------------------------------------------
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam   = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        if (idParam == null || !idParam.matches("\\d+") || newStatus == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        int orderId = Integer.parseInt(idParam);
        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        String currentStatus = order.getStatus();

        // Cancellation: restore stock for every product in the order.
        // Guard: only restore when the order is NOT already Cancelled,
        // preventing a double-restore if updateStatus is somehow called twice.
        if ("Cancelled".equals(newStatus) && !"Cancelled".equals(currentStatus)) {
            List<OrderDetail> detailList = orderDetailDAO.getOrderDetailsByOrderId(orderId);
            for (OrderDetail detail : detailList) {
                productDAO.increaseStock(detail.getProductId(), detail.getQuantity());
            }
        }

        orderDAO.updateOrderStatus(orderId, newStatus);
        response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
    }

    // ----------------------------------------------------------------
    // Transition rules
    // ----------------------------------------------------------------

    // Returns the list of statuses the admin may move to from the current one.
    private List<String> getAllowedNextStatuses(String currentStatus) {
        if (currentStatus == null) {
            return Arrays.asList("Confirmed", "Cancelled");
        }
        switch (currentStatus) {
            case "Pending":
                return Arrays.asList("Confirmed", "Cancelled");
            case "Confirmed":
                return Arrays.asList("Shipping", "Cancelled");
            case "Shipping":
                return Arrays.asList("Completed");
            case "Completed":
            case "Cancelled":
            default:
                return Arrays.asList(); // terminal states — no further changes
        }
    }

    // Returns true if moving from currentStatus to newStatus is allowed.
    private boolean isValidTransition(String currentStatus, String newStatus) {
        return getAllowedNextStatuses(currentStatus).contains(newStatus);
    }
}
