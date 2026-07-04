/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?


SELECT s.customer_id,
SUM(m.price) AS totalSpend
FROM sales AS s
JOIN menu AS m 
     ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT customer_id,
COUNT(DISTINCT order_date) AS visits
FROM sales 
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?

WITH ranked_sales AS (
    SELECT 
        customer_id,
        order_date,
        product_id,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS order_rank
    FROM sales
)
SELECT r.customer_id ,
r.order_date,
m.product_name
FROM ranked_sales as r
JOIN menu as m ON r.product_id = m.product_id
WHERE r.order_rank = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

WITH famous_item AS (
SELECT 
product_id,
count(*) as popularitem
FROM sales
group by product_id
)
SELECT 
	f.product_id,
	f.popularitem,
	m.product_name
FROM famous_item f
join menu m on 
	f.product_id = m.product_id
ORDER BY f.popularitem DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH famous_item AS (
    SELECT 
        customer_id,
        product_id,
        COUNT(*) AS popularitem
    FROM sales
    GROUP BY customer_id, product_id
),
ranked_items AS (
    SELECT 
        customer_id,
        product_id,
        popularitem,
        DENSE_RANK() OVER(
            PARTITION BY customer_id
            ORDER BY popularitem DESC
        ) AS topitem
    FROM famous_item
)
SELECT
    r.customer_id,
    m.product_name,
    r.popularitem
FROM ranked_items r
JOIN menu m
    ON r.product_id = m.product_id
WHERE r.topitem = 1;

-- 6. Which item was purchased first by the customer after they became a member?
WITH first_purchase AS (
    SELECT
        s.customer_id,
        s.order_date,
        s.product_id,
        ROW_NUMBER() OVER(
            PARTITION BY s.customer_id
            ORDER BY s.order_date
        ) AS rn
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id
    WHERE s.order_date >= m.join_date
)

SELECT
    fp.customer_id,
    fp.order_date,
    me.product_name
FROM first_purchase fp
JOIN menu me
    ON fp.product_id = me.product_id
WHERE fp.rn = 1;


-- 7. Which item was purchased just before the customer became a member?

WITH last_purchase AS (
    SELECT
        s.customer_id,
        s.order_date,
        s.product_id,
        ROW_NUMBER() OVER(
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC
        ) AS rn
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id
    WHERE s.order_date <= m.join_date
)

SELECT
    lp.customer_id,
    lp.order_date,
    me.product_name
FROM last_purchase lp
JOIN menu me
    ON lp.product_id = me.product_id
WHERE lp.rn = 1;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT
    s.customer_id,
    COUNT(*) AS total_items,
    SUM(m.price) AS total_amount_spent
FROM sales s
JOIN members mem
    ON s.customer_id = mem.customer_id
JOIN menu m
    ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH pricepoint AS (
SELECT price, product_id, product_name,
CASE 
WHEN product_name <>"sushi" THEN price*10
ELSE (price*10)*2
END AS points
FROM menu
)
SELECT 
	s.customer_id,
	SUM(p.points) AS Totalpoints
FROM sales s
JOIN pricepoint p
	ON s.product_id = p.product_id
GROUP BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
WITH firstweek AS (
	SELECT
        s.customer_id,
        s.order_date,
        m.join_date,
        mn.product_name,
        mn.price,

        CASE
            WHEN s.order_date >= m.join_date AND s.order_date < DATE_ADD(m.join_date, INTERVAL 7 DAY)
                THEN mn.price * 20
            WHEN mn.product_name = 'sushi' THEN mn.price * 20
            ELSE mn.price * 10
        END AS points

    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id
    JOIN menu mn
        ON s.product_id = mn.product_id

	WHERE s.order_date <= '2021-01-31'
)
SELECT
    customer_id,
    SUM(points) AS total_points
FROM firstweek
GROUP BY customer_id;
