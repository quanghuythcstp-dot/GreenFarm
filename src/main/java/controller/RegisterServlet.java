package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Customer;
import utils.Validation;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");

        // Validate required fields
        if (Validation.isEmpty(username)) {
            request.setAttribute("error", "Username is required.");
            forwardBack(request, response);
            return;
        }

        if (Validation.isEmpty(password)) {
            request.setAttribute("error", "Password is required.");
            forwardBack(request, response);
            return;
        }

        if (Validation.isEmpty(fullName)) {
            request.setAttribute("error", "Full name is required.");
            forwardBack(request, response);
            return;
        }

        if (!Validation.isEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            forwardBack(request, response);
            return;
        }

        if (!Validation.isPhone(phone)) {
            request.setAttribute("error", "Please enter a valid phone number.");
            forwardBack(request, response);
            return;
        }

        if (Validation.isEmpty(address)) {
            request.setAttribute("error", "Address is required.");
            forwardBack(request, response);
            return;
        }

        // Register new customer
        Customer customer = new Customer(
        0,
        username.trim(),
        password.trim(),
        fullName.trim(),
        email.trim(),
        phone.trim(),
        address.trim(),
        "customer"
);
        customerDAO.register(customer);

        response.sendRedirect(request.getContextPath() + "/login");
    }

    // Forward back to register.jsp while preserving entered values
    private void forwardBack(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("username", request.getParameter("username"));
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("email",    request.getParameter("email"));
        request.setAttribute("phone",    request.getParameter("phone"));
        request.setAttribute("address",  request.getParameter("address"));
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
