#!/bin/bash
#echo "host replication postgres 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf
echo "listen_addresses='*'" >> "$PGDATA/postgresql.conf"
echo "wal_level = logical" >> "$PGDATA/postgresql.conf"
echo "enable_partition_pruning = on" >> $PGDATA/postgresql.conf
echo "max_wal_senders = 3" >> $PGDATA/postgresql.conf
