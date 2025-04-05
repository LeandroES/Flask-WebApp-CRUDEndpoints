#!/bin/bash

set -e

host="$MYSQL_HOST"
port="$MYSQL_PORT"
timeout=60

echo "⏳ Esperando a que MySQL esté disponible en $host:$port..."

for i in $(seq 1 $timeout); do
  if nc -z "$host" "$port"; then
    echo "✅ MySQL está disponible."
    exec "$@"
    exit
  fi
  sleep 1
done

echo "❌ Timeout después de $timeout segundos esperando a MySQL."
exit 1
