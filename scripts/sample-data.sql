INSERT INTO orders (product_name, quantity, order_date)
SELECT
    unnest(ARRAY['Produto1', 'Produto2', 'Produto3', 'Produto4']),
    trunc(random()*50)::int,
    date '2023-01-01' + (random() * (date '2023-12-31' - date '2023-01-01'))::int
FROM generate_series(1, 100);
