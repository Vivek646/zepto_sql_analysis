drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUM(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER	
); 

-- data exploration

-- count of rows
SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto
LIMIT 5;

-- null values
SELECT * FROM zepto
WHERE name IS NULL OR category IS NULL OR mrp IS NULL OR discountPercent IS NULL
OR availableQuantity IS NULL OR discountedSellingPrice IS NULL OR weightInGms IS NULL 
OR outOfStock IS NULL OR quantity IS NULL;

-- different product categories
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

-- product in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT (sku_id) DESC;

-- DATA CLEANING

-- products with price = 0
SELECT * FROM ZEPTO
WHERE MRP = 0 OR DISCOUNTEDSELLINGPRICE = 0;

DELETE FROM ZEPTO
WHERE MRP = 0;

-- convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

-- Q1 FIND THE TOP 10 BEST VALUE PRODUCTS BASED ON THE DISCOUNT PERCENTAGE.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2 WHAT ARE THE PRODUCTS WITH HIGH MRP BUT OUT OF STOCK.
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;

-- Q3 CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY
SELECT category,
SUM(discountedSellingPrice * availableQuantity) as Total_Revenue
FROM zepto
GROUP BY category
ORDER BY Total_Revenue;

-- Q4 FIND ALL PRODUCTS WHERE MRP IS GREATER THAN 500 AND DISCOUNT IS LESS THAN 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5 IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE.
SELECT category, ROUND(AVG(discountPercent),2) as HIGHEST_AVG_DISCOUNT
FROM zepto
GROUP BY category
ORDER BY HIGHEST_AVG_DISCOUNT DESC
LIMIT 5;

-- Q6 FIND THE PRICE PER GRAM FOR PRODUCTS ABOVE 100g AND SORT BY BEST VALUE.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms, 2) AS PRICE_PER_GM
FROM zepto
WHERE weightInGms >= 100
ORDER BY PRICE_PER_GM;
 
-- Q7 GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW, MEDIUM, HIGH
SELECT DISTINCT name, weightIngms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 3000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- 	Q8 WHAT IS THE TOTAL INVENTORY WEIGHT PER CATEGORY
SELECT category, 
SUM(weightInGms * availableQuantity) AS TOTAL_WEIGHT
FROM zepto
GROUP BY category
ORDER BY TOTAL_WEIGHT;




