from celery import shared_task

from stats.statistics.crunch.cases_per_day import CasesPerDay
from stats.statistics.crunch.transmission_chain import TransmissionChain


@shared_task
def scheduled_sormas_import():
    """
    Called periodically to import data from SORMAS into the SORMAS-Stats DB
    """
    cpd = CasesPerDay()
    cpd.crunch_numbers()
    chain = TransmissionChain()
    chain.crunch_numbers()
