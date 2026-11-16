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
import utils.Validation;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Only logged-in users can submit messages
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/contact?guestError=1");
            return;
        }

        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Validate message
        if (Validation.isEmpty(message)) {
            request.setAttribute("error", "Message cannot be empty.");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        if (message.trim().length() > 2000) {
            request.setAttribute("error", "Message cannot exceed 2000 characters.");
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        // Pre-fill customer info from session — never trust client-side input
        ContactMessage cm = new ContactMessage();
        cm.setFullName(customer.getFullName());
        cm.setPhoneNumber(customer.getPhone() != null ? customer.getPhone() : "");
        cm.setEmail(customer.getEmail() != null ? customer.getEmail() : "");
        cm.setSubject(subject != null ? subject.trim() : "");
        cm.setMessage(message.trim());

        contactDAO.save(cm);

        response.sendRedirect(request.getContextPath() + "/contact?success=1");
    }
}
