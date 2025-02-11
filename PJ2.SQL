CREATE DATABASE ShopDB;
GO

USE ShopDB;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);
GO

INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES (1, 'John', 'Doe', 'john.doe@example.com');
GO

UPDATE Customers
SET Email = 'john.doe@newemail.com'
WHERE CustomerID = 1;
GO

DELETE FROM Customers WHERE CustomerID = 5;
GO

SELECT * FROM Customers
ORDER BY LastName;
GO

INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Tom', 'Brown', 'tom.brown@example.com'),
(4, 'Lucy', 'Williams', 'lucy.williams@example.com');
GO

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (1, 1, '2023-05-01', 150.00);
GO

UPDATE Orders
SET TotalAmount = 200.00
WHERE OrderID = 2;
GO

DELETE FROM Orders WHERE OrderID = 3;
GO

SELECT * FROM Orders
WHERE CustomerID = 1;
GO

SELECT * FROM Orders
WHERE YEAR(OrderDate) = 2023;
GO

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);
GO

INSERT INTO Products (ProductID, ProductName, Price)
VALUES (1, 'Laptop', 999.99);
GO

UPDATE Products
SET Price = 299.99
WHERE ProductID = 2;
GO

DELETE FROM Products WHERE ProductID = 4;
GO

SELECT * FROM Products
WHERE Price > 100;
GO

SELECT * FROM Products
WHERE Price <= 50;
GO

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

UPDATE OrderDetails
SET Quantity = 3
WHERE OrderDetailID = 1;
GO

DELETE FROM OrderDetails WHERE OrderDetailID = 2;
GO

SELECT * FROM OrderDetails
WHERE OrderID = 1;
GO

SELECT * FROM OrderDetails
WHERE ProductID = 2;
GO

SELECT O.OrderID, C.FirstName, C.LastName
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID;
GO

SELECT P.ProductName, C.FirstName, C.LastName, OD.Quantity
FROM OrderDetails OD
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN Products P ON OD.ProductID = P.ProductID;
GO

SELECT O.OrderID, C.FirstName, C.LastName
FROM Orders O
LEFT JOIN Customers C ON O.CustomerID = C.CustomerID;
GO

SELECT O.OrderID, P.ProductName
FROM OrderDetails OD
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID;
GO

SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > 500
);
GO

SELECT * FROM Products
WHERE ProductID IN (
    SELECT ProductID
    FROM OrderDetails
    GROUP BY ProductID
    HAVING COUNT(*) > 10
);
GO

SELECT FirstName, LastName,
       (SELECT SUM(TotalAmount)
        FROM Orders
        WHERE CustomerID = C.CustomerID) AS TotalSpent
FROM Customers C;
GO

SELECT ProductName, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);
GO

SELECT O.OrderID, C.FirstName, C.LastName, P.ProductName
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID;
GO

SELECT C.FirstName, C.LastName, O.OrderID, P.ProductName, OD.Quantity, OD.Price
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID;
GO

SELECT C.FirstName, C.LastName, P.ProductName, SUM(OD.Quantity * OD.Price) AS TotalPrice
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY C.FirstName, C.LastName, P.ProductName;
GO

SELECT C.FirstName, C.LastName, SUM(OD.Quantity * OD.Price) AS TotalOrderAmount
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY C.FirstName, C.LastName;
GO

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);
GO

INSERT INTO Categories (CategoryID, CategoryName)
VALUES (1, 'Electronics'), (2, 'Clothing'), (3, 'Furniture');
GO

ALTER TABLE Products
ADD CategoryID INT;
GO

UPDATE Products
SET CategoryID = 1
WHERE ProductID = 1;
GO

ALTER TABLE Products
ADD CONSTRAINT FK_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
GO

SELECT P.ProductName, C.CategoryName
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID;
GO

SELECT C.FirstName, C.LastName, COUNT(O.OrderID) AS NumberOfOrders
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;
GO

SELECT P.ProductName
FROM Products P
INNER JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
HAVING COUNT(OD.OrderDetailID) > 5;
GO

SELECT C.FirstName, C.LastName, SUM(OD.Quantity * OD.Price) AS TotalAmount
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY C.FirstName, C.LastName
HAVING SUM(OD.Quantity * OD.Price) > 500;
GO

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (2, 2, '2023-06-15', 450.00);
GO

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price)
VALUES (2, 2, 1, 2, 225.00);
GO

SELECT AVG(TotalAmount) AS AverageOrderAmount
FROM Orders;
GO

