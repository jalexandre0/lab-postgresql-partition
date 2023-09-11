# Online Partition Test

## Prerequisites:
- Docker installed. Depending on your configuration, you may or may not need `sudo`. In this guide and in the internal scripts, all Docker commands are run without `sudo`.

- Linux or MacOS operating system. The scripts uses bash and are not tested on Windows Machines. Maybe this will work fine on WSL, but I don't have a Windows machine to test it.

## Execution Instructions:
Follow the sequence of the scripts below to execute the lab:

### 1. Start Docker Containers
Open a terminal and execute the following command to start the docker containers:
```bash
docker-compose up -d
```
#### To access the databases, you should export the variables and call the container with `psql` installed:
```
export MASTER_DB='postgresql://postgres:postgres@master:5432/testDB'
export REPLICA_DB='postgresql://postgres:postgres@replica:5432/testDB'
docker exec -it client psql $MASTER_DB
docker exec -it client psql $REPLICA_DB
```

### 2. Create Logical Replication
Run the script below to set up logical replication:
```bash
./01-create-logical-replication.sh
```

### 3. Insert Sample Data Continuously
Open a new shell and run the following script to insert sample data continuously:
```bash
./insert-loop.sh
```

### 4. Run the Online Partitioning Script
After validate the  data, execute the next script to start the online partitioning process:
```bash
./02-online-partitioning.sh
```
**Note:** This script is configured to recreate logical replication with partitioned tables, with resync of data upon subscription creation. This is fine for small tables, but large tables will need a another approach for data sync.

### 5. Evaluation
At this stage, you are encouraged to evaluate the code, partitions, and SQL scripts. At this stage you can also stop the docker and `insert-loop.sh` process unless you want explore data further.
