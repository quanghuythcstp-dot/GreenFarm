<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - GreenFarm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">
</head>
<body class="bg-light">

<!-- ── Navbar ── -->
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ── Breadcrumb ── -->
<div class="bg-white border-bottom py-2">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0" style="font-size:.85rem;">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/home"
                       class="text-success text-decoration-none">Home</a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/cart"
                       class="text-success text-decoration-none">Cart</a>
                </li>
                <li class="breadcrumb-item active">Checkout</li>
            </ol>
        </nav>
    </div>
</div>

<!-- ── Main ── -->
<div class="container py-4">

    <h4 class="fw-bold mb-4 text-success">
        <i class="bi bi-bag-check me-2"></i>Checkout
    </h4>

    <%-- Wrap the entire checkout in a single form posting to /checkout --%>
    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="bi bi-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4 align-items-start">

        <!-- ── LEFT COLUMN ── -->
        <div class="col-lg-7">

            <!-- 1. Order Summary -->
            <div class="ck-section-card">
                <div class="ck-section-header">
                    <i class="bi bi-cart3"></i>Order Summary
                </div>
                <div class="ck-section-body">
                    <c:forEach var="entry" items="${cart}">
                        <c:set var="item" value="${entry.value}"/>
                        <div class="ck-product-row">
                            <img src="${pageContext.request.contextPath}/images/${item.product.image}"
                                 alt="${item.product.productName}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            <div class="flex-grow-1 min-width-0">
                                <div class="ck-product-name">${item.product.productName}</div>
                                <div class="ck-product-qty">Qty: ${item.quantity}</div>
                            </div>
                            <div class="ck-product-price">
                                <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- 1b. Delivery Information -->
            <div class="ck-section-card">
                <div class="ck-section-header">
                    <i class="bi bi-person-lines-fill"></i>Delivery Information
                </div>
                <div class="ck-section-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">
                                Receiver Name <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-white">
                                    <i class="bi bi-person text-success"></i>
                                </span>
                                <input type="text" name="receiverName" class="form-control"
                                       placeholder="Enter receiver name"
                                       value="${sessionScope.customer.fullName}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Phone <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-white">
                                    <i class="bi bi-telephone text-success"></i>
                                </span>
                                <input type="tel" name="phone" class="form-control"
                                       placeholder="e.g. 0912345678"
                                       value="${sessionScope.customer.phone}"
                                       pattern="^0\d{9}$"
                                       title="10 digits starting with 0" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Delivery Address <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-white">
                                    <i class="bi bi-geo-alt text-success"></i>
                                </span>
                                <input type="text" name="address" class="form-control"
                                       placeholder="Enter delivery address"
                                       value="${sessionScope.customer.address}" required>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Delivery Method -->
            <div class="ck-section-card">
                <div class="ck-section-header">
                    <i class="bi bi-truck"></i>Delivery Method
                </div>
                <div class="ck-section-body">

                    <label class="ck-option-label selected" id="lbl-standard">
                        <input type="radio" name="deliveryMethod"
                               value="standard" id="deliveryStandard" checked
                               onchange="updateDelivery()">
                        <div class="ck-option-icon"><i class="bi bi-bicycle"></i></div>
                        <div>
                            <div class="ck-option-title">Standard Delivery</div>
                            <div class="ck-option-sub">
                                Delivered within 2–4 hours ·
                                Fee: <fmt:formatNumber value="${feeStandard}" type="number" groupingUsed="true"/> đ
                            </div>
                        </div>
                        <div class="ms-auto fw-bold text-success">
                            <fmt:formatNumber value="${feeStandard}" type="number" groupingUsed="true"/> đ
                        </div>
                    </label>

                    <label class="ck-option-label" id="lbl-express">
                        <input type="radio" name="deliveryMethod"
                               value="express" id="deliveryExpress"
                               onchange="updateDelivery()">
                        <div class="ck-option-icon"><i class="bi bi-lightning-charge-fill"></i></div>
                        <div>
                            <div class="ck-option-title">Express Delivery</div>
                            <div class="ck-option-sub">
                                Delivered within 1 hour ·
                                Fee: <fmt:formatNumber value="${feeExpress}" type="number" groupingUsed="true"/> đ
                            </div>
                        </div>
                        <div class="ms-auto fw-bold text-success">
                            <fmt:formatNumber value="${feeExpress}" type="number" groupingUsed="true"/> đ
                        </div>
                    </label>

                </div>
            </div>

            <!-- 3. Payment Method -->
            <div class="ck-section-card">
                <div class="ck-section-header">
                    <i class="bi bi-credit-card-2-front"></i>Payment Method
                </div>
                <div class="ck-section-body">

                    <label class="ck-option-label selected" id="lbl-cod">
                        <input type="radio" name="paymentMethod"
                               value="cod" id="paymentCOD" checked
                               onchange="selectPayment('lbl-cod')">
                        <div class="ck-option-icon"><i class="bi bi-cash-coin"></i></div>
                        <div>
                            <div class="ck-option-title">Cash on Delivery</div>
                            <div class="ck-option-sub">Pay when your order arrives</div>
                        </div>
                    </label>

                    <label class="ck-option-label" id="lbl-bank">
                        <input type="radio" name="paymentMethod"
                               value="bank" id="paymentBank"
                               onchange="selectPayment('lbl-bank')">
                        <div class="ck-option-icon"><i class="bi bi-bank"></i></div>
                        <div>
                            <div class="ck-option-title">Bank Transfer</div>
                            <div class="ck-option-sub">Transfer before delivery</div>
                        </div>
                    </label>

                </div>
            </div>

            <!-- 4. Order Note -->
            <div class="ck-section-card">
                <div class="ck-section-header">
                    <i class="bi bi-pencil-square"></i>Order Note
                </div>
                <div class="ck-section-body">
                    <textarea name="orderNote" id="orderNote"
                              class="form-control"
                              rows="3"
                              placeholder="Please leave delivery instructions…"
                              style="border-radius:10px;border:1.5px solid #e9ecef;font-size:.9rem;resize:vertical;"></textarea>
                </div>
            </div>

        </div>

        <!-- ── RIGHT COLUMN — Order Total ── -->
        <div class="col-lg-5">
            <div class="ck-section-card" style="position:sticky;top:80px;">
                <div class="ck-section-header">
                    <i class="bi bi-receipt"></i>Payment Summary
                </div>
                <div class="ck-section-body">

                    <div class="ck-summary-row">
                        <span>Subtotal</span>
                        <span id="summarySubtotal">
                            <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="$"/>
                        </span>
                    </div>
                    <div class="ck-summary-row">
                        <span>Delivery Fee</span>
                        <span id="summaryDelivery">$2.00</span>
                    </div>
                    <hr>
                    <div class="ck-summary-row ck-summary-total">
                        <span>Total</span>
                        <span id="summaryTotal">—</span>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="ck-confirm-btn" id="confirmBtn">
                            <i class="bi bi-bag-check-fill"></i>Confirm Order
                        </button>
                    </div>

                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/cart"
                           class="btn btn-outline-secondary btn-sm w-100">
                            <i class="bi bi-arrow-left me-1"></i>Back to Cart
                        </a>
                    </div>

                    <div class="mt-3 d-flex align-items-center justify-content-center gap-2 text-muted"
                         style="font-size:.78rem;">
                        <i class="bi bi-shield-check text-success"></i>
                        Secure checkout — your data is protected
                    </div>

                </div>
            </div>
        </div>

    </div>
    </form><%-- end checkoutForm --%>

</div>

<!-- ── Footer ── -->
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
    // Delivery fee values from server (read from DB)
    var deliveryFees = {
        standard: ${feeStandard},
        express:  ${feeExpress}
    };
    var cartTotal    = ${cartTotal};
    var currentFee   = 2.00;

    // Initialise total on page load
    document.addEventListener('DOMContentLoaded', function () {
        renderTotal();
    });

    // Called when delivery radio changes
    function updateDelivery() {
        var standard = document.getElementById('deliveryStandard');
        var express  = document.getElementById('deliveryExpress');

        document.getElementById('lbl-standard').classList.toggle('selected', standard.checked);
        document.getElementById('lbl-express').classList.toggle('selected', express.checked);

        currentFee = standard.checked ? deliveryFees.standard : deliveryFees.express;
        document.getElementById('summaryDelivery').textContent = '$' + currentFee.toFixed(2);
        renderTotal();
    }

    // Called when payment radio changes
    function selectPayment(activeLblId) {
        ['lbl-cod', 'lbl-bank'].forEach(function (id) {
            document.getElementById(id).classList.toggle('selected', id === activeLblId);
        });
    }

    function renderTotal() {
        var total = cartTotal + currentFee;
        document.getElementById('summaryTotal').textContent =
            '$' + total.toLocaleString('en-US', { minimumFractionDigits: 2 });
    }

    // Show spinner when form submits
    document.getElementById('checkoutForm').addEventListener('submit', function () {
        var btn = document.getElementById('confirmBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Processing…';
    });
</script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
