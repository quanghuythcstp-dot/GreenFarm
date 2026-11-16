<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - GreenFarm</title>
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
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="bi bi-cart3 me-1"></i>Cart
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Registration Form -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4 p-md-5">

                        <!-- Logo -->
                        <div class="text-center mb-4">
                            <span class="display-6 text-success fw-bold">
                                <i class="bi bi-leaf-fill me-2"></i>GreenFarm
                            </span>
                            <p class="text-muted mt-1 mb-0">Create a new account</p>
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Register Form -->
                        <form action="${pageContext.request.contextPath}/register" method="post"
                              onsubmit="return validateConfirmPassword()">

                            <!-- Username -->
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-person text-success"></i>
                                    </span>
                                    <input type="text" id="username" name="username"
                                           class="form-control"
                                           placeholder="Choose a username"
                                           value="${username}"
                                           required autofocus>
                                </div>
                            </div>

                            <!-- Password -->
                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-lock text-success"></i>
                                    </span>
                                    <input type="password" id="password" name="password"
                                           class="form-control"
                                           placeholder="Create a password"
                                           required>
                                </div>
                            </div>

                            <!-- Confirm Password -->
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label fw-semibold">Confirm Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-lock-fill text-success"></i>
                                    </span>
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                           class="form-control"
                                           placeholder="Re-enter your password"
                                           required>
                                </div>
                                <div id="confirmPasswordError" class="text-danger small mt-1" style="display: none;">
                                    Passwords do not match.
                                </div>
                            </div>

                            <!-- Full Name -->
                            <div class="mb-3">
                                <label for="fullName" class="form-label fw-semibold">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-person-badge text-success"></i>
                                    </span>
                                    <input type="text" id="fullName" name="fullName"
                                           class="form-control"
                                           placeholder="Enter your full name"
                                           value="${fullName}"
                                           required>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-envelope text-success"></i>
                                    </span>
                                    <input type="email" id="email" name="email"
                                           class="form-control"
                                           placeholder="Enter your email"
                                           value="${email}"
                                           required>
                                </div>
                            </div>

                            <!-- Phone -->
                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">Phone</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-telephone text-success"></i>
                                    </span>
                                    <input type="tel" id="phone" name="phone"
                                           class="form-control"
                                           placeholder="e.g. 0912345678"
                                           value="${phone}"
                                           pattern="^0\d{9}$"
                                           title="Phone number must be 10 digits starting with 0"
                                           required>
                                </div>
                            </div>

                            <!-- Address -->
                            <div class="mb-4">
                                <label for="address" class="form-label fw-semibold">Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-geo-alt text-success"></i>
                                    </span>
                                    <input type="text" id="address" name="address"
                                           class="form-control"
                                           placeholder="Enter your address"
                                           value="${address}"
                                           required>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-grid gap-2 mb-3">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="bi bi-person-plus me-2"></i>Register
                                </button>
                                <a href="${pageContext.request.contextPath}/login"
                                   class="btn btn-outline-secondary btn-lg">
                                    <i class="bi bi-arrow-left me-2"></i>Back to Login
                                </a>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-success text-white py-3 mt-auto">
        <div class="container text-center">
            <p class="mb-0 small">&copy; 2024 GreenFarm Viet Nam.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateConfirmPassword() {
            const password = document.getElementById('password').value;
            const confirm  = document.getElementById('confirmPassword').value;
            const errorEl  = document.getElementById('confirmPasswordError');
            if (password !== confirm) {
                errorEl.style.display = 'block';
                return false;
            }
            errorEl.style.display = 'none';
            return true;
        }
    </script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
