package controller;

import dao.ProductDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Customer;
import model.Product;
import model.Review;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final ReviewDAO  reviewDAO  = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("productId");

        // Validate productId parameter
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int productId = Integer.parseInt(idParam);
        Product product = productDAO.getProductById(productId);

        // Redirect to home if product does not exist
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Load review data for this product
        List<Review> reviewList  = reviewDAO.getReviewsByProduct(productId);
        System.out.println("Review count = " + reviewList.size());

for (Review r : reviewList) {
    System.out.println("Review: " + r.getComment());
}
        double       avgRating   = reviewDAO.getAverageRating(productId);
        int          reviewCount = reviewDAO.getReviewCount(productId);

        request.setAttribute("product",     product);
        request.setAttribute("reviewList",  reviewList);
        request.setAttribute("avgRating",   avgRating);
        request.setAttribute("reviewCount", reviewCount);

        // Load customer-specific review state from session
        Customer customer = (Customer) request.getSession().getAttribute("customer");

if (customer != null) {

    int customerId = customer.getCustomerId();

    int reviewableOrderId =
            reviewDAO.getReviewableOrderId(customerId, productId);

    Review existingReview = null;

if (reviewableOrderId != -1) {
    existingReview = reviewDAO.getCustomerReview(
            reviewableOrderId,
            productId,
            customerId
    );
}

    request.setAttribute("reviewableOrderId", reviewableOrderId);
    request.setAttribute("existingReview", existingReview);
}

        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }
}
