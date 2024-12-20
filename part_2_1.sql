DROP TABLE IF EXISTS products_3 CASCADE;
DROP TABLE IF EXISTS orders_2 CASCADE;

CREATE TABLE products_3 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_category VARCHAR(100)
);

CREATE TABLE orders_2 (
    order_date TIMESTAMP,
    order_id INT,
    product_id INT,
    order_ammount NUMERIC,
    unique_order_id SERIAL PRIMARY KEY,  
    FOREIGN KEY (product_id) REFERENCES products_3(product_id)
);

COPY products_3 (product_id, product_name, product_category) 
FROM 'C:\\Code\\WB\\SQL_HW_2\\products_3.csv' DELIMITER ',' CSV HEADER;

COPY orders_2 (order_date, order_id, product_id, order_ammount)
FROM 'C:\\Code\\WB\\SQL_HW_2\\orders_2.csv' DELIMITER ',' CSV HEADER;

SELECT 
    p.product_category,
    SUM(o.order_ammount) AS total_sales
FROM 
    products_3 p
JOIN 
    orders_2 o ON p.product_id = o.product_id
GROUP BY 
    p.product_category;
