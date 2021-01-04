#!/bin/bash
set -e

# run migration
pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -d /srv/src/db/stats/ -t latest migrate
echo "Migration successful"

# make env variables accessible to scripts executed by cron
printenv | grep "DB_HOST" >>  /container.env

# FIXME monitor cron
cron -L 15 > /proc/1/fd/1 2>&1

cd src/python/sormas_stats/sormas_stats

uwsgi --ini uwsgi.ini
