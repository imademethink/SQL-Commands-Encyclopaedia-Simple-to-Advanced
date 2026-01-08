-- Create Tables
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_quantity INT,
    description TEXT
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    product_id INT REFERENCES products(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantity INT,
    total_amount DECIMAL(10, 2)
);

-- Seed 200 Customers
INSERT INTO customers (first_name, last_name, email, country)
SELECT 
    'User_' || i, 
    'Last_' || i, 
    'user' || i || '@example.com',
    (ARRAY['USA', 'UK', 'Germany', 'India', 'Canada'])[floor(random() * 5 + 1)]
FROM generate_series(1, 200) s(i);

-- Seed 200 Products
INSERT INTO products (name, category, price, stock_quantity)
SELECT 
    'Product_' || i,
    (ARRAY['Electronics', 'Apparel', 'Home', 'Books', 'Beauty'])[floor(random() * 5 + 1)],
    (random() * 500 + 10)::numeric(10,2),
    floor(random() * 100 + 1)
FROM generate_series(1, 200) s(i);

-- Seed 200 Orders
INSERT INTO orders (customer_id, product_id, quantity, order_date)
SELECT 
    floor(random() * 200 + 1),
    floor(random() * 200 + 1),
    floor(random() * 5 + 1),
    NOW() - (random() * INTERVAL '365 days')
FROM generate_series(1, 200) s(i);

-- Update total_amount based on product price * quantity
UPDATE orders o
SET total_amount = o.quantity * p.price
FROM products p
WHERE o.product_id = p.id;