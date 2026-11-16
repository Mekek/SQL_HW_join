-- Заказ с самой долгой доставкой.
SELECT
    c.name AS customer_name,
    o.order_id,
    EXTRACT(DAY FROM o.shipment_date - o.order_date) AS delivery_days
FROM customer_orders AS o
JOIN customers AS c USING (customer_id)
ORDER BY o.shipment_date - o.order_date DESC
LIMIT 1;

-- Число заказов, средний срок доставки и выручка по клиентам.
SELECT
    c.customer_id,
    c.name AS customer_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM o.shipment_date - o.order_date) / 86400), 2) AS avg_delivery_days,
    SUM(o.order_amount) AS total_spent
FROM customer_orders AS o
JOIN customers AS c USING (customer_id)
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- Клиенты с задержанными или отменёнными заказами.
SELECT
    c.customer_id,
    c.name AS customer_name,
    COUNT(*) FILTER (WHERE o.shipment_date - o.order_date > INTERVAL '5 days') AS delayed_orders,
    COUNT(*) FILTER (WHERE o.order_status = 'Cancel') AS cancelled_orders,
    SUM(o.order_amount) FILTER (WHERE o.order_status <> 'Cancel') AS completed_revenue
FROM customer_orders AS o
JOIN customers AS c USING (customer_id)
GROUP BY c.customer_id, c.name
HAVING COUNT(*) FILTER (WHERE o.shipment_date - o.order_date > INTERVAL '5 days') > 0
    OR COUNT(*) FILTER (WHERE o.order_status = 'Cancel') > 0
ORDER BY completed_revenue DESC NULLS LAST;

-- Выручка по категориям.
SELECT
    p.product_category,
    SUM(i.order_amount) AS total_sales
FROM order_items AS i
JOIN products AS p USING (product_id)
GROUP BY p.product_category
ORDER BY total_sales DESC;

-- Категория с максимальной выручкой.
SELECT
    p.product_category,
    SUM(i.order_amount) AS total_sales
FROM order_items AS i
JOIN products AS p USING (product_id)
GROUP BY p.product_category
ORDER BY total_sales DESC
LIMIT 1;

-- Самый продаваемый товар по выручке в каждой категории.
WITH product_sales AS (
    SELECT
        p.product_category,
        p.product_name,
        SUM(i.order_amount) AS total_sales
    FROM order_items AS i
    JOIN products AS p USING (product_id)
    GROUP BY p.product_category, p.product_name
), ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY product_category ORDER BY total_sales DESC) AS sales_rank
    FROM product_sales
)
SELECT product_category, product_name, total_sales
FROM ranked
WHERE sales_rank = 1
ORDER BY product_category, product_name;
