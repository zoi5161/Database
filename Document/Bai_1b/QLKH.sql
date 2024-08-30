-- MSSV: 22127034
-- Name: Trần Gia Bảo
CREATE DATABASE QLKH
GO
USE QLKH
GO

CREATE TABLE CUSTOMER(
    ID INT CONSTRAINT PK_Customer PRIMARY KEY,
    NAME VARCHAR(20),
    CITY VARCHAR(20)
)

CREATE TABLE [ORDER](
    O_ID CHAR(3) CONSTRAINT PK_Order PRIMARY KEY,
    [DATE] VARCHAR(20),
    CUSTOMER_ID INT,
    AMOUNT INT
)

CREATE TABLE PRODUCT(
    PID CHAR(2) CONSTRAINT PK_Product PRIMARY KEY,
    Pname VARCHAR(20),
    TYPE VARCHAR(20),
)

CREATE TABLE DETAILS(
    O_ID CHAR(3),
    P_ID CHAR(2)

    CONSTRAINT PK_Details PRIMARY KEY (O_ID, P_ID)
)

ALTER TABLE [ORDER] ADD CONSTRAINT FK_ORDER_CUSTOMER
FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER

ALTER TABLE DETAILS ADD CONSTRAINT FK_DETAILS_CUSTOMER
FOREIGN KEY (P_ID) REFERENCES PRODUCT

ALTER TABLE DETAILS ADD CONSTRAINT FK_DETAILS_ORDERR
FOREIGN KEY (O_ID) REFERENCES [ORDER]

INSERT INTO CUSTOMER VALUES (1, 'Brian', 'Chicago'),
                            (2, 'Jane', 'Houston'),
                            (3, 'Katie', 'Houston'),
                            (4, 'John', 'Houston'),
                            (5, 'Leo', 'San Jose')

INSERT INTO [ORDER] VALUES ('001', 'May 30', 2, 200),
                          ('002', 'June 8', 3, 500),
                          ('003', 'June 12', 2, 100),
                          ('004', 'May 30', 4, 300),
                          ('005', 'June 14', 2, 400),
                          ('006', 'May 30', 3, 300)

INSERT INTO PRODUCT VALUES ('P1', 'Cinderella', 'Books'),
                           ('P2', 'Dell XYZ', 'Computers'),
                           ('P3', 'Aladdin', 'Books'),
                           ('P4', 'HP123', 'Computers')

INSERT INTO DETAILS VALUES ('001', 'P1'),
                           ('001', 'P3'),
                           ('002', 'P2'),
                           ('003', 'P2'),
                           ('004', 'P2'),
                           ('005', 'P2'),
                           ('006', 'P1')
-- Question 1: Find all customers in Chicago
SELECT C.*
FROM CUSTOMER C
WHERE C.CITY = 'Chicago'

-- Question 2: Find all customers who purchased in May 30
SELECT DISTINCT C.*
FROM CUSTOMER C JOIN [ORDER] O ON O.CUSTOMER_ID = C.ID
WHERE O.DATE = 'May 30'

-- Question 3: Find name of customers who don't make any order
SELECT C.NAME
FROM CUSTOMER C LEFT JOIN [ORDER] O ON C.ID = O.CUSTOMER_ID
GROUP BY C.ID, C.NAME
HAVING COUNT(O.O_ID) = 0

-- Question 4: Find id, date and amount of all orders of "Brian"
SELECT O.O_ID, O.DATE, O.Amount
FROM [ORDER] O
JOIN CUSTOMER C ON O.CUSTOMER_ID = C.ID AND C.NAME = 'Brian'

-- Question 5: Find name of customers whom every amounts of their orders >= 300
SELECT DISTINCT C.Name
FROM CUSTOMER C JOIN [ORDER] O ON C.ID = O.CUSTOMER_ID
GROUP BY C.ID, C.NAME
HAVING MIN(O.AMOUNT) >= 300

-- Question 6: Find name of products which have never been sold
SELECT P.Pname
FROM PRODUCT P
WHERE NOT EXISTS (
    SELECT 1
    FROM DETAILS D
    WHERE D.P_ID = P.PID
)

SELECT P.Pname
FROM PRODUCT P
WHERE P.PID NOT IN(
    SELECT D.P_ID
    FROM DETAILS D
)

-- Question 7: Find name of customers who have bought all items
SELECT C.NAME
FROM CUSTOMER C JOIN [ORDER] O ON C.ID = O.CUSTOMER_ID
JOIN DETAILS D ON D.O_ID = O.O_ID
GROUP BY C.ID, C.NAME
HAVING COUNT(DISTINCT O.P_ID) = (SELECT COUNT(*) FROM PRODUCT P)

-- Question 8: Find name of customers who have bought all books.
SELECT NAME
FROM CUSTOMER C
WHERE NOT EXISTS (
    SELECT 1
    FROM PRODUCT P
    WHERE P.Type = 'Books' AND NOT EXISTS (
        SELECT 1
        FROM DETAILS D JOIN [ORDER] O ON D.O_ID = O.O_ID
        WHERE O.CUSTOMER_ID = C.ID AND D.P_ID = P.PID
    )
)

-- Question 9: Find name of customers who bought 'Dell XYZ'
SELECT DISTINCT C.NAME
FROM CUSTOMER C JOIN [ORDER] O ON C.ID = O.CUSTOMER_ID
JOIN DETAILS D ON O.O_ID = D.O_ID JOIN PRODUCT P ON D.P_ID = P.PID
WHERE P.Pname = 'Dell XYZ'

-- Question 10: Find name of computers which has been sold in May 30
SELECT DISTINCT P.Pname
FROM PRODUCT P JOIN DETAILS D ON P.PID = D.P_ID JOIN [ORDER] O ON D.O_ID = O.O_ID
WHERE P.Type = 'Computers' AND O.DATE = 'May 30'

-- Question 11: For each customer, show id, name and the number of their orders
SELECT C.ID, C.NAME, COUNT(O.CUSTOMER_ID) NumOfOrder
FROM CUSTOMER C LEFT JOIN [ORDER] O
ON C.ID = O.CUSTOMER_ID
GROUP BY C.ID, C.NAME

-- Question 12: Show id and name of customers who had paid the most for their orders
SELECT C.ID, C.NAME
FROM CUSTOMER C
JOIN [ORDER] O ON C.ID = O.CUSTOMER_ID
WHERE O.Amount = (
    SELECT MAX(Amount)
    FROM [ORDER]
)

-- Question 13: Show the date and the sales for each date.
SELECT O.[DATE]
FROM [ORDER] O
GROUP BY O.[DATE]

-- Question 14: Show the dates which had the most sales
SELECT DATE
FROM [ORDER]
GROUP BY DATE
HAVING SUM(Amount) = (
    SELECT MAX(TotalSales)
    FROM (
        SELECT SUM(Amount) AS TotalSales
        FROM [ORDER]
        GROUP BY DATE
    ) AS SalesPerDate
)

-- Question 15: Which city has the most sales

-- Question 16: Find ID and Name of customer who don't make any order
SELECT C.ID, C.NAME
FROM CUSTOMER C
WHERE NOT EXISTS (
    SELECT 1
    FROM [ORDER] O
    WHERE O.CUSTOMER_ID = C.ID
)

-- Question 17: For each customer, show id, name and the number orders (0 of they don't make any order)
SELECT C.ID, C.NAME, COUNT(O.O_ID) OrderNum
FROM CUSTOMER C LEFT JOIN [ORDER] O ON C.ID =  O.CUSTOMER_ID
GROUP BY C.ID, C.NAME

-- Question 18: Find name of customers whom every amounts of their orders must be >= 300
SELECT C.NAME
FROM CUSTOMER C
WHERE EXISTS (
    SELECT 1
    FROM [ORDER] O
    WHERE O.CUSTOMER_ID = C.ID
) AND NOT EXISTS (
    SELECT 1
    FROM [ORDER] O
    WHERE O.CUSTOMER_ID = C.ID AND O.Amount < 300
)

-- TEST
SELECT * FROM CUSTOMER
SELECT * FROM [ORDER]
SELECT * FROM PRODUCT
SELECT * FROM DETAILS