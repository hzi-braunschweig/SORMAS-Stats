#!/bin/sh
set -e

# run migration
pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -d /srv/src/db/stats/ -t latest migrate

echo "Migration successful"


# see: https://github.com/dubiousjim/dcron/issues/13
# ignore using `exec` for `dcron` to get another pid instead of `1`
# exec "$@"
"$@"