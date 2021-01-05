# Statistic Docker Container for SORMAS
## R code
All R code goes under `R`.

## Python code
All Python code goes under `python`. This folder also contains the Dash(boards).

## DB
The [db](db/) folder contains the DB migrations. If you want to extend or modify the DB, this is the place to go. Read the [README](db/README.md) for more details how database migration works. To apply the migration run `pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -t latest migrate`. Adding `--dryrun` will not commit your changes.

## Config
The [config](config/) folder contains the [setup](config/setup.sh) script which runs at startup and e.g., initiates the DB migration to the latest version. The [crontab](config/crontab) defines how a certain statistic script is scheduled. Scripts running at the same schudle can be grouped together like [run_stats.sh](config/run_stats.sh) does for example. If you struggle to write your cron expression, this [site](https://crontab.guru/) has you covered!

## Build it!
To create a container which contains the statistic scripts and also the DB migrations run:
`docker build -t local-sormas/stats .` from this folder. Start and debug the container via `docker run -it local-sormas/stats bash`

## Python for SORMAS-Stats
**IMPORTANT** Before you start run 
```
python3 -m venv src/python/venv
pip3 install -r src/python/requirements-dev.txt
```
Always use the python interpreter  from the virtual environment.  