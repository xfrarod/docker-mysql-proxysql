##### Configuring ProxySQL

# We're adding 4 servers to 4 hostgroups 
# 	1 - global read & write 
# 	2 - global read only
# 	3 - shard read & write
# 	4 - shard read only

DELETE FROM mysql_servers;
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (1, 'database.beta.thislife.com', '9998');
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (2, 'database.beta.thislife.com', '9999');
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (3, 'database.beta.thislife.com', '10000');
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (4, 'database.beta.thislife.com', '12000');
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;

# Add mysql credentials to monitor so it can monitor MySQL servers state
UPDATE global_variables SET variable_value='proxysqladmin'WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='admin123'WHERE variable_name='mysql-monitor_password';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

# Enable web interface
UPDATE global_variables SET variable_value='true' WHERE variable_name='admin-web_enabled';
LOAD ADMIN VARIABLES TO RUNTIME;
SAVE ADMIN VARIABLES TO DISK;

# Replication configuration - first pair is global (1 - read & write, 2 read only slave) , second pair is shard (3 - read & write, 4 read only slave)
DELETE FROM mysql_replication_hostgroups;
INSERT INTO mysql_replication_hostgroups (writer_hostgroup, reader_hostgroup, check_type, comment) VALUES (1,2,'super_read_only','GlobalCluster');
INSERT INTO mysql_replication_hostgroups (writer_hostgroup, reader_hostgroup, check_type, comment) VALUES (3,4,'innodb_read_only','ShardCluster');
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;

# Mysql users - who will connect to the ProxySQL | Loading into runtime for password hasing | Downloading from runtime | Save to disk
DELETE FROM mysql_users;
INSERT INTO mysql_users (username,password) VALUES ('proxysqladmin','admin123');
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO MEMORY;
SAVE MYSQL USERS TO DISK;

#####
## One way to do it - split trafic by ports - Application controls the reads/write splitting
## This is drop-in configuration - no application change.
#####

# Set 4 ports - 9998 & 10000 for read&write, 9999 & 12000 for read only | here we only set the listen ports, not the read/write split
UPDATE global_variables SET variable_value='0.0.0.0:9998;0.0.0.0:9999;0.0.0.0:10000;0.0.0.0:12000' WHERE variable_name='mysql-interfaces';
SAVE MYSQL VARIABLES TO DISK;

# Set routing from port 9998 to hostgroup 1, 9999 to hostgroup 2, 10000 to hostgroup 3 and 12000 to hostgroup 4
DELETE FROM mysql_query_rules;
INSERT INTO mysql_query_rules (rule_id,active,proxy_port,destination_hostgroup,apply) VALUES (1,1,9998,1,1);
INSERT INTO mysql_query_rules (rule_id,active,proxy_port,destination_hostgroup,apply) VALUES (2,1,9999,2,1);
INSERT INTO mysql_query_rules (rule_id,active,proxy_port,destination_hostgroup,apply) VALUES (3,1,10000,3,1);
INSERT INTO mysql_query_rules (rule_id,active,proxy_port,destination_hostgroup,apply) VALUES (4,1,12000,4,1);
LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;

# Queries for validation
# 
# SELECT * FROM mysql_servers;
# SELECT * FROM global_variables;
# SELECT * FROM mysql_replication_hostgroups;
# SELECT * FROM mysql_users;
# SELECT * FROM mysql_query_rules;

