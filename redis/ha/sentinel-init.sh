#!/bin/bash
set -e

function updateConfig() {
  key=$1
  value=$2
  file="/etc/redis/sentinel.conf"

  # Omit $value here, in case there is sensitive information
  echo "[Redis Sentinel Configuring] '$key' in '$file'"

  # If config exists in file, replace it. Otherwise, append to file.
  if grep -E -q "^$key" "$file"; then
    sed -r -i "s#^$key.*#$key $value#g" "$file" #note that no config values may contain an '@' char
  else
    echo "$key $value" >> "$file"
  fi
}

# Set sentinel auth.
echo "sentinel config set sentinel-user default" | redis-cli -p 26379
echo "sentinel config set sentinel-pass 123" | redis-cli -p 26379


# Remove default mymaster.
echo "sentinel remove mymaster" | redis-cli -p 26379

# Set default user acl.
echo "acl setuser default >123" | redis-cli -p 26379
echo "sentinel flushconfig" | redis-cli -p 26379 -a 123