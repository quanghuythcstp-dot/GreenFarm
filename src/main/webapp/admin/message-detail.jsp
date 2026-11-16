<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message #${message.messageId} - GreenFarm Admin</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-receipt me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/messages">
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

    <!-- Breadcrumb -->
    <div class="bg-white border-bottom py-3">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/admin/messages"
                               class="text-success text-decoration-none">Messages</a>
                        </li>
                        <li class="breadcrumb-item active">Message #${message.messageId}</li>
                    </ol>
                </nav>
                <a href="${pageContext.request.contextPath}/admin/messages"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Back to Messages
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-envelope-open me-2"></i>Message #${message.messageId}
                        </h5>
                        <c:choose>
                            <c:when test="${message.status == 'New'}">
                                <span class="badge bg-danger">New</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-light text-success">Read</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body p-4">

                        <!-- Customer Info -->
                        <h6 class="fw-bold text-muted mb-3 text-uppercase" style="font-size:.75rem;letter-spacing:.8px;">
                            Customer Information
                        </h6>
                        <div class="row g-3 mb-4">
                            <div class="col-sm-6">
                                <div class="p-3 rounded-3 bg-light">
                                    <div class="text-muted small mb-1"><i class="bi bi-person me-1"></i>Full Name</div>
                                    <div class="fw-semibold">${message.fullName}</div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="p-3 rounded-3 bg-light">
                                    <div class="text-muted small mb-1"><i class="bi bi-telephone me-1"></i>Phone</div>
                                    <div class="fw-semibold">${message.phoneNumber}</div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="p-3 rounded-3 bg-light">
                                    <div class="text-muted small mb-1"><i class="bi bi-envelope me-1"></i>Email</div>
                                    <div class="fw-semibold">
                                        <c:choose>
                                            <c:when test="${not empty message.email}">${message.email}</c:when>
                                            <c:otherwise><span class="text-muted fst-italic">Not provided</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="p-3 rounded-3 bg-light">
                                    <div class="text-muted small mb-1"><i class="bi bi-clock me-1"></i>Received At</div>
                                    <div class="fw-semibold">
                                        <fmt:formatDate value="${message.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr>

                        <!-- Message Content -->
                        <h6 class="fw-bold text-muted mb-3 text-uppercase" style="font-size:.75rem;letter-spacing:.8px;">
                            Message Content
                        </h6>
                        <div class="mb-3">
                            <div class="text-muted small mb-1">Subject</div>
                            <div class="fw-semibold fs-6">
                                <c:choose>
                                    <c:when test="${not empty message.subject}">${message.subject}</c:when>
                                    <c:otherwise><span class="text-muted fst-italic">No subject</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mb-4">
                            <div class="text-muted small mb-1">Message</div>
                            <div class="p-3 rounded-3 border" style="background:#f8f9fa;line-height:1.7;white-space:pre-wrap;">${message.message}</div>
                        </div>

                        <!-- Action buttons -->
                        <div class="d-flex gap-3 flex-wrap">
                            <a href="${pageContext.request.contextPath}/admin/messages"
                               class="btn btn-outline-secondary px-4">
                                <i class="bi bi-arrow-left me-1"></i>Back
                            </a>
                            <form action="${pageContext.request.contextPath}/admin/messages/detail"
                                  method="post"
                                  onsubmit="return confirm('Permanently delete this message?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${message.messageId}">
                                <button type="submit" class="btn btn-danger px-4">
                                    <i class="bi bi-trash me-1"></i>Delete Message
                                </button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
