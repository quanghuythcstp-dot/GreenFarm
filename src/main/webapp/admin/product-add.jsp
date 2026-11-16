<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - GreenFarm Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Admin Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/admin/products">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/products">
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
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/admin/products"
                           class="text-success text-decoration-none">Products</a>
                    </li>
                    <li class="breadcrumb-item active">Add New Product</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-plus-circle me-2"></i>Add New Product
                        </h5>
                    </div>
                    <div class="card-body p-4">

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="bi bi-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/products" method="post">
                            <input type="hidden" name="action" value="insert">

                            <!-- Category -->
                            <div class="mb-3">
                                <label for="categoryId" class="form-label fw-semibold">
                                    Category <span class="text-danger">*</span>
                                </label>
                                <select id="categoryId" name="categoryId" class="form-select" required>
                                    <option value="" disabled selected>-- Select Category --</option>
                                    <c:forEach var="category" items="${categoryList}">
                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Product Name -->
                            <div class="mb-3">
                                <label for="productName" class="form-label fw-semibold">
                                    Product Name <span class="text-danger">*</span>
                                </label>
                                <input type="text" id="productName" name="productName"
                                       class="form-control"
                                       placeholder="e.g. Organic Tomato"
                                       value="${param.productName}"
                                       required>
                            </div>

                            <!-- Price and Quantity -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label fw-semibold">
                                        Price ($) <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white">$</span>
                                        <input type="number" id="price" name="price"
                                               class="form-control"
                                               placeholder="0.00"
                                               value="${param.price}"
                                               step="0.01" min="0.01"
                                               required>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="quantity" class="form-label fw-semibold">
                                        Quantity <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" id="quantity" name="quantity"
                                           class="form-control"
                                           placeholder="0"
                                           value="${param.quantity}"
                                           min="0"
                                           required>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="mb-3">
                                <label for="description" class="form-label fw-semibold">Description</label>
                                <textarea id="description" name="description"
                                          class="form-control" rows="4"
                                          placeholder="Enter product description...">${param.description}</textarea>
                            </div>

                            <!-- Image Filename -->
                            <div class="mb-4">
                                <label for="image" class="form-label fw-semibold">Image Filename</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-image text-success"></i>
                                    </span>
                                    <input type="text" id="image" name="image"
                                           class="form-control"
                                           placeholder="e.g. tomato.jpg"
                                           value="${param.image}">
                                </div>
                                <div class="form-text">
                                    Enter the image filename only. The image file must be placed in
                                    <code>webapp/images/</code> folder.
                                </div>
                            </div>

                            <!-- Image Preview -->
                            <div class="mb-4" id="previewContainer" style="display: none;">
                                <label class="form-label fw-semibold">Image Preview</label>
                                <div>
                                    <img id="imagePreview" src="" alt="Preview"
                                         style="height: 150px; object-fit: cover;"
                                         class="rounded border">
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-success px-4">
                                    <i class="bi bi-check-circle me-2"></i>Add Product
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/products"
                                   class="btn btn-outline-secondary px-4">
                                    <i class="bi bi-x-circle me-2"></i>Cancel
                                </a>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Live image preview from filename input
        const imageInput   = document.getElementById('image');
        const previewImg   = document.getElementById('imagePreview');
        const previewCont  = document.getElementById('previewContainer');
        const contextPath  = '${pageContext.request.contextPath}';

        imageInput.addEventListener('input', function () {
            const filename = this.value.trim();
            if (filename) {
                previewImg.src = contextPath + '/images/' + filename;
                previewImg.onerror = function () {
                    this.src = contextPath + '/images/default.jpg';
                };
                previewCont.style.display = 'block';
            } else {
                previewCont.style.display = 'none';
            }
        });
    </script>
</body>
</html>
