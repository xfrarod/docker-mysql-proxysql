#!/bin/bash
set -e

## ProxySQL entrypoint
## ===================
##
## Supported environment variables:
##
## MONITOR_CONFIG_CHANGE={true|false}
## - Monitor /etc/proxysql.cnf for any changes and reload ProxySQL automatically
##
## CONSUL_SERVER_URL
## - Consul server address
##

CONSUL_SERVER_URL="${CONSUL_SERVER_URL:-'consul_server:8500'}"

# If command has arguments, prepend proxysql
if [ "${1:0:1}" == '-' ]; then
    CMDARG="$@"
fi

consul-template -consul-addr=${CONSUL_SERVER_URL} -template "/usr/local/share/proxysql/proxysql.ctpl:/etc/proxysql.cnf" --once

# Start ProxySQL in the background
proxysql --reload -f $CMDARG &

if [ $MONITOR_CONFIG_CHANGE ]; then

    echo 'Env MONITOR_CONFIG_CHANGE=true'
    CONFIG=/usr/local/share/proxysql/config.sql
    CONFIG_CTPL=/usr/local/share/proxysql/config.sql.ctpl

    nohup consul-template -consul-addr=${CONSUL_SERVER_URL} -template ${CONFIG_CTPL}:${CONFIG} &

    oldcksum=$(cksum ${CONFIG})

    echo "Monitoring $CONFIG for changes.."
    while true; do
        newcksum=$(cksum ${CONFIG})
        sleep 2
        if [ "$newcksum" != "$oldcksum" ]; then
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "At $(date) ${CONFIG} update detected."
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            oldcksum=$newcksum

            echo "Reloading Configuration ProxySQL.."
            mysql -uradmin -pradmin -h127.0.0.1 -P6032 < ${CONFIG}
        fi
    done
fi

# Start ProxySQL with PID 1
exec proxysql -f $CMDARG






