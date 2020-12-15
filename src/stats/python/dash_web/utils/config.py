import os

REPORT_DIRECTORY = '/tmp/report'

if not os.path.exists(REPORT_DIRECTORY):
    os.makedirs(REPORT_DIRECTORY)
