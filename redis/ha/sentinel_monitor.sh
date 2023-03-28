#!/bin/bash

set -e

master=$1

# Set redis auth.
echo "sentinel monitor mymaster $master 6379 2" | redis-cli -p 26379 -a 123
echo "sentinel set mymaster auth-user sentinel-user" | redis-cli -p 26379 -a 123
echo "sentinel set mymaster auth-pass 123" | redis-cli -p 26379 -a 123
echo "sentinel set mymaster down-after-milliseconds 10000" | redis-cli -p 26379 -a 123
echo "sentinel set mymaster failover-timeout 180000" | redis-cli -p 26379 -a 123
echo "sentinel set mymaster parallel-syncs 1" | redis-cli -p 26379 -a 123