<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - GreenFarm</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/my-orders">
                            <i class="bi bi-clock-history me-1"></i>My Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/profile">
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

    <!-- Page Header -->
    <div class="bg-white border-bottom py-3">
        <div class="container">
            <h4 class="mb-0 text-success">
                <i class="bi bi-person-gear me-2"></i>My Profile
            </h4>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container py-4">
        <div class="row g-4 justify-content-center">

            <!-- Card 1: Profile Information -->
            <div class="col-12 col-lg-6">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-person-lines-fill me-2"></i>Profile Information
                        </h5>
                    </div>
                    <div class="card-body p-4">

                        <!-- Success / Error alerts for profile update -->
                        <c:if test="${not empty profileSuccess}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>${profileSuccess}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty profileError}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-circle me-2"></i>${profileError}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/profile" method="post" novalidate>
                            <input type="hidden" name="action" value="update">

                            <!-- Username (read-only) -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-person text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control bg-light"
                                           value="${sessionScope.customer.username}"
                                           readonly>
                                </div>
                                <div class="form-text">Username cannot be changed.</div>
                            </div>

                            <!-- Email (read-only) -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-envelope text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control bg-light"
                                           value="${sessionScope.customer.email}"
                                           readonly>
                                </div>
                                <div class="form-text">Email cannot be changed.</div>
                            </div>

                            <!-- Full Name -->
                            <div class="mb-3">
                                <label for="fullName" class="form-label fw-semibold">
                                    Full Name <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-person-badge text-success"></i>
                                    </span>
                                    <input type="text" id="fullName" name="fullName"
                                           class="form-control"
                                           value="${sessionScope.customer.fullName}"
                                           required>
                                </div>
                            </div>

                            <!-- Phone -->
                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">
                                    Phone <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-telephone text-success"></i>
                                    </span>
                                    <input type="tel" id="phone" name="phone"
                                           class="form-control"
                                           value="${sessionScope.customer.phone}"
                                           placeholder="e.g. 0912345678"
                                           required>
                                </div>
                            </div>

                            <!-- Address -->
                            <div class="mb-4">
                                <label for="address" class="form-label fw-semibold">
                                    Address <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-geo-alt text-success"></i>
                                    </span>
                                    <input type="text" id="address" name="address"
                                           class="form-control"
                                           value="${sessionScope.customer.address}"
                                           required>
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>Save Changes
                                </button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>

            <!-- Card 2: Change Password -->
            <div class="col-12 col-lg-6">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-lock me-2"></i>Change Password
                        </h5>
                    </div>
                    <div class="card-body p-4">

                        <!-- Success / Error alerts for password change -->
                        <c:if test="${not empty passwordSuccess}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>${passwordSuccess}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty passwordError}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-circle me-2"></i>${passwordError}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/profile" method="post"
                              novalidate onsubmit="return validatePasswordForm()">
                            <input type="hidden" name="action" value="password">

                            <!-- Current Password -->
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label fw-semibold">
                                    Current Password <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-lock text-success"></i>
                                    </span>
                                    <input type="password" id="currentPassword" name="currentPassword"
                                           class="form-control"
                                           placeholder="Enter current password"
                                           required>
                                </div>
                            </div>

                            <!-- New Password -->
                            <div class="mb-3">
                                <label for="newPassword" class="form-label fw-semibold">
                                    New Password <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-lock-fill text-success"></i>
                                    </span>
                                    <input type="password" id="newPassword" name="newPassword"
                                           class="form-control"
                                           placeholder="Minimum 6 characters"
                                           required minlength="6">
                                </div>
                            </div>

                            <!-- Confirm New Password -->
                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label fw-semibold">
                                    Confirm New Password <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-lock-fill text-success"></i>
                                    </span>
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                           class="form-control"
                                           placeholder="Re-enter new password"
                                           required>
                                </div>
                                <div id="confirmPasswordError" class="text-danger small mt-1"
                                     style="display: none;">
                                    Passwords do not match.
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="bi bi-shield-lock me-2"></i>Change Password
                                </button>
                            </div>
                        </form>

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
    <script>
        function validatePasswordForm() {
            const np  = document.getElementById('newPassword').value;
            const cp  = document.getElementById('confirmPassword').value;
            const err = document.getElementById('confirmPasswordError');
            if (np !== cp) {
                err.style.display = 'block';
                return false;
            }
            err.style.display = 'none';
            return true;
        }
    </script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
