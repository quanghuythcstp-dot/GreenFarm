<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Branches - GreenFarm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/branches.css">
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/branches">Branches</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a></li>
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
<section class="br-hero">
    <img src="https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=1400&q=80&auto=format&fit=crop"
         class="br-hero-bg-img" alt="GreenFarm store">
    <div class="container">
        <div class="row">
            <div class="col-lg-7">
                <span class="br-hero-badge">
                    <i class="bi bi-shop"></i>6 Locations Across Da Nang
                </span>
                <h1 class="mb-3">GreenFarm Store<br>Locations</h1>
                <p class="lead mb-4">
                    Visit Our Stores &amp; Experience Freshness — find your nearest GreenFarm
                    branch and enjoy farm-fresh produce sourced daily from local growers.
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="#storesSection" class="btn btn-light fw-bold px-4 py-2 rounded-pill">
                        <i class="bi bi-geo-alt-fill me-2"></i>View Stores
                    </a>
                    <a href="${pageContext.request.contextPath}/home"
                       class="btn btn-outline-light fw-semibold px-4 py-2 rounded-pill">
                        <i class="bi bi-cart3 me-2"></i>Shop Online
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 2 — ABOUT OUR RETAIL NETWORK
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="row g-5 align-items-center">
            <div class="col-lg-5">
                <img src="https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80&auto=format&fit=crop"
                     alt="GreenFarm store interior" class="br-about-img">
            </div>
            <div class="col-lg-7">
                <span class="br-tag">Our Retail Network</span>
                <h2 class="br-title mb-4">Fresh at Every Corner of Da Nang</h2>
                <p class="text-muted mb-4" style="line-height:1.75;">
                    GreenFarm operates five conveniently located branches across Da Nang City.
                    Each store is designed to bring the freshness of the farm directly into your
                    neighbourhood — clean, bright, and stocked with the best the region has to offer.
                </p>
                <div class="br-network-item">
                    <div class="br-network-icon"><i class="bi bi-shop-window"></i></div>
                    <div><strong>5 Branches City-Wide</strong><br><span class="text-muted small">From Son Tra to Lien Chieu — always close to home.</span></div>
                </div>
                <div class="br-network-item">
                    <div class="br-network-icon"><i class="bi bi-sun-fill"></i></div>
                    <div><strong>Fresh Products Every Day</strong><br><span class="text-muted small">Restocked every morning directly from partner farms.</span></div>
                </div>
                <div class="br-network-item">
                    <div class="br-network-icon"><i class="bi bi-people-fill"></i></div>
                    <div><strong>Friendly Trained Staff</strong><br><span class="text-muted small">Our team is ready to help you find the best seasonal produce.</span></div>
                </div>
                <div class="br-network-item">
                    <div class="br-network-icon"><i class="bi bi-truck"></i></div>
                    <div><strong>Click &amp; Collect Available</strong><br><span class="text-muted small">Order online and pick up at any branch within 2 hours.</span></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 3 — STORE CARDS
══════════════════════════════════════ -->
<section id="storesSection" class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="br-tag">Find a Store</span>
            <h2 class="br-title mt-2">Our Branches</h2>
            <p class="text-muted mt-2">Click <strong>View on Map</strong> on any card to see its exact location.</p>
        </div>
        <div class="row g-4">
            <c:forEach var="branch" items="${branches}" varStatus="st">
                <div class="col-12 col-md-6 col-xl-4">
                    <div class="br-store-card${st.index == 0 ? ' active-branch' : ''}">
                        <div class="br-store-img-wrap">
                            <img src="${branch['image']}" alt="${branch['name']}">
                            <span class="br-store-badge">Branch #${branch['code']}</span>
                        </div>
                        <div class="br-store-body">
                            <div class="br-store-name">
                                <i class="bi bi-shop text-success me-2"></i>${branch['name']}
                            </div>
                            <div class="br-store-info">
                                <i class="bi bi-geo-alt-fill"></i>
                                <span>${branch['address']}</span>
                            </div>
                            <div class="br-store-info">
                                <i class="bi bi-telephone-fill"></i>
                                <span>${branch['phone']}</span>
                            </div>
                            <div class="br-store-info">
                                <i class="bi bi-clock-fill"></i>
                                <span>${branch['hours']}</span>
                            </div>
                            <div class="br-store-info">
                                <i class="bi bi-person-badge-fill"></i>
                                <span>Manager: ${branch['manager']}</span>
                            </div>
                            <div class="br-services">
                                <c:forTokens var="svc" items="${branch['services']}" delims="·">
                                    <span class="br-service-tag">${svc.trim()}</span>
                                </c:forTokens>
                            </div>
                            <button class="br-view-map-btn"
                                    data-embed="${branch['mapEmbed']}"
                                    data-index="${st.index}">
                                <i class="bi bi-map-fill"></i>View on Map
                            </button>
                            <a href="${branch['mapLink']}" target="_blank" rel="noopener"
                               class="btn btn-outline-success btn-sm w-100 mt-2">
                                <i class="bi bi-box-arrow-up-right me-1"></i>Open in Google Maps
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 4 — INTERACTIVE MAP
══════════════════════════════════════ -->
<section id="mapSection" class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-4">
            <span class="br-tag">Interactive Map</span>
            <h2 class="br-title mt-2">Find Us on the Map</h2>
            <p class="text-muted mt-2">Select a branch above — the map will update automatically.</p>
        </div>
        <div class="br-map-wrapper">
            <%-- Default: shows the first branch. JS swaps src on button click. --%>
            <iframe id="branchMap"
                    src="https://maps.google.com/maps?q=Da+Nang+Vietnam&output=embed"
                    allowfullscreen
                    loading="lazy"
                    title="GreenFarm branch location map">
            </iframe>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 5 — STORE STATISTICS
══════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-6 col-md-3">
                <div class="br-stat-card">
                    <div class="br-stat-icon"><i class="bi bi-shop-window"></i></div>
                    <div class="br-stat-num" data-count="6" data-suffix="">6</div>
                    <div class="br-stat-lbl">Branches</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="br-stat-card">
                    <div class="br-stat-icon"><i class="bi bi-people-fill"></i></div>
                    <div class="br-stat-num" data-count="20000" data-suffix="+">20,000+</div>
                    <div class="br-stat-lbl">Happy Customers</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="br-stat-card">
                    <div class="br-stat-icon"><i class="bi bi-bag-check-fill"></i></div>
                    <div class="br-stat-num" data-count="500" data-suffix="+">500+</div>
                    <div class="br-stat-lbl">Orders Daily</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="br-stat-card">
                    <div class="br-stat-icon"><i class="bi bi-star-fill"></i></div>
                    <div class="br-stat-num">4.9</div>
                    <div class="br-stat-lbl">Average Rating</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 6 — WHY VISIT GREENFARM
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="text-center mb-5">
            <span class="br-tag">In-Store Experience</span>
            <h2 class="br-title mt-2">Why Visit GreenFarm</h2>
        </div>
        <div class="row g-4">
            <div class="col-6 col-lg-3">
                <div class="br-feature-card">
                    <div class="br-feature-icon"><i class="bi bi-sun-fill"></i></div>
                    <h5 class="fw-bold mb-2">Fresh Products</h5>
                    <p class="text-muted small mb-0">Every shelf is restocked daily with produce harvested just hours before.</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="br-feature-card">
                    <div class="br-feature-icon"><i class="bi bi-patch-check-fill"></i></div>
                    <h5 class="fw-bold mb-2">Certified Quality</h5>
                    <p class="text-muted small mb-0">All products pass our in-store quality check before hitting the shelves.</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="br-feature-card">
                    <div class="br-feature-icon"><i class="bi bi-emoji-smile-fill"></i></div>
                    <h5 class="fw-bold mb-2">Friendly Staff</h5>
                    <p class="text-muted small mb-0">Our trained team is always happy to recommend seasonal picks for you.</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="br-feature-card">
                    <div class="br-feature-icon"><i class="bi bi-lightning-charge-fill"></i></div>
                    <h5 class="fw-bold mb-2">Fast Pickup</h5>
                    <p class="text-muted small mb-0">Order ahead online and collect your basket in under 10 minutes.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 7 — CONTACT INFORMATION
══════════════════════════════════════ -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="br-tag">Get in Touch</span>
            <h2 class="br-title mt-2">Contact &amp; Support</h2>
        </div>
        <div class="row g-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="br-contact-card text-center">
                    <div class="br-contact-icon mx-auto"><i class="bi bi-building"></i></div>
                    <div class="fw-bold mb-1">Head Office</div>
                    <p class="text-muted small mb-0">29 An Thuong 4, My An,<br>Ngu Hanh Son, Da Nang</p>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="br-contact-card text-center">
                    <div class="br-contact-icon mx-auto"><i class="bi bi-telephone-fill"></i></div>
                    <div class="fw-bold mb-1">Phone</div>
                    <p class="text-muted small mb-0">+84 359 151 256<br>Mon–Sat · 7am–8pm</p>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="br-contact-card text-center">
                    <div class="br-contact-icon mx-auto"><i class="bi bi-envelope-fill"></i></div>
                    <div class="fw-bold mb-1">Email</div>
                    <p class="text-muted small mb-0">GreenfarmVN@gmail.com<br>Reply within 2 hours</p>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="br-contact-card text-center">
                    <div class="br-contact-icon mx-auto"><i class="bi bi-clock-fill"></i></div>
                    <div class="fw-bold mb-1">Business Hours</div>
                    <p class="text-muted small mb-0">Mon–Sat: 6am – 9pm<br>Sunday: 7am – 6pm</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══════════════════════════════════════
     SECTION 8 — CTA
══════════════════════════════════════ -->
<section class="py-5" style="background:#fff;">
    <div class="container">
        <div class="br-cta text-center position-relative">
            <h2 class="fw-bold mb-3" style="font-size:clamp(1.7rem,4vw,2.5rem);">
                Visit GreenFarm Today
            </h2>
            <p class="mb-4" style="font-size:1.05rem;opacity:.92;max-width:560px;margin-inline:auto;">
                Step into any of our five branches and experience the freshness,
                warmth, and quality that GreenFarm has been delivering since 2020.
            </p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="${pageContext.request.contextPath}/home"
                   class="btn btn-light fw-bold px-5 py-2 rounded-pill text-success">
                    <i class="bi bi-cart3 me-2"></i>Shop Online
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
<script src="${pageContext.request.contextPath}/js/branches.js"></script>
<jsp:include page="/chatbot.jsp"/>
</body>
</html>
