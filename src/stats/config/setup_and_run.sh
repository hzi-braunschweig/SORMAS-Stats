#!/bin/sh
set -e

# run migration
pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -d /srv/src/db/stats/ -t latest migrate

echo "Migration successful"

cron -f -L 15 > /proc/1/fd/1 2>&1
echo "This should never happen"
