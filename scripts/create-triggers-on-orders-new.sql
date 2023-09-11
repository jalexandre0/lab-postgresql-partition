CREATE OR REPLACE FUNCTION orders_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO orders_new VALUES (NEW.*);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION orders_update_trigger()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE orders_new SET id = NEW.id, product_name = NEW.product_name, quantity = NEW.quantity, order_date = NEW.order_date WHERE id = OLD.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION orders_delete_trigger()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM orders_new WHERE id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_after_orders
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION orders_insert_trigger();

CREATE TRIGGER after_update_after_orders
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION orders_update_trigger();

CREATE TRIGGER after_delete_after_orders
AFTER DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION orders_delete_trigger();
