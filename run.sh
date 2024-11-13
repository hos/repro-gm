#! /bin/bash

export CMD="yarn dlx"

$CMD graphile-migrate watch 2>&1 &

pid=$!

sleep 5

$CMD graphile-migrate commit
$CMD graphile-migrate uncommit

# Tell graphile-migrate that we allow invalid hashes
echo "--! AllowInvalidHash" | cat - ./migrations/current.sql > temp && mv temp ./migrations/current.sql

# Add some new statement in the current.sql file
echo "SELECT 1;" >> ./migrations/current.sql

$CMD graphile-migrate commit || true # continue on fail

if kill -0 $pid 2>/dev/null; then
    echo "Failed to terminate process $pid. Trying again..."
    pkill -f "graphile-migrate/dist"
    echo "Process $pid forcefully terminated."
else
    echo "Process $pid terminated successfully."
fi