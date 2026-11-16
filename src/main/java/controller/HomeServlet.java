package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Product;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private static final int PAGE_SIZE = 9; // products per page

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductDAO  productDAO  = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword         = request.getParameter("keyword");
        String categoryIdParam = request.getParameter("categoryId");
        String pageParam       = request.getParameter("page");

        // Normalise inputs
        String  kw         = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : "";
        int     categoryId = (categoryIdParam != null && categoryIdParam.matches("\\d+"))
                             ? Integer.parseInt(categoryIdParam) : 0;
        int     page       = 1;
        if (pageParam != null && pageParam.matches("\\d+")) {
            page = Integer.parseInt(pageParam);
            if (page < 1) page = 1;
        }

        // Count total matching products and calculate total pages
        int totalProducts = productDAO.countProducts(kw, categoryId);
        int totalPages    = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * PAGE_SIZE;

        // Fetch only the products for the current page
        List<Product>  productList  = productDAO.getProductsPaged(kw, categoryId, offset, PAGE_SIZE);
        List<Category> categoryList = categoryDAO.getAllCategories();

        request.setAttribute("categoryList",   categoryList);
        request.setAttribute("productList",    productList);
        request.setAttribute("currentPage",    page);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("totalProducts",  totalProducts);
        request.setAttribute("keyword",        kw);
        request.setAttribute("categoryId",     categoryId > 0 ? String.valueOf(categoryId) : "");

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
