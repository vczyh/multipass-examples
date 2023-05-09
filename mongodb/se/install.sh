#!/bin/bash

# Download
package_name=mongodb-linux-arm64-ubuntu1604-4.0.28
mongodb_dir=/opt/mongodb
wget https://fastdl.mongodb.org/linux/${package_name}.tgz -O /opt/${package_name}.tgz
mkdir -p ${mongodb_dir}
tar -C ${mongodb_dir} -xzvf /opt/${package_name}.tgz --strip-components 1
cp ${mongodb_dir}/bin/* /usr/bin

adduser --system --group --no-create-home mongodb
config_dir=/etc/mongodb
mongod_data=/mongodb
mongod_log=/var/log/mongod
mongos_log=/var/log/mongos
mkdir -p ${config_dir} && chown mongodb:mongodb ${config_dir} -R && chmod 755 ${config_dir} -R
mkdir -p ${mongod_data} && chown mongodb:mongodb ${mongod_data} -R && chmod 755 ${mongod_data} -R
mkdir -p ${mongod_log} && chown mongodb:mongodb ${mongod_log} -R && chmod 755 ${mongod_log} -R
mkdir -p ${mongos_log} && chown mongodb:mongodb ${mongos_log} -R && chmod 755 ${mongos_log} -R

# Mongod
cat > ${config_dir}/mongod.conf << EOF
storage:
  dbPath: ${mongod_data}
#  engine:
#  wiredTiger:

systemLog:
  destination: file
  logAppend: true
  path: ${mongod_log}/mongod.log

net:
  port: 27017
  bindIp: 0.0.0.0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

#security:

#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options:

#auditLog:

#snmp:
EOF

cat > /lib/systemd/system/mongod.service << EOF
[Unit]
Description=MongoDB Database Server
Documentation=https://docs.mongodb.org/manual
After=network-online.target
Wants=network-online.target

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod --config ${config_dir}/mongod.conf
RuntimeDirectory=mongodb
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false

# Recommended limits for mongod as specified in
# https://docs.mongodb.com/manual/reference/ulimit/#recommended-ulimit-settings

[Install]
WantedBy=multi-user.target
EOF


# Mongos
cat > ${config_dir}/mongos.conf << EOF
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongos/mongos.log

net:
  port: 30000
  bindIp: 0.0.0.0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

sharding:
  configDB: replsetname/127.0.0.1:10000
EOF

cat > /lib/systemd/system/mongos.service << EOF
[Unit]
Description=MongoDB Mongos Server
Documentation=https://docs.mongodb.org/manual
After=network-online.target
Wants=network-online.target

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongos --config ${config_dir}/mongos.conf
RuntimeDirectory=mongodb
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false

# Recommended limits for mongod as specified in
# https://docs.mongodb.com/manual/reference/ulimit/#recommended-ulimit-settings

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start mongod
systemctl start mongos
