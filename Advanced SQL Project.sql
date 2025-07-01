----- Advanced  Tasks -------
 ---- George Sepiadis  -----

---- 1. CREATE THE DATABSE -------------------------
---- 2. USE THE DATABSE ----------------------------
---- 3. CREATE TABLES ------------------------------
---- 4. INSERT DATA --------------------------------
---- 5. TASKS --------------------------------------


---- 1. CREATE THE DATABSE -------------------------
/*

CREATE DATABASE RetailStoreDB;
GO

*/
--- END --------------------------------------------

---- 2. USE THE DATABSE ----------------------------
/*

USE RetailStoreDB;
GO

*/
--- END --------------------------------------------

---- 3. CREATE TABLES ------------------------------
/*

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Country NVARCHAR(50),
    JoinDate DATE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE,
    Status NVARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    PaymentDate DATE,
    Amount DECIMAL(10, 2),
    PaymentMethod NVARCHAR(20),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

*/
--- END --------------------------------------------

---- 4. INSERT DATA --------------------------------
/*
INSERT INTO Customers (FirstName, LastName, Email, Country, JoinDate) 
VALUES
('Maria', 'Papadopoulos', 'maria.p@gmail.com', 'Australia', '2022-01-15'),
('Maria', 'Papadopoulos', 'maria2.p@gmail.com', 'Australia', '2022-08-15'),
('John', NULL, 'john.smith@yahoo.com', 'USA', '2022-02-20'),
('Lena', 'Kowalski', NULL, 'Poland', NULL),
('Arjun', 'Patel', NULL, 'India', '2021-11-05'),
('Emily', 'Brown', 'emily.b@hotmail.com', NULL, '2023-04-01');

INSERT INTO Products (ProductName, Category, Price, Stock) 
VALUES
('Wireless Mouse', 'Electronics', 29.99, 150),
('Bluetooth Speaker', 'Electronics', 59.99, 80),
('Yoga Mat', 'Fitness', 24.99, 120),
('Running Shoes', 'Footwear', 89.99, 60),
('Coffee Maker', 'Appliances', 99.99, 40);

INSERT INTO Orders (CustomerID, OrderDate, Status) 
VALUES
(1, '2023-12-01', 'Completed'),
(2, '2024-01-15', 'Shipped'),
(3, '2024-02-10', 'Cancelled'),
(1, '2024-03-05', 'Completed'),
(5, '2024-03-12', 'Completed'),
(NULL, '2024-04-12', 'Completed');

INSERT INTO OrderItems (OrderID, ProductID, Quantity) 
VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 2),
(3, 5, 1),
(4, 1, 1),
(4, 4, 1),
(5, 2, 2),
(NULL, 2, 6),
(1, NULL, 2);

INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod) 
VALUES
(1, '2023-12-02', 89.97, 'Credit Card'),
(2, '2024-01-16', 49.98, NULL),
(4, '2024-03-06', 119.98, 'Credit Card'),
(5, NULL, 119.98, 'Debit Card'),
(NULL, '2024-02-24', 19.38, 'Debit Card')
;

*/
--- END --------------------------------------------

---- 5. TASKS --------------------------------------
/*
--- Task 1 CTE TO FIND MOST RECENT ORDER FOR EACH CUSTOMER
WITH LatestOrders AS (
    SELECT 
        CustomerID,
        OrderDate,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID 
            ORDER BY OrderDate DESC
						  ) AS rn
    FROM Orders
					)
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    lo.OrderDate AS MostRecentOrder
FROM Customers c
LEFT JOIN LatestOrders lo 
    ON c.CustomerID = lo.CustomerID AND lo.rn = 1
ORDER BY c.CustomerID;

--- Task 2 ALL CUSTOMERS AND ALL ORDERS
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.Status
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY 
    CASE 
        WHEN c.CustomerID IS NULL THEN 1
        WHEN o.OrderID IS NULL THEN 2
        ELSE 0
    END,
    c.CustomerID;

--- Task 3 TOTAL ORDERS EVEN IF NULL
WITH OrderCounts AS (
    SELECT 
        CustomerID,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY CustomerID
)
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    oc.TotalOrders
FROM Customers c
LEFT JOIN OrderCounts oc ON c.CustomerID = oc.CustomerID
ORDER BY c.CustomerID;

--- Task 4 FLAG MISSING PAYMENTS
SELECT 
    OrderID,
    PaymentDate,
    CASE 
        WHEN PaymentDate IS NULL THEN 'Pending'
        ELSE 'Completed'
    END AS PaymentStatus
FROM Payments;

--- Task 5 TOTAL SPENT AND RANK, USING CTE
WITH CustomerSpending AS (
    SELECT 
        c.CustomerID,
        c.FirstName,
        c.LastName,
        SUM(p.Amount) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN Payments p ON o.OrderID = p.OrderID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)

SELECT 
    CustomerID,
    FirstName,
    LastName,
    TotalSpent,
    RANK() OVER (ORDER BY TotalSpent DESC) AS SpendRank
FROM CustomerSpending
ORDER BY SpendRank;

--- Task 6 ORDER DATES USING LAG AND LEAD
WITH CustomerOrders AS (
    SELECT 
        o.CustomerID,
        o.OrderDate
    FROM Orders o
)
SELECT 
    o.CustomerID,
    c.FirstName,
    c.LastName,
    LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) AS PreviousOrderDate,
    o.OrderDate AS CurrentOrderDate,
    LEAD(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) AS NextOrderDate
FROM CustomerOrders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY c.CustomerID, o.OrderDate;

--- Task 7 RUNNING TOTAL AND AVERAGE
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderDate,
    p.Amount,
    SUM(p.Amount) OVER (
        PARTITION BY c.CustomerID 
        ORDER BY o.OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal,
    AVG(p.Amount) OVER (
        PARTITION BY c.CustomerID 
        ORDER BY o.OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningAvg
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Payments p ON o.OrderID = p.OrderID
ORDER BY c.CustomerID, o.OrderDate;

--- Task 8 FIND POSSIBLE DUPLICATES
SELECT 
    FirstName,
    LastName,
    COUNT(*) AS Occurrences
FROM Customers
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1;


*/
--- END --------------------------------------------
