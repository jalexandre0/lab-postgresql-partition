#!/bin/bash
export MASTER_DB='postgresql://postgres:postgres@master:5432/testDB'
export REPLICA_DB='postgresql://postgres:postgres@replica:5432/testDB'

while true ; do
    echo 'inserting data'
    docker exec -i client psql $MASTER_DB -X -t < scripts/sample-data.sql

    echo 'sleeping for 2 seconds'
    sleep 2

    echo 'counting rows on both servers'
    ROWS_MASTER=$(docker exec -i client psql $MASTER_DB    -X -t -c "SELECT count(*) FROM orders;")
    ROWS_REPLICAS=$(docker exec -i client psql $REPLICA_DB -X -t -c "SELECT count(*) FROM orders;")
    echo "Rows on master:  $ROWS_MASTER"
    echo "Rows on replica: $ROWS_REPLICAS"
done
