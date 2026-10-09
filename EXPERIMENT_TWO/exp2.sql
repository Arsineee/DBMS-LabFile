-- ============================================================
-- EXPERIMENT 2
-- CONVERSION OF ER DIAGRAM INTO RELATIONAL SCHEMA
-- Indian E-Commerce Platform
-- ============================================================

-- ------------------------------------------------------------
-- 1. CREATE DATABASE
-- ------------------------------------------------------------

DROP DATABASE IF EXISTS IndianECommerce;
CREATE DATABASE IndianECommerce;
USE IndianECommerce;


-- ============================================================
-- 2. CUSTOMER TABLE
-- ============================================================

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Date_Joined DATE NOT NULL
);


-- ============================================================
-- 3. CUSTOMER_PHONE TABLE
-- Multivalued attribute of Customer
-- ============================================================

CREATE TABLE Customer_Phone (
    Customer_ID INT NOT NULL,
    Phone_Number VARCHAR(15) NOT NULL,

    PRIMARY KEY (Customer_ID, Phone_Number),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 4. SELLER TABLE
-- ============================================================

CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY AUTO_INCREMENT,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE
);


-- ============================================================
-- 5. CATEGORY TABLE
-- ============================================================

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);


-- ============================================================
-- 6. PRODUCT TABLE
-- ============================================================

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    Category_ID INT NOT NULL,
    Seller_ID INT,

    CONSTRAINT chk_product_price
        CHECK (Price >= 0),

    CONSTRAINT chk_product_stock
        CHECK (Stock >= 0),

    FOREIGN KEY (Category_ID)
        REFERENCES Category(Category_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Seller_ID)
        REFERENCES Seller(Seller_ID)
        ON DELETE SET NULL
);


-- ============================================================
-- 7. PRODUCT SPECIALIZATION
-- Product -> Electronics
-- Product -> Clothing
-- ============================================================

CREATE TABLE Electronics_Product (
    Product_ID INT PRIMARY KEY,
    Warranty_Years INT NOT NULL,

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE,

    CHECK (Warranty_Years >= 0)
);


CREATE TABLE Clothing_Product (
    Product_ID INT PRIMARY KEY,
    Size VARCHAR(10) NOT NULL,
    Material VARCHAR(50),

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 8. ADDRESS TABLE
-- Weak Entity of Customer
-- Composite Primary Key: Customer_ID + Address_ID
-- ============================================================

CREATE TABLE Address (
    Customer_ID INT NOT NULL,
    Address_ID INT NOT NULL,
    Address_Type VARCHAR(20) NOT NULL,
    House_No VARCHAR(50) NOT NULL,
    Street VARCHAR(100),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PIN_Code VARCHAR(10) NOT NULL,

    PRIMARY KEY (Customer_ID, Address_ID),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 9. ORDERS TABLE
-- ORDER is a reserved keyword in SQL,
-- therefore we use Orders as the table name.
-- ============================================================

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Address_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(12,2) NOT NULL,
    Order_Status VARCHAR(30) NOT NULL DEFAULT 'Placed',

    CONSTRAINT chk_order_amount
        CHECK (Total_Amount >= 0),

    FOREIGN KEY (Customer_ID, Address_ID)
        REFERENCES Address(Customer_ID, Address_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 10. ORDER ITEM TABLE
-- Weak Entity of Orders
-- Composite Primary Key: Order_ID + Product_ID
-- ============================================================

CREATE TABLE OrderItem (
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (Order_ID, Product_ID),

    CONSTRAINT chk_quantity
        CHECK (Quantity > 0),

    CONSTRAINT chk_unit_price
        CHECK (Unit_Price >= 0),

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 11. PAYMENT TABLE
-- ============================================================

CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Method VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(30) NOT NULL,
    Transaction_ID VARCHAR(100) UNIQUE,
    Payment_Date DATE,

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 12. DELIVERY TABLE
-- ============================================================

CREATE TABLE Delivery (
    Delivery_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL UNIQUE,
    Delivery_Date DATE,
    Delivery_Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    Tracking_Number VARCHAR(100) UNIQUE,

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 13. INSERT SAMPLE CUSTOMERS
-- ============================================================

INSERT INTO Customer
(Customer_Name, Email, Password, Date_Joined)
VALUES
('Ujjawal Chauhan', 'ujjawal@gmail.com', 'pass123', '2026-01-10'),
('Rahul Sharma', 'rahul@gmail.com', 'rahul123', '2026-01-15'),
('Aman Verma', 'aman@gmail.com', 'aman123', '2026-02-01'),
('Priya Singh', 'priya@gmail.com', 'priya123', '2026-02-10');


-- ============================================================
-- 14. INSERT CUSTOMER PHONE NUMBERS
-- Multivalued attribute
-- ============================================================

INSERT INTO Customer_Phone
(Customer_ID, Phone_Number)
VALUES
(1, '9876543210'),
(1, '9123456780'),
(2, '9876543211'),
(3, '9876543212'),
(4, '9876543213');


-- ============================================================
-- 15. INSERT SELLERS
-- ============================================================

INSERT INTO Seller
(Seller_Name, Email, Phone)
VALUES
('Tech World India', 'techworld@gmail.com', '9000000001'),
('Fashion Hub India', 'fashionhub@gmail.com', '9000000002'),
('Home Store India', 'homestore@gmail.com', '9000000003');


-- ============================================================
-- 16. INSERT CATEGORIES
-- ============================================================

INSERT INTO Category
(Category_Name, Description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Men and women clothing'),
('Home Appliances', 'Products used in homes');


-- ============================================================
-- 17. INSERT PRODUCTS
-- ============================================================

INSERT INTO Product
(Product_Name, Price, Stock, Category_ID, Seller_ID)
VALUES
('Wireless Headphones', 2499.00, 50, 1, 1),
('Mechanical Keyboard', 3999.00, 30, 1, 1),
('Cotton T-Shirt', 799.00, 100, 2, 2),
('Smart Watch', 4999.00, 25, 1, 1),
('Table Lamp', 1299.00, 40, 3, 3);


-- ============================================================
-- 18. INSERT ELECTRONICS SPECIALIZATION
-- ============================================================

INSERT INTO Electronics_Product
(Product_ID, Warranty_Years)
VALUES
(1, 1),
(2, 2),
(4, 1);


-- ============================================================
-- 19. INSERT CLOTHING SPECIALIZATION
-- ============================================================

INSERT INTO Clothing_Product
(Product_ID, Size, Material)
VALUES
(3, 'L', 'Cotton');


-- ============================================================
-- 20. INSERT CUSTOMER ADDRESSES
-- Address is a weak entity
-- ============================================================

INSERT INTO Address
(Customer_ID, Address_ID, Address_Type, House_No,
 Street, City, State, PIN_Code)
VALUES
(1, 1, 'Home', 'H-101', 'MG Road', 'Lucknow',
 'Uttar Pradesh', '226001'),

(1, 2, 'Hostel', 'Room 205', 'University Road', 'Lucknow',
 'Uttar Pradesh', '226021'),

(2, 1, 'Home', 'H-202', 'Main Road', 'Delhi',
 'Delhi', '110001'),

(3, 1, 'Home', 'H-303', 'Civil Lines', 'Prayagraj',
 'Uttar Pradesh', '211001'),

(4, 1, 'Home', 'H-404', 'Gomti Nagar', 'Lucknow',
 'Uttar Pradesh', '226010');


-- ============================================================
-- 21. INSERT ORDERS
-- ============================================================

INSERT INTO Orders
(Customer_ID, Address_ID, Order_Date, Total_Amount, Order_Status)
VALUES
(1, 1, '2026-08-01', 2499.00, 'Placed'),

(2, 1, '2026-08-03', 3999.00, 'Shipped'),

(3, 1, '2026-08-05', 799.00, 'Delivered');


-- ============================================================
-- 22. INSERT ORDER ITEMS
-- ============================================================

INSERT INTO OrderItem
(Order_ID, Product_ID, Quantity, Unit_Price)
VALUES
(1, 1, 1, 2499.00),
(2, 2, 1, 3999.00),
(3, 3, 1, 799.00);


-- ============================================================
-- 23. INSERT PAYMENTS
-- ============================================================

INSERT INTO Payment
(Order_ID, Payment_Method, Payment_Status,
 Transaction_ID, Payment_Date)
VALUES
(1, 'UPI', 'Success', 'TXN10001', '2026-08-01'),

(2, 'Credit Card', 'Success', 'TXN10002', '2026-08-03'),

(3, 'Cash on Delivery', 'Pending', NULL, NULL);


-- ============================================================
-- 24. INSERT DELIVERY INFORMATION
-- ============================================================

INSERT INTO Delivery
(Order_ID, Delivery_Date, Delivery_Status, Tracking_Number)
VALUES
(1, '2026-08-04', 'Delivered', 'TRK10001'),

(2, NULL, 'In Transit', 'TRK10002'),

(3, '2026-08-08', 'Delivered', 'TRK10003');


-- ============================================================
-- 25. DISPLAY ALL TABLES
-- ============================================================

SELECT * FROM Customer;

SELECT * FROM Customer_Phone;

SELECT * FROM Seller;

SELECT * FROM Category;

SELECT * FROM Product;

SELECT * FROM Electronics_Product;

SELECT * FROM Clothing_Product;

SELECT * FROM Address;

SELECT * FROM Orders;

SELECT * FROM OrderItem;

SELECT * FROM Payment;

SELECT * FROM Delivery;


-- ============================================================
-- 26. DEMONSTRATE NOT NULL VIOLATION
-- ============================================================

-- This will generate an error because Customer_Name
-- cannot be NULL.

INSERT INTO Customer
(Customer_Name, Email, Password, Date_Joined)
VALUES
(NULL, 'test@gmail.com', 'test123', '2026-08-19');


-- ============================================================
-- 27. DEMONSTRATE UNIQUE CONSTRAINT VIOLATION
-- ============================================================

-- This will generate an error because the email
-- already exists.

INSERT INTO Customer
(Customer_Name, Email, Password, Date_Joined)
VALUES
('Test User', 'ujjawal@gmail.com', 'test123', '2026-08-19');


-- ============================================================
-- 28. DEMONSTRATE PRIMARY KEY VIOLATION
-- ============================================================

-- Customer_ID 1 already exists.

INSERT INTO Customer
(Customer_ID, Customer_Name, Email, Password, Date_Joined)
VALUES
(1, 'Duplicate User', 'duplicate@gmail.com',
 'duplicate123', '2026-08-19');


-- ============================================================
-- 29. DEMONSTRATE FOREIGN KEY / REFERENTIAL INTEGRITY
-- ============================================================

-- Customer_ID 999 does not exist.

INSERT INTO Customer_Phone
(Customer_ID, Phone_Number)
VALUES
(999, '9999999999');


-- ============================================================
-- 30. FOREIGN KEY VIOLATION IN PRODUCT
-- ============================================================

-- Category_ID 999 does not exist.

INSERT INTO Product
(Product_Name, Price, Stock, Category_ID, Seller_ID)
VALUES
('Invalid Product', 1000.00, 10, 999, 1);


-- ============================================================
-- 31. FOREIGN KEY VIOLATION IN ORDER ITEM
-- ============================================================

-- Product_ID 999 does not exist.

INSERT INTO OrderItem
(Order_ID, Product_ID, Quantity, Unit_Price)
VALUES
(1, 999, 1, 1000.00);


-- ============================================================
-- 32. DEMONSTRATE ON DELETE SET NULL
-- ============================================================

-- Product 1 belongs to Seller 1.

SELECT * FROM Product
WHERE Product_ID = 1;

-- Delete Seller 1.

DELETE FROM Seller
WHERE Seller_ID = 1;

-- Product 1 remains, but Seller_ID becomes NULL.

SELECT * FROM Product
WHERE Product_ID = 1;


-- ============================================================
-- 33. DEMONSTRATE ON DELETE CASCADE
-- ============================================================

-- Delete Category 3.

DELETE FROM Category
WHERE Category_ID = 3;

-- Products belonging to Category 3 are automatically deleted.

SELECT * FROM Product
WHERE Category_ID = 3;


-- ============================================================
-- 34. DEMONSTRATE ORDER CASCADE
-- ============================================================

-- Delete Order 1.

DELETE FROM Orders
WHERE Order_ID = 1;

-- Its OrderItem, Payment and Delivery records
-- are automatically deleted.

SELECT * FROM OrderItem
WHERE Order_ID = 1;

SELECT * FROM Payment
WHERE Order_ID = 1;

SELECT * FROM Delivery
WHERE Order_ID = 1;


-- ============================================================
-- 35. USEFUL JOIN QUERY
-- ============================================================

SELECT
    O.Order_ID,
    C.Customer_Name,
    P.Product_Name,
    OI.Quantity,
    OI.Unit_Price,
    O.Order_Status
FROM Orders O
JOIN Customer C
    ON O.Customer_ID = C.Customer_ID
JOIN OrderItem OI
    ON O.Order_ID = OI.Order_ID
JOIN Product P
    ON OI.Product_ID = P.Product_ID;