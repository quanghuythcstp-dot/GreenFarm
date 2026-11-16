<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Transfer - GreenFarm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment.css">
</head>
<body class="bg-light">

<!-- ══════════ NAVBAR ══════════ -->
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

<!-- ══════════ MAIN ══════════ -->
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-10 col-xl-9">

            <!-- Page title -->
            <div class="text-center mb-4">
                <h3 class="fw-bold text-success mb-2">
                    <i class="bi bi-bank me-2"></i>Bank Transfer Payment
                </h3>
                <div class="pmt-status-badge">
                    <span class="pmt-status-dot"></span>
                    Pending Payment
                </div>
            </div>

            <!-- Warning banner -->
            <div class="alert alert-warning d-flex align-items-start gap-3 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-4 flex-shrink-0 mt-1"></i>
                <div>
                    <strong>Important — Please read before transferring:</strong>
                    <ul class="mb-0 mt-1 ps-3 small">
                        <li>Transfer the <strong>exact amount</strong> shown below.</li>
                        <li>Use the <strong>transfer content</strong> exactly as displayed so we can match your payment.</li>
                        <li>Your order will be processed after payment confirmation (usually within 1–2 hours).</li>
                    </ul>
                </div>
            </div>

            <div class="row g-4">

                <!-- ── LEFT: Order summary + bank details ── -->
                <div class="col-12 col-md-6">

                    <!-- Order summary -->
                    <div class="card border-0 shadow-sm mb-4" style="border-radius:14px;">
                        <div class="card-header bg-success text-white fw-bold py-3"
                             style="border-radius:14px 14px 0 0;">
                            <i class="bi bi-receipt me-2"></i>Order Summary
                        </div>
                        <div class="card-body p-3">
                            <div class="pmt-order-box">
                                <div class="row-item">
                                    <span class="text-muted">Order ID</span>
                                    <span class="fw-bold">#${orderId}</span>
                                </div>
                                <div class="row-item">
                                    <span class="text-muted">Payment Status</span>
                                    <span class="badge bg-warning text-dark">Pending</span>
                                </div>
                                <div class="row-item total-row">
                                    <span>Total Amount</span>
                                    <span>
                                        <fmt:formatNumber value="${orderTotal}"
                                                          type="currency" currencySymbol="$"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bank details -->
                    <div class="card border-0 shadow-sm" style="border-radius:14px;">
                        <div class="card-header bg-success text-white fw-bold py-3"
                             style="border-radius:14px 14px 0 0;">
                            <i class="bi bi-building me-2"></i>Bank Information
                        </div>
                        <div class="card-body p-3">
                            <table class="pmt-bank-table">
                                <tbody>
                                    <tr>
                                        <td class="lbl">Bank Name</td>
                                        <td class="val">${bankName} (${bankCode})</td>
                                    </tr>
                                    <tr>
                                        <td class="lbl">Account Name</td>
                                        <td class="val">${accountName}</td>
                                    </tr>
                                    <tr>
                                        <td class="lbl">Account Number</td>
                                        <td class="val">
                                            ${bankAccount}
                                            <button class="pmt-copy-btn"
                                                    onclick="copyText('${bankAccount}', this)"
                                                    title="Copy account number">
                                                <i class="bi bi-clipboard"></i> Copy
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="lbl">Amount</td>
                                        <td class="val text-success">
                                            <fmt:formatNumber value="${orderTotal}"
                                                              type="currency" currencySymbol="$"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="lbl">Transfer Content</td>
                                        <td>
                                            <div class="pmt-transfer-content" id="transferContent">
                                                ${transferContent}
                                            </div>
                                            <button class="pmt-copy-btn mt-1"
                                                    onclick="copyText('${transferContent}', this)"
                                                    title="Copy transfer content">
                                                <i class="bi bi-clipboard"></i> Copy
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

                <!-- ── RIGHT: QR code + actions ── -->
                <div class="col-12 col-md-6 d-flex flex-column gap-4">

                    <!-- QR code -->
                    <div class="card border-0 shadow-sm text-center" style="border-radius:14px;">
                        <div class="card-header bg-success text-white fw-bold py-3"
                             style="border-radius:14px 14px 0 0;">
                            <i class="bi bi-qr-code me-2"></i>Scan to Pay
                        </div>
                        <div class="card-body p-4 d-flex flex-column align-items-center">
                            <%-- QR generated via api.qrserver.com — no API key required --%>
                            <div class="pmt-qr-wrap">
                                <img src="${vietQrUrl}"
                                     alt="VietQR - ${transferContent}"
                                     id="qrImage"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                <div class="pmt-qr-label">
                                    Scan with any Vietnamese banking app<br>
                                    <span class="text-success fw-bold">${transferContent}</span>
                                </div>
                            </div>
                            <p class="text-muted small mt-3 mb-0">
                                Supports MB Bank, VCB, Techcombank, BIDV &amp; most banking apps
                            </p>
                        </div>
                    </div>

                    <!-- Action buttons -->
                    <div class="card border-0 shadow-sm" style="border-radius:14px;">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/payment" method="post"
                                  class="d-grid gap-3">
                                <button type="submit" class="pmt-btn-primary">
                                    <i class="bi bi-check-circle-fill"></i>
                                    I Have Transferred
                                </button>
                            </form>
                            <div class="d-grid gap-2 mt-2">
                                <a href="${pageContext.request.contextPath}/my-orders"
                                   class="pmt-btn-outline">
                                    <i class="bi bi-clock-history"></i>View My Orders
                                </a>
                                <a href="${pageContext.request.contextPath}/home"
                                   class="btn btn-outline-secondary"
                                   style="border-radius:10px;padding:12px 0;font-weight:600;">
                                    <i class="bi bi-house me-2"></i>Back to Home
                                </a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Bottom note -->
            <div class="text-center mt-4 text-muted" style="font-size:.82rem;">
                <i class="bi bi-shield-check text-success me-1"></i>
                Payments are verified by GreenFarm within 1–2 business hours.
                Contact us at <strong>GreenfarmVN@gmail.com</strong> if you need help.
            </div>

        </div>
    </div>
</div>

<!-- ══════════ FOOTER ══════════ -->
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
    function copyText(text, btn) {
        navigator.clipboard.writeText(text).then(function () {
            var orig = btn.innerHTML;
            btn.innerHTML = '<i class="bi bi-check-lg"></i> Copied!';
            btn.style.background  = '#198754';
            btn.style.color       = '#fff';
            btn.style.borderColor = '#198754';
            setTimeout(function () {
                btn.innerHTML         = orig;
                btn.style.background  = '';
                btn.style.color       = '';
                btn.style.borderColor = '';
            }, 2000);
        });
    }
</script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
