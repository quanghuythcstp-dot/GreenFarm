<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #${order.orderId} - GreenFarm Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Admin Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-leaf-fill me-2"></i>GreenFarm Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarAdmin">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">
                            <i class="bi bi-box-seam me-1"></i>Products
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="bi bi-grid me-1"></i>Categories
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/customers">
                            <i class="bi bi-people me-1"></i>Customers
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-receipt me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">
                            <i class="bi bi-envelope me-1"></i>Messages
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/delivery-config">
                            <i class="bi bi-truck me-1"></i>Shipping
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">
                            <i class="bi bi-house me-1"></i>Back to Site
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-1"></i>Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Page Header / Breadcrumb -->
    <div class="bg-white border-bottom py-3">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/admin/orders"
                               class="text-success text-decoration-none">Orders</a>
                        </li>
                        <li class="breadcrumb-item active">Order #${order.orderId}</li>
                    </ol>
                </nav>
                <a href="${pageContext.request.contextPath}/admin/orders"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Back to Orders
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container-fluid py-4">

        <!-- Status error alert -->
        <c:if test="${not empty statusError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${statusError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">

            <!-- Left column: Order Information + Status Management -->
            <div class="col-12 col-lg-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>Order Information
                        </h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless mb-0">
                            <tbody>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0" style="width: 130px;">Order ID</td>
                                    <td class="fw-bold">#${order.orderId}</td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Customer</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty orderCustomer}">
                                                ${orderCustomer.fullName}
                                                <br>
                                                <small class="text-muted">
                                                    <i class="bi bi-envelope me-1"></i>${orderCustomer.email}
                                                </small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">ID: ${order.customerId}</span>
                                            </c:otherwise>
                                        </c:choose>
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
                                    <td class="fw-semibold text-muted ps-0">Order Date</td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDate}"
                                                        pattern="dd/MM/yyyy"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Total</td>
                                    <td class="text-success fw-bold">
                                        <fmt:formatNumber value="${order.totalAmount}"
                                                          type="currency" currencySymbol="$"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Delivery</td>
                                    <td>
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
                                    <td class="fw-semibold text-muted ps-0">Order Note</td>
                                    <td class="text-muted fst-italic" style="white-space:pre-wrap;">${order.orderNote}</td>
                                </tr>
                                </c:if>
                                <tr>
                                    <td class="fw-semibold text-muted ps-0">Status</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Confirmed'}">
                                                <span class="badge bg-info text-dark">Confirmed</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Shipping'}">
                                                <span class="badge bg-primary">Shipping</span>
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
                            </tbody>
                        </table>

                        <!-- Status Management form -->
                        <c:if test="${not empty allowedStatuses}">
                            <hr>
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <label for="statusSelect" class="form-label fw-semibold mb-2">
                                    <i class="bi bi-arrow-repeat me-1"></i>Update Status
                                </label>
                                <div class="d-flex gap-2">
                                    <select id="statusSelect" name="status" class="form-select">
                                        <c:forEach var="s" items="${allowedStatuses}">
                                            <option value="${s}">${s}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="submit" class="btn btn-success px-3 text-nowrap">
                                        <i class="bi bi-check-circle me-1"></i>Update Status
                                    </button>
                                </div>
                            </form>
                        </c:if>

                        <c:if test="${empty allowedStatuses}">
                            <hr>
                            <p class="text-muted small mb-0">
                                <i class="bi bi-lock me-1"></i>
                                No further status changes are allowed for this order.
                            </p>
                        </c:if>

                    </div>
                </div>
            </div>

            <!-- Right column: Products table -->
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

        <!-- Back to Orders button -->
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/admin/orders"
               class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Back to Orders
            </a>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
