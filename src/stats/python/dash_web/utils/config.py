import os

REPORT_DIRECTORY = os.path.join('/tmp', 'report')

if not os.path.exists(REPORT_DIRECTORY):
    os.makedirs(REPORT_DIRECTORY)
