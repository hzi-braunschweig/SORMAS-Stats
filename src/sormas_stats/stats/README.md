# Stats

All statistic computation goes here.

## Processing pipeline

The process is as follows for every statistical indicator or data importer:

1. Fetch data from SORMAS DB
1. Compute indicator or do data scrubbing/normalization
1. In case you import newer data, flush stale data from stats DB
1. Store the computed/imported values in stats DB

## Stats DB

Checkout the DB [models](models.py) of SORMAS-Stats. Everything we import into SORMAS-Stats needs a well-defined table.
We use PostgreSQL for persistance.

## SORMAS DB

Checkout the SORMAS DB [models](sormas_models.py). Allow programmatic access to SORMAS DB entities.

## tasks

Run import tasks on schedule.

## statistics

Statistic and importer scripts. See [here](statistics/README.md).
