<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Config - GreenFarm Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

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
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-1"></i>Products</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-grid me-1"></i>Categories</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/customers"><i class="bi bi-people me-1"></i>Customers</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-receipt me-1"></i>Orders</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/messages"><i class="bi bi-envelope me-1"></i>Messages</a></li>
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/delivery-config"><i class="bi bi-truck me-1"></i>Shipping</a></li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home"><i class="bi bi-house me-1"></i>Back to Site</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-1"></i>Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="bg-white border-bottom py-3">
        <div class="container-fluid">
            <h4 class="mb-0 text-success">
                <i class="bi bi-truck me-2"></i>Delivery Fee Management
            </h4>
        </div>
    </div>

    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-9">

                <!-- Alerts -->
                <c:if test="${param.success == '1'}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="bi bi-check-circle-fill me-2"></i>Changes saved successfully.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- ── SECTION 1: Edit existing methods ── -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Delivery Methods</h5>
                    </div>
                    <div class="card-body p-4">
                        <p class="text-muted small mb-4">
                            <i class="bi bi-info-circle me-1"></i>
                            Changes take effect immediately for all new orders. Fee unit: <strong>VND (đ)</strong>.
                        </p>

                        <c:choose>
                            <c:when test="${empty configList}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                    No delivery methods found. Please run
                                    <code>add_delivery_config.sql</code> first, then add a new method below.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/admin/delivery-config"
                                      method="post">
                                    <c:forEach var="config" items="${configList}">
                                        <div class="card mb-3 border" style="border-radius:12px;overflow:hidden;">
                                            <div class="card-header d-flex justify-content-between align-items-center"
                                                 style="background:#f0faf5;border-bottom:1.5px solid #d1e7dd;">
                                                <span class="fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${config.methodKey == 'express'}">
                                                            <i class="bi bi-lightning-charge-fill text-warning me-1"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-bicycle text-success me-1"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    ${config.methodName}
                                                    <span class="badge bg-secondary ms-1 text-uppercase" style="font-size:.65rem;">${config.methodKey}</span>
                                                </span>
                                                <!-- Delete button for this method -->
                                                <button type="submit"
                                                        form="deleteForm${config.configId}"
                                                        class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('Delete \'${config.methodName}\'?');">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                            <div class="card-body p-3">
                                                <input type="hidden" name="configId" value="${config.configId}">
                                                <div class="row g-3 align-items-end">
                                                    <div class="col-md-4">
                                                        <label class="form-label fw-semibold small">Fee (VND) <span class="text-danger">*</span></label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-white"><i class="bi bi-cash-coin text-success"></i></span>
                                                            <input type="number" name="fee"
                                                                   class="form-control"
                                                                   value="${config.fee}"
                                                                   min="0" step="500" required>
                                                            <span class="input-group-text bg-white">đ</span>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-8">
                                                        <label class="form-label fw-semibold small">Description shown to customer</label>
                                                        <input type="text" name="description"
                                                               class="form-control"
                                                               value="${config.description}"
                                                               placeholder="e.g. Delivered within 2–4 hours">
                                                    </div>
                                                </div>
                                                <div class="mt-2 p-2 rounded" style="background:#f8f9fa;border:1px dashed #dee2e6;">
                                                    <small class="text-muted">
                                                        <i class="bi bi-eye me-1"></i>Preview:
                                                        <strong>${config.methodName}</strong> —
                                                        <span class="text-success fw-bold">
                                                            <fmt:formatNumber value="${config.fee}" type="number" groupingUsed="true"/> đ
                                                        </span>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="d-flex gap-3 mt-3">
                                        <button type="submit" class="btn btn-success px-4">
                                            <i class="bi bi-check-circle me-2"></i>Save All Changes
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                                           class="btn btn-outline-secondary px-4">
                                            <i class="bi bi-x-circle me-2"></i>Cancel
                                        </a>
                                    </div>
                                </form>

                                <%-- Hidden delete forms (one per row) --%>
                                <c:forEach var="config" items="${configList}">
                                    <form id="deleteForm${config.configId}"
                                          action="${pageContext.request.contextPath}/admin/delivery-config"
                                          method="post">
                                        <input type="hidden" name="action"   value="delete">
                                        <input type="hidden" name="configId" value="${config.configId}">
                                    </form>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- ── SECTION 2: Add new method ── -->
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white border-bottom">
                        <h5 class="mb-0 text-success">
                            <i class="bi bi-plus-circle me-2"></i>Add New Delivery Method
                        </h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/admin/delivery-config"
                              method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold small">Method Name <span class="text-danger">*</span></label>
                                    <input type="text" name="newMethodName" class="form-control"
                                           placeholder="e.g. Same Day Delivery" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-semibold small">Fee (VND) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" name="newFee" class="form-control"
                                               placeholder="0" min="0" step="500" required>
                                        <span class="input-group-text bg-white">đ</span>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label fw-semibold small">Description</label>
                                    <input type="text" name="newDescription" class="form-control"
                                           placeholder="e.g. Delivered within 30 minutes">
                                </div>
                            </div>
                            <div class="mt-3">
                                <button type="submit" class="btn btn-outline-success px-4">
                                    <i class="bi bi-plus-lg me-2"></i>Add Method
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
