import os

# set the default Django settings module for the 'celery' program.
from celery import Celery
from celery.utils.log import get_task_logger

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'sormas_stats.settings')

app = Celery('sormas_stats')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# - namespace='CELERY' means all celery-related configuration keys
#   should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django app configs.
app.autodiscover_tasks()

logger = get_task_logger(__name__)


@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')

# Periodic
# @app.on_after_configure.connect
# def setup_periodic_tasks(sender, **kwargs):
#    # Calls every 10 seconds.
#    sender.add_periodic_task(10.0, scheduled.s(), name='abc')


# @app.task
# def scheduled():
#    print('acc')
