<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - GreenFarm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css">
</head>
<body style="background:#f8f9fa;">

<!-- ══════════════ NAVBAR ══════════════ -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success sticky-top" style="z-index:1030;">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-leaf-fill me-2"></i>GreenFarm
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/about">About</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/branches">Branches</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/contact">Contact</a></li>
            </ul>
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.customer}">
                        <li class="nav-item">
                            <span class="nav-link text-white">
                                <i class="bi bi-person-circle me-1"></i>${sessionScope.customer.fullName}
                            </span>
                        </li>
                        <c:if test="${sessionScope.customer.role == 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2 me-1"></i>Manager
                                </a>
                            </li>
                        </c:if>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart"><i class="bi bi-cart3 me-1"></i>Cart</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/my-orders"><i class="bi bi-clock-history me-1"></i>My Orders</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-gear me-1"></i>Profile</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a></li>
                        <li class="nav-item"><a class="btn btn-light btn-sm ms-2" href="${pageContext.request.contextPath}/register">Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- ══════════════════════════════════════
     SECTION 1 — HERO
══════════════════════════════════════ -->
<section class="ct-hero">
    <img src="https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=1400&q=80&auto=format&fit=crop"
         class="ct-hero-bg-img" alt="GreenFarm contact">
    <div class="container">
        <div class="row">
            <div class="col-lg-7">
                <span class="ct-hero-badge">
                    <i class="bi bi-headset"></i>We're Here to Help
                </span>
                <h1 class="mb-3">Contact GreenFarm</h1>
                <p class="lead mb-4">
                    We're Always Happy To Help — whether you have a question about our
                    products, need help with your order, or just want to say hello,
                    our team is ready to assist you.
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="#contactForm" class="btn btn-light fw-bold px-4 py-2 rounded-pill">
                        <i class="bi bi-envelope-fill me-2"></i>Send a Message
                    </a>
                    <a href="tel:+84359151256" class="btn btn-outline-light fw-semibold px-4 py-2 rounded-pill">
                        <i class="bi bi-telephone-fill me-2"></i>Call Us Now
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 2 — CONTACT INFORMATION CARDS
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ct-tag">Reach Us</span>
            <h2 class="ct-title mt-2">Contact Information</h2>
            <p class="text-muted mt-2">Multiple ways to get in touch with GreenFarm.</p>
        </div>
        <div class="row g-4">
            <div class="col-6 col-lg-4">
                <div class="ct-info-card">
                    <div class="ct-info-icon"><i class="bi bi-building"></i></div>
                    <div class="ct-info-title">Head Office</div>
                    <p>29 An Thuong 4, My An<br>Ngu Hanh Son, Da Nang</p>
                </div>
            </div>
            <div class="col-6 col-lg-4">
                <div class="ct-info-card">
                    <div class="ct-info-icon"><i class="bi bi-telephone-fill"></i></div>
                    <div class="ct-info-title">Phone Number</div>
                    <p>+84 359 151 256<br>Mon – Sat · 7am – 8pm</p>
                </div>
            </div>
            <div class="col-6 col-lg-4">
                <div class="ct-info-card">
                    <div class="ct-info-icon"><i class="bi bi-envelope-fill"></i></div>
                    <div class="ct-info-title">Email Address</div>
                    <p>GreenfarmVN@gmail.com<br>Reply within 2 hours</p>
                </div>
            </div>
            <div class="col-6 col-lg-4">
                <div class="ct-info-card">
                    <div class="ct-info-icon"><i class="bi bi-clock-fill"></i></div>
                    <div class="ct-info-title">Business Hours</div>
                    <p>Mon – Sat: 6:00 – 21:00<br>Sunday: 7:00 – 18:00</p>
                </div>
            </div>
            <div class="col-6 col-lg-4">
                <div class="ct-info-card">
                    <div class="ct-info-icon"><i class="bi bi-headset"></i></div>
                    <div class="ct-info-title">Customer Support</div>
                    <p>Online support available<br>7 days a week</p>
                </div>
            </div>
            <div class="col-6 col-lg-4">
                <div class="ct-info-card">
                    <div class="ct-info-icon"><i class="bi bi-shop-window"></i></div>
                    <div class="ct-info-title">Our Branches</div>
                    <p>6 stores across Da Nang<br>
                        <a href="${pageContext.request.contextPath}/branches"
                           class="text-success fw-semibold text-decoration-none">View all branches →</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 3 — CONTACT FORM + SIDE PANEL
══════════════════════════════════════ -->
<section id="contactForm" class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ct-tag">Get in Touch</span>
            <h2 class="ct-title mt-2">Send Us a Message</h2>
            <p class="text-muted mt-2">Fill in the form and our team will get back to you shortly.</p>
        </div>

        <div class="row g-4 align-items-start">

            <!-- Form column -->
            <div class="col-lg-7">

                <!-- Success alert -->
                <c:if test="${param.success == '1'}">
                    <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <strong>Thank you for contacting GreenFarm.</strong><br>
                        Your message has been sent successfully.
                        Our staff will contact you soon.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Guest warning -->
                <c:if test="${param.guestError == '1' or empty sessionScope.customer}">
                    <c:if test="${empty sessionScope.customer}">
                        <div class="alert alert-warning mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <strong>You must log in before sending a message.</strong><br>
                            Please sign in to your GreenFarm account to contact our support team.
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/login"
                                   class="btn btn-warning fw-semibold px-4">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>Login Now
                                </a>
                                <a href="${pageContext.request.contextPath}/register"
                                   class="btn btn-outline-secondary ms-2 px-4">
                                    <i class="bi bi-person-plus me-2"></i>Register
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:if>

                <!-- Error alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                        <i class="bi bi-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Form — only shown when logged in -->
                <c:if test="${not empty sessionScope.customer}">
                    <div class="ct-form-card">
                        <div class="ct-form-header">
                            <i class="bi bi-pencil-square"></i>Contact Form
                        </div>
                        <div class="ct-form-body">
                            <form action="${pageContext.request.contextPath}/contact"
                                  method="post" novalidate>
                                <div class="row g-3">

                                    <!-- Read-only customer info from session -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Full Name</label>
                                        <input type="text" class="form-control bg-light"
                                               value="${sessionScope.customer.fullName}" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Phone Number</label>
                                        <input type="text" class="form-control bg-light"
                                               value="${sessionScope.customer.phone}" readonly>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Email Address</label>
                                        <input type="text" class="form-control bg-light"
                                               value="${sessionScope.customer.email}" readonly>
                                    </div>

                                    <!-- Subject -->
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Subject</label>
                                        <select name="subject" class="form-select">
                                            <option value="">— Select a subject —</option>
                                            <option value="Order Inquiry"    ${subject == 'Order Inquiry'    ? 'selected' : ''}>Order Inquiry</option>
                                            <option value="Product Question" ${subject == 'Product Question' ? 'selected' : ''}>Product Question</option>
                                            <option value="Delivery Issue"   ${subject == 'Delivery Issue'   ? 'selected' : ''}>Delivery Issue</option>
                                            <option value="Return & Refund"  ${subject == 'Return & Refund'  ? 'selected' : ''}>Return &amp; Refund</option>
                                            <option value="Partnership"      ${subject == 'Partnership'      ? 'selected' : ''}>Partnership</option>
                                            <option value="Other"            ${subject == 'Other'            ? 'selected' : ''}>Other</option>
                                        </select>
                                    </div>

                                    <!-- Message -->
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">
                                            Message <span class="text-danger">*</span>
                                        </label>
                                        <textarea name="message" class="form-control" rows="6"
                                                  placeholder="Write your message here…"
                                                  maxlength="2000" required
                                                  id="ctMessage">${not empty message ? message : ''}</textarea>
                                        <div class="text-end small mt-1 text-muted">
                                            <span id="ctCharCount">0</span>/2000
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <button type="submit" class="ct-submit-btn">
                                            <i class="bi bi-send-fill"></i>Send Message
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Side panel -->
            <div class="col-lg-5">
                <div class="ct-side-panel">
                    <h5 class="fw-bold mb-4" style="font-size:1.1rem;">
                        <i class="bi bi-leaf-fill me-2" style="color:#52b788;"></i>GreenFarm Support
                    </h5>
                    <div class="ct-side-item">
                        <div class="ct-side-icon"><i class="bi bi-geo-alt-fill"></i></div>
                        <div>
                            <div class="label">Head Office</div>
                            <div class="value">29 An Thuong 4, My An<br>Ngu Hanh Son, Da Nang</div>
                        </div>
                    </div>
                    <div class="ct-side-item">
                        <div class="ct-side-icon"><i class="bi bi-telephone-fill"></i></div>
                        <div>
                            <div class="label">Phone</div>
                            <div class="value">+84 359 151 256</div>
                        </div>
                    </div>
                    <div class="ct-side-item">
                        <div class="ct-side-icon"><i class="bi bi-envelope-fill"></i></div>
                        <div>
                            <div class="label">Email</div>
                            <div class="value">GreenfarmVN@gmail.com</div>
                        </div>
                    </div>
                    <div class="ct-side-item">
                        <div class="ct-side-icon"><i class="bi bi-clock-fill"></i></div>
                        <div>
                            <div class="label">Working Hours</div>
                            <div class="value">Mon–Sat: 06:00 – 21:00<br>Sunday: 07:00 – 18:00</div>
                        </div>
                    </div>
                    <div class="ct-side-item mb-0">
                        <div class="ct-side-icon"><i class="bi bi-lightning-charge-fill"></i></div>
                        <div>
                            <div class="label">Response Time</div>
                            <div class="value">Within 2 hours on working days</div>
                        </div>
                    </div>
                    <hr style="border-color:rgba(255,255,255,.15);margin:24px 0;">
                    <p style="font-size:.82rem;opacity:.7;line-height:1.6;margin:0;">
                        GreenFarm is committed to providing the best customer experience.
                        Your message will be reviewed by our support team as soon as possible.
                    </p>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 4 — QUICK CONTACT BUTTONS
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ct-tag">Quick Actions</span>
            <h2 class="ct-title mt-2">Quick Contact</h2>
        </div>
        <div class="row g-4">
            <div class="col-12 col-md-4">
                <a href="tel:+84359151256"
                   class="ct-quick-btn btn btn-success text-white w-100">
                    <i class="bi bi-telephone-fill"></i>Call Now
                </a>
            </div>
            <div class="col-12 col-md-4">
                <a href="mailto:GreenfarmVN@gmail.com"
                   class="ct-quick-btn btn btn-outline-success w-100">
                    <i class="bi bi-envelope-fill"></i>Send Email
                </a>
            </div>
            <div class="col-12 col-md-4">
                <a href="${pageContext.request.contextPath}/branches"
                   class="ct-quick-btn btn btn-outline-secondary w-100">
                    <i class="bi bi-shop-window"></i>View Branches
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 5 — FAQ ACCORDION
══════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ct-tag">FAQ</span>
            <h2 class="ct-title mt-2">Frequently Asked Questions</h2>
            <p class="text-muted mt-2">Find quick answers to common questions below.</p>
        </div>
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="accordion" id="faqAccordion">

                    <div class="accordion-item border-0 mb-3 shadow-sm rounded-3 overflow-hidden">
                        <h2 class="accordion-header">
                            <button class="accordion-button fw-semibold" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#faq1">
                                <i class="bi bi-truck me-2 text-success"></i>
                                How long does delivery take?
                            </button>
                        </h2>
                        <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted">
                                Standard delivery within Da Nang City takes 2–4 hours after order confirmation.
                                Express delivery (1–2 hours) is available for orders placed before 3:00 PM.
                                Free delivery on orders over $30.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-0 mb-3 shadow-sm rounded-3 overflow-hidden">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#faq2">
                                <i class="bi bi-search me-2 text-success"></i>
                                How can I track my order?
                            </button>
                        </h2>
                        <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted">
                                After logging in, visit <strong>My Orders</strong> in the navigation bar
                                to view the real-time status of all your orders including Confirmed,
                                Shipping, and Completed stages.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-0 mb-3 shadow-sm rounded-3 overflow-hidden">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#faq3">
                                <i class="bi bi-arrow-counterclockwise me-2 text-success"></i>
                                How do I request a refund?
                            </button>
                        </h2>
                        <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted">
                                GreenFarm offers a 7-day return policy for quality issues.
                                Please contact our support team via this form or call us directly.
                                Provide your order number and a photo of the item for faster processing.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-0 mb-3 shadow-sm rounded-3 overflow-hidden">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#faq4">
                                <i class="bi bi-headset me-2 text-success"></i>
                                How can I contact customer support?
                            </button>
                        </h2>
                        <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted">
                                You can reach our support team by filling in the contact form above,
                                calling <strong>+84 359 151 256</strong>, or emailing
                                <strong>GreenfarmVN@gmail.com</strong>.
                                Our team is available Mon–Sat 7am–8pm and Sunday 7am–6pm.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-0 mb-3 shadow-sm rounded-3 overflow-hidden">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#faq5">
                                <i class="bi bi-bag-check me-2 text-success"></i>
                                Can I modify or cancel my order?
                            </button>
                        </h2>
                        <div id="faq5" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted">
                                Orders can be cancelled before they reach <strong>Shipping</strong> status.
                                To modify an order, please contact us immediately after placing it.
                                Once an order is being prepared, changes may not be possible.
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 6 — BOTTOM CTA
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="ct-cta text-center position-relative">
            <h2 class="fw-bold mb-3" style="font-size:clamp(1.7rem,4vw,2.5rem);">
                Need Fresh Products?
            </h2>
            <p class="mb-4" style="font-size:1.05rem;opacity:.92;max-width:520px;margin-inline:auto;">
                Browse our full range of farm-fresh vegetables, fruits, herbs and grains —
                delivered straight to your door or ready for pickup at any of our 6 branches.
            </p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="${pageContext.request.contextPath}/home"
                   class="btn btn-light fw-bold px-5 py-2 rounded-pill text-success">
                    <i class="bi bi-cart3 me-2"></i>Shop Now
                </a>
                <a href="${pageContext.request.contextPath}/branches"
                   class="btn btn-outline-light fw-semibold px-5 py-2 rounded-pill">
                    <i class="bi bi-shop-window me-2"></i>Visit Our Branches
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════ FOOTER ══════════════ -->
<footer class="bg-success text-white mt-4 py-4">
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
    // Character counter for message textarea
    var msgArea   = document.getElementById('ctMessage');
    var charCount = document.getElementById('ctCharCount');
    if (msgArea) {
        charCount.textContent = msgArea.value.length;
        msgArea.addEventListener('input', function () {
            charCount.textContent = this.value.length;
        });
    }
</script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
