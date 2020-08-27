# Test `DROP TRIGGER` in a Galera cluster

The `docker-compose.yml` file describes three containers – `db00`, `db01` and `db02` – based on [bitnami/mariadb-galera](https://github.com/bitnami/bitnami-docker-mariadb-galera), each running MariaDB 10.5.5 with Galera 4.5 and linked into a single multi-master cluster.

The script `run_test.sh` starts the cluster via `docker-compose`, waits for all three servers to be operational and then executes three scripts:

1. `test0.sql` – executed on `db02` – initialises two databeses with one table each. Then it adds a trigger to one of the tables, which inserts a value into the other table (i.e. writes a log), whenever the first table receives a new row (`after insert`). To test the trigger, three random values are added to this table. Finally the trigger is **`dropped`**.
2. `test1.sql` – executed on `db01` - simply adds further two values to the table, which has had the trigger.
3. We count – and `echo` – on `db00` the number of logged items.

The trigger has been dropped after three inserts, so the echoed number should be `3`, but the `drop trigger` on `db02` is not propagated by Galera, so the `insert` on `db01` still runs the trigger, resulting in `5` log entries.
