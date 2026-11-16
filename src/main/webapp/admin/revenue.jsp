<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Revenue Dashboard - GreenFarm Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .rev-card { border: none; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,.08); }
        .rev-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0; }
        .rev-label { font-size: .78rem; color: #6c757d; font-weight: 500; }
        .rev-value { font-size: 1.45rem; font-weight: 700; line-height: 1.1; }
        .filter-card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,.06); }
        .chart-card  { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,.06); }
    </style>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/revenue">
                            <i class="bi bi-bar-chart-line me-1"></i>Revenue
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">
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

    <!-- Page Header -->
    <div class="bg-white border-bottom py-3">
        <div class="container-fluid">
            <h4 class="mb-0 text-success">
                <i class="bi bi-bar-chart-line me-2"></i>Revenue Dashboard
            </h4>
        </div>
    </div>

    <div class="container-fluid py-4">

        <!-- ── Summary Cards ───────────────────────────────────────── -->
        <div class="row g-3 mb-4">

            <!-- Total Revenue -->
            <div class="col-6 col-xl-3">
                <div class="card rev-card h-100 p-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rev-icon bg-success bg-opacity-10">
                            <i class="bi bi-currency-dollar text-success"></i>
                        </div>
                        <div>
                            <div class="rev-label">Total Revenue</div>
                            <div class="rev-value text-success">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                            </div>
                            <div class="text-muted" style="font-size:.72rem;">All completed orders</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Today's Revenue -->
            <div class="col-6 col-xl-3">
                <div class="card rev-card h-100 p-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rev-icon" style="background:rgba(13,110,253,.1);">
                            <i class="bi bi-calendar-day" style="color:#0d6efd;"></i>
                        </div>
                        <div>
                            <div class="rev-label">Today's Revenue</div>
                            <div class="rev-value" style="color:#0d6efd;">
                                <fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="$"/>
                            </div>
                            <div class="text-muted" style="font-size:.72rem;">Completed today</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Monthly Revenue -->
            <div class="col-6 col-xl-3">
                <div class="card rev-card h-100 p-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rev-icon" style="background:rgba(255,193,7,.12);">
                            <i class="bi bi-calendar-month" style="color:#e6a817;"></i>
                        </div>
                        <div>
                            <div class="rev-label">This Month</div>
                            <div class="rev-value" style="color:#e6a817;">
                                <fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="$"/>
                            </div>
                            <div class="text-muted" style="font-size:.72rem;">Current calendar month</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Yearly Revenue -->
            <div class="col-6 col-xl-3">
                <div class="card rev-card h-100 p-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rev-icon" style="background:rgba(111,66,193,.1);">
                            <i class="bi bi-calendar-year" style="color:#6f42c1;"></i>
                        </div>
                        <div>
                            <div class="rev-label">This Year</div>
                            <div class="rev-value" style="color:#6f42c1;">
                                <fmt:formatNumber value="${yearlyRevenue}" type="currency" currencySymbol="$"/>
                            </div>
                            <div class="text-muted" style="font-size:.72rem;">Current calendar year</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- ── Filter Panel ────────────────────────────────────────── -->
        <div class="card filter-card mb-4">
            <div class="card-body py-3">
                <form action="${pageContext.request.contextPath}/admin/revenue" method="get"
                      class="row g-2 align-items-end">

                    <div class="col-12 col-md-auto">
                        <label class="form-label fw-semibold mb-1 small">Quick Filter</label>
                        <select name="quick" id="quickSelect" class="form-select form-select-sm"
                                onchange="handleQuickFilter(this.value)">
                            <option value="today"     ${quickFilter == 'today'     ? 'selected' : ''}>Today</option>
                            <option value="thisWeek"  ${quickFilter == 'thisWeek'  ? 'selected' : ''}>This Week</option>
                            <option value="thisMonth" ${quickFilter == 'thisMonth' ? 'selected' : ''}>This Month</option>
                            <option value="thisYear"  ${quickFilter == 'thisYear'  ? 'selected' : ''}>This Year</option>
                            <option value="custom"    ${quickFilter == 'custom'    ? 'selected' : ''}>Custom Range</option>
                        </select>
                    </div>

                    <div id="customRange" class="col-12 col-md-auto d-flex gap-2 align-items-end"
                         style="${quickFilter == 'custom' ? '' : 'display:none !important;'}">
                        <div>
                            <label class="form-label fw-semibold mb-1 small">Date From</label>
                            <input type="date" name="dateFrom" class="form-control form-control-sm"
                                   value="${dateFrom}">
                        </div>
                        <div>
                            <label class="form-label fw-semibold mb-1 small">Date To</label>
                            <input type="date" name="dateTo" class="form-control form-control-sm"
                                   value="${dateTo}">
                        </div>
                    </div>

                    <div class="col-12 col-md-auto">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success btn-sm px-3">
                                <i class="bi bi-funnel me-1"></i>Apply
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/revenue"
                               class="btn btn-outline-secondary btn-sm px-3">
                                <i class="bi bi-x-circle me-1"></i>Reset
                            </a>
                        </div>
                    </div>

                    <!-- Filtered result display -->
                    <div class="col-12 col-md-auto ms-md-auto">
                        <div class="bg-success bg-opacity-10 rounded-3 px-3 py-2 text-center">
                            <div class="text-muted small">Filtered Revenue</div>
                            <div class="fw-bold text-success fs-5">
                                <fmt:formatNumber value="${filteredRevenue}" type="currency" currencySymbol="$"/>
                            </div>
                            <div class="text-muted" style="font-size:.72rem;">
                                ${dateFrom} → ${dateTo}
                            </div>
                        </div>
                    </div>

                </form>
            </div>
        </div>

        <!-- ── Chart + Top Products ────────────────────────────────── -->
        <div class="row g-4 mb-4">

            <!-- Line Chart -->
            <div class="col-12 col-xl-8">
                <div class="card chart-card h-100">
                    <div class="card-header bg-white border-bottom fw-semibold py-3 text-success">
                        <i class="bi bi-graph-up me-2"></i>Monthly Revenue — Current Year
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart" height="110"></canvas>
                    </div>
                </div>
            </div>

            <!-- Top 5 Products -->
            <div class="col-12 col-xl-4">
                <div class="card chart-card h-100">
                    <div class="card-header bg-white border-bottom fw-semibold py-3 text-success">
                        <i class="bi bi-trophy me-2"></i>Top 5 Products by Revenue
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty topProducts}">
                                <div class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox fs-1"></i>
                                    <p class="mt-2 mb-0">No data yet.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-success">
                                            <tr>
                                                <th class="ps-3">#</th>
                                                <th>Product</th>
                                                <th class="text-end">Qty</th>
                                                <th class="text-end pe-3">Revenue</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="row" items="${topProducts}" varStatus="s">
                                                <tr>
                                                    <td class="ps-3 fw-semibold text-muted">${s.index + 1}</td>
                                                    <td class="fw-semibold">${row[0]}</td>
                                                    <td class="text-end">${row[1]}</td>
                                                    <td class="text-end pe-3 text-success fw-bold">
                                                        <fmt:formatNumber value="${row[2]}" type="currency" currencySymbol="$"/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <!-- ── Recent Completed Orders ────────────────────────────── -->
        <div class="card chart-card">
            <div class="card-header bg-white border-bottom d-flex justify-content-between align-items-center py-3">
                <span class="fw-semibold text-success">
                    <i class="bi bi-clock-history me-2"></i>Recent Active Orders
                </span>
                <a href="${pageContext.request.contextPath}/admin/orders"
                   class="btn btn-sm btn-outline-success">View All</a>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty recentOrders}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-inbox display-1"></i>
                            <h5 class="mt-3">No active orders yet.</h5>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-success">
                                    <tr>
                                        <th class="ps-3">Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Receiver</th>
                                        <th>Phone</th>
                                        <th class="text-end">Total</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td class="ps-3 fw-semibold">#${order.orderId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customerMap[order.customerId]}">
                                                        <span class="fw-semibold">${customerMap[order.customerId].fullName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">ID: ${order.customerId}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>${order.receiverName}</td>
                                            <td>${order.phone}</td>
                                            <td class="text-end text-success fw-bold">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$"/>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${order.status == 'Completed'}">
                                                        <span class="badge bg-success">Completed</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Shipping'}">
                                                        <span class="badge bg-primary">Shipping</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Confirmed'}">
                                                        <span class="badge bg-info text-dark">Confirmed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${order.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.orderId}"
                                                   class="btn btn-sm btn-outline-success">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div><!-- /container-fluid -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        // ── Chart.js — Monthly Revenue Line Chart ─────────────────
        (function () {
            // chartData is a double[12] from the servlet (index 0 = Jan)
            var rawData = [
                <c:forEach var="v" items="${chartData}" varStatus="s">${v}<c:if test="${!s.last}">,</c:if></c:forEach>
            ];

            var ctx = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan','Feb','Mar','Apr','May','Jun',
                             'Jul','Aug','Sep','Oct','Nov','Dec'],
                    datasets: [{
                        label: 'Revenue ($)',
                        data: rawData,
                        borderColor: '#198754',
                        backgroundColor: 'rgba(25,135,84,0.08)',
                        borderWidth: 2.5,
                        pointBackgroundColor: '#198754',
                        pointRadius: 4,
                        tension: 0.35,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(ctx) {
                                    return ' $' + ctx.parsed.y.toLocaleString('en-US', {minimumFractionDigits: 2});
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(v) { return '$' + v.toLocaleString(); }
                            },
                            grid: { color: 'rgba(0,0,0,.05)' }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });
        })();

        // ── Quick-filter toggle for custom date range ──────────────
        function handleQuickFilter(value) {
            var el = document.getElementById('customRange');
            if (value === 'custom') {
                el.style.removeProperty('display');
            } else {
                el.style.display = 'none';
            }
        }
    </script>
</body>
</html>
