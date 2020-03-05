#!/bin/sh 

printf "##########################\n"
printf "# Configure KV on Consul #\n"
printf "##########################\n"


CONSUL_HTTP_ADDR="${CONSUL_HTTP_ADDR:-'consul.dev.thislife.com'}"

consul kv put proxysql/config/admin_variables/admin_credentials "admin:admin;radmin:radmin"
consul kv put proxysql/config/admin_variables/mysql_ifaces "0.0.0.0:6032"
consul kv put proxysql/config/mysql_variables/threads 2
consul kv put proxysql/config/mysql_variables/max_connections 2048
consul kv put proxysql/config/mysql_variables/default_query_delay 0
consul kv put proxysql/config/mysql_variables/default_query_timeout 36000000
consul kv put proxysql/config/mysql_variables/have_compress true
consul kv put proxysql/config/mysql_variables/poll_timeout 2000
consul kv put proxysql/config/mysql_variables/interfaces "0.0.0.0:6033"
consul kv put proxysql/config/mysql_variables/default_schema "information_schema"
consul kv put proxysql/config/mysql_variables/stacksize 1048576
consul kv put proxysql/config/mysql_variables/server_version "5.5.30"
consul kv put proxysql/config/mysql_variables/connect_timeout_server 3000
consul kv put proxysql/config/mysql_variables/monitor_username "monitor"
consul kv put proxysql/config/mysql_variables/monitor_password "monitor"
consul kv put proxysql/config/mysql_variables/monitor_history 600000
consul kv put proxysql/config/mysql_variables/monitor_connect_interval 60000
consul kv put proxysql/config/mysql_variables/monitor_ping_interval 10000
consul kv put proxysql/config/mysql_variables/monitor_read_only_interval 1500
consul kv put proxysql/config/mysql_variables/monitor_read_only_timeout 500
consul kv put proxysql/config/mysql_variables/ping_interval_server_msec 120000
consul kv put proxysql/config/mysql_variables/ping_timeout_server 500
consul kv put proxysql/config/mysql_variables/commands_stats true
consul kv put proxysql/config/mysql_variables/sessions_sort true
consul kv put proxysql/config/mysql_variables/connect_retries_on_failure 10

consul kv put proxysql/config/proxysql.cnf @proxysql.cnf
consul kv put proxysql/config/mysql_servers.cnf @mysql_servers.cnf
consul kv put proxysql/config/mysql_users.cnf @mysql_users.cnf
consul kv put proxysql/config/config.sql @config.sql
