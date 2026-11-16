package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Product;

@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load 6 featured products for the Featured Products section
        List<Product> featuredProducts = productDAO.getProductsPaged("", 0, 0, 6);
        request.setAttribute("featuredProducts", featuredProducts);
        request.getRequestDispatcher("/about.jsp").forward(request, response);
    }
}
