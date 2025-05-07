CREATE DATABASE inventoryTrackingDB;

USE inventoryTrackingDB;

-- 1. Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Stationery'),
('Furniture');


-- 2. Items
CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    sku VARCHAR(50) UNIQUE,
    unit_price DECIMAL(10, 2) NOT NULL,
    reorder_level INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

INSERT INTO items (name, description, sku, unit_price, reorder_level, category_id) VALUES
('Laptop', '14-inch, 8GB RAM', 'ELEC001', 750.00, 5, 1),
('Desk Chair', 'Ergonomic office chair', 'FURN001', 120.00, 2, 3),
('Notebook', 'A5 ruled notebook', 'STAT001', 2.50, 50, 2);


-- 3. Locations
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    address TEXT
);

INSERT INTO locations (location_name, address) VALUES
('Main Store', '234 Moi Avenue'),
('Mombasa Road store', '332 City Mombasa Rd');


-- 4. Inventory (current stock per location)
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    item_id INT NOT NULL,
    location_id INT NOT NULL,
    quantity_available INT DEFAULT 0,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    UNIQUE (item_id, location_id)
);

INSERT INTO suppliers (name, contact_info) VALUES
('TechWorld Ltd.', 'techworld@example.com, +254712345678'),
('OfficeSupplies Inc.', 'officesupplies@example.com, +254798765432');


-- 5. Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info TEXT
);

INSERT INTO users (username, role, password_hash) VALUES
('admin', 'admin', 'hashedpassword1'),
('warehouse_mgr', 'warehouse_manager', 'hashedpassword2');


-- 6. Purchases
CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    item_id INT NOT NULL,
    supplier_id INT NOT NULL,
    location_id INT NOT NULL,
    quantity INT NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

INSERT INTO purchases (item_id, supplier_id, location_id, quantity, purchase_date) VALUES
(1, 1, 1, 10, NOW()),
(2, 2, 1, 5, NOW()),
(3, 2, 2, 100, NOW());


-- 7. Sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    item_id INT NOT NULL,
    location_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

INSERT INTO sales (item_id, location_id, quantity, sale_date) VALUES
(1, 2, 2, NOW()),
(3, 2, 20, NOW());


-- 8. Users (optional)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,
    password_hash TEXT -- Optional if you need auth
);

INSERT INTO inventory (item_id, location_id, quantity_available) VALUES
(1, 1, 10),
(1, 2, 8),
(2, 1, 5),
(3, 2, 80);


-- 9. Transactions (all inventory movements)
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    item_id INT NOT NULL,
    location_id INT NOT NULL,
    quantity INT NOT NULL,
    transaction_type VARCHAR(50) CHECK (transaction_type IN ('purchase', 'sale', 'adjustment')),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO transactions (item_id, location_id, quantity, transaction_type, transaction_date, user_id) VALUES
(1, 1, 10, 'purchase', NOW(), 1),
(2, 1, 5, 'purchase', NOW(), 2),
(3, 2, 100, 'purchase', NOW(), 2),
(1, 2, 2, 'sale', NOW(), 2),
(3, 2, 20, 'sale', NOW(), 2);
