#!/bin/bash

set -e

master=$1

echo "replicaof $master 6379" | redis-cli -a 123
echo "config rewrite" | redis-cli -a 123
