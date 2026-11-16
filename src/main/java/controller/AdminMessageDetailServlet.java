package controller;

import dao.ContactDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.ContactMessage;
import model.Customer;

@WebServlet("/admin/messages/detail")
public class AdminMessageDetailServlet extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin guard
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/messages");
            return;
        }

        int messageId = Integer.parseInt(idParam);
        ContactMessage message = contactDAO.getMessageById(messageId);

        if (message == null) {
            response.sendRedirect(request.getContextPath() + "/admin/messages");
            return;
        }

        // Automatically mark as Read when admin opens the message
        if ("New".equalsIgnoreCase(message.getStatus())) {
            contactDAO.updateStatus(messageId, "Read");
            message.setStatus("Read");
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("/admin/message-detail.jsp").forward(request, response);
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

        String action  = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (idParam != null && idParam.matches("\\d+")) {
            int messageId = Integer.parseInt(idParam);
            if ("delete".equals(action)) {
                contactDAO.deleteMessage(messageId);
                response.sendRedirect(request.getContextPath() + "/admin/messages");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/messages");
    }
}
