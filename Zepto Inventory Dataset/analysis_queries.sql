SELECT * FROM zepto;

-- Unique category
SELECT DISTINCT category 
FROM zepto

-- Product in stock or out of stock
SELECT outOfStock, count(sku_id)
FROM zepto
GROUP BY outOfStock 

-- product name repeated multiple times
SELECT name, COUNT(sku_id)
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC

-- Data cleaning

-- check if mrp and discount is zero
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0
-- deleting zero value
DELETE FROM zepto
WHERE mrp = 0 
  AND sku_id > 0;
  
-- updating mrp/discount from paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT * FROM zepto
ORDER BY discountpercent DESC
LIMIT 10

-- Q2. What are the products with high MRP but out of stock?

SELECT * FROM zepto
WHERE outOfStock = 1
AND mrp>500
ORDER BY mrp DESC

-- Q3. Calculate Estimated Revenue for each category

SELECT category,
SUM(discountedSellingPrice* quantity) AS Revenue
FROM zepto
GROUP BY category
ORDER BY Revenue DESC


-- Q4. Find all products where MRP is greater than 500 and discount is less than 10%.

SELECT category, name, mrp, discountPercent
FROM zepto
WHERE mrp>500
AND discountPercent <10
ORDER BY mrp DESC

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT category,
AVG(discountPercent) AS averageDiscountPercent
FROM zepto
GROUP BY category
ORDER BY averageDiscountPercent DESC
LIMIT 5

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT category, name, weightInGms,
(discountedSellingPrice / weightInGms) AS pricePerGms
FROM zepto
WHERE weightInGMs > 100
ORDER BY pricePerGms ASC

-- Q7. Group the products into weight categories like Low, Medium, Bulk.

SELECT 
  category, name,
  CASE 
    WHEN weightInGms > 2000 THEN 'Bulk'
    WHEN weightInGms > 500 THEN 'Medium'
    ELSE 'Low'
  END AS weight_category
FROM zepto;

-- Q8. What is the Total Inventory Weight Per Category?

SELECT category,
SUM(weightInGms * availableQuantity)/1000 AS inventoryWeightKg
FROM zepto
GROUP BY category
ORDER BY inventoryWeightKg DESC
  
  
  