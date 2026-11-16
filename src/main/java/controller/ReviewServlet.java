package controller;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Customer;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Security: always read customerId from session, never from request
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String productIdParam = request.getParameter("productId");
        String ratingParam    = request.getParameter("rating");
        String comment        = request.getParameter("comment");

        // Validate productId
        if (productIdParam == null || !productIdParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int productId  = Integer.parseInt(productIdParam);
        int customerId = customer.getCustomerId();

        // Validate rating
        if (ratingParam == null || !ratingParam.matches("[1-5]")) {
            request.setAttribute("reviewError", "Please select a rating between 1 and 5.");
            request.getRequestDispatcher("/product?productId=" + productId)
                   .forward(request, response);
            return;
        }

        // Validate comment
        if (comment == null || comment.trim().isEmpty()) {
            request.setAttribute("reviewError", "Comment cannot be empty.");
            request.getRequestDispatcher("/product?productId=" + productId)
                   .forward(request, response);
            return;
        }

        if (comment.trim().length() > 1000) {
            request.setAttribute("reviewError", "Comment cannot exceed 1000 characters.");
            request.getRequestDispatcher("/product?productId=" + productId)
                   .forward(request, response);
            return;
        }

        int rating = Integer.parseInt(ratingParam);

        // Security: verify purchase server-side (Completed orders only)
        int orderId = reviewDAO.getReviewableOrderId(customerId, productId);

if (orderId == -1) {
    request.setAttribute("reviewError",
            "You have no completed order available to review.");
    request.getRequestDispatcher("/product?productId=" + productId)
           .forward(request, response);
    return;
}
System.out.println("orderId = " + orderId);
System.out.println("productId = " + productId);
System.out.println("customerId = " + customerId);
        

        reviewDAO.addReview(orderId, productId, customerId, rating, comment.trim());
        System.out.println("Preparing to insert review...");
        System.out.println("Insert finished.");

        // Redirect back to the product page after successful submission
        response.sendRedirect(request.getContextPath()
                + "/product?productId=" + productId + "&reviewSuccess=1");
    }
}
