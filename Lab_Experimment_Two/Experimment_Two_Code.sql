-- ==========================================
-- 1. CREATE DATABASE
-- ==========================================

DROP DATABASE IF EXISTS IndianECommerce;
CREATE DATABASE IndianECommerce;
USE IndianECommerce;


-- ==========================================
-- 2. CUSTOMER TABLE
-- ==========================================

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Date_Joined DATE NOT NULL
);


-- ==========================================
-- 3. CUSTOMER PHONE TABLE
-- Multivalued attribute
-- ==========================================

CREATE TABLE Customer_Phone (
    Customer_ID INT NOT NULL,
    Phone_Number VARCHAR(15) NOT NULL,
    PRIMARY KEY (Customer_ID, Phone_Number),
    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
);


-- ==========================================
-- 4. SELLER TABLE
-- ==========================================

CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY AUTO_INCREMENT,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE
);


-- ==========================================
-- 5. CATEGORY TABLE
-- ==========================================

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);


-- ==========================================
-- 6. PRODUCT TABLE
-- ==========================================

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    Category_ID INT NOT NULL,
    Seller_ID INT,

    CONSTRAINT chk_price CHECK (Price >= 0),
    CONSTRAINT chk_stock CHECK (Stock >= 0),

    FOREIGN KEY (Category_ID)
        REFERENCES Category(Category_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Seller_ID)
        REFERENCES Seller(Seller_ID)
        ON DELETE SET NULL
);


-- ==========================================
-- 7. PRODUCT SPECIALIZATION TABLES
-- ==========================================

CREATE TABLE Electronics_Product (
    Product_ID INT PRIMARY KEY,
    Warranty_Years INT NOT NULL CHECK (Warranty_Years >= 0),
    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);

CREATE TABLE Clothing_Product (
    Product_ID INT PRIMARY KEY,
    Size VARCHAR(10) NOT NULL,
    Material VARCHAR(50),
    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);


-- ==========================================
-- 8. ADDRESS TABLE
-- Weak entity with a composite primary key
-- ==========================================

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


-- ==========================================
-- 9. ORDERS TABLE
-- ==========================================

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Address_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(12,2) NOT NULL,
    Order_Status VARCHAR(30) NOT NULL DEFAULT 'Placed',

    CONSTRAINT chk_total CHECK (Total_Amount >= 0),

    FOREIGN KEY (Customer_ID, Address_ID)
        REFERENCES Address(Customer_ID, Address_ID)
        ON DELETE CASCADE
);


-- ==========================================
-- 10. ORDER ITEM TABLE
-- Weak entity of Orders
-- ==========================================

CREATE TABLE OrderItem (
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (Order_ID, Product_ID),

    CONSTRAINT chk_qty CHECK (Quantity > 0),
    CONSTRAINT chk_unit_price CHECK (Unit_Price >= 0),

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);


-- ==========================================
-- 11. PAYMENT TABLE
-- ==========================================

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


-- ==========================================
-- 12. DELIVERY TABLE
-- ==========================================

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


-- ==========================================
-- 13. INSERT CUSTOMER DATA
-- ==========================================

INSERT INTO Customer
(Customer_Name, Email, Password, Date_Joined)
VALUES
('Arnav Mehta', 'arnav@example.com', 'arnav123', '2026-01-12'),
('Riya Kapoor', 'riya@example.com', 'riya123', '2026-01-20'),
('Kunal Joshi', 'kunal@example.com', 'kunal123', '2026-02-05'),
('Mehak Saini', 'mehak@example.com', 'mehak123', '2026-02-15');


-- ==========================================
-- 14. CUSTOMER CONTACT NUMBERS
-- ==========================================

INSERT INTO Customer_Phone
(Customer_ID, Phone_Number)
VALUES
(1, '9811100001'),
(1, '9811100002'),
(2, '9811100003'),
(3, '9811100004'),
(4, '9811100005');


-- ==========================================
-- 15. SELLER RECORDS
-- ==========================================

INSERT INTO Seller (Seller_Name, Email, Phone)
VALUES
('Digital Mart', 'digital@example.com', '9100000001'),
('Style Street', 'style@example.com', '9100000002'),
('Urban Living', 'urban@example.com', '9100000003');


-- ==========================================
-- 16. PRODUCT CATEGORIES
-- ==========================================

INSERT INTO Category (Category_Name, Description)
VALUES
('Electronics', 'Electronic gadgets and accessories'),
('Clothing', 'Apparel and fashion products'),
('Home Appliances', 'Useful products for households');


-- ==========================================
-- 17. PRODUCT INVENTORY
-- ==========================================

INSERT INTO Product
(Product_Name, Price, Stock, Category_ID, Seller_ID)
VALUES
('Bluetooth Speaker', 2199.00, 45, 1, 1),
('Gaming Mouse', 1499.00, 35, 1, 1),
('Casual Shirt', 999.00, 80, 2, 2),
('Fitness Band', 2999.00, 20, 1, 1),
('Desk Lamp', 1199.00, 30, 3, 3);


-- ==========================================
-- 18. ELECTRONICS DETAILS
-- ==========================================

INSERT INTO Electronics_Product
(Product_ID, Warranty_Years)
VALUES
(1, 1),
(2, 2),
(4, 1);


-- ==========================================
-- 19. CLOTHING DETAILS
-- ==========================================

INSERT INTO Clothing_Product
(Product_ID, Size, Material)
VALUES
(3, 'M', 'Cotton');


-- ==========================================
-- 20. CUSTOMER ADDRESSES
-- ==========================================

INSERT INTO Address
(Customer_ID, Address_ID, Address_Type, House_No,
 Street, City, State, PIN_Code)
VALUES
(1, 1, 'Home', 'A-101', 'Park Street',
 'Jaipur', 'Rajasthan', '302001'),

(1, 2, 'Hostel', 'Room 12', 'College Road',
 'Jaipur', 'Rajasthan', '302015'),

(2, 1, 'Home', 'B-202', 'Nehru Road',
 'Chandigarh', 'Chandigarh', '160001'),

(3, 1, 'Home', 'C-303', 'Civil Lines',
 'Kanpur', 'Uttar Pradesh', '208001'),

(4, 1, 'Home', 'D-404', 'Sector 21',
 'Gurugram', 'Haryana', '122016');


-- ==========================================
-- 21. CREATE CUSTOMER ORDERS
-- ==========================================

INSERT INTO Orders
(Customer_ID, Address_ID, Order_Date, Total_Amount, Order_Status)
VALUES
(1, 1, '2026-08-02', 2199.00, 'Placed'),
(2, 1, '2026-08-04', 1499.00, 'Shipped'),
(3, 1, '2026-08-06', 999.00, 'Delivered');


-- ==========================================
-- 22. ORDERED PRODUCT DETAILS
-- ==========================================

INSERT INTO OrderItem
(Order_ID, Product_ID, Quantity, Unit_Price)
VALUES
(1, 1, 1, 2199.00),
(2, 2, 1, 1499.00),
(3, 3, 1, 999.00);


-- ==========================================
-- 23. PAYMENT INFORMATION
-- ==========================================

INSERT INTO Payment
(Order_ID, Payment_Method, Payment_Status,
 Transaction_ID, Payment_Date)
VALUES
(1, 'UPI', 'Success', 'PAY20001', '2026-08-02'),
(2, 'Credit Card', 'Success', 'PAY20002', '2026-08-04'),
(3, 'Cash on Delivery', 'Pending', NULL, NULL);


-- ==========================================
-- 24. DELIVERY INFORMATION
-- ==========================================

INSERT INTO Delivery
(Order_ID, Delivery_Date, Delivery_Status, Tracking_Number)
VALUES
(1, '2026-08-05', 'Delivered', 'SHIP20001'),
(2, NULL, 'In Transit', 'SHIP20002'),
(3, '2026-08-09', 'Delivered', 'SHIP20003');


-- ==========================================
-- 25. DISPLAY TABLE CONTENTS
-- ==========================================

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


-- ==========================================
-- 26. TEST NOT NULL CONSTRAINT
-- Expected: Error because Customer_Name is NULL
-- Run separately
-- ==========================================

-- INSERT INTO Customer
-- (Customer_Name, Email, Password, Date_Joined)
-- VALUES
-- (NULL, 'nulltest@example.com', 'test123', '2026-08-19');


-- ==========================================
-- 27. TEST UNIQUE CONSTRAINT
-- Expected: Error because email already exists
-- ==========================================

-- INSERT INTO Customer
-- (Customer_Name, Email, Password, Date_Joined)
-- VALUES
-- ('Test Customer', 'arnav@example.com', 'test123', '2026-08-19');


-- ==========================================
-- 28. TEST PRIMARY KEY CONSTRAINT
-- Expected: Error because Customer_ID 1 exists
-- ==========================================

-- INSERT INTO Customer
-- (Customer_ID, Customer_Name, Email, Password, Date_Joined)
-- VALUES
-- (1, 'Duplicate Customer', 'duplicate@example.com',
--  'test123', '2026-08-19');


-- ==========================================
-- 29. TEST FOREIGN KEY CONSTRAINT
-- Expected: Error because customer 999 does not exist
-- ==========================================

-- INSERT INTO Customer_Phone (Customer_ID, Phone_Number)
-- VALUES (999, '9999999999');


-- ==========================================
-- 30. TEST PRODUCT FOREIGN KEY
-- Expected: Error because category 999 does not exist
-- ==========================================

-- INSERT INTO Product
-- (Product_Name, Price, Stock, Category_ID, Seller_ID)
-- VALUES ('Invalid Item', 1000.00, 10, 999, 1);


-- ==========================================
-- 31. TEST ORDER ITEM FOREIGN KEY
-- Expected: Error because product 999 does not exist
-- ==========================================

-- INSERT INTO OrderItem
-- (Order_ID, Product_ID, Quantity, Unit_Price)
-- VALUES (1, 999, 1, 1000.00);


-- ==========================================
-- 32. DEMONSTRATE ON DELETE SET NULL
-- ==========================================

-- Check product assigned to seller 1
SELECT * FROM Product WHERE Product_ID = 1;

-- Run these statements separately to test the effect:
-- DELETE FROM Seller WHERE Seller_ID = 1;

-- The product remains, but Seller_ID becomes NULL.
-- SELECT * FROM Product WHERE Product_ID = 1;


-- ==========================================
-- 33. DEMONSTRATE CATEGORY CASCADE
-- ==========================================

-- Run separately to test category deletion:
-- DELETE FROM Category WHERE Category_ID = 3;

-- Products in category 3 are deleted automatically.
-- SELECT * FROM Product WHERE Category_ID = 3;


-- ==========================================
-- 34. DEMONSTRATE ORDER CASCADE
-- ==========================================

-- Run separately to test dependent-record deletion:
-- DELETE FROM Orders WHERE Order_ID = 1;

-- Related order items, payment and delivery records
-- are deleted automatically.
-- SELECT * FROM OrderItem WHERE Order_ID = 1;
-- SELECT * FROM Payment WHERE Order_ID = 1;
-- SELECT * FROM Delivery WHERE Order_ID = 1;


-- ==========================================
-- 35. JOIN QUERY
-- Display customer orders and product information
-- ==========================================

SELECT
    o.Order_ID,
    c.Customer_Name,
    p.Product_Name,
    oi.Quantity,
    oi.Unit_Price,
    o.Order_Status
FROM Orders o
JOIN Customer c
    ON o.Customer_ID = c.Customer_ID
JOIN OrderItem oi
    ON o.Order_ID = oi.Order_ID
JOIN Product p
    ON oi.Product_ID = p.Product_ID;


-- ==========================================
-- END OF EXPERIMENT 2
-- ==========================================