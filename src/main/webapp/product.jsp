<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - GreenFarm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/home">Products</a>
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

    <div class="bg-white border-bottom py-2">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/home" class="text-success text-decoration-none">Home</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/home" class="text-success text-decoration-none">Products</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">${product.productName}</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container py-5">
        <div class="row g-5">

            <!-- Product Image -->
            <div class="col-12 col-md-5">
                <div class="card border-0 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/${product.image}"
                         class="card-img-top rounded"
                         alt="${product.productName}"
                         style="height: 380px; object-fit: cover;"
                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                </div>
            </div>

            <div class="col-12 col-md-7">
                <h2 class="fw-bold mb-2">${product.productName}</h2>

                <p class="text-muted mb-3">
                    <i class="bi bi-tag me-1"></i>Category ID: ${product.categoryId}
                </p>

                <h3 class="text-success fw-bold mb-3">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                </h3>

                <!-- Stock Status -->
                <div class="mb-3">
                    <c:choose>
                        <c:when test="${product.quantity > 0}">
                            <span class="badge bg-success fs-6">
                                <i class="bi bi-check-circle me-1"></i>In Stock (${product.quantity} available)
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger fs-6">
                                <i class="bi bi-x-circle me-1"></i>Out of Stock
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <hr>

                <div class="mb-4">
                    <h6 class="fw-semibold mb-2">Description</h6>
                    <p class="text-muted">${product.description}</p>
                </div>

                <!-- Add to Cart Form -->
                <c:if test="${product.quantity > 0}">
                    <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-3">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <input type="hidden" name="productName" value="${product.productName}">
                        <input type="hidden" name="price" value="${product.price}">

                        <div class="d-flex align-items-center gap-3 mb-3">
                            <label for="quantity" class="fw-semibold mb-0">Quantity:</label>
                            <input type="number" id="quantity" name="quantity"
                                   class="form-control" style="width: 90px;"
                                   value="1" min="1" max="${product.quantity}">
                        </div>

                        <div class="d-flex gap-3 flex-wrap">
                            <button type="submit" class="btn btn-success btn-lg px-4">
                                <i class="bi bi-cart-plus me-2"></i>Add to Cart
                            </button>
                            <a href="${pageContext.request.contextPath}/home"
                               class="btn btn-outline-secondary btn-lg px-4">
                                <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                            </a>
                        </div>
                    </form>
                </c:if>

                <c:if test="${product.quantity <= 0}">
                    <a href="${pageContext.request.contextPath}/home"
                       class="btn btn-outline-secondary btn-lg px-4">
                        <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                    </a>
                </c:if>

            </div>
        </div>
    </div>

    <!-- Reviews Section -->
    <div class="container pb-5">

        <div class="d-flex align-items-center mb-4">
            <h4 class="fw-bold me-3 mb-0">Customer Reviews</h4>
            <c:choose>
                <c:when test="${reviewCount > 0}">
                    <span class="text-warning fs-5">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= avgRating}">
                                    <i class="bi bi-star-fill"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-star"></i>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </span>
                    <span class="ms-2 text-muted">
                        <fmt:formatNumber value="${avgRating}" minFractionDigits="1" maxFractionDigits="1"/>
                        (${reviewCount} reviews)
                    </span>
                </c:when>
                <c:otherwise>
                    <span class="text-muted">No reviews yet.</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="row">

            <!-- Left: Write a Review -->
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <strong>Write a Review</strong>
                    </div>
                    <div class="card-body">

                        <c:if test="${param.reviewSuccess == '1'}">
                            <div class="alert alert-success">
                                Thank you! Your review has been submitted.
                            </div>
                        </c:if>

                        <c:choose>

                            <c:when test="${empty sessionScope.customer}">
                                <p>
                                    <a href="${pageContext.request.contextPath}/login">Login</a>
                                    to review this product.
                                </p>
                            </c:when>

                            <c:when test="${reviewableOrderId == -1 && not empty existingReview}">
                                <div class="alert alert-info">
                                    You have already reviewed this product.
                                </div>
                                <div class="text-warning mb-2">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= existingReview.rating}">
                                                <i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <p>${existingReview.comment}</p>
                            </c:when>

                            <c:when test="${reviewableOrderId != -1}">
                                <form action="${pageContext.request.contextPath}/review" method="post">
                                    <input type="hidden" name="productId" value="${product.productId}">

                                    <label class="form-label fw-bold">Rating</label>
                                    <div id="starContainer" class="fs-3 mb-3">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="bi bi-star text-warning"
                                               data-value="${i}" id="star${i}"
                                               style="cursor:pointer;"></i>
                                        </c:forEach>
                                    </div>
                                    <input type="hidden" id="ratingInput" name="rating">

                                    <label class="form-label fw-bold">Comment</label>
                                    <textarea id="comment" name="comment"
                                              class="form-control" rows="4"
                                              maxlength="1000" required></textarea>
                                    <div class="text-end small mt-1">
                                        <span id="charCount">0</span>/1000
                                    </div>

                                    <button class="btn btn-success w-100 mt-3"
                                            onclick="return validateReviewForm();">
                                        Submit Review
                                    </button>
                                </form>
                            </c:when>

                            <c:otherwise>
                                <p class="text-muted">
                                    You can only review products you have purchased.
                                </p>
                            </c:otherwise>

                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Right: Review list -->
            <div class="col-lg-8">
                <c:choose>
                    <c:when test="${empty reviewList}">
                        <div class="text-center text-muted py-5">
                            <i class="bi bi-chat-square-text display-3"></i>
                            <p class="mt-3">No reviews yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviewList}">
                            <div class="card shadow-sm mb-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <strong>${review.customerFullName}</strong>
                                            <div class="text-warning">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= review.rating}">
                                                            <i class="bi bi-star-fill"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/>
                                        </small>
                                    </div>
                                    <p class="mt-3 mb-0">${review.comment}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>

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
        const stars       = document.querySelectorAll('#starContainer .bi');
        const ratingInput = document.getElementById('ratingInput');

        if (stars.length > 0) {
            stars.forEach(function (star) {
                star.addEventListener('mouseover', function () {
                    highlightStars(parseInt(this.dataset.value));
                });
                star.addEventListener('mouseout', function () {
                    highlightStars(parseInt(ratingInput.value) || 0);
                });
                star.addEventListener('click', function () {
                    ratingInput.value = this.dataset.value;
                    highlightStars(parseInt(this.dataset.value));
                });
            });
        }

        function highlightStars(value) {
            stars.forEach(function (star) {
                var v = parseInt(star.dataset.value);
                star.classList.toggle('bi-star-fill', v <= value);
                star.classList.toggle('bi-star',      v >  value);
            });
        }

        function validateReviewForm() {
            if (!ratingInput || !ratingInput.value) {
                document.getElementById('ratingError').style.display = 'block';
                return false;
            }
            document.getElementById('ratingError').style.display = 'none';
            return true;
        }

        var commentArea = document.getElementById('comment');
        var charCount   = document.getElementById('charCount');
        if (commentArea) {
            commentArea.addEventListener('input', function () {
                charCount.textContent = this.value.length;
            });
        }
    </script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
