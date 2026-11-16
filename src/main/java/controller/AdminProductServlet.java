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
import utils.Validation;
import model.Customer;
@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");

if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "list":
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");

    if (customer == null || !"admin".equalsIgnoreCase(customer.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        switch (action) {
            case "insert":
                insertProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> productList = productDAO.getAllProducts();
        List<Category> categoryList = categoryDAO.getAllCategories();

        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/admin/product-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        int productId = Integer.parseInt(idParam);
        Product product = productDAO.getProductById(productId);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("product", product);
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdParam = request.getParameter("categoryId");
        String productName     = request.getParameter("productName");
        String priceParam      = request.getParameter("price");
        String quantityParam   = request.getParameter("quantity");
        String description     = request.getParameter("description");
        String image           = request.getParameter("image");

        // Validate product name
        if (Validation.isEmpty(productName)) {
            request.setAttribute("error", "Product name is required.");
            showAddForm(request, response);
            return;
        }

        // Validate price
        if (!Validation.isNumber(priceParam) || Double.parseDouble(priceParam) <= 0) {
            request.setAttribute("error", "Price must be greater than 0.");
            showAddForm(request, response);
            return;
        }

        // Validate quantity
        if (!Validation.isNumber(quantityParam) || Integer.parseInt(quantityParam) < 0) {
            request.setAttribute("error", "Quantity must be 0 or greater.");
            showAddForm(request, response);
            return;
        }

        int categoryId = Integer.parseInt(categoryIdParam);
        double price   = Double.parseDouble(priceParam);
        int quantity   = Integer.parseInt(quantityParam);

        Product product = new Product(0, categoryId, productName.trim(),
                price, quantity, description, image);
        productDAO.insert(product);

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdParam  = request.getParameter("productId");
        String categoryIdParam = request.getParameter("categoryId");
        String productName     = request.getParameter("productName");
        String priceParam      = request.getParameter("price");
        String quantityParam   = request.getParameter("quantity");
        String description     = request.getParameter("description");
        String image           = request.getParameter("image");

        // Validate product name
        if (Validation.isEmpty(productName)) {
            request.setAttribute("error", "Product name is required.");
            showEditForm(request, response);
            return;
        }

        // Validate price
        if (!Validation.isNumber(priceParam) || Double.parseDouble(priceParam) <= 0) {
            request.setAttribute("error", "Price must be greater than 0.");
            showEditForm(request, response);
            return;
        }

        // Validate quantity
        if (!Validation.isNumber(quantityParam) || Integer.parseInt(quantityParam) < 0) {
            request.setAttribute("error", "Quantity must be 0 or greater.");
            showEditForm(request, response);
            return;
        }

        int productId  = Integer.parseInt(productIdParam);
        int categoryId = Integer.parseInt(categoryIdParam);
        double price   = Double.parseDouble(priceParam);
        int quantity   = Integer.parseInt(quantityParam);

        Product product = new Product(productId, categoryId, productName.trim(),
                price, quantity, description, image);
        productDAO.update(product);

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && idParam.matches("\\d+")) {
            int productId = Integer.parseInt(idParam);
            productDAO.delete(productId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
