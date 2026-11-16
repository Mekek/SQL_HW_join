DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customer_orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE customer_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date TIMESTAMP NOT NULL,
    shipment_date TIMESTAMP NOT NULL,
    order_amount NUMERIC(12, 2) NOT NULL CHECK (order_amount >= 0),
    order_status VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(100) NOT NULL
);

CREATE TABLE order_items (
    item_id BIGSERIAL PRIMARY KEY,
    order_date TIMESTAMP NOT NULL,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    order_amount NUMERIC(12, 2) NOT NULL CHECK (order_amount >= 0)
);

\copy customers (customer_id, name) FROM 'data/customers_new_3.csv' WITH (FORMAT csv, HEADER true);
\copy customer_orders (order_id, customer_id, order_date, shipment_date, order_amount, order_status) FROM 'data/orders_new_3.csv' WITH (FORMAT csv, HEADER true);
\copy products (product_id, product_name, product_category) FROM 'data/products_3.csv' WITH (FORMAT csv, HEADER true);
\copy order_items (order_date, order_id, product_id, order_amount) FROM 'data/orders_2.csv' WITH (FORMAT csv, HEADER true);
