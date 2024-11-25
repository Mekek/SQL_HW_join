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
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products_3(product_id)
);


\COPY products_3 FROM 'path/to/products_3.csv' DELIMITER ',' CSV HEADER;

\COPY orders_2 FROM 'path/to/orders_2.csv' DELIMITER ',' CSV HEADER;


SELECT 
    product_category,
    SUM((
        SELECT SUM(o.order_ammount)
        FROM orders_2 o
        WHERE o.product_id = p.product_id
    )) AS total_sales
FROM products_3 p
GROUP BY product_category;


