ALTER SUBSCRIPTION subscription_orders DISABLE;
ALTER SUBSCRIPTION subscription_orders SET (slot_name = NONE);
DROP SUBSCRIPTION subscription_orders;
