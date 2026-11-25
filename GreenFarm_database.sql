-- ============================================================
--  GreenFarm Database Setup Script
--  SQL Server 2016+ / SQL Server Express
--  Chạy script này bằng SQL Server Management Studio (SSMS)
--  hoặc sqlcmd để tạo database và dữ liệu mẫu.
-- ============================================================

-- 1. Tạo database (bỏ qua nếu đã có)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GreenFarm')
BEGIN
    CREATE DATABASE GreenFarm;
END
GO

USE GreenFarm;
GO

-- ============================================================
--  DROP TABLES (đúng thứ tự để tránh lỗi FK)
-- ============================================================
IF OBJECT_ID('Review',          'U') IS NOT NULL DROP TABLE Review;
IF OBJECT_ID('OrderDetail',     'U') IS NOT NULL DROP TABLE OrderDetail;
IF OBJECT_ID('Orders',          'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Product',         'U') IS NOT NULL DROP TABLE Product;
IF OBJECT_ID('Category',        'U') IS NOT NULL DROP TABLE Category;
IF OBJECT_ID('Customer',        'U') IS NOT NULL DROP TABLE Customer;
IF OBJECT_ID('ContactMessage',  'U') IS NOT NULL DROP TABLE ContactMessage;
IF OBJECT_ID('DeliveryConfig',  'U') IS NOT NULL DROP TABLE DeliveryConfig;
GO

-- ============================================================
--  CREATE TABLES
-- ============================================================

CREATE TABLE Category (
    categoryId   INT           IDENTITY(1,1) PRIMARY KEY,
    categoryName NVARCHAR(100) NOT NULL,
    description  NVARCHAR(255) NULL
);
GO

CREATE TABLE Customer (
    customerId INT           IDENTITY(1,1) PRIMARY KEY,
    username   NVARCHAR(50)  NOT NULL UNIQUE,
    password   NVARCHAR(255) NOT NULL,
    fullName   NVARCHAR(100) NOT NULL,
    email      NVARCHAR(100) NULL,
    phone      NVARCHAR(15)  NULL,
    address    NVARCHAR(255) NULL,
    role       NVARCHAR(20)  NOT NULL DEFAULT ('customer')
);
GO

CREATE TABLE Product (
    productId   INT             IDENTITY(1,1) PRIMARY KEY,
    categoryId  INT             NOT NULL,
    productName NVARCHAR(150)   NOT NULL,
    price       DECIMAL(18,2)   NOT NULL,
    quantity    INT             NOT NULL DEFAULT 0,
    description NVARCHAR(MAX)   NULL,
    image       NVARCHAR(255)   NULL DEFAULT ('default.jpg'),
    CONSTRAINT FK_Product_Category FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);
GO

CREATE TABLE Orders (
    orderId        INT             IDENTITY(1,1) PRIMARY KEY,
    customerId     INT             NOT NULL,
    orderDate      DATETIME        NOT NULL DEFAULT (GETDATE()),
    receiverName   NVARCHAR(100)   NOT NULL,
    phone          NVARCHAR(15)    NOT NULL,
    address        NVARCHAR(255)   NOT NULL,
    totalAmount    DECIMAL(18,2)   NOT NULL,
    status         NVARCHAR(30)    NOT NULL DEFAULT (N'Pending'),
    deliveryMethod NVARCHAR(20)    NOT NULL DEFAULT ('Standard'),
    paymentMethod  NVARCHAR(20)    NOT NULL DEFAULT ('COD'),
    shippingFee    DECIMAL(10,2)   NOT NULL DEFAULT (2.00),
    orderNote      NVARCHAR(500)   NULL,
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);
GO

CREATE TABLE OrderDetail (
    detailId  INT           IDENTITY(1,1) PRIMARY KEY,
    orderId   INT           NOT NULL,
    productId INT           NOT NULL,
    price     DECIMAL(18,2) NOT NULL,
    quantity  INT           NOT NULL,
    subtotal  DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_OrderDetail_Order   FOREIGN KEY (orderId)   REFERENCES Orders(orderId),
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (productId) REFERENCES Product(productId)
);
GO

CREATE TABLE Review (
    reviewId   INT           IDENTITY(1,1) PRIMARY KEY,
    productId  INT           NOT NULL,
    customerId INT           NOT NULL,
    rating     INT           NOT NULL,
    comment    NVARCHAR(1000) NOT NULL,
    reviewDate DATETIME      NOT NULL DEFAULT (GETDATE()),
    orderId    INT           NULL,
    CONSTRAINT FK_Review_Product  FOREIGN KEY (productId)  REFERENCES Product(productId),
    CONSTRAINT FK_Review_Customer FOREIGN KEY (customerId) REFERENCES Customer(customerId),
    CONSTRAINT FK_Review_Order    FOREIGN KEY (orderId)    REFERENCES Orders(orderId)
);
GO

CREATE TABLE ContactMessage (
    messageId   INT            IDENTITY(1,1) PRIMARY KEY,
    fullName    NVARCHAR(100)  NOT NULL,
    phoneNumber NVARCHAR(20)   NOT NULL,
    email       NVARCHAR(100)  NULL,
    subject     NVARCHAR(200)  NULL,
    message     NVARCHAR(2000) NOT NULL,
    createdAt   DATETIME       NOT NULL DEFAULT (GETDATE()),
    status      NVARCHAR(20)   NOT NULL DEFAULT ('New')
);
GO

CREATE TABLE DeliveryConfig (
    configId    INT           IDENTITY(1,1) PRIMARY KEY,
    methodKey   NVARCHAR(20)  NOT NULL,
    methodName  NVARCHAR(50)  NOT NULL,
    fee         DECIMAL(18,2) NOT NULL,
    description NVARCHAR(200) NULL
);
GO

-- ============================================================
--  SEED DATA – Category
-- ============================================================
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (categoryId, categoryName, description) VALUES
(1, N'Vegetables',   N'Fresh vegetables'),
(2, N'Fruits',       N'Fresh fruits'),
(3, N'Grains',       N'Rice and cereal'),
(4, N'Herbs',        N'Cooking herbs'),
(5, N'Dairy & Eggs', N'Dairy products');
SET IDENTITY_INSERT Category OFF;
GO

-- ============================================================
--  SEED DATA – Customer
--  Tài khoản admin : username=admin   / password=admin123
--  Tài khoản user  : username=john    / password=john123
--                    username=mary    / password=mary123
--                    username=huy     / password=123456
-- ============================================================
SET IDENTITY_INSERT Customer ON;
INSERT INTO Customer (customerId, username, password, fullName, email, phone, address, role) VALUES
(1,  N'admin',  N'admin123', N'Administrator',    N'admin@greenfarm.vn',       N'0901000001', N'Ho Chi Minh City',           N'admin'),
(2,  N'john',   N'john123',  N'John Nguyen',       N'john@gmail.com',           N'0912345678', N'District 1',                 N'customer'),
(3,  N'mary',   N'mary123',  N'Mary Tran',         N'mary@gmail.com',           N'0987654321', N'District 7',                 N'customer'),
(4,  N'huy',    N'123456',   N'Huy Truong Quang',  N'huytruong@gmail.com',      N'0359151256', N'12/591 Nguyen Tat Thanh',    N'customer'),
(5,  N'trang',  N'123456',   N'Trang Le',          N'trangle@gmail.com',        N'0814063621', N'Phan Chu Trinh',             N'customer'),
(6,  N'son',    N'1234567',  N'Son Nguyen',        N'son@gmail.com',            N'0897465321', N'Phan Chu Trinh',             N'customer'),
(7,  N'phuong', N'123456',   N'Phuong',            N'phuong@gmail.com',         N'0123456789', N'Phan Chu Trinh',             N'customer');
SET IDENTITY_INSERT Customer OFF;
GO

-- ============================================================
--  SEED DATA – DeliveryConfig
-- ============================================================
SET IDENTITY_INSERT DeliveryConfig ON;
INSERT INTO DeliveryConfig (configId, methodKey, methodName, fee, description) VALUES
(1, N'standard', N'Standard Delivery', 2000.00, N'Delivered within 2–4 hours'),
(2, N'express',  N'Express Delivery',  5000.00, N'Delivered within 1 hour');
SET IDENTITY_INSERT DeliveryConfig OFF;
GO

-- ============================================================
--  SEED DATA – Product
-- ============================================================
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (productId, categoryId, productName, price, quantity, description, image) VALUES
-- Vegetables (categoryId = 1)
(1,  1, N'Organic Tomato',  30000.00, 52,  N'Fresh organic tomato', N'tomato.jpg'),
(2,  1, N'Baby Spinach',    40000.00, 66,  N'Organic spinach', N'spinach.jpg'),
(3,  1, N'Broccoli',        25000.00, 52,  N'Fresh broccoli', N'broccoli.jpg'),
(4,  1, N'Sweet Corn',      10000.00, 146, N'Sweet corn', N'corn.jpg'),
(17, 1, N'Asparagus',       12000.00, 64,
    N'A nutrient-dense green vegetable with long, slender spears. It has a unique, earthy flavor and a tender-crisp texture when cooked.',
    N'Asparagus.jpg'),
(18, 1, N'Cabbage',         12000.00, 64,
    N'A leafy green or purple biennial plant, grown as an annual vegetable crop for its dense-leaved heads. Perfect for salads, soups, and stir-fries.',
    N'Cabbage.jpg'),

-- Fruits (categoryId = 2)
(5,  2, N'Mango',           39000.00, 114, N'Vietnam mango', N'mango.jpg'),
(6,  2, N'Dragon Fruit',    35000.00, 65,  N'Red dragon fruit', N'dragonfruit.jpg'),
(7,  2, N'Watermelon',      20000.00, 50,  N'Fresh watermelon', N'watermelon.jpg'),
(13, 2, N'Apple',            2000.00, 64,
    N'A crisp and juicy round fruit available in red, green, or yellow. It offers a perfect balance of sweet and tart flavors and is famous for being rich in fiber and vitamin C.',
    N'Apple.jpg'),
(14, 2, N'Banana',          13000.00, 64,
    N'A long, curved fruit with a soft, sweet flesh and a protective yellow peel. It is a highly convenient snack that is naturally rich in potassium and provides quick energy.',
    N'Banana.jpg'),
(15, 2, N'Strawberrie',     50000.00, 64,
    N'A bright red, heart-shaped berry dotted with tiny seeds on its skin. It has a sweet, fragrant aroma and a juicy texture, making it a favorite for desserts and salads.',
    N'Strawberrie.jpg'),
(16, 2, N'Orange',          21000.00, 64,
    N'A vibrant citrus fruit with a bright orange skin and juicy, segmented flesh. It is world-renowned for its high vitamin C content and refreshing, sweet-and-sour taste.',
    N'Orange.jpg'),

-- Grains (categoryId = 3)
(8,  3, N'Jasmine Rice 1kg', 25000.00, 200, N'Premium rice', N'rice.jpg'),
(9,  3, N'Sweet Potato',     18000.00, 87,  N'Sweet potato', N'sweetpotato.jpg'),
(22, 3, N'Oatmeal',           5.90,    64,
    N'A hearty, whole-grain cereal commonly rolled or crushed for quick cooking. Rich in soluble fiber (beta-glucan), it is a breakfast favorite known for supporting heart health and providing lasting energy.',
    N'Oatmeal.jpg'),
(23, 3, N'Brown Rice',        5.80,    64,
    N'A whole grain rice with only the inedible outer hull removed. It retains its nutrient-rich bran and germ layers, offering a nutty flavor and chewy texture.',
    N'Brown Rice.jpg'),

-- Herbs (categoryId = 4)
(10, 4, N'Lemongrass',      5000.00, 110, N'Fresh lemongrass', N'lemongrass.jpg'),
(11, 4, N'Pandan Leaves',   8000.00, 130, N'Fresh pandan', N'pandan.jpg'),
(19, 4, N'Rosemary',        8000.00, 64,
    N'A woody, perennial herb with fragrant, needle-like leaves. It has a distinctive aromatic scent with hints of pine and lemon, making it perfect for roasting with meats and potatoes.',
    N'Rosemary.jpg'),
(20, 4, N'Mint',             0.20,   64,
    N'A refreshing herb known for its cooling menthol sensation and sweet aroma. It is highly versatile, widely used in beverages (like mojitos and teas), desserts, and savory Mediterranean dishes.',
    N'Mint.jpg'),

-- Dairy & Eggs (categoryId = 5)
(12, 5, N'Free Range Eggs', 15000.00, 61, N'10 eggs', N'eggs.jpg'),
(24, 5, N'Cheese',           1.00,   64,
    N'A dairy product made from pressed milk curds. It comes in a wide range of textures and flavors, from mild and creamy to sharp and hard, rich in calcium and protein.',
    N'Cheese.jpg'),
(25, 5, N'Quail Eggs',       2.00,   64,
    N'Tiny, bite-sized eggs with speckled brown and white shells. Despite their small size, they have a high yolk-to-white ratio, offering a rich flavor popular in street food and stews.',
    N'Quail Eggs.jpg'),
(26, 5, N'Butter',          9000.00, 63,
    N'A rich dairy product made by churning milk or cream. It adds a savory, creamy flavor and flaky texture to baked goods and pan-seared dishes.',
    N'Butter.jpg');
SET IDENTITY_INSERT Product OFF;
GO

-- Reset IDENTITY counters to max existing IDs
DBCC CHECKIDENT ('Category',      RESEED, 5);
DBCC CHECKIDENT ('Customer',      RESEED, 7);
DBCC CHECKIDENT ('DeliveryConfig',RESEED, 2);
DBCC CHECKIDENT ('Product',       RESEED, 26);
GO

-- ============================================================
--  VERIFY
-- ============================================================
SELECT 'Category'       AS [Table], COUNT(*) AS [Rows] FROM Category
UNION ALL
SELECT 'Customer',       COUNT(*) FROM Customer
UNION ALL
SELECT 'Product',        COUNT(*) FROM Product
UNION ALL
SELECT 'DeliveryConfig', COUNT(*) FROM DeliveryConfig
UNION ALL
SELECT 'Orders',         COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderDetail',    COUNT(*) FROM OrderDetail
UNION ALL
SELECT 'Review',         COUNT(*) FROM Review
UNION ALL
SELECT 'ContactMessage', COUNT(*) FROM ContactMessage;
GO

-- ============================================================
--  DONE
--  Tài khoản mặc định:
--    Admin : username=admin  / password=admin123
--    User  : username=john   / password=john123
--            username=mary   / password=mary123
--            username=huy    / password=123456
--            username=trang  / password=123456
--            username=son    / password=1234567
--            username=phuong / password=123456
-- ============================================================
