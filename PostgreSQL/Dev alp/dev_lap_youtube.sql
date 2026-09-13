-- Create Customer Table
CREATE TABLE
    Customers (
        CustomerId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        CustomerName VARCHAR(200) NOT NULL,
        ContactNo VARCHAR(15) NOT NULL,
        EmailAddress VARCHAR(200) NOT NULL
    );

-- Insert data
INSERT INTO
    Customers (CustomerName, ContactNo, EmailAddress)
VALUES
    ('Aurgha', '01711000000', 'aurgha@gmail.com'),
    ('Aurpan', '01711000000', 'aurpan@gmail.com'),
    ('Rafiq', '01711000000', 'rafiq221@gmail.com'),
    ('Shafiq', '01711000000', 'shafiq99@gmail.com');

Select
    *
from
    Customers;

-- Create Products Table
CREATE TABLE
    Products (
        ProductId INT PRIMARY KEY,
        ProductName VARCHAR(200) NOT NULL,
        BrandName VARCHAR(200) NOT NULL,
        ReceiveDate DATE,
        AvailableStock FLOAT NOT NULL,
        Price MONEY NOT NULL
    );

-- Insert data
INSERT INTO
    Products (
        ProductId,
        ProductName,
        BrandName,
        ReceiveDate,
        AvailableStock,
        Price
    )
VALUES
    (
        25,
        'Logitech MX Master 3',
        'Logitech',
        '2022-07-18',
        100,
        99.99
    ),
    (
        26,
        'Apple Magic Keyboard',
        'Apple',
        '2022-03-28',
        200,
        199.99
    ),
    (
        27,
        'Samsung T7 Portable SSD',
        'Samsung',
        '2022-04-15',
        150,
        179.99
    ),
    (
        28,
        '990 Pro 2TB SSD',
        'Samsung',
        '2022-09-07',
        300,
        279.99
    ),
    (
        29,
        'Magic Mouse',
        'Apple',
        '2022-03-28',
        50,
        99.99
    ),
    (
        30,
        'SIGNATURE K650',
        'Logitech',
        '2022-03-28',
        100,
        49.99
    ),
    (
        31,
        '870 Evo SATA 250GB',
        'Samsung',
        '2022-03-28',
        75,
        49.99
    ),
    (
        32,
        'MX Key Mini',
        'Logitech',
        '2022-03-28',
        200,
        99.99
    ),
    (
        33,
        'Samsung T5 Portable SSD',
        'Samsung',
        '2022-03-28',
        100,
        197.99
    ),
    (
        34,
        'AirTag Leasther Loop',
        'Apple',
        '2022-03-28',
        20,
        39.99
    ),
    (
        35,
        'AirTag Leasther Loop 2',
        'Apple',
        '2022-03-28',
        20,
        99.99
    );

SELECT
    *
FROM
    Products;

-- Create the Invoice table
CREATE TABLE
    Invoices (
        InvoiceID INT PRIMARY KEY,
        InvoiceNo VARCHAR(10),
        InvoiceDate DATE,
        CustomerID INT,
        FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerId)
    );

-- Insert sample data into the Invoice table
INSERT INTO
    Invoices (InvoiceID, InvoiceNo, InvoiceDate, CustomerID)
VALUES
    (1, '#INV001', '2023-05-01', 1),
    (2, '#INV002', '2023-05-05', 2),
    (3, '#INV003', '2023-05-10', 1),
    (4, '#INV004', '2023-05-15', 4),
    (5, '#INV005', '2023-05-20', 4);

select
    *
from
    Invoices;

-- Create the InvoiceDetails table
CREATE TABLE
    InvoiceDetails (
        InvoiceID INT,
        ProductID INT,
        Quantity INT,
        FOREIGN KEY (InvoiceID) REFERENCES Invoices (InvoiceID),
        FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
    );

-- Insert sample data into the InvoiceDetails table
INSERT INTO
    InvoiceDetails (InvoiceID, ProductID, Quantity)
VALUES
    (1, 25, 2),
    (1, 26, 3),
    (1, 27, 3),
    (2, 26, 9),
    (3, 29, 10),
    (3, 28, 40),
    (3, 32, 2),
    (4, 32, 8),
    (4, 27, 30),
    (5, 32, 21);

select
    *
from
    InvoiceDetails;

SELECT
    i.invoiceId,
    i.InvoiceNo,
    i.invoicedate,
    SUM(id.quantity * p.price) AS TotalPrice
FROM
    invoices i
    JOIN InvoiceDetails id ON i.InvoiceID = id.InvoiceID
    JOIN Products p ON id.ProductID = p.ProductID
GROUP BY
    i.invoiceId,
    i.InvoiceNo,
    i.invoicedate
ORDER BY
    i.invoiceId;

SELECT * FROM customers c
INNER JOIN invoices i ON c.CustomerId = i.CustomerID
INNER JOIN invoicedetails id ON i.InvoiceID = id.InvoiceID
INNER JOIN products p ON id.ProductID = p.ProductID


SELECT  c.customerId, c.customerName, SUM(p.price * id.quantity) AS total_price FROM customers c
INNER JOIN invoices i ON c.CustomerId = i.CustomerID
INNER JOIN invoicedetails id ON i.InvoiceID = id.InvoiceID
INNER JOIN products p ON id.ProductID = p.ProductID
GROUP BY c.CustomerId, c.CustomerName
HAVING SUM(p.price * id.quantity) > CAST(5000 AS money)
ORDER BY c.customerId;

SELECT
    c.customerId,
    c.customerName,
    SUM(p.price * id.quantity) AS Total_Price
FROM customers c
INNER JOIN invoices i 
    ON c.CustomerId = i.CustomerID
INNER JOIN invoicedetails id 
    ON i.InvoiceID = id.InvoiceID
INNER JOIN products p 
    ON id.ProductID = p.ProductID
GROUP BY
    c.customerId,
    c.customerName
HAVING
    SUM(p.price * id.quantity) > CAST(5000 AS money)
ORDER BY
    c.customerId ASC;

SELECT 
    p.ProductId,
    p.ProductName,
    p.brandName,
    SUM(id.Quantity) AS TotalQuantitySold,
    p.price AS unite_price,
    SUM(p.price * id.quantity) AS TotalSales
FROM products p
INNER JOIN invoicedetails id 
    ON p.ProductID = id.ProductID
GROUP BY
    p.ProductId,
    p.ProductName
ORDER BY
    TotalQuantitySold DESC LIMIT 1;


DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS InvoiceDetails;




-- Create Table 'Products'
CREATE TABLE Products_2
(
    ProductId SERIAL PRIMARY KEY,
    ProductName VARCHAR(200) NOT NULL,
    BrandName VARCHAR(200) NOT NULL,
    ReceiveDate DATE NULL,
    AvailableStock FLOAT NOT NULL,
    Price NUMERIC(10,2) NOT NULL,
    CreateDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ModifyDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);




-- Inser Data
INSERT INTO Products_2
(ProductId, ProductName, BrandName, ReceiveDate, AvailableStock, Price)
VALUES
(1, 'Logitech MX Master 3', 'Logitech', '2022-07-18', 100, 99.99),
(2, 'Apple Magic Keyboard', 'Apple', '2022-03-28', 200, 199.99),
(3, 'Samsung T7 Portable SSD', 'Samsung', '2022-04-15', 150, 179.99),
(4, '990 Pro 2TB SSD', 'Samsung', '2022-09-07', 300, 279.99),
(5, 'Magic Mouse', 'Apple', '2022-03-28', 50, 99.99),
(6, 'SIGNATURE K650', 'Logitech', '2022-03-28', 100, 49.99),
(7, '870 Evo SATA 250GB', 'Samsung', '2022-03-28', 75, 49.99),
(8, 'MX Key Mini', 'Logitech', '2022-03-28', 200, 99.99),
(9, 'Samsung T5 Portable SSD', 'Samsung', '2022-03-28', 100, 197.99),
(10, 'AirTag Leather Loop', 'Apple', '2022-03-28', 20, 39.99);

SELECT * FROM Products_2;
INSERT INTO Products_2
(ProductId, ProductName, BrandName, ReceiveDate, AvailableStock, Price)
VALUES
(11, 'A AirTag Leather Loop', 'A Apple', '2022-03-28', 20, 39.99);

SELECT * FROM Products_2;


-- Create Table AuditRecord                   
CREATE TABLE AuditRecord
(
	RecordId SERIAL PRIMARY KEY,
	ActionName VARCHAR(50) NOT NULL,
	TableName VARCHAR(50) NOT NULL,
	ColumnName VARCHAR(50) NULL,
	PreviousValue VARCHAR(500) NULL,
	ModifedValue VARCHAR(500) NULL,
	CreateDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM AuditRecord;

CREATE FUNCTION InsertAuditRecord()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO AuditRecord (ActionName, TableName)
    VALUES ('INSERT', 'products_2');

    RAISE NOTICE 'Audit record inserted for table: %', 'products_2';

    RETURN NEW;
END;
$$;


---Create Trigger
CREATE TRIGGER InsertAuditRecordTrigger
AFTER INSERT ON Products_2
FOR EACH ROW
EXECUTE FUNCTION InsertAuditRecord();


INSERT INTO products_2
(ProductId, ProductName, BrandName, ReceiveDate, AvailableStock, Price)
VALUES
(12, 'AirTag Leather Loop', 'Apple', '2022-01-28', 20, 39.99);
(12, 'AirTag Leather Loop', 'Apple', '2022-01-28', 20, 39.99);


select * from auditrecord;
SELECT * FROM products_2;

----ALter Trigger FUNCTION
ALTER FUNCTION InsertAuditRecord()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO AuditRecord (ActionName, TableName)
    VALUES ('INSERT', 'products_2');

    RAISE NOTICE 'Audit record inserted for table: %', 'products_2';

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION InsertAuditRecord()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO AuditRecord (ActionName, TableName)
    VALUES ('DELETE', 'products_2');

    RAISE NOTICE 'Audit record inserted for % on table %',
                 'DELETE', 'products_2';

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$;

DELETE FROM products_2 WHERE ProductId = 11;

SELECT * FROM auditrecord;
SELECT * FROM products_2;