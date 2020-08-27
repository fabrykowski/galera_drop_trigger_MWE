#!/bin/bash

docker-compose up -d

mysql_user=root
mysql_pass=password
mysql_hosts=(db00 db01 db02)

for host in ${mysql_hosts[@]}; do
    while true; do
        docker-compose exec $host mysqladmin -h$host -u$mysql_user -p$mysql_pass ping > /dev/null
        if [ $? -eq 0 ]; then
            break
        fi
    done
done

# all databases operational

cat test0.sql | docker-compose exec -T db02 mysql -hdb02 -u$mysql_user -p$mysql_pass > /dev/null
cat test1.sql | docker-compose exec -T db01 mysql -hdb01 -u$mysql_user -p$mysql_pass > /dev/null

# now check
docker-compose exec -T db00 mysql -hdb00 -u$mysql_user -p$mysql_pass db_out -se "select count(*) from tbl_log;"
