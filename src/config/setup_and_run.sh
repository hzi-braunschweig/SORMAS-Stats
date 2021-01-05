#!/bin/bash
set -e

cd src/sormas_stats/

# run migration
python3 manage.py migrate
echo "Migration successful"

# start celery workers in background
celery multi start w1 -A sormas_stats -l INFO --pidfile=/var/run/celery/%n.pid --logfile=/var/log/celery/%n%I.log

# todo cleanup
celery -A sormas_stats beat -l INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler&


cd sormas_stats
uwsgi --ini uwsgi.ini
