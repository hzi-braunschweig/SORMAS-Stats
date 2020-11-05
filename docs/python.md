# Statistic Docker Container for SORMAS

## DB
The [db](https://github.com/hzi-braunschweig/SORMAS-Stats/tree/development/src/stats/db) folder contains the DB migrations. If you want to extend or modify the DB, 
this is the place to go. Read the [db-documentation](db.md) for more details how database migration works. 
To apply the migration run 

`pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -t latest migrate`. 

Adding `--dryrun` will not commit your changes.

## Config
The [config](https://github.com/hzi-braunschweig/SORMAS-Stats/tree/development/src/stats/config) folder 
contains the [setup](https://github.com/hzi-braunschweig/SORMAS-Stats/blob/development/src/stats/config/setup_and_run.sh) 
script which runs at startup and e.g., initiates the DB migration 
to the latest version. The [crontab](https://github.com/hzi-braunschweig/SORMAS-Stats/blob/development/src/stats/config/crontab) defines how a certain statistic script 
is scheduled. Scripts running at the same schedule can be grouped together 
like [run_stats.sh](https://github.com/hzi-braunschweig/SORMAS-Stats/blob/development/src/stats/config/run_stats.sh) 
does for example. If you struggle to write your cron  expression, the [crontab.guru](https://crontab.guru/) has you covered!
    
## Build it!
To create a container which contains the statistic scripts and also the DB migrations run:
`docker build -t local-sormas/stats .` from this folder. Start and debug the container via `docker run -it local-sormas/stats bash`