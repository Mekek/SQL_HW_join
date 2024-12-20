DROP TABLE IF EXISTS customers_new_3 CASCADE;

DROP TABLE IF EXISTS orders_new_3 CASCADE;

CREATE TABLE IF NOT EXISTS customers_new_3 (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS orders_new_3 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP NOT NULL,
    shipment_date TIMESTAMP NOT NULL,
    order_ammount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers_new_3(customer_id)
);

COPY customers_new_3 FROM 'C:\\Code\\WB\\SQL_HW_2\\customers_new_3.csv' DELIMITER ',' CSV HEADER;

COPY orders_new_3 FROM 'C:\\Code\\WB\\SQL_HW_2\\orders_new_3.csv' DELIMITER ',' CSV HEADER;


SELECT 
    c.name AS customer_name,
    o.order_id,
    (EXTRACT(EPOCH FROM (o.shipment_date - o.order_date)) / 86400) AS delivery_delay_days
FROM 
    orders_new_3 o
JOIN 
    customers_new_3 c ON o.customer_id = c.customer_id
ORDER BY 
    delivery_delay_days DESC
LIMIT 1;