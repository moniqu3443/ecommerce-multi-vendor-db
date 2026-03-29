-- Part 3: SQL DDL Script 
-- Plan:
-- Write CREATE TABLE statements
-- Primary key constraints 
-- Foreign key constraints 
-- NOT NULL, UNIQUE
-- Tables should match the schema 

USE ecommerce_db;

CREATE TABLE Vendor (
    vend_ID INT PRIMARY KEY,
    vend_name VARCHAR(30),
    vend_phone VARCHAR(12),
    vend_email VARCHAR(30)
);

CREATE TABLE Category (
    cat_ID INT PRIMARY KEY,
    cat_name VARCHAR(30),
    cat_description VARCHAR(100)
);

CREATE TABLE Product (
    prod_ID INT PRIMARY KEY,
    cat_ID INT,
    vend_ID INT,
    prod_name VARCHAR(30),
    prod_description VARCHAR(100),
    prod_price DECIMAL(10, 2),

    FOREIGN KEY (cat_ID) REFERENCES Category(cat_ID),
    FOREIGN KEY (vend_ID) REFERENCES Vendor(vend_ID)
);

CREATE TABLE Customer (
    cust_ID INT PRIMARY KEY,
    cust_name VARCHAR(30),
    cust_phone VARCHAR(12),
    cust_email VARCHAR(30)
);

CREATE TABLE Orders (
    order_ID INT PRIMARY KEY,
    cust_ID INT,
    order_time TIMESTAMP,
    total_price DECIMAL(10, 2),

    FOREIGN KEY (cust_ID) REFERENCES Customer(cust_ID)
);

CREATE TABLE Order_Line_Item (
    order_ID INT,
    prod_ID INT,
    prod_quantity INT,
    price_per_item DECIMAL(10, 2),

    PRIMARY KEY (order_ID, prod_ID),

    FOREIGN KEY (order_ID) REFERENCES Orders(order_ID),
    FOREIGN KEY (prod_ID) REFERENCES Product(prod_ID)
);

SHOW TABLES;
