#!/bin/bash
set -e

function updateConfig() {
  key=$1
  value=$2
  file="/etc/redis/redis.conf"

  # Omit $value here, in case there is sensitive information
  echo "[Redis Configuring] '$key' in '$file'"

  # If config exists in file, replace it. Otherwise, append to file.
  if grep -E -q "^$key" "$file"; then
    sed -r -i "s#^$key.*#$key $value#g" "$file" #note that no config values may contain an '@' char
  else
    echo "$key $value" >> "$file"
  fi
}

# set master auth.
echo "config set masteruser replica-user" | redis-cli
echo "config set masterauth 123" | redis-cli

# set replica user.
echo "ACL SETUSER replica-user on >123 +psync +replconf +ping" | redis-cli
# set sentinel user.
echo "ACL SETUSER sentinel-user ON >123 allchannels +multi +slaveof +ping +exec +subscribe +config|rewrite +role +publish +info +client|setname +client|kill +script|kill" | redis-cli
# Set default user password.
echo "ACL SETUSER default >123" | redis-cli

# persistence.
echo "config rewrite" | redis-cli -a 123

systemctl stop redis-server
updateConfig "bind" "0.0.0.0"
systemctl start redis-server
