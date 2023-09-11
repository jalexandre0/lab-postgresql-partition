CREATE SUBSCRIPTION subscription_orders
CONNECTION 'dbname=testDB user=postgres password=postgres host=pg_master port=5432'
PUBLICATION publication_orders
WITH (slot_name = slot_orders, create_slot = false);
