#!/bin/bash
export MASTER_DB='postgresql://postgres:postgres@master:5432/testDB'
export REPLICA_DB='postgresql://postgres:postgres@replica:5432/testDB'

create_tables () {
    echo 'creating tables on both servers'
    docker exec -i client psql $MASTER_DB  -X < scripts/create-table-orders.sql
    docker exec -i client psql $REPLICA_DB -X < scripts/create-table-orders.sql
}

insert_sample_data () {
    echo 'inserting sample data on master'
    docker exec -i client psql $MASTER_DB -X < scripts/sample-data.sql
}

create_replication_slot () {
    echo 'creating replication slot on master'
    docker exec -i client psql $MASTER_DB -X -c "SELECT * FROM pg_create_logical_replication_slot('slot_orders','pgoutput');"
}

create_publication () {
    echo 'creating publication on master'
    docker exec -i client psql $MASTER_DB -X -c "CREATE PUBLICATION publication_orders FOR TABLE orders;"
}

create_subscripton () {
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

create_tables
insert_sample_data
count_rows_on_both_servers
create_replication_slot
create_publication
create_subscripton
insert_sample_data
count_rows_on_both_servers
