<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About GreenFarm - Fresh Agricultural Products</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">
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
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/about">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/branches">Branches</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a>
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
                        <c:if test="${sessionScope.customer.role == 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2 me-1"></i>Manager
                                </a>
                            </li>
                        </c:if>
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

<!-- ══════════════════════════════════════
     SECTION 1 — HERO
══════════════════════════════════════ -->
<section class="ab-hero">
    <img src="https://images.unsplash.com/photo-1542838132-92c53300491e?w=1400&q=80&auto=format&fit=crop"
         class="ab-hero-bg-img"
         alt="Fresh vegetables background">
    <div class="container">
        <div class="row">
            <div class="col-lg-7">
                <span class="ab-hero-badge">
                    <i class="bi bi-patch-check-fill"></i>Est. 2020 · Da Nang, Viet Nam
                </span>
                <h1 class="mb-3">Where Nature Meets<br>Your Table</h1>
                <p class="lead mb-4">
                    GreenFarm connects local farmers with families who care about freshness,
                    quality, and a healthier way of living. Every product we carry is
                    sourced, inspected, and delivered with pride.
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/home"
                       class="btn btn-light fw-bold px-4 py-2 rounded-pill">
                        <i class="bi bi-grid-3x3-gap-fill me-2"></i>Browse Products
                    </a>
                    <a href="#about-section"
                       class="btn btn-outline-light fw-semibold px-4 py-2 rounded-pill">
                        <i class="bi bi-info-circle me-2"></i>Learn More
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 2 — ABOUT / MISSION / VISION
══════════════════════════════════════ -->
<section id="about-section" class="py-5" style="background:#fff;">
    <div class="container">
        <div class="row g-5 align-items-center">
            <div class="col-lg-5">
                <img src="https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=800&q=80"
                     alt="GreenFarm field" class="ab-about-img">
            </div>
            <div class="col-lg-7">
                <span class="ab-section-tag">Our Story</span>
                <h2 class="ab-section-title mb-4">About GreenFarm</h2>
                <p class="text-muted mb-4" style="line-height:1.75;">
                    Founded in 2020, GreenFarm was born from a simple belief: everyone deserves access to
                    genuinely fresh, chemical-free food. We partner directly with over 50 family-run farms
                    across Central Viet Nam, cutting out middlemen so the produce that leaves the soil in
                    the morning reaches your door by afternoon.
                </p>
                <div class="row g-3 mb-4">
                    <div class="col-sm-6">
                        <div class="p-3 rounded-3" style="background:#f0faf5;border:1.5px solid #d1e7dd;">
                            <div class="fw-bold text-success mb-1"><i class="bi bi-bullseye me-2"></i>Our Mission</div>
                            <p class="small text-muted mb-0">Deliver farm-fresh food to every household in Viet Nam while supporting local farmers.</p>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-3 rounded-3" style="background:#f0faf5;border:1.5px solid #d1e7dd;">
                            <div class="fw-bold text-success mb-1"><i class="bi bi-eye me-2"></i>Our Vision</div>
                            <p class="small text-muted mb-0">A Viet Nam where healthy eating is affordable, accessible, and celebrated.</p>
                        </div>
                    </div>
                </div>
                <div class="ab-value-item">
                    <div class="ab-value-icon"><i class="bi bi-shield-check"></i></div>
                    <div><strong>Integrity</strong><br><span class="text-muted small">We never sell a product we wouldn't feed our own families.</span></div>
                </div>
                <div class="ab-value-item">
                    <div class="ab-value-icon"><i class="bi bi-people"></i></div>
                    <div><strong>Community First</strong><br><span class="text-muted small">Every purchase supports a Vietnamese farming family.</span></div>
                </div>
                <div class="ab-value-item">
                    <div class="ab-value-icon"><i class="bi bi-leaf"></i></div>
                    <div><strong>Sustainability</strong><br><span class="text-muted small">Eco-friendly packaging and zero-waste logistics across our supply chain.</span></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 4 — WHY CHOOSE GREENFARM
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ab-section-tag">Our Promise</span>
            <h2 class="ab-section-title mt-2">Why Choose GreenFarm</h2>
        </div>
        <div class="row g-4">
            <div class="col-6 col-lg-3">
                <div class="ab-feature-card">
                    <div class="ab-feature-icon"><i class="bi bi-sun-fill"></i></div>
                    <h5 class="fw-bold mb-2">Fresh Every Day</h5>
                    <p class="text-muted small mb-0">Harvested daily and dispatched within hours so you always get peak-freshness produce.</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="ab-feature-card">
                    <div class="ab-feature-icon"><i class="bi bi-patch-check-fill"></i></div>
                    <h5 class="fw-bold mb-2">Quality Guaranteed</h5>
                    <p class="text-muted small mb-0">Every batch is inspected before packing — no chemicals, no compromises, ever.</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="ab-feature-card">
                    <div class="ab-feature-icon"><i class="bi bi-tags-fill"></i></div>
                    <h5 class="fw-bold mb-2">Affordable Prices</h5>
                    <p class="text-muted small mb-0">We buy directly from farmers, cutting out middlemen and passing savings to you.</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="ab-feature-card">
                    <div class="ab-feature-icon"><i class="bi bi-truck"></i></div>
                    <h5 class="fw-bold mb-2">Fast Delivery</h5>
                    <p class="text-muted small mb-0">Same-day delivery in Da Nang. Free shipping on orders over $30.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 5 — FEATURED PRODUCTS
══════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end flex-wrap gap-3 mb-5">
            <div>
                <span class="ab-section-tag">From Our Farm</span>
                <h2 class="ab-section-title mt-2 mb-0">Featured Products</h2>
            </div>
            <a href="${pageContext.request.contextPath}/home"
               class="btn btn-outline-success rounded-pill px-4">
                View All Products <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>
        <c:choose>
            <c:when test="${empty featuredProducts}">
                <div class="alert alert-info">No products available at the moment.</div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-2 row-cols-md-3 g-3">
                    <c:forEach var="product" items="${featuredProducts}">
                        <div class="col">
                            <div class="ab-product-card">
                                <div style="overflow:hidden;">
                                    <img src="${pageContext.request.contextPath}/images/${product.image}"
                                         class="ab-product-img"
                                         alt="${product.productName}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                </div>
                                <div class="ab-product-body">
                                    <div class="ab-product-name">${product.productName}</div>
                                    <div class="ab-product-price">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/product?productId=${product.productId}"
                                       class="btn btn-outline-success btn-sm w-100">
                                        <i class="bi bi-eye me-1"></i>View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 6 — FARM GALLERY
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ab-section-tag">Life on the Farm</span>
            <h2 class="ab-section-title mt-2">Farm Gallery</h2>
        </div>
        <div class="row g-3">
            <div class="col-12 col-sm-6 col-lg-4">
                <img src="https://images.unsplash.com/photo-1500595046743-cd271d694d30?w=600&q=75"
                     class="ab-gallery-img" style="height:240px;" alt="Farm field">
            </div>
            <div class="col-12 col-sm-6 col-lg-4">
                <img src="https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=75"
                     class="ab-gallery-img" style="height:240px;" alt="Fresh vegetables">
            </div>
            <div class="col-12 col-sm-6 col-lg-4">
                <img src="https://images.unsplash.com/photo-1560493676-04071c5f467b?w=600&q=75"
                     class="ab-gallery-img" style="height:240px;" alt="Harvest time">
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <img src="https://images.unsplash.com/photo-1606923829579-0cb981a83e2e?w=600&q=75"
                     class="ab-gallery-img" style="height:200px;" alt="Fruits">
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <img src="https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&q=75"
                     class="ab-gallery-img" style="height:200px;" alt="Herbs">
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <img src="https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=600&q=75"
                     class="ab-gallery-img" style="height:200px;" alt="Healthy food">
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <img src="https://images.unsplash.com/photo-1550989460-0adf9ea622e2?w=600&q=75"
                     class="ab-gallery-img" style="height:200px;" alt="Organic produce">
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 7 — CUSTOMER REVIEWS
══════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ab-section-tag">What People Say</span>
            <h2 class="ab-section-title mt-2">Customer Reviews</h2>
        </div>
        <div class="row g-4">
            <div class="col-12 col-md-4">
                <div class="ab-review-card">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <img src="https://randomuser.me/api/portraits/women/44.jpg"
                             class="ab-avatar" alt="Nguyen Thi Lan">
                        <div>
                            <div class="fw-bold" style="font-size:.92rem;">Nguyen Thi Lan</div>
                            <div class="ab-stars">
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                            </div>
                        </div>
                    </div>
                    <p class="text-muted small mb-0" style="line-height:1.65;">
                        "The vegetables are incredibly fresh — you can actually taste the difference.
                        I ordered spinach and tomatoes on Monday morning and they arrived by lunch,
                        still cool and crisp. GreenFarm has completely changed how I shop for groceries."
                    </p>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="ab-review-card">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <img src="https://randomuser.me/api/portraits/men/32.jpg"
                             class="ab-avatar" alt="Tran Van Minh">
                        <div>
                            <div class="fw-bold" style="font-size:.92rem;">Tran Van Minh</div>
                            <div class="ab-stars">
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-half"></i>
                            </div>
                        </div>
                    </div>
                    <p class="text-muted small mb-0" style="line-height:1.65;">
                        "Fantastic prices and the quality is consistent every time. I run a small
                        restaurant and GreenFarm supplies our herbs and greens daily. Reliable,
                        honest, and the team is always responsive. Highly recommended!"
                    </p>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="ab-review-card">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <img src="https://randomuser.me/api/portraits/women/68.jpg"
                             class="ab-avatar" alt="Le Thi Thu">
                        <div>
                            <div class="fw-bold" style="font-size:.92rem;">Le Thi Thu</div>
                            <div class="ab-stars">
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                            </div>
                        </div>
                    </div>
                    <p class="text-muted small mb-0" style="line-height:1.65;">
                        "As a mom of three I care deeply about what goes into our food. GreenFarm
                        gives me peace of mind — no pesticides, clear labelling, and the kids
                        actually enjoy eating vegetables now. The fruit selection is amazing too!"
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 8 — CONTACT
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ab-section-tag">Get in Touch</span>
            <h2 class="ab-section-title mt-2">Contact Information</h2>
        </div>
        <div class="row g-4 mb-5">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="ab-contact-card text-center">
                    <div class="ab-contact-icon mx-auto"><i class="bi bi-geo-alt-fill"></i></div>
                    <div class="fw-bold mb-1">Address</div>
                    <p class="text-muted small mb-0">123 Xuan Dieu Street,<br>Da Nang City, Viet Nam</p>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="ab-contact-card text-center">
                    <div class="ab-contact-icon mx-auto"><i class="bi bi-telephone-fill"></i></div>
                    <div class="fw-bold mb-1">Phone</div>
                    <p class="text-muted small mb-0">+84 359 151 256<br>Mon–Sat 7am–8pm</p>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="ab-contact-card text-center">
                    <div class="ab-contact-icon mx-auto"><i class="bi bi-envelope-fill"></i></div>
                    <div class="fw-bold mb-1">Email</div>
                    <p class="text-muted small mb-0">GreenfarmVN@gmail.com<br>Reply within 2 hours</p>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="ab-contact-card text-center">
                    <div class="ab-contact-icon mx-auto"><i class="bi bi-clock-fill"></i></div>
                    <div class="fw-bold mb-1">Opening Hours</div>
                    <p class="text-muted small mb-0">Mon–Sat: 6am – 9pm<br>Sunday: 7am – 6pm</p>
                </div>
            </div>
        </div>

        <!-- CTA -->
        <div class="ab-cta text-center position-relative">
            <h2 class="fw-bold mb-3" style="font-size:clamp(1.6rem,4vw,2.4rem);">
                Healthy Living Starts Here
            </h2>
            <p class="mb-4 opacity-90" style="font-size:1.05rem;">
                Browse hundreds of fresh products today and taste the GreenFarm difference.
            </p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="${pageContext.request.contextPath}/home"
                   class="btn btn-light fw-bold px-5 py-2 rounded-pill text-success">
                    <i class="bi bi-cart3 me-2"></i>Shop Now
                </a>
                <a href="mailto:GreenfarmVN@gmail.com"
                   class="btn btn-outline-light fw-semibold px-5 py-2 rounded-pill">
                    <i class="bi bi-envelope me-2"></i>Contact Us
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
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
