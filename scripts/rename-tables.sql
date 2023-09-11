BEGIN;
ALTER TABLE orders RENAME TO orders_temp;
ALTER SEQUENCE orders_id_seq RENAME TO orders_temp_id_seq;
ALTER TABLE orders_new RENAME TO orders;
ALTER SEQUENCE orders_new_id_seq RENAME TO orders_id_seq;
COMMIT;
