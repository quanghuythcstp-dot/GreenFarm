package controller;

import dao.CategoryDAO;
import dao.ContactDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final OrderDAO    orderDAO    = new OrderDAO();
    private final ContactDAO  contactDAO  = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin guard
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // --- Stat cards ---
        int    totalProducts   = productDAO.getAllProducts().size();
        int    totalCategories = categoryDAO.getAllCategories().size();
        int    totalCustomers  = customerDAO.countCustomers();
        int    totalOrders     = orderDAO.getAllOrders().size();
        double totalRevenue    = orderDAO.getTotalRevenue();

        // --- Latest 5 orders (getAllOrders already returns DESC by date) ---
        List<Order> allOrders   = orderDAO.getAllOrders();
        List<Order> latestOrders = allOrders.size() > 5
                ? allOrders.subList(0, 5)
                : allOrders;

        // Build customerMap for the latest orders so JSP can show customer name
        Map<Integer, Customer> customerMap = new HashMap<>();
        for (Order order : latestOrders) {
            int cid = order.getCustomerId();
            if (!customerMap.containsKey(cid)) {
                Customer c = customerDAO.getCustomerById(cid);
                if (c != null) {
                    customerMap.put(cid, c);
                }
            }
        }

        request.setAttribute("totalProducts",   totalProducts);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("totalCustomers",  totalCustomers);
        request.setAttribute("totalOrders",     totalOrders);
        request.setAttribute("totalRevenue",    totalRevenue);
        request.setAttribute("latestOrders",    latestOrders);
        request.setAttribute("customerMap",     customerMap);
        request.setAttribute("newMessageCount", contactDAO.countNewMessages());

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
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
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
