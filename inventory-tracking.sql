CREATE DATABASE inventoryTrackingDB;

USE inventoryTrackingDB;

-- 1. Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

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

-- 3. Locations
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    address TEXT
);

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

-- 5. Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info TEXT
);

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

-- 8. Users (optional)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,
    password_hash TEXT -- Optional if you need auth
);

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
