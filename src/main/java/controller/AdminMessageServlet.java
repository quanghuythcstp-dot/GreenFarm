package controller;

import dao.ContactDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.ContactMessage;
import model.Customer;

@WebServlet("/admin/messages")
public class AdminMessageServlet extends HttpServlet {

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

        List<ContactMessage> messageList = contactDAO.getAllMessages();
        int newMessageCount = contactDAO.countNewMessages();

        request.setAttribute("messageList",     messageList);
        request.setAttribute("newMessageCount", newMessageCount);
        request.getRequestDispatcher("/admin/messages.jsp").forward(request, response);
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

        String action    = request.getParameter("action");
        String idParam   = request.getParameter("id");

        if ("delete".equals(action) && idParam != null && idParam.matches("\\d+")) {
            contactDAO.deleteMessage(Integer.parseInt(idParam));
        }

        response.sendRedirect(request.getContextPath() + "/admin/messages");
    }
}
