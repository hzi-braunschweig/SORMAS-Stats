import os

from django.apps import AppConfig


class ReportingConfig(AppConfig):
    name = 'reporting'
    REPORT_DIRECTORY = os.path.join('/tmp', 'sormas_stats', 'reporting')

    def ready(self):
        if not os.path.exists(self.REPORT_DIRECTORY):
            os.makedirs(self.REPORT_DIRECTORY)
