CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;
show tables;

CREATE TABLE CUSTOMERS(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state_name VARCHAR(50),
    signup_date DATE
);

INSERT INTO CUSTOMERS VALUES
(101,'Rahul Sharma','Male','Chennai','Tamil Nadu','2023-01-10'),
(102,'Priya Kumar','Female','Bangalore','Karnataka','2023-02-15'),
(103,'Arjun Nair','Male','Kochi','Kerala','2023-03-12'),
(104,'Sneha Reddy','Female','Hyderabad','Telangana','2023-04-08'),
(105,'Vikram Singh','Male','Delhi','Delhi','2023-05-01'),
(106,'Aisha Khan','Female','Mumbai','Maharashtra','2023-06-10'),
(107,'Karthik Raj','Male','Chennai','Tamil Nadu','2023-07-18'),
(108,'Divya Menon','Female','Bangalore','Karnataka','2023-08-22'),
(109,'Rohit Verma','Male','Pune','Maharashtra','2023-09-10'),
(110,'Ananya Das','Female','Kolkata','West Bengal','2023-10-15');

SELECT * FROM CUSTOMERS;
CREATE TABLE CATEGORIES(
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

INSERT INTO CATEGORIES VALUES
(1,'Electronics'),
(2,'Fashion'),
(3,'Home Appliances'),
(4,'Books'),
(5,'Sports');
 SELECT * FROM CATEGORIES;
 
CREATE TABLE PRODUCTS(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2)
);

INSERT INTO PRODUCTS VALUES
(201,'iPhone 15',1,80000),
(202,'Samsung Galaxy S24',1,70000),
(203,'Nike Shoes',2,5000),
(204,'Levis Jeans',2,2500),
(205,'LG Refrigerator',3,35000),
(206,'Microwave Oven',3,12000),
(207,'SQL Mastery Book',4,900),
(208,'Python for Data Analysis',4,1200),
(209,'Cricket Bat',5,3000),
(210,'Football',5,1500);

SELECT * FROM PRODUCTS;

CREATE TABLE ORDERS(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO ORDERS VALUES
(1001,101,'2024-01-10',85000),
(1002,102,'2024-01-12',5000),
(1003,103,'2024-01-15',12000),
(1004,104,'2024-02-05',3000),
(1005,105,'2024-02-10',70000),
(1006,106,'2024-03-01',2500),
(1007,107,'2024-03-15',80000),
(1008,108,'2024-04-05',1200),
(1009,109,'2024-04-10',35000),
(1010,110,'2024-05-01',1500);

SELECT * FROM ORDERS;

CREATE TABLE ORDER_DETAILS(
    detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO ORDER_DETAILS VALUES
(1,1001,201,1),
(2,1001,209,1),
(3,1002,203,1),
(4,1003,206,1),
(5,1004,209,1),
(6,1005,202,1),
(7,1006,204,1),
(8,1007,201,1),
(9,1008,208,1),
(10,1009,205,1),
(11,1010,210,1);

SELECT * FROM ORDER_DETAILS;

CREATE TABLE PAYMENTS(
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20)
);

INSERT INTO PAYMENTS VALUES
(1,1001,'UPI','Success'),
(2,1002,'Credit Card','Success'),
(3,1003,'UPI','Success'),
(4,1004,'Debit Card','Success'),
(5,1005,'Net Banking','Success'),
(6,1006,'UPI','Success'),
(7,1007,'Credit Card','Success'),
(8,1008,'UPI','Success'),
(9,1009,'Debit Card','Success'),
(10,1010,'UPI','Success');

SELECT * FROM PAYMENTS;


#Total revenue/average value
SELECT SUM(total_amount) AS total_revenue,AVG(total_amount) AS average_value
		FROM ORDERS;

#Customers by cities
SELECT * FROM CUSTOMERS;
SELECT city, COUNT(city) AS customer_count
FROM CUSTOMERS
GROUP BY city;

#More than 1 customer in a city
SELECT city, COUNT(city) AS customer_count
FROM CUSTOMERS
GROUP BY city
HAVING COUNT(city) > 1;

#Top 3 spenders
WITH CTE AS (
    SELECT CUSTOMER_ID,
           SUM(TOTAL_AMOUNT) AS TOTAL_SPEND
    FROM ORDERS
    GROUP BY CUSTOMER_ID
)
SELECT *
FROM CTE
ORDER BY TOTAL_SPEND DESC
LIMIT 3;

#Joins attributes of different table
SELECT o.order_id, p.product_name, od.quantity
FROM ORDERS o
INNER JOIN ORDER_DETAILS od ON o.order_id = od.order_id
INNER JOIN PRODUCTS p ON od.product_id = p.product_id;

#Customer spend above average
SELECT customer_id
FROM ORDERS
WHERE total_amount > (
    SELECT AVG(total_amount) FROM ORDERS
);

#Revenue Based On Category
WITH order_products AS (
    SELECT od.order_id, p.category_id, o.total_amount
    FROM ORDER_DETAILS od
    JOIN PRODUCTS p ON od.product_id = p.product_id
    JOIN ORDERS o ON od.order_id = o.order_id
)
SELECT category_id, SUM(total_amount) AS revenue
FROM order_products
GROUP BY category_id;

#customer rank based on spending
SELECT 
    customer_id,
    SUM(total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_position
FROM ORDERS
GROUP BY customer_id;

#Running total
SELECT 
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM ORDERS;

#Dense Rank
SELECT 
    customer_id,
    SUM(total_amount) AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS truerank
FROM ORDERS
GROUP BY customer_id;

#Views - SUMMARIZE 
CREATE VIEW customer_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT * FROM CUSTOMER_SUMMARY;

