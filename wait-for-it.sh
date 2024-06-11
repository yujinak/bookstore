#!/usr/bin/env bash
# wait-for-it.sh
# Use this script to test if a given TCP host/port are available
# Source: https://github.com/vishnubob/wait-for-it

set -e

host="$1"
shift
port="$1"
shift

timeout="${WAIT_FOR_IT_TIMEOUT:-15}"
cmd=( "$@" )

>&2 echo "Waiting for $host:$port..."

for ((i=0;i<timeout;i++)); do
    nc -z "$host" "$port" && break
    >&2 echo "Waiting..."
    sleep 1
done

>&2 echo "$host:$port is available"
exec $cmd
