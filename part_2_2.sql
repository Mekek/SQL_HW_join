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
    total_sales
FROM (
    SELECT 
        p.product_category,
        SUM(o.order_ammount) AS total_sales
    FROM 
        orders_2 o
    JOIN 
        products_3 p
    ON 
        o.product_id = p.product_id
    GROUP BY 
        p.product_category
) category_sales
ORDER BY 
    total_sales DESC
LIMIT 1;
