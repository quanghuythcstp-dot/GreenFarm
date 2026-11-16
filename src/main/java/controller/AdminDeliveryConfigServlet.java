package controller;

import dao.DeliveryConfigDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Customer;
import model.DeliveryConfig;

@WebServlet("/admin/delivery-config")
public class AdminDeliveryConfigServlet extends HttpServlet {

    private final DeliveryConfigDAO deliveryConfigDAO = new DeliveryConfigDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<DeliveryConfig> configList = deliveryConfigDAO.getAll();
        request.setAttribute("configList", configList);
        request.getRequestDispatcher("/admin/delivery-config.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            // Delete a single method
            String idParam = request.getParameter("configId");
            if (idParam != null && idParam.matches("\\d+")) {
                deliveryConfigDAO.delete(Integer.parseInt(idParam));
            }

        } else if ("add".equals(action)) {
            // Add a new delivery method
            String methodName  = request.getParameter("newMethodName");
            String feeParam    = request.getParameter("newFee");
            String description = request.getParameter("newDescription");
            if (methodName != null && !methodName.trim().isEmpty()
                    && feeParam != null && feeParam.matches("\\d+(\\.\\d+)?")) {
                deliveryConfigDAO.insert(
                        methodName.trim(),
                        methodName.trim(),
                        Double.parseDouble(feeParam),
                        description != null ? description.trim() : ""
                );
            }

        } else {
            // Default: update all existing methods
            String[] configIds    = request.getParameterValues("configId");
            String[] fees         = request.getParameterValues("fee");
            String[] descriptions = request.getParameterValues("description");
            if (configIds != null) {
                for (int i = 0; i < configIds.length; i++) {
                    try {
                        int    configId   = Integer.parseInt(configIds[i]);
                        double fee        = Double.parseDouble(fees[i]);
                        String desc       = (descriptions != null && i < descriptions.length)
                                            ? descriptions[i] : "";
                        if (fee >= 0) deliveryConfigDAO.update(configId, fee, desc);
                    } catch (NumberFormatException ignored) {}
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/delivery-config?success=1");
    }
}
