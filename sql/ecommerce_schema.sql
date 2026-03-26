USE ecommerce_db;

CREATE TABLE Vendor (
    vend_ID INT PRIMARY KEY AUTO_INCREMENT,
    vend_name VARCHAR(30) NOT NULL,
    vend_phone VARCHAR(12),
    vend_email VARCHAR(30) UNIQUE
);

CREATE TABLE Category (
    cat_ID INT PRIMARY KEY AUTO_INCREMENT,
    cat_name VARCHAR(30) NOT NULL,
    cat_description VARCHAR(100)
);

CREATE TABLE Product (
    prod_ID INT PRIMARY KEY AUTO_INCREMENT,
    cat_ID INT NOT NULL,
    vend_ID INT NOT NULL,
    prod_name VARCHAR(30) NOT NULL,
    prod_description VARCHAR(100),
    prod_price DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (cat_ID) REFERENCES Category(cat_ID),
    FOREIGN KEY (vend_ID) REFERENCES Vendor(vend_ID)
);

CREATE TABLE Customer (
    cust_ID INT PRIMARY KEY AUTO_INCREMENT,
    cust_name VARCHAR(30) NOT NULL,
    cust_phone VARCHAR(12),
    cust_email VARCHAR(30) UNIQUE
);

CREATE TABLE Orders (
    order_ID INT PRIMARY KEY AUTO_INCREMENT,
    cust_ID INT NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2),

    FOREIGN KEY (cust_ID) REFERENCES Customer(cust_ID)
);

CREATE TABLE Order_Line_Item (
    order_ID INT,
    prod_ID INT,
    prod_quantity INT NOT NULL,
    price_per_item DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (order_ID, prod_ID),

    FOREIGN KEY (order_ID) REFERENCES Orders(order_ID),
    FOREIGN KEY (prod_ID) REFERENCES Product(prod_ID)
);

SHOW TABLES;
