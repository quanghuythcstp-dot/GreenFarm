package controller;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;
import model.Order;
import model.OrderDetail;
import model.Product;

@WebServlet("/my-orders")
public class OrderHistoryServlet extends HttpServlet {

    private final OrderDAO       orderDAO       = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    private final ProductDAO     productDAO     = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Authentication check
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            showOrderDetail(request, response, customer);
        } else {
            listOrders(request, response, customer);
        }
    }

    // ----------------------------------------------------------------
    // List all orders belonging to the logged-in customer
    // ----------------------------------------------------------------
    private void listOrders(HttpServletRequest request, HttpServletResponse response,
                            Customer customer) throws ServletException, IOException {
        List<Order> orderList = orderDAO.getOrdersByCustomer(customer.getCustomerId());
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("/order-history.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------
    // Show details of one order — ownership verified before display
    // ----------------------------------------------------------------
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response,
                                 Customer customer) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        // Validate id parameter
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        int orderId = Integer.parseInt(idParam);
        Order order = orderDAO.getOrderById(orderId);

        // Redirect if order not found
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        // Security: ensure this order belongs to the logged-in customer
        if (order.getCustomerId() != customer.getCustomerId()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        List<OrderDetail> detailList = orderDetailDAO.getOrderDetailsByOrderId(orderId);

        // Build productId -> Product map for JSP to display name and image
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

        request.setAttribute("order", order);
        request.setAttribute("detailList", detailList);
        request.setAttribute("productMap", productMap);
        request.getRequestDispatcher("/order-history-detail.jsp").forward(request, response);
    }
}
