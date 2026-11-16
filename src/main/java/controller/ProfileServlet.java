package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;
import utils.Validation;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Authentication check
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Authentication check
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("password".equals(action)) {
            changePassword(request, response, session, customer);
        } else {
            updateProfile(request, response, session, customer);
        }
    }

    // ----------------------------------------------------------------
    // POST action=update — update fullName, phone, address
    // ----------------------------------------------------------------
    private void updateProfile(HttpServletRequest request, HttpServletResponse response,
                                HttpSession session, Customer customer)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");

        if (Validation.isEmpty(fullName)) {
            request.setAttribute("profileError", "Full name is required.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (!Validation.isPhone(phone)) {
            request.setAttribute("profileError", "Phone number must be 10 digits starting with 0.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (Validation.isEmpty(address)) {
            request.setAttribute("profileError", "Address is required.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        // Apply changes to the DAO
        customer.setFullName(fullName.trim());
        customer.setPhone(phone.trim());
        customer.setAddress(address.trim());
        customerDAO.updateProfile(customer);

        // Update session so the navbar reflects the new name immediately
        session.setAttribute("customer", customer);

        request.setAttribute("profileSuccess", "Your profile has been updated successfully.");
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------
    // POST action=password — change password
    // ----------------------------------------------------------------
    private void changePassword(HttpServletRequest request, HttpServletResponse response,
                                 HttpSession session, Customer customer)
            throws ServletException, IOException {
        String currentPassword  = request.getParameter("currentPassword");
        String newPassword      = request.getParameter("newPassword");
        String confirmPassword  = request.getParameter("confirmPassword");

        // Current password must match what is stored in the session customer object
        if (!customer.getPassword().equals(currentPassword)) {
            request.setAttribute("passwordError", "Current password is incorrect.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (Validation.isEmpty(newPassword) || newPassword.length() < 6) {
            request.setAttribute("passwordError", "New password must be at least 6 characters.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passwordError", "New passwords do not match.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        customerDAO.changePassword(customer.getCustomerId(), newPassword);

        // Update session so the stored password stays in sync
        customer.setPassword(newPassword);
        session.setAttribute("customer", customer);

        request.setAttribute("passwordSuccess", "Password changed successfully.");
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
