<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenFarm - Fresh Agricultural Products</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-leaf-fill me-2"></i>GreenFarm
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/about">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/branches">Branches</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.customer}">
                            <li class="nav-item">
                                <span class="nav-link text-white">
                                    <i class="bi bi-person-circle me-1"></i>${sessionScope.customer.fullName}
                                </span>
                            </li>
                            <c:if test="${sessionScope.customer.role == 'admin'}">
                                <li class="nav-item">
                                    <a class="nav-link"
                                       href="${pageContext.request.contextPath}/admin/dashboard">
                                        <i class="bi bi-speedometer2 me-1"></i>Manager
                                    </a>
                                </li>
                            </c:if>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="bi bi-cart3 me-1"></i>Cart
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/my-orders">
                                    <i class="bi bi-clock-history me-1"></i>My Orders
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                                    <i class="bi bi-person-gear me-1"></i>Profile
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-light btn-sm ms-2" href="${pageContext.request.contextPath}/register">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <c:if test="${not empty sessionScope.successMessage}">
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="orderToast" class="toast text-bg-success border-0">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.successMessage}
                </div>
                <button type="button"
                        class="btn-close btn-close-white me-2 m-auto"
                        data-bs-dismiss="toast">
                </button>
            </div>
        </div>
    </div>
    <c:remove var="successMessage" scope="session"/>
    </c:if>

    <!-- Search Bar -->
    <div class="bg-light py-3 border-bottom">
        <div class="container">
            <form action="${pageContext.request.contextPath}/home" method="get" class="d-flex gap-2">
                <c:if test="${not empty param.categoryId}">
                    <input type="hidden" name="categoryId" value="${param.categoryId}">
                </c:if>
                <input type="text" name="keyword" class="form-control"
                       placeholder="Search for products..." value="${param.keyword}">
                <button type="submit" class="btn btn-success px-4">
                    <i class="bi bi-search"></i>
                </button>
            </form>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container my-4">
        <div class="row">

            <!-- Category Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white fw-semibold">
                        <i class="bi bi-grid-fill me-2"></i>Categories
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <a href="${pageContext.request.contextPath}/home?keyword=${param.keyword}"
                               class="text-decoration-none ${empty param.categoryId ? 'fw-semibold text-success' : 'text-dark'}">
                                All Products
                            </a>
                        </li>
                        <c:forEach var="category" items="${categoryList}">
                            <li class="list-group-item">
                                <a href="${pageContext.request.contextPath}/home?categoryId=${category.categoryId}&keyword=${param.keyword}"
                                   class="text-decoration-none ${param.categoryId == category.categoryId ? 'fw-semibold text-success' : 'text-dark'}">
                                    ${category.categoryName}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>

            <!-- Product Section -->
            <div class="col-lg-9 col-md-8">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                    <h5 class="mb-0 fw-semibold text-success">
                        <i class="bi bi-box-seam me-2"></i>
                        <c:choose>
                            <c:when test="${not empty param.keyword and not empty param.categoryId}">
                                Results for "<strong>${param.keyword}</strong>" in selected category
                            </c:when>
                            <c:when test="${not empty param.keyword}">
                                Results for "<strong>${param.keyword}</strong>"
                            </c:when>
                            <c:when test="${not empty param.categoryId}">
                                Products in selected category
                            </c:when>
                            <c:otherwise>
                                Our Products
                            </c:otherwise>
                        </c:choose>
                    </h5>
                    <c:if test="${not empty param.keyword or not empty param.categoryId}">
                        <a href="${pageContext.request.contextPath}/home"
                           class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-x-circle me-1"></i>Clear filter
                        </a>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${empty productList}">
                        <div class="alert alert-info">No products found.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-xl-3 g-4">
                            <c:forEach var="product" items="${productList}">
                                <div class="col">
                                    <div class="card h-100 shadow-sm">
                                        <img src="${pageContext.request.contextPath}/images/${product.image}"
                                             class="card-img-top"
                                             alt="${product.productName}"
                                             style="height: 200px; object-fit: cover;"
                                             onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                        <div class="card-body d-flex flex-column">
                                            <h6 class="card-title fw-semibold">${product.productName}</h6>
                                            <p class="text-success fw-bold mb-3">
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                                            </p>
                                            <c:choose>
                                                <c:when test="${product.quantity > 0}">
                                                    <p class="text-muted mb-2">
                                                        <i class="bi bi-box-seam"></i>
                                                        Stock: <strong>${product.quantity}</strong>
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-danger fw-bold mb-2">
                                                        <i class="bi bi-x-circle"></i>
                                                        Out of Stock
                                                    </p>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="mt-auto d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/product?productId=${product.productId}"
                                                   class="btn btn-outline-success btn-sm flex-fill">
                                                    <i class="bi bi-eye me-1"></i>View Details
                                                </a>
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="flex-fill">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <input type="hidden" name="productName" value="${product.productName}">
                                                    <input type="hidden" name="price" value="${product.price}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <c:choose>
                                                        <c:when test="${product.quantity > 0}">
                                                            <button type="submit" class="btn btn-success btn-sm w-100">
                                                                <i class="bi bi-cart-plus me-1"></i>Add to Cart
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn btn-secondary btn-sm w-100" disabled>
                                                                Out of Stock
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav class="mt-4 d-flex justify-content-center" aria-label="Product pages">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/home?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty categoryId ? '&categoryId='.concat(categoryId) : ''}">
                                &laquo;
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/home?page=${p}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty categoryId ? '&categoryId='.concat(categoryId) : ''}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/home?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty categoryId ? '&categoryId='.concat(categoryId) : ''}">
                                &raquo;
                            </a>
                        </li>
                    </ul>
                </nav>
                <p class="text-center text-muted small mt-1">
                    Showing page ${currentPage} of ${totalPages}
                    (${totalProducts} products total)
                </p>
            </c:if>

        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-success text-white mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6 mb-3 mb-md-0">
                    <h6 class="fw-bold"><i class="bi bi-leaf-fill me-2"></i>GreenFarm</h6>
                    <p class="mb-0 small">Fresh and organic agricultural products delivered to your door.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-1 small"><i class="bi bi-telephone me-1"></i>+84 359 151 256</p>
                    <p class="mb-1 small"><i class="bi bi-envelope me-1"></i>GreenfarmVN@gmail.com</p>
                    <p class="mb-0 small"><i class="bi bi-geo-alt me-1"></i>Da Nang City, Viet Nam</p>
                </div>
            </div>
            <hr class="border-light mt-3 mb-2">
            <p class="text-center mb-0 small">&copy; 2024 GreenFarm Viet Nam.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
document.addEventListener("DOMContentLoaded", function () {
    const toastEl = document.getElementById("orderToast");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
        toast.show();
    }
});
    </script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
