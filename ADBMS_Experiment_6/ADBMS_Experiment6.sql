--Medium Level Problem  
 	 
CREATE TABLE employee_info (     
id SERIAL PRIMARY KEY,     
name VARCHAR(50) NOT NULL,     
gender VARCHAR(10) NOT NULL,     
salary NUMERIC(10,2) NOT NULL,     
city VARCHAR(50) NOT NULL 
); 
 
INSERT INTO employee_info (name, gender, salary, city) 
VALUES 
('Arjun', 'Male', 53000.00, 'Bengaluru'), 
('Meera', 'Female', 61000.00, 'Chennai'), 
('Karan', 'Male', 47000.00, 'Pune'), 
('Divya', 'Female', 56000.00, 'Delhi'), 
('Rohan', 'Male', 49000.00, 'Mumbai'), 
('Ananya', 'Female', 52000.00, 'Kolkata'), 
('Siddharth', 'Male', 48000.00, 'Hyderabad'), 
('Tanvi', 'Female', 63000.00, 'Ahmedabad'), 
('Vikram', 'Male', 51000.00, 'Jaipur'); 
 
CREATE OR REPLACE PROCEDURE sp_get_employees_by_gender( 
    IN p_gender VARCHAR(50), 
    OUT p_employee_count INT 
) 
LANGUAGE plpgsql 
AS $$ 
BEGIN 
    SELECT COUNT(id) 
    INTO p_employee_count 
    FROM employee_info 
    WHERE gender = p_gender; 
 
RAISE NOTICE 'Total employees with gender %: %', p_gender, p_employee_count; 
END; 
$$; 
 
CALL sp_get_employees_by_gender('Male', NULL); 
 

--Hard Level Problem
 
CREATE TABLE products ( 
product_code VARCHAR(10) PRIMARY KEY, 
product_name VARCHAR(100) NOT NULL, 
price NUMERIC(10,2) NOT NULL, 
quantity_remaining INT NOT NULL, 
quantity_sold INT DEFAULT 0 
); 
 
CREATE TABLE sales ( 
order_id SERIAL PRIMARY KEY, 
order_date DATE NOT NULL, 
product_code VARCHAR(10) NOT NULL, 
quantity_ordered INT NOT NULL, 
sale_price NUMERIC(10,2) NOT NULL, 
FOREIGN KEY (product_code) REFERENCES products(product_code) 
); 
 
INSERT INTO products (product_code, product_name, price, quantity_remaining, quantity_sold) 
VALUES 
('P001', 'MacBook Pro 14"', 189999.00, 5, 0), 
('P002', 'Google Pixel 8 Pro', 79999.00, 12, 0), 
('P003', 'OnePlus 12', 69999.00, 10, 0), 
('P004', 'iPad Pro 11"', 64999.00, 6, 0), 
('P005', 'Bose QuietComfort 45 Headphones', 24999.00, 20, 0); 
 
INSERT INTO sales (order_date, product_code, quantity_ordered, sale_price) 
VALUES 
('2025-09-20', 'P001', 1, 189999.00), 
('2025-09-21', 'P002', 2, 159998.00), 
('2025-09-22', 'P003', 1, 69999.00), 
('2025-09-23', 'P004', 1, 64999.00), 
('2025-09-24', 'P005', 3, 74997.00); 
 
SELECT * FROM products; 
SELECT * FROM sales; 
 
CREATE OR REPLACE PROCEDURE pr_buy_products( 
IN p_product_name VARCHAR, 
IN p_quantity INT 
) 
LANGUAGE plpgsql 
AS $$ DECLARE 
v_product_code VARCHAR(20); v_price FLOAT; v_count INT; 

BEGIN 
SELECT COUNT(*) 
INTO v_count 
FROM products 
WHERE product_name = p_product_name 
AND quantity_remaining >= p_quantity; 
 
IF v_count > 0 THEN 
SELECT product_code, price 
INTO v_product_code, v_price 
FROM products 
WHERE product_name = p_product_name; 
 
INSERT INTO sales (order_date, product_code, quantity_ordered, sale_price) 
VALUES (CURRENT_DATE, v_product_code, p_quantity, (v_price * p_quantity));  
UPDATE products 
SET quantity_remaining = quantity_remaining - p_quantity, quantity_sold = quantity_sold + p_quantity 
WHERE product_code = v_product_code; 
 
RAISE NOTICE 'PRODUCT SOLD..! Order placed successfully for % unit(s) of %.', p_quantity, p_product_name; ELSE 
RAISE NOTICE 'INSUFFICIENT QUANTITY..! Order cannot be processed for % unit(s) of %.', p_quantity, p_product_name; 
END IF; 
END; 
$$; 
 
CALL pr_buy_products('MacBook Pro 14"', 1);