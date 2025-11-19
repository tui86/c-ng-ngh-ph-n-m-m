-- Tạo cơ sở dữ liệu nếu nó chưa tồn G
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- 1. Bảng User (Khớp với ERD [cite: 201])
CREATE TABLE IF NOT EXISTS User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    Role VARCHAR(50) NOT NULL DEFAULT 'customer'
);

-- 2. Bảng Category
CREATE TABLE IF NOT EXISTS Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY, 
    CategoryName VARCHAR(100) NOT NULL,
    Description TEXT
);

-- 3. Bảng Product
CREATE TABLE IF NOT EXISTS Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    Status VARCHAR(50) DEFAULT 'available',
    CategoryID INT, 
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. Bảng Cart
CREATE TABLE IF NOT EXISTS Cart (
    CartID INT AUTO_INCREMENT PRIMARY KEY,
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    UserID INT UNIQUE,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- 5. Bảng CartItem
CREATE TABLE IF NOT EXISTS CartItem (
    CartItemID INT AUTO_INCREMENT PRIMARY KEY,
    Quantity INT NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    CartID INT,
    ProductID INT,
    FOREIGN KEY (CartID) REFERENCES Cart(CartID)
        ON UPDATE CASCADE ON DELETE CASCADE, 
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- 6. Bảng Order 
CREATE TABLE IF NOT EXISTS `Order` (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    ShippingAddress VARCHAR(255),
    PaymentMethod VARCHAR(50),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- 7. Bảng OrderDetail
CREATE TABLE IF NOT EXISTS OrderDetail (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    OrderID INT,
    ProductID INT,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON UPDATE CASCADE ON DELETE RESTRICT 
);

-- 8. Bảng ReturnExchange
CREATE TABLE IF NOT EXISTS ReturnExchange (
    ReturnID INT AUTO_INCREMENT PRIMARY KEY, 
    Reason VARCHAR(255) NOT NULL,
    Type VARCHAR(50) NOT NULL, -- 'Return' hoặc 'Exchange'
    Status VARCHAR(50) NOT NULL,
    OrderID INT,
    ProductID INT,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- 9. Bảng Report 
CREATE TABLE IF NOT EXISTS Report (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReportDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalOrders INT NOT NULL,
    InventoryStatus VARCHAR(255) NOT NULL,
    PerformanceNote TEXT,
    StaffID INT,
    FOREIGN KEY (StaffID) REFERENCES User(UserID)
        ON UPDATE CASCADE ON DELETE SET NULL
);