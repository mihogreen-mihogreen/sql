# Prompt 2 Tables
##########################

DROP DATABASE IF EXISTS customers;
CREATE DATABASE IF NOT EXISTS customers;
USE customers;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS customer_order,
					 customer;

CREATE TABLE customer (
    cust_id 	INT     		NOT NULL,
    cust_name	VARCHAR(32) 	NOT NULL,
    PRIMARY KEY (cust_id)
);

CREATE TABLE customer_order (
    order_num   INT     NOT NULL,
    cust_id 	INT     NOT NULL,
    order_date	DATE 	NOT NULL,
    FOREIGN KEY (cust_id)  	REFERENCES customer (cust_id),
    PRIMARY KEY (order_num, cust_id)
);

INSERT INTO customer
	(cust_id, cust_name)
VALUES
	(121, 'Acme Wholesalers'),
	(234, 'Griffin Electric'),
	(336, 'East Coast Marine Supplies'),
	(544, 'Sanford Automotive');

INSERT INTO customer_order
	(order_num, cust_id, order_date)
VALUES
	(1, 121, '2017-02-15'),
	(2, 234, '2018-07-24'),
	(3, 336, '2017-05-02'),
	(4, 121, '2017-02-15'),
	(5, 336, '2018-03-19'),
	(6, 234, '2018-07-24'),
	(7, 121, '2017-02-15'),
	(8, 121, '2020-06-12'),
	(9, 336, '2020-06-12'),
	(10, 234, '2018-07-24');

# Prompt 2 Questions
##########################

#1. Write a query to retrieve each unique customer ID (cust_id) from the Customer_Order table.  There are multiple ways to construct the query, but do not use a subquery.
# ---------------
SELECT cust_id
	FROM customer_order
	GROUP BY cust_id;

#2. Write a query to retrieve each unique customer ID (cust_id) along with the latest order date for each customer.  Do not use a subquery.
# ---------------
SELECT cust_id, max(order_date) last_order
	FROM customer_order
	GROUP BY cust_id;

#3. Write a query to retrieve all rows and columns from the Customer_Order table, with the results sorted by order date descending (latest date first) and then by customer ID ascending.
# ---------------
SELECT *
	FROM customer_order
	ORDER BY cust_id asc, order_date desc;

#4. Write a query to retrieve each unique customer (cust_id) whose lowest order number (order_num) is at least 3. 
# Please note that this is referring to the value of the lowest order number and NOT the order count.  Do not use a subquery.
# ---------------
SELECT cust_id
	FROM customer_order
	WHERE order_num >= 3;

#5. Write a query to retrieve only those customers who had 2 or more orders on the same day. 
# Retrieve the cust_id and order_date values, along with the total number of orders on that date.  Do not use a subquery.
# ---------------
SELECT cust_id, order_date, count(*) total_numbers_of_orders
	FROM customer_order
	GROUP BY cust_id, order_date
	HAVING total_numbers_of_orders > 1;

#6. Along with the Customer_Order table, there is another Customer table below. 
# Write a query that returns the name of each customer who has placed exactly 3 orders.  
# Do not return the same customer name more than once, and use a correlated subquery against Customer_Order to determine the total number of orders for each customer:
# ---------------
SELECT c.cust_name
	FROM customer c
	WHERE 3 = (SELECT count(*)
			FROM customer_order o
			WHERE c.cust_id = o.cust_id);

#7. Construct a different query to return the same data as the previous question (name of each customer who has placed exactly 3 orders), 
# but use a non-correlated subquery against the Customer_Order table.
# ---------------
# In non correlated subquery, inner query doesn't depend on outer query and can run as stand alone query
SELECT cust_name
	FROM customer
	WHERE cust_id IN (SELECT cust_id
		FROM customer_order
		GROUP BY cust_id
		HAVING count(*) = 3);

#8. Write a query to return the name of each customer, along with the total number of orders for each customer.  
# Include all customers, regardless of whether or not they have orders. Use a scalar, correlated subquery to generate the number of orders.
# ---------------
# notice this subquery is non correlated and not scalar (returning more than one row)
SELECT c.cust_name, nbr_orders.total_numbers_of_orders
	FROM customer c
	LEFT JOIN (SELECT cust_id, count(*) total_numbers_of_orders
		FROM customer_order
		GROUP BY cust_id) nbr_orders
	ON c.cust_id = nbr_orders.cust_id;
