<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - GreenFarm Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Admin Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-leaf-fill me-2"></i>GreenFarm Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarAdmin">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-receipt me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">
                            <i class="bi bi-envelope me-1"></i>Messages
                            <c:if test="${newMessageCount > 0}">
                                <span class="badge bg-danger ms-1">${newMessageCount}</span>
                            </c:if>
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

    <!-- Page Header -->
    <div class="bg-white border-bottom py-3">
        <div class="container-fluid">
            <h4 class="mb-0 text-success">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </h4>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container-fluid py-4">

        <!-- Stat Cards -->
        <div class="row g-4 mb-4">

            <!-- Products -->
            <div class="col-6 col-md-4 col-xl">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-success bg-opacity-10 p-3">
                            <i class="bi bi-box-seam fs-3 text-success"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Products</div>
                            <div class="fw-bold fs-3 lh-1">${totalProducts}</div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0 pb-3 px-3">
                        <a href="${pageContext.request.contextPath}/admin/products"
                           class="btn btn-sm btn-outline-success w-100">
                            Manage
                        </a>
                    </div>
                </div>
            </div>

            <!-- Categories -->
            <div class="col-6 col-md-4 col-xl">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-success bg-opacity-10 p-3">
                            <i class="bi bi-grid fs-3 text-success"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Categories</div>
                            <div class="fw-bold fs-3 lh-1">${totalCategories}</div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0 pb-3 px-3">
                        <a href="${pageContext.request.contextPath}/admin/categories"
                           class="btn btn-sm btn-outline-success w-100">
                            Manage
                        </a>
                    </div>
                </div>
            </div>

            <!-- Customers -->
            <div class="col-6 col-md-4 col-xl">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-success bg-opacity-10 p-3">
                            <i class="bi bi-people fs-3 text-success"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Customers</div>
                            <div class="fw-bold fs-3 lh-1">${totalCustomers}</div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0 pb-3 px-3">
                        <a href="${pageContext.request.contextPath}/admin/customers"
                           class="btn btn-sm btn-outline-success w-100">
                            View
                        </a>
                    </div>
                </div>
            </div>

            <!-- Orders -->
            <div class="col-6 col-md-4 col-xl">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-success bg-opacity-10 p-3">
                            <i class="bi bi-receipt fs-3 text-success"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Orders</div>
                            <div class="fw-bold fs-3 lh-1">${totalOrders}</div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0 pb-3 px-3">
                        <a href="${pageContext.request.contextPath}/admin/orders"
                           class="btn btn-sm btn-outline-success w-100">
                            Manage
                        </a>
                    </div>
                </div>
            </div>

            <!-- Messages -->
            <div class="col-6 col-md-4 col-xl">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="rounded-circle p-3" style="background:rgba(220,53,69,.1);">
                            <i class="bi bi-envelope fs-3" style="color:#dc3545;"></i>
                        </div>
                        <div>
                            <div class="text-muted small">New Messages</div>
                            <div class="fw-bold fs-3 lh-1" style="color:#dc3545;">${newMessageCount}</div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0 pb-3 px-3">
                        <a href="${pageContext.request.contextPath}/admin/messages"
                           class="btn btn-sm btn-outline-danger w-100">
                            View Messages
                        </a>
                    </div>
                </div>
            </div>

            <!-- Revenue -->
            <div class="col-12 col-md-4 col-xl">
                <div class="card border-0 shadow-sm h-100 bg-success text-white">                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white bg-opacity-25 p-3">
                            <i class="bi bi-currency-dollar fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="small opacity-75">Total Revenue</div>
                            <div class="fw-bold fs-3 lh-1">
                                <fmt:formatNumber value="${totalRevenue}"
                                                  type="currency" currencySymbol="$"/>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 border-top border-white border-opacity-25 pt-0 pb-3 px-3">
                        <a href="${pageContext.request.contextPath}/admin/revenue"
                           class="btn btn-sm btn-light w-100 text-success fw-semibold">
                            View Revenue
                        </a>
                    </div>
                </div>
            </div>

        </div>

        <!-- Latest Orders Table -->
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center py-3">
                <h5 class="mb-0 text-success">
                    <i class="bi bi-clock-history me-2"></i>Latest Orders
                </h5>
                <a href="${pageContext.request.contextPath}/admin/orders"
                   class="btn btn-sm btn-outline-success">
                    View All
                </a>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty latestOrders}">
                        <div class="text-center py-5">
                            <i class="bi bi-inbox display-1 text-muted"></i>
                            <h5 class="mt-3 text-muted">No orders yet.</h5>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-success">
                                    <tr>
                                        <th class="ps-3">Order ID</th>
                                        <th>Customer</th>
                                        <th>Order Date</th>
                                        <th>Receiver Name</th>
                                        <th>Phone</th>
                                        <th>Total Amount</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${latestOrders}">
                                        <tr>
                                            <td class="ps-3 fw-semibold">#${order.orderId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customerMap[order.customerId]}">
                                                        <span class="fw-semibold">
                                                            ${customerMap[order.customerId].fullName}
                                                        </span>
                                                        <br>
                                                        <small class="text-muted">ID: ${order.customerId}</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">ID: ${order.customerId}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${order.orderDate}"
                                                                pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>${order.receiverName}</td>
                                            <td>${order.phone}</td>
                                            <td class="text-success fw-bold">
                                                <fmt:formatNumber value="${order.totalAmount}"
                                                                  type="currency" currencySymbol="$"/>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.orderId}"
                                                   class="btn btn-sm btn-outline-success"
                                                   title="View order details">
                                                    <i class="bi bi-eye me-1"></i>View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
