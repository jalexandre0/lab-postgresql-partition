CREATE TABLE orders (
    id INT GENERATED ALWAYS AS IDENTITY,
    product_name TEXT,
    quantity INT,
    order_date DATE,
    PRIMARY KEY (id)
);
