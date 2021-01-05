from celery import shared_task

from stats.statistics.fetch.cases_per_day import import_cases_per_day
from stats.models import CasesPerDay


@shared_task
def scheduled_sormas_import():
    """
    Called periodically to import data from SORMAS into the SORMAS-Stats DB
    """
    return import_cases_per_day()


@shared_task
def task_case_count_total():
    return CasesPerDay.objects.count()
