#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Started ProxySQL / Orchestrator / MySQL Docker Cluster Provisioner!            #\n"
printf "##################################################################################\n"
printf "$NORMAL"

sleep 1

docker-compose up -d consul_server

######################################################
## Run all scripts of initial consul configurations ##
######################################################

INITIAL_SCRIPTS='./conf/consul/initial_scripts/'
if [ -d $INITIAL_SCRIPTS ] ; then 
  cd ${INITIAL_SCRIPTS}
  echo ">> Running initial configuration scripts"
  for file in $(ls *.sh); do 
    docker exec -it docker-mysql-proxysql_consul_server_1 /consul/config/initial_scripts/${file}
  done
  cd -
else 
  echo ">> NO initial_scripts to run"; 
fi

docker-compose up -d

./bin/docker-mysql-post.bash && \
./bin/docker-orchestrator-post.bash && \
#./bin/docker-restart-binlog_reader.bash && \
./bin/docker-proxy-post.bash #&& \
#./bin/docker-consul-post-kv.bash

#if [[ -z "$1" ]]; then
#    ./bin/docker-benchmark.bash
#fi
