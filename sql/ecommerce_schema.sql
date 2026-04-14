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

-- Part 4: SQL DML Script 
-- Plan:
-- Write triggers to calculate the value of order line items in relation to quantity purchased
-- Write triggers to automatically track total order price as items are added/modified/deleted
-- Insert at least 10 rows per table
-- Inserted data should be realistic

-- TRIGGERS
-- Order_Line_Item table triggers
-- trigger to set price_per_item to prod_price multiplied by quantity (on insert)
DELIMITER //
	CREATE TRIGGER order_line_item_price_trigger_insert
    BEFORE INSERT ON Order_Line_Item
	FOR EACH ROW
	BEGIN
		DECLARE price DECIMAL(10, 2);
        DECLARE tot_price DECIMAL(10, 2);

        SELECT prod_price INTO price FROM Product
        WHERE prod_ID = NEW.prod_ID;

        SET tot_price = price * NEW.prod_quantity;

        SET NEW.price_per_item = tot_price;
	END//
DELIMITER ;

-- trigger to set price_per_item to prod_price multiplied by quantity (on update)
DELIMITER //
	CREATE TRIGGER order_line_item_price_trigger_update
    BEFORE UPDATE ON Order_Line_Item
	FOR EACH ROW
	BEGIN
		DECLARE price DECIMAL(10, 2);
        DECLARE tot_price DECIMAL(10, 2);

        SELECT prod_price INTO price FROM Product
        WHERE prod_ID = NEW.prod_ID;

        SET tot_price = price * NEW.prod_quantity;

        SET NEW.price_per_item = tot_price;
	END//
DELIMITER ;

-- Orders table triggers
-- trigger to update total_price in accordance with new line_item value (on insert)
DELIMITER //
    CREATE TRIGGER orders_total_price_trigger_insert 
    AFTER INSERT ON Order_Line_Item
	FOR EACH ROW
	BEGIN
		DECLARE old_price DECIMAL(10, 2);
        DECLARE new_price DECIMAL(10, 2);

        SELECT total_price INTO old_price FROM Orders
        WHERE order_ID = NEW.order_ID;

        SET new_price = old_price + NEW.price_per_item;

        UPDATE Orders
        SET total_price = new_price
        WHERE order_ID = NEW.order_ID;
	END//
DELIMITER ;

-- trigger to update total_price in accordance with new line_item value (on update)
DELIMITER //
	CREATE TRIGGER orders_total_price_trigger_update
    AFTER UPDATE ON Order_Line_Item
	FOR EACH ROW
	BEGIN
		DECLARE old_price DECIMAL(10, 2);
        DECLARE new_price DECIMAL(10, 2);

        SELECT total_price INTO old_price FROM Orders
        WHERE order_ID = NEW.order_ID;

        SET new_price = (old_price - OLD.price_per_item) + NEW.price_per_item;

        UPDATE Orders
        SET total_price = new_price
        WHERE order_ID = NEW.order_ID;
	END//
DELIMITER ;

-- trigger to update total_price in accordance with new line_item value (on delete)
DELIMITER //
	CREATE TRIGGER orders_total_price_trigger_delete
    AFTER DELETE ON Order_Line_Item
	FOR EACH ROW
	BEGIN
		DECLARE old_price DECIMAL(10, 2);
        DECLARE new_price DECIMAL(10, 2);

        SELECT total_price INTO old_price FROM Orders
        WHERE order_ID = OLD.order_ID;
        
        SET new_price = old_price - OLD.price_per_item;
        
        UPDATE Orders
        SET total_price = new_price
        WHERE order_ID = OLD.order_ID;
	END//
DELIMITER ;

-- trigger to initialize order_time to current timestamp and total_price to zero
DELIMITER //
	CREATE TRIGGER orders_order_time_total_price_trigger
    BEFORE INSERT ON Orders
	FOR EACH ROW
	BEGIN
		SET NEW.order_time = NOW();
        SET NEW.total_price = 0.00;
	END//
DELIMITER ;

-- INSERTS
-- Category table
INSERT INTO Category
VALUES (1572, "Electronic", "Having or operating with the aid of many small components, that control/direct an electric current.");

INSERT INTO Category
VALUES (2892, "Personal Care", "Products used daily for hygiene, grooming, and enhanced physical appearance.");

INSERT INTO Category
VALUES (1591, "Kitchen", "Devices designed to automate/simplify food preparation, cooking, cleaning, and storage in a kitchen.");

INSERT INTO Category
VALUES (7584, "Garden", "Essentials and tools for a cultivated outdoor space dedicated to growing plants.");

INSERT INTO Category
VALUES (0317, "Children's Shoes", "A children's clothing item designed to protect and comfort the human foot, usually worn in pairs.");

INSERT INTO Category
VALUES (1725, "Pets", "Essentials for domesticated animals kept for reasons other than commercial purposes.");

INSERT INTO Category
VALUES (1574, "Candy", "A sugary confection made primarily from sugar.");

INSERT INTO Category
VALUES (6316, "Novels", "An extended prose narrative that explores human experience through a complex, structured story.");

INSERT INTO Category
VALUES (8267, "Home Decor", "The furnishing and decoration of a room.");

INSERT INTO Category
VALUES (3398, "Stationary", "Materials used for writing, printing, and office or school tasks.");

-- Customer table
INSERT INTO Customer
VALUES (92188, "Luce-Melissa K.", "345-785-3487", "LuceK@email.com");

INSERT INTO Customer
VALUES (09714, "Mason L.", "509-866-5437", "MasonL@email.com");

INSERT INTO Customer
VALUES (20988, "Marlon M.", "805-479-4290", "MarlonM@email.com");

INSERT INTO Customer
VALUES (64505, "Rishi N.", "446-799-4689", "RishiN@email.com");

INSERT INTO Customer
VALUES (05366, "Chuong N.", "986-345-7995", "ChuongN@email.com");

INSERT INTO Customer
VALUES (37373, "Maxwell O.", "223-689-8965", "MaxwellO@email.com");

INSERT INTO Customer
VALUES (63262, "Ayush P.", "976-443-5789", "AyushP@email.com");

INSERT INTO Customer
VALUES (95394, "Meet P.", "457-778-8753", "MeetP@email.com");

INSERT INTO Customer
VALUES (56605, "Devine R.", "890-879-9908", "DevineR@email.com");

INSERT INTO Customer
VALUES (37253, "Pardis R.", "554-336-7889", "PardisR@email.com");

-- Vendor table
INSERT INTO Vendor
VALUES (7316, "Mel A.", "345-678-4578", "MelA@email.com");

INSERT INTO Vendor
VALUES (1528, "Christian A.", "654-335-6785", "ChristianA@email.com");

INSERT INTO Vendor
VALUES (6834, "Darius A.", "345-789-6568", "DariusA@email.com");

INSERT INTO Vendor
VALUES (8218, "Gio S.", "208-239-4309", "GioS@email.com");

INSERT INTO Vendor
VALUES (6087, "Evaan E.", "123-890-7694", "EvaanE@email.com");

INSERT INTO Vendor
VALUES (6964, "Kavin E.", "309-859-5235", "KavinE@email.com");

INSERT INTO Vendor
VALUES (1789, "Eli F.", "456-908-2345", "EliF@email.com");

INSERT INTO Vendor
VALUES (3439, "Monique G.", "023-473-7952", "MoniqueG@email.com");

INSERT INTO Vendor
VALUES (8358, "Ali H.", "137-379-5438", "AliH@email.com");

INSERT INTO Vendor
VALUES (3316, "Meghan H.", "720-346-8345", "MeghanH@email.com");

-- Product table
INSERT INTO Product
VALUES (66215, 1572, 7316, "Wireless Headphones", "High quality sound and comfortable, all-day listening in a wireless headphone.", 89.94);

INSERT INTO Product
VALUES (12870, 2892, 1528, "Toilet Paper", "Woven like a washcloth and holds up when you wipe. It cleans better so you use less, and for longer!", 31.67);

INSERT INTO Product
VALUES (21641, 1591, 6834, "Water Bottle", "A practical choice for daily hydration! Leakproof, thermal, and easy to clean.", 19.99);

INSERT INTO Product
VALUES (00664, 2892, 8218, "Body Lotion", "A low-viscosity, topical emulsion of oil and water designed for moisturization and softening.", 9.97);

INSERT INTO Product
VALUES (97878, 0317, 6087, "Children Rainbow Sneakers", "Little girls' children tennis shoes designed for durability and comfort.", 18.79);

INSERT INTO Product
VALUES (39759, 1591, 6964, "Kitchen Air Fryer", "Prepare a variety of dishes effortlessly, from quick snacks to complete meals, with the Air Fryer.", 129.54);

INSERT INTO Product
VALUES (42206, 1574, 1789, "Nerds Gummy Clusters", "Crunchy, gummy, tangy: it all comes together to provide a truly craveable experience in every bite!", 7.42);

INSERT INTO Product
VALUES (28412, 6316, 3439, "The Hunger Games: Book 1", "A book by internationally best-selling author Suzanne Collins.", 18.86);

INSERT INTO Product
VALUES (51281, 1572, 8358, "Vehicle Dash Cam", "High quality vehicle live-feed dash cam with smartphone capabilities and 24/7 monitoring.", 99.99);

INSERT INTO Product
VALUES (09152, 3398, 3316, "Printer Paper", "Reliable everyday 8.5x11 printer paper to suit all your printing needs! Universal compatibility.", 24.99);

-- Orders table
INSERT INTO Orders (order_ID, cust_ID)
VALUES (1775789, 92188);
UPDATE Orders
SET order_time = '2024-02-17 03:17:42'
WHERE order_ID = 1775789;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (2404135, 09714);
UPDATE Orders
SET order_time = '2023-11-05 14:52:09'
WHERE order_ID = 2404135;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (7744251, 20988);
UPDATE Orders
SET order_time = '2025-07-29 22:08:55'
WHERE order_ID = 7744251;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (4085901, 64505);
UPDATE Orders
SET order_time = '2022-01-13 07:33:21'
WHERE order_ID = 4085901;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (7219547, 05366);
UPDATE Orders
SET order_time = '2024-09-30 19:46:03'
WHERE order_ID = 7219547;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (7572262, 37373);
UPDATE Orders
SET order_time = '2023-06-21 11:05:38'
WHERE order_ID = 7572262;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (3549360, 63262);
UPDATE Orders
SET order_time = '2025-12-02 00:59:14'
WHERE order_ID = 3549360;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (5271526, 95394);
UPDATE Orders
SET order_time = '2022-08-18 16:27:50'
WHERE order_ID = 5271526;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (3539472, 56605);
UPDATE Orders
SET order_time = '2024-04-07 09:41:06'
WHERE order_ID = 3539472;

INSERT INTO Orders (order_ID, cust_ID)
VALUES (3335156, 37253);
UPDATE Orders
SET order_time = '2023-10-25 21:13:29'
WHERE order_ID = 3335156;

-- Order_Line_Item table
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (1775789, 66215, 1);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (1775789, 00664, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (2404135, 12870, 2);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (2404135, 97878, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (7744251, 21641, 2);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (7744251, 42206, 3);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (7744251, 39759, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (4085901, 00664, 3);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (4085901, 28412, 1);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (4085901, 51281, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (7219547, 97878, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (7572262, 09152, 2);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3549360, 09152, 2);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3549360, 28412, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (5271526, 39759, 1);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (5271526, 21641, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3539472, 51281, 1);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3539472, 28412, 1);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3539472, 00664, 1);

INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3335156, 00664, 2);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3335156, 97878, 1);
INSERT INTO Order_Line_Item (order_ID, prod_ID, prod_quantity)
VALUES (3335156, 39759, 1);
