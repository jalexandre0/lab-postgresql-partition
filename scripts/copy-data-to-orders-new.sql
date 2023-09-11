INSERT INTO orders_new (id, product_name, quantity, order_date)
SELECT id, product_name, quantity, order_date
FROM orders
ON CONFLICT (id, order_date)
DO NOTHING;
