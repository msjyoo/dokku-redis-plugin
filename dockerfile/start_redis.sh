#!/bin/bash

export REDIS_HOST = $DB_PORT_6379_TCP_ADDR
export REDIS_PORT = 6379

# Start redis with our custom configuration
/usr/bin/redis-server /etc/redis/redis.conf
