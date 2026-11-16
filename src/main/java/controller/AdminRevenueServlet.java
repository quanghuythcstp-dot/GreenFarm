package controller;

import dao.CustomerDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;
import model.Order;

@WebServlet("/admin/revenue")
public class AdminRevenueServlet extends HttpServlet {

    private final OrderDAO    orderDAO    = new OrderDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin guard
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Read filter parameters
        String quickFilter = request.getParameter("quick");
        String dateFrom    = request.getParameter("dateFrom");
        String dateTo      = request.getParameter("dateTo");

        // Resolve date range from quick filter.
        // When quickFilter == "custom", use the dateFrom/dateTo from the form directly.
        if (quickFilter != null && !quickFilter.isEmpty() && !"custom".equals(quickFilter)) {
            String[] range = resolveQuickFilter(quickFilter);
            dateFrom = range[0];
            dateTo   = range[1];
        }

        // Validate custom dates — fall back to current month if blank
        if (dateFrom == null || dateFrom.isEmpty() || dateTo == null || dateTo.isEmpty()) {
            LocalDate now = LocalDate.now();
            dateFrom = now.withDayOfMonth(1).format(FMT);
            dateTo   = now.format(FMT);
            if (quickFilter == null || quickFilter.isEmpty()) {
                quickFilter = "thisMonth";
            }
        }

        // ── Summary cards ──────────────────────────────────────────
        double totalRevenue   = orderDAO.getTotalRevenue();
        double todayRevenue   = orderDAO.getTodayRevenue();
        double monthlyRevenue = orderDAO.getMonthlyRevenue();
        double yearlyRevenue  = orderDAO.getYearlyRevenue();
        double filteredRevenue = orderDAO.getRevenueByDateRange(dateFrom, dateTo);

        // ── Chart data: monthly revenue for current year ───────────
        double[] chartData = orderDAO.getMonthlyRevenueChart();

        // ── Top 5 selling products ─────────────────────────────────
        List<Object[]> topProducts = orderDAO.getTopSellingProducts(5);

        // ── Recent 10 completed orders ─────────────────────────────
        List<Order> recentOrders = orderDAO.getRecentCompletedOrders(10);

        // Build customerMap for recent orders
        Map<Integer, Customer> customerMap = new HashMap<>();
        for (Order order : recentOrders) {
            int cid = order.getCustomerId();
            if (!customerMap.containsKey(cid)) {
                Customer c = customerDAO.getCustomerById(cid);
                if (c != null) customerMap.put(cid, c);
            }
        }

        // ── Pass attributes to JSP ─────────────────────────────────
        request.setAttribute("totalRevenue",    totalRevenue);
        request.setAttribute("todayRevenue",    todayRevenue);
        request.setAttribute("monthlyRevenue",  monthlyRevenue);
        request.setAttribute("yearlyRevenue",   yearlyRevenue);
        request.setAttribute("filteredRevenue", filteredRevenue);
        request.setAttribute("chartData",       chartData);
        request.setAttribute("topProducts",     topProducts);
        request.setAttribute("recentOrders",    recentOrders);
        request.setAttribute("customerMap",     customerMap);
        request.setAttribute("dateFrom",        dateFrom);
        request.setAttribute("dateTo",          dateTo);
        request.setAttribute("quickFilter",     quickFilter != null ? quickFilter : "");

        request.getRequestDispatcher("/admin/revenue.jsp").forward(request, response);
    }

    // Resolves a quick-filter keyword to [dateFrom, dateTo] in yyyy-MM-dd format.
    private String[] resolveQuickFilter(String quick) {
        LocalDate today = LocalDate.now();
        LocalDate from;
        LocalDate to = today;

        switch (quick) {
            case "today":
                from = today;
                break;
            case "thisWeek":
                from = today.with(java.time.DayOfWeek.MONDAY);
                break;
            case "thisYear":
                from = today.withDayOfYear(1);
                break;
            case "thisMonth":
            default:
                from = today.withDayOfMonth(1);
                break;
        }
        return new String[]{ from.format(FMT), to.format(FMT) };
    }
}
