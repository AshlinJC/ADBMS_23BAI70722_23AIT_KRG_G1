--Medium Level Problem

CREATE TABLE transaction_data (
    id INT,
    value INT
);

INSERT INTO transaction_data (id, value)
SELECT 1, (random() * 1000)::INT
FROM generate_series(1, 500000);

INSERT INTO transaction_data (id, value)
SELECT 2, (random() * 1000)::INT
FROM generate_series(1, 500000);

SELECT * FROM transaction_data LIMIT 10;

CREATE OR REPLACE VIEW sales_summary_view AS
SELECT id,
       COUNT(*) AS total_orders,
       SUM(value) AS total_sales,
       AVG(value) AS avg_transaction
FROM transaction_data
GROUP BY id;

SELECT * FROM sales_summary_view;

EXPLAIN ANALYZE
SELECT * FROM sales_summary_view;

CREATE MATERIALIZED VIEW sales_summary_mv AS
SELECT id,
       COUNT(*) AS total_orders,
       SUM(value) AS total_sales,
       AVG(value) AS avg_transaction
FROM transaction_data
GROUP BY id;

SELECT * FROM sales_summary_mv;

EXPLAIN ANALYZE
SELECT * FROM sales_summary_mv;

INSERT INTO transaction_data (id, value)
SELECT 1, (random() * 1000)::INT
FROM generate_series(1, 2500000);

INSERT INTO transaction_data (id, value)
SELECT 2, (random() * 1000)::INT
FROM generate_series(1, 2500000);

REFRESH MATERIALIZED VIEW sales_summary_mv;

SELECT * FROM sales_summary_view;

SELECT * FROM sales_summary_mv;

--Hard Level Problem

CREATE TABLE customer_master (
    customer_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(50),
    city VARCHAR(30)
);

CREATE TABLE product_catalog (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    brand VARCHAR(30),
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE sales_orders (
    order_id SERIAL PRIMARY KEY,
    product_id VARCHAR(5) REFERENCES product_catalog(product_id),
    quantity INT NOT NULL,
    customer_id VARCHAR(5) REFERENCES customer_master(customer_id),
    discount_percent NUMERIC(5,2),
    order_date DATE NOT NULL
);

INSERT INTO customer_master (customer_id, full_name, phone, email, city) VALUES  
('C1', 'Karan Patel', '9876001122', 'karan.patel@example.com', 'Jaipur'),  
('C2', 'Meera Joshi', '9812233445', 'meera.joshi@example.com', 'Chandigarh'),  
('C3', 'Suresh Rao', '9922003344', 'suresh.rao@example.com', 'Mysore'),  
('C4', 'Alok Deshmukh', '9765432199', 'alok.deshmukh@example.com', 'Nagpur'),  
('C5', 'Divya Kapoor', '9090887766', 'divya.kapoor@example.com', 'Indore'),  
('C6', 'Rahul Bansal', '9123450098', 'rahul.bansal@example.com', 'Bhopal'),  
('C7', 'Shruti Nanda', '9345098761', 'shruti.nanda@example.com', 'Surat'),  
('C8', 'Mohit Arora', '9800765432', 'mohit.arora@example.com', 'Noida'),  
('C9', 'Nidhi Jain', '9012345677', 'nidhi.jain@example.com', 'Amritsar'),  
('C10', 'Aditya Malhotra', '9998877665', 'aditya.malhotra@example.com', 'Patna');  

INSERT INTO product_catalog (product_id, product_name, brand, unit_price) VALUES
('P1', 'Smartphone X100', 'X-Tech', 47500.00),
('P2', 'Laptop Pro 15', 'ZenBook', 58500.00),
('P3', 'Wireless Earbuds', 'AudioMax', 20000.00),
('P4', 'Smartwatch Fit', 'WearableCo', 27600.00),
('P5', 'Tablet 10.5', 'TabCorp', 41800.00),
('P6', 'Gaming Console', 'GameON', 39600.00),
('P7', 'Bluetooth Speaker', 'SoundWave', 14000.00),
('P8', 'Digital Camera', 'PhotoPro', 49500.00),
('P9', 'LED TV 55 inch', 'VisionX', 51000.00),
('P10', 'Power Bank 20000mAh', 'ChargeFast', 10000.00);


INSERT INTO sales_orders (product_id, quantity, customer_id, discount_percent, order_date) VALUES
('P1', 1, 'C1', 0.00, '2025-09-01'),
('P2', 1, 'C2', 0.00, '2025-09-02'),
('P3', 1, 'C3', 25.00, '2025-09-03'),
('P4', 1, 'C4', 0.00, '2025-09-04'),
('P5', 1, 'C5', 0.00, '2025-09-05'),
('P6', 1, 'C1', 0.00, '2025-09-06'),
('P7', 1, 'C2', 0.00, '2025-09-07'),
('P8', 1, 'C3', 0.00, '2025-09-08'),
('P9', 1, 'C6', 0.00, '2025-09-09'),
('P10', 1, 'C7', 0.00, '2025-09-10'),
('P1', 1, 'C8', 50.00, '2025-09-11'),
('P2', 2, 'C9', 0.00, '2025-09-12'),
('P3', 1, 'C10', 50.00, '2025-09-13');

CREATE OR REPLACE VIEW vW_ORDER_SUMMARY AS
SELECT
    O.order_id,
    O.order_date,
    P.product_name,
    C.full_name,
    (P.unit_price * O.quantity) - ((P.unit_price * O.quantity) * O.discount_percent / 100) AS final_cost
FROM customer_master AS C
JOIN sales_orders AS O
ON O.customer_id = C.customer_id
JOIN product_catalog AS P
ON P.product_id = O.product_id;

SELECT * FROM vW_ORDER_SUMMARY;

CREATE ROLE ASHLIN
LOGIN
PASSWORD 'As@123';

GRANT SELECT ON vW_ORDER_SUMMARY TO ASHLIN;
REVOKE SELECT ON vW_ORDER_SUMMARY FROM ASHLIN;