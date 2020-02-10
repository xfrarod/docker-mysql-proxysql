#!/bin/bash 

printf "$BRIGHT"
printf "##########################\n"
printf "# Configure KV on Conaul #\n"
printf "##########################\n"
printf "$NORMAL"

docker exec docker-mysql-proxysql_consul_server_1 consul kv put admin_variables/admin_credentials "admin:admin;radmin:radmin"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put admin_variables/mysql_ifaces "0.0.0.0:6032"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/threads 2
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/max_connections 2048
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/default_query_delay 0
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/default_query_timeout 36000000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/have_compress true
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/poll_timeout 2000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/interfaces "0.0.0.0:6033"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/default_schema "information_schema"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/stacksize 1048576
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/server_version "5.5.30"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/connect_timeout_server 3000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_username "monitor"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_password "monitor"
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_history 600000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_connect_interval 60000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_ping_interval 10000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_read_only_interval 1500
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/monitor_read_only_timeout 500
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/ping_interval_server_msec 120000
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/ping_timeout_server 500
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/commands_stats true
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/sessions_sort true
docker exec docker-mysql-proxysql_consul_server_1 consul kv put mysql_variables/connect_retries_on_failure 10