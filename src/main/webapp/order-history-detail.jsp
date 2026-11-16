<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #${order.orderId} - GreenFarm</title>
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
                    <li class="nav-item">
                        <span class="nav-link text-white">
                            <i class="bi bi-person-circle me-1"></i>${sessionScope.customer.fullName}
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="bi bi-cart3 me-1"></i>Cart
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/my-orders">
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
                </ul>
            </div>
        </div>
    </nav>

    <!-- Page Header / Breadcrumb -->
    <div class="bg-white border-bottom py-3">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/my-orders"
                               class="text-success text-decoration-none">My Orders</a>
                        </li>
                        <li class="breadcrumb-item active">Order #${order.orderId}</li>
                    </ol>
                </nav>
                <a href="${pageContext.request.contextPath}/my-orders"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Back to My Orders
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container py-4">
        <div class="row g-4">

            <!-- Order Information -->
            <div class="col-12 col-lg-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>Order Information
                        </h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless mb-0">
                            <tbody>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0" style="width: 120px;">Order ID</td>
                                    <td class="fw-bold">#${order.orderId}</td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Order Date</td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDate}"
                                                        pattern="dd/MM/yyyy"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Receiver</td>
                                    <td>${order.receiverName}</td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Phone</td>
                                    <td>${order.phone}</td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Address</td>
                                    <td>${order.address}</td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Status</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Confirmed'}">
                                                <span class="badge bg-primary">Confirmed</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Shipping'}">
                                                <span class="badge bg-info text-dark">Shipping</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Cancelled'}">
                                                <span class="badge bg-danger">Cancelled</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr class="border-top">
                                    <td class="fw-semibold text-muted ps-0 pt-3">Delivery</td>
                                    <td class="pt-3">
                                        <c:choose>
                                            <c:when test="${order.deliveryMethod == 'express'}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="bi bi-lightning-charge-fill me-1"></i>Express (+$5.00)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    <i class="bi bi-bicycle me-1"></i>Standard (+$2.00)
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Payment</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'bank'}">
                                                <span class="badge bg-info text-dark">
                                                    <i class="bi bi-bank me-1"></i>Bank Transfer
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">
                                                    <i class="bi bi-cash-coin me-1"></i>Cash on Delivery
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <c:if test="${not empty order.orderNote}">
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Note</td>
                                    <td class="text-muted fst-italic" style="white-space:pre-wrap;">${order.orderNote}</td>
                                </tr>
                                </c:if>
                                <tr class="border-top">
                                    <td class="fw-semibold text-muted ps-0 pt-3">Total</td>
                                    <td class="text-success fw-bold fs-5 pt-3">
                                        <fmt:formatNumber value="${order.totalAmount}"
                                                          type="currency" currencySymbol="$"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Order Items -->
            <div class="col-12 col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-cart3 me-2"></i>Order Items
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty detailList}">
                                <div class="text-center py-4">
                                    <p class="text-muted mb-0">No items found for this order.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="ps-3">Product</th>
                                                <th>Price</th>
                                                <th>Qty</th>
                                                <th>Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="detail" items="${detailList}">
                                                <c:set var="product" value="${productMap[detail.productId]}"/>
                                                <tr>
                                                    <td class="ps-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <c:choose>
                                                                <c:when test="${not empty product}">
                                                                    <img src="${pageContext.request.contextPath}/images/${product.image}"
                                                                         alt="${product.productName}"
                                                                         style="width: 55px; height: 55px; object-fit: cover;"
                                                                         class="rounded border"
                                                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                                                    <span class="fw-semibold">${product.productName}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/images/default.jpg"
                                                                         alt="Product"
                                                                         style="width: 55px; height: 55px; object-fit: cover;"
                                                                         class="rounded border">
                                                                    <span class="text-muted">
                                                                        Product ID: ${detail.productId}
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${detail.price}"
                                                                          type="currency" currencySymbol="$"/>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary">${detail.quantity}</span>
                                                    </td>
                                                    <td class="fw-bold text-success">
                                                        <fmt:formatNumber value="${detail.subtotal}"
                                                                          type="currency" currencySymbol="$"/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr class="table-success">
                                                <td colspan="3" class="text-end fw-bold ps-3">Order Total:</td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${order.totalAmount}"
                                                                      type="currency" currencySymbol="$"/>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

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
