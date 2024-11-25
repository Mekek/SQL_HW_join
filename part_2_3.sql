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
    category_product_sales.product_category,
    category_product_sales.product_name,
    MAX(category_product_sales.product_sales) AS max_sales
FROM (
    SELECT 
        p.product_category,
        p.product_name,
        SUM(o.order_ammount) AS product_sales
    FROM 
        orders_2 o
    JOIN 
        products_3 p
    ON 
        o.product_id = p.product_id
    GROUP BY 
        p.product_category, p.product_name
) category_product_sales
GROUP BY 
    category_product_sales.product_category, category_product_sales.product_name
ORDER BY 
    category_product_sales.product_category, max_sales DESC;