CREATE TABLE customers_new_3 (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE orders_new_3 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP NOT NULL,
    shipment_date TIMESTAMP NOT NULL,
    order_ammount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers_new_3(customer_id)
);

\COPY customers_new_3 FROM 'path/to/customers_new_3.csv' DELIMITER ',' CSV HEADER;

\COPY orders_new_3 FROM 'path/to/orders_new_3.csv' DELIMITER ',' CSV HEADER;



SELECT 
    c.name AS customer_name,
    COUNT(CASE WHEN (o.shipment_date - o.order_date) > INTERVAL '5 days' THEN 1 END) AS delayed_deliveries,
    COUNT(CASE WHEN o.order_status = 'Cancel' THEN 1 END) AS canceled_orders,
    SUM(o.order_ammount) AS total_spent
FROM 
    orders_new_3 o
JOIN 
    customers_new_3 c ON o.customer_id = c.customer_id
GROUP BY 
    c.customer_id
ORDER BY 
    total_spent DESC;
