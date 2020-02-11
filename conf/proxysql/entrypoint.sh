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

consul-template -consul-addr=${CONSUL_SERVER_URL} -template "/usr/local/share/proxysql/proxysql.ctpl:/etc/proxysql.cnf" &

if [ $MONITOR_CONFIG_CHANGE ]; then

	echo 'Env MONITOR_CONFIG_CHANGE=true'
	CONFIG=/etc/proxysql.cnf
	oldcksum=$(cksum ${CONFIG})

	# Start ProxySQL in the background
	proxysql --reload -f $CMDARG &

	echo "Monitoring $CONFIG for changes.."
	inotifywait -m --timefmt '%d/%m/%y %H:%M' --format '%T' ${CONFIG} | \
	while read date time; do
		newcksum=$(cksum ${CONFIG})
		if [ "$newcksum" != "$oldcksum" ]; then
			echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
			echo "At ${time} on ${date}, ${CONFIG} update detected."
			echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
			oldcksum=$newcksum
			echo "Reloading ProxySQL.."
				killall -15 proxysql
			proxysql --initial --reload -f $CMDARG
		fi
	done
fi

# Start ProxySQL with PID 1
exec proxysql -f $CMDARG

