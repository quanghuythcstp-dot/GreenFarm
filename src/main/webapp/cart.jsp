<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - GreenFarm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <!-- Navigation Bar -->
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Products</a>
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
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/cart">
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

    <div class="container py-4">
        <h3 class="fw-bold mb-4 text-success">
            <i class="bi bi-cart3 me-2"></i>Shopping Cart
        </h3>

        <!-- Stock error set by OrderServlet when a product has insufficient stock -->
        <c:if test="${not empty sessionScope.stockError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.stockError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="stockError" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${empty cart}">
                <div class="text-center py-5">
                    <i class="bi bi-cart-x display-1 text-muted"></i>
                    <h5 class="mt-3 text-muted">Your cart is empty.</h5>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-success mt-3">
                        <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="row g-4">

                    <!-- Cart Table -->
                    <div class="col-12">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-success">
                                            <tr>
                                                <th class="ps-3">Product</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Subtotal</th>
                                                <th class="text-center">Remove</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="entry" items="${cart}">
                                                <c:set var="item" value="${entry.value}" />
                                                <tr>
                                                    <!-- Product Image + Name -->
                                                    <td class="ps-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <img src="${pageContext.request.contextPath}/images/${item.product.image}"
                                                                 alt="${item.product.productName}"
                                                                 style="width: 60px; height: 60px; object-fit: cover;"
                                                                 class="rounded"
                                                                 onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                                            <span class="fw-semibold">${item.product.productName}</span>
                                                        </div>
                                                    </td>

                                                    <!-- Price -->
                                                    <td class="text-success fw-semibold">
                                                        <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="$"/>
                                                    </td>

                                                    <!-- Update Quantity -->
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/cart" method="post"
                                                              class="d-flex align-items-center gap-2">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="productId" value="${item.product.productId}">
                                                            <input type="number" name="quantity"
                                                                   value="${item.quantity}"
                                                                   min="1" max="999"
                                                                   class="form-control form-control-sm"
                                                                   style="width: 75px;"
                                                                   onchange="this.form.submit()">
                                                        </form>
                                                    </td>

                                                    <!-- Subtotal -->
                                                    <td class="fw-bold">
                                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/>
                                                    </td>

                                                    <!-- Remove -->
                                                    <td class="text-center">
                                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                                            <input type="hidden" name="action" value="remove">
                                                            <input type="hidden" name="productId" value="${item.product.productId}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                    title="Remove item">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr class="table-light">
                                                <td colspan="3" class="text-end fw-bold ps-3">Total:</td>
                                                <td colspan="2" class="fw-bold text-success fs-5">
                                                    <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="$"/>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Checkout Form -->
                    <div class="col-12 col-lg-6">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-success text-white fw-semibold">
                                <i class="bi bi-bag-check me-2"></i>Ready to Order?
                            </div>
                            <div class="card-body p-4">
                                <p class="text-muted mb-4" style="font-size:.9rem;">
                                    Review your items above, then proceed to checkout to enter
                                    delivery details and choose your payment method.
                                </p>
                                <div class="d-flex gap-3 flex-wrap">
                                    <a href="${pageContext.request.contextPath}/checkout"
                                       class="btn btn-success btn-lg flex-fill">
                                        <i class="bi bi-bag-check me-2"></i>Proceed to Checkout
                                    </a>
                                    <a href="${pageContext.request.contextPath}/home"
                                       class="btn btn-outline-secondary btn-lg flex-fill">
                                        <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Summary -->
                    <div class="col-12 col-lg-6">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-success text-white fw-semibold">
                                <i class="bi bi-receipt me-2"></i>Order Summary
                            </div>
                            <div class="card-body p-4">
                                <c:forEach var="entry" items="${cart}">
                                    <c:set var="item" value="${entry.value}" />
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">
                                            ${item.product.productName}
                                            <span class="badge bg-secondary ms-1">x${item.quantity}</span>
                                        </span>
                                        <span class="fw-semibold">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/>
                                        </span>
                                    </div>
                                </c:forEach>
                                <hr>
                                <div class="d-flex justify-content-between">
                                    <span class="fw-bold fs-5">Total</span>
                                    <span class="fw-bold fs-5 text-success">
                                        <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="$"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </c:otherwise>
        </c:choose>
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
                    <p class="mb-1 small"><i class="bi bi-telephone me-1"></i>+84 123 456 789</p>
                    <p class="mb-1 small"><i class="bi bi-envelope me-1"></i>contact@greenfarm.vn</p>
                    <p class="mb-0 small"><i class="bi bi-geo-alt me-1"></i>Ho Chi Minh City, Vietnam</p>
                </div>
            </div>
            <hr class="border-light mt-3 mb-2">
            <p class="text-center mb-0 small">&copy; 2024 GreenFarm Viet Nam.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
