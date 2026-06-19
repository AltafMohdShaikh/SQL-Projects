-- A. Pizza Metrics

SELECT * FROM customer_orders;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM runner_orders;
SELECT * FROM runners;


-- 1.How many pizzas were ordered?

SELECT 
COUNT(*) AS totalOrder
FROM customer_orders;

-- 2. How many unique customer orders were made?

SELECT 
COUNT(DISTINCT customer_id) AS uniqeCustomer
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?

SELECT
runner_id,
COUNT(*) as CO
FROM runner_orders
WHERE duration <> 'null'
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?

SELECT
co.pizza_id,
COUNT(*) AS dilivered
FROM runner_orders ro
JOIN customer_orders co
ON co.order_id = ro.order_id
WHERE duration <> 'null'
GROUP BY pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
customer_id,
pizza_id,
COUNT(*) AS totalpizza
FROM customer_orders
GROUP BY pizza_id , customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT MAX(totalPizza) AS maxPizza
FROM (
    SELECT
        co.order_id,
        COUNT(*) AS totalPizza
    FROM customer_orders co
    JOIN runner_orders ro
        ON co.order_id = ro.order_id
    WHERE ro.duration <> 'null'
    GROUP BY co.order_id
) AS mo;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
co.customer_id,
SUM(CASE
		WHEN ((co.exclusions NOT IN ('null', ''))
			OR (co.extras NOT IN ('null', '')))
		THEN 1
		ELSE 0
	END
) AS changed_pizzas,
SUM(CASE
		WHEN ((co.exclusions IN ('null', ''))
			AND (co.extras IN ('null', '')))
		THEN 1
		ELSE 0
	END
) AS unchanged_pizzas
FROM customer_orders co
JOIN runner_orders ro
ON co.order_id=ro.order_id
WHERE ro.duration <> 'null'
GROUP BY co.customer_id;



-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) AS orders 
FROM customer_orders co
JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE exclusions <> 'null'
AND exclusions <> ''
AND extras<> 'null'
AND extras <> ''
AND duration <> 'null';

-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT 
HOUR(order_time) AS hourInDay,
COUNT(pizza_id) AS pizzavolume
FROM customer_orders
GROUP BY hourInDay;

-- 10. What was the volume of orders for each day of the week?
SELECT 
    DAYNAME(order_time) AS day_name,
    COUNT(*) AS pizza_volume
FROM customer_orders
GROUP BY day_name
