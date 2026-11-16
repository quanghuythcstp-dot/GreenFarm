package controller;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Customer;
import utils.Validation;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

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
                listCategories(request, response);
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
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        switch (action) {
            case "insert":
                insertCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
        }
    }

    // ----------------------------------------------------------------
    // GET handlers
    // ----------------------------------------------------------------

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categoryList = categoryDAO.getAllCategories();

        // Attach product count to each category so the JSP can display it
        // without needing a Map — store counts in a parallel int array
        int[] productCounts = new int[categoryList.size()];
        for (int i = 0; i < categoryList.size(); i++) {
            productCounts[i] = categoryDAO.countProductsByCategory(
                    categoryList.get(i).getCategoryId());
        }

        request.setAttribute("categoryList", categoryList);
        request.setAttribute("productCounts", productCounts);
        request.getRequestDispatcher("/admin/category-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/category-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        int categoryId = Integer.parseInt(idParam);
        Category category = categoryDAO.getCategoryById(categoryId);

        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/category-edit.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------
    // POST handlers
    // ----------------------------------------------------------------

    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryName = request.getParameter("categoryName");
        String description  = request.getParameter("description");

        // Validate: name required
        if (Validation.isEmpty(categoryName)) {
            request.setAttribute("error", "Category name is required.");
            request.setAttribute("description", description);
            showAddForm(request, response);
            return;
        }

        // Validate: no duplicate name (excludeId = 0 for new insert)
        if (categoryDAO.isCategoryNameExists(categoryName.trim(), 0)) {
            request.setAttribute("error", "Category name already exists. Please choose a different name.");
            request.setAttribute("categoryName", categoryName);
            request.setAttribute("description", description);
            showAddForm(request, response);
            return;
        }

        Category category = new Category(0, categoryName.trim(), description);
        categoryDAO.insert(category);

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdParam = request.getParameter("categoryId");
        String categoryName    = request.getParameter("categoryName");
        String description     = request.getParameter("description");

        if (categoryIdParam == null || !categoryIdParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdParam);

        // Validate: name required
        if (Validation.isEmpty(categoryName)) {
            request.setAttribute("error", "Category name is required.");
            request.setAttribute("category", categoryDAO.getCategoryById(categoryId));
            request.getRequestDispatcher("/admin/category-edit.jsp").forward(request, response);
            return;
        }

        // Validate: no duplicate name (excludeId = current id so same name is allowed)
        if (categoryDAO.isCategoryNameExists(categoryName.trim(), categoryId)) {
            request.setAttribute("error", "Category name already exists. Please choose a different name.");
            request.setAttribute("category", new Category(categoryId, categoryName, description));
            request.getRequestDispatcher("/admin/category-edit.jsp").forward(request, response);
            return;
        }

        Category category = new Category(categoryId, categoryName.trim(), description);
        categoryDAO.update(category);

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        int categoryId = Integer.parseInt(idParam);

        // Guard: do not delete if category still has products
        int productCount = categoryDAO.countProductsByCategory(categoryId);
        if (productCount > 0) {
            List<Category> categoryList = categoryDAO.getAllCategories();
            int[] productCounts = new int[categoryList.size()];
            for (int i = 0; i < categoryList.size(); i++) {
                productCounts[i] = categoryDAO.countProductsByCategory(
                        categoryList.get(i).getCategoryId());
            }
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("productCounts", productCounts);
            request.setAttribute("error",
                    "Cannot delete this category because it still contains "
                    + productCount + " product(s). Please remove or reassign them first.");
            request.getRequestDispatcher("/admin/category-list.jsp").forward(request, response);
            return;
        }

        categoryDAO.delete(categoryId);
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
