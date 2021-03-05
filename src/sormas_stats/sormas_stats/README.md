# SORMAS-Stats

Main django application. Takes care of global [settings](settings.py) and [routing](urls.py).

## Celery

We use [Celery](https://docs.celeryproject.org/en/stable/) as task queue for 
background processing and scheduling.