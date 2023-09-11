#!/bin/bash
export MASTER_DB='postgresql://postgres:postgres@master:5432/testDB'
export REPLICA_DB='postgresql://postgres:postgres@replica:5432/testDB'

create_table_orders_new () {
    echo 'creating table orders_new masterdb'
    docker exec -i client psql $MASTER_DB -X < scripts/create-table-orders-new.sql
}

create_triggers_on_orders_new () {
    echo 'creating triggers on orders_new masterdb'
    docker exec -i client psql $MASTER_DB -X < scripts/create-triggers-on-orders-new.sql
}

copy_old_data_to_new_table () {
    echo 'copying old data to orders_new masterdb'
    docker exec -i client psql $MASTER_DB -X < scripts/copy-data-to-orders-new.sql
}

rename_tables () {
    echo 'renaming tables masterdb'
    docker exec -i client psql $MASTER_DB -X < scripts/rename-tables.sql
}

count_rows_on_both_servers () {
    sleep 3
    echo 'counting rows on both servers'
    ROWS_MASTER=$(docker exec -i client psql $MASTER_DB    -X -t -c "SELECT count(*) FROM orders;")
    ROWS_REPLICAS=$(docker exec -i client psql $REPLICA_DB -X -t -c "SELECT count(*) FROM orders;")
    echo "Rows on master:  $ROWS_MASTER"
    echo "Rows on replica: $ROWS_REPLICAS"
 }

disable_subscription () {
    docker exec -i client psql $REPLICA_DB -X -t < scripts/disable-subscription.sql
}

delete_replication_slot () {
    echo 'deleting replication slot on master'
    docker exec -i client psql $MASTER_DB -X -t -c "select * from pg_drop_replication_slot('slot_orders');"
}

drop_publication () {
    echo 'dropping publication on master'
    docker exec -i client psql $MASTER_DB -X -t -c "DROP PUBLICATION publication_orders;"
}

recreate_table_orders_on_replica () {
    echo 'renaming tables on replicadb'
    docker exec -i client psql $REPLICA_DB -X < scripts/create-table-orders-new.sql
    docker exec -i client psql $REPLICA_DB -X < scripts/rename-tables.sql
}

create_replication_slot () {
    echo 'creating replication slot on master'
    docker exec -i client psql $MASTER_DB -X -c "SELECT * FROM pg_create_logical_replication_slot('slot_orders','pgoutput');"
}

create_publication () {
    echo 'creating publication on master'
    docker exec -i client psql $MASTER_DB -X -c "CREATE PUBLICATION publication_orders FOR TABLE orders;"
}

create_subscription () {
    echo 'creating subscription on replica'
    docker exec -i client psql $REPLICA_DB -X  < scripts/create-subscription.sql
}

count_rows_on_both_servers () {
    sleep 3
    echo 'counting rows on both servers'
    ROWS_MASTER=$(docker exec -i client psql $MASTER_DB    -X -t -c "SELECT count(*) FROM orders;")
    ROWS_REPLICAS=$(docker exec -i client psql $REPLICA_DB -X -t -c "SELECT count(*) FROM orders;")
    echo "Rows on master:  $ROWS_MASTER"
    echo "Rows on replica: $ROWS_REPLICAS"
}

create_table_orders_new
create_triggers_on_orders_new
copy_old_data_to_new_table
rename_tables
disable_subscription
delete_replication_slot
drop_publication
recreate_table_orders_on_replica
create_replication_slot
create_publication
create_subscription
count_rows_on_both_servers
