# This assignment will test your understanding of conditional logic, views, ranking and windowing functions, and transactions
# Prompt: A manufacturing company’s data warehouse contains the following tables.

DROP DATABASE IF EXISTS sales;
CREATE DATABASE IF NOT EXISTS sales;
USE sales;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS region,
                     product,
                     sales_totals;

CREATE TABLE region (
    region_id    	INT             NOT NULL,
    region_name  	VARCHAR(16)     NOT NULL,
    super_region_id	INT,
    FOREIGN KEY (super_region_id)  	REFERENCES region (region_id),
    PRIMARY KEY (region_id)
);

CREATE TABLE product (
    product_id  	INT             NOT NULL,
    product_name  	VARCHAR(16)		NOT NULL,
    PRIMARY KEY (product_id)
);

CREATE TABLE sales_totals (
    product_id    	INT     		NOT NULL,
    region_id  		INT     		NOT NULL,
    year  			YEAR    		NOT NULL,
    month  			INT				NOT NULL,
    sales 			INT             NOT NULL,
    FOREIGN KEY (product_id)  	REFERENCES product (product_id),
    FOREIGN KEY (region_id)  	REFERENCES region (region_id),
    PRIMARY KEY (product_id, region_id, year, month)
);

INSERT INTO region
	(region_id, region_name, super_region_id)
VALUES
	(101,'North America', NULL),
	(102,'USA',101),
	(103,'Canada',101),
	(104,'USA-Northeast',102),
	(105,'USA-Southeast',102),
	(106,'USA-West',102),
	(107,'Mexico',101);

INSERT INTO product
	(product_id, product_name)
VALUES
	(1256,'Gear - Large'),
	(4437,'Gear - Small'),
	(5567,'Crankshaft'),
	(7684,'Sprocket');

INSERT INTO sales_totals
	(product_id, region_id, year, month, sales)
VALUES
	(1256,104,'2020',1,1000),
	(4437,105,'2020',2,1200),
	(7684,106,'2020',3,800),
	(1256,103,'2020',4,2200),
	(4437,107,'2020',5,1700),
	(7684,104,'2020',6,750),
	(1256,104,'2020',7,1100),
	(4437,105,'2020',8,1050),
	(7684,106,'2020',9,600),
	(1256,103,'2020',10,1900),
	(4437,107,'2020',11,1500),
	(7684,104,'2020',12,900);

#1. Write a CASE expression that can be used to return the quarter number (1, 2, 3, or 4) only based on the month.
# ---------------

#January, February, and March (Q1)
#April, May, and June (Q2)
#July, August, and September (Q3)
#October, November, and December (Q4)

SELECT 
    CASE
        WHEN month < 4 THEN 'Q1'
        WHEN month BETWEEN 4 AND 6 THEN 'Q2'
        WHEN month BETWEEN 7 AND 9 THEN 'Q3'
        WHEN month > 9 THEN 'Q4'
        ELSE NULL
    END quarter,
    sum(sales)
FROM
    sales_totals
GROUP BY quarter
ORDER BY quarter;


#2. Write a query which will pivot the Sales_Totals data so that there is a column for each of the 4 products containing the total sales across all months of 2020.  It is OK to include the product_id values in your query, and the results should look as follows:
# ---------------

#+-----------------------+-----------------------+-----------------------+--------------------+
#| tot_sales_large_gears | tot_sales_small_gears | tot_sales_crankshafts |tot_sales_sprockets |
#+-----------------------+-----------------------+-----------------------+--------------------+

# no pivot
#SELECT 
#    p.product_name,
#    CASE
#        WHEN SUM(s.sales) IS NOT NULL THEN SUM(s.sales)
#        ELSE 0
#    END total_sales
#FROM
#    product p
#        LEFT JOIN
#    sales_totals s ON p.product_id = s.product_id
#GROUP BY p.product_id;
#
#+--------------+-------------+
#| product_name | total_sales |
#+--------------+-------------+
#| Gear - Large |        6200 |
#| Gear - Small |        5450 |
#| Crankshaft   |           0 |
#| Sprocket     |        3050 |
#+--------------+-------------+

# with pivot 
SELECT 
    SUM(CASE
        WHEN p.product_id = 1256 THEN s.sales
        ELSE 0
    END) tot_sales_large_gears,
    SUM(CASE
        WHEN p.product_id = 4437 THEN s.sales
        ELSE 0
    END) tot_sales_small_gears,
    SUM(CASE
        WHEN p.product_id = 5567 THEN s.sales
        ELSE 0
    END) tot_sales_crankshafts,
    SUM(CASE
        WHEN p.product_id = 7684 THEN s.sales
        ELSE 0
    END) tot_sales_sprockets
FROM
    product p
        JOIN
    sales_totals s ON p.product_id = s.product_id;

#3. Write a query that retrieves all columns from the Sales_Totals table, along with a column called sales_rank which assigns a ranking to each row based on the value of the Sales column in descending order.
# ---------------
SELECT * ,rank() over (ORDER BY sales desc) sales_rank
	FROM sales_totals;

#4. Write a query that retrieves all columns from the Sales_Totals table, along with a column called product_sales_rank which assigns a ranking to each row based on the value of the Sales column in descending order, 
# with a separate set of rankings for each product.
# ---------------
SELECT * ,rank() over (PARTITION BY product_id ORDER BY sales desc) product_sales_rank
	FROM sales_totals;

#5. Expand on the query from question #4 by adding logic to return only those rows with a product_sales_rank of 1 or 2.
# ---------------
SELECT * 
	FROM 
		(SELECT * ,rank() over (PARTITION BY product_id ORDER BY sales desc) product_sales_rank
			FROM sales_totals s) sales_rank
	WHERE sales_rank.product_sales_rank < 3;

#6. Write a set of SQL statements which will add a row to the Region table for Europe, 
# and then add a row to the Sales_Total table for the Europe region and the Sprocket product (product_id = 7684) for October 2020, 
# with a sales total of $1,500. You can assign any value to the region_id column, as long as it is unique to the Region table. 
# The statements should be executed as a single unit of work. Please note that since the statements are executed as a single unit of work, additional code is needed.
# ---------------
START TRANSACTION;
INSERT INTO region
    (region_id, region_name, super_region_id)
VALUES
    (108,'Europe', NULL);
INSERT INTO sales_totals
    (product_id, region_id, year, month, sales)
VALUES
    (7684,108,'2020',8,1500);
COMMIT;

#7. Write a statement to create a view called Product_Sales_Totals which will group sales data by product and year.  
# Columns should include product_id, year, product_sales, 
# and gear_sales, which will contain the total sales for the “Gear - Large” and “Gear Small” products (should be generated by an expression, and it is OK to use the product_id values in the expression).  
# To accomplish this, you need a CASE statement. 
# The product_sales column should be a sum of sales for the particular product_id and year, regardless of what kind of product it is. 
# The gear_sales column should be a sum of sales only in the case where the product is either "Gear - Large” or “Gear Small”.  
# Else in the case that the product is neither “Gear - Large” or “Gear Small”, the value for gear_sales should be 0.
# ---------------

# without gear_sales column and not a view
#SELECT product_id, year, sum(sales) product_sales 
#    FROM sales_totals
#    GROUP BY product_id, year;

# not a view
#SELECT product_id, year, sum(sales) product_sales, CASE
#        WHEN product_id = 1256 THEN sum(sales)
#        WHEN product_id = 4437 THEN sum(sales)
#        ELSE 0
#    END gear_sales
#    FROM sales_totals
#    GROUP BY product_id, year;

CREATE OR REPLACE VIEW 
    product_sales_totals AS
SELECT product_id, year, sum(sales) product_sales, CASE
        WHEN product_id = 1256 THEN sum(sales)
        WHEN product_id = 4437 THEN sum(sales)
        ELSE 0
    END gear_sales
    FROM sales_totals
    GROUP BY product_id, year;

# check view is corect (Crankshaft is missing)
SELECT * 
    FROM product_sales_totals;

#8. Write a query to return all sales data for 2020, along with a column showing the percentage of sales for each product.  Columns should include product_id, region_id, month, sales, and pct_product_sales.
# ---------------

#9. Write a query to return the year, month, and sales columns, along with a 4th column named prior_month_sales showing the sales from the prior month.  There are only 12 rows in the sales_totals table, one for each month of 2020, so you will not need to group data or filter/partition on region_id or product_id.
# ---------------

#10. If the tables used in this prompt are in the ‘sales’ database, write a query to retrieve the name and type of each of the columns in the Product table. Please specify the 'sales' database in your answer.
# ---------------












