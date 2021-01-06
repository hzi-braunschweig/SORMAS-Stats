from celery import shared_task

from stats.statistics.compute.cases_per_day import CasesPerDay
from stats.statistics.compute.transmission_chain import TransmissionChain


@shared_task
def scheduled_sormas_import():
    """
    Called periodically to import data from SORMAS into the SORMAS-Stats DB
    """
    cpd = CasesPerDay()
    cpd.run()
    chain = TransmissionChain()
    chain.run()
