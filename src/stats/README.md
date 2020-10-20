# Statistic Docker Container for SORMAS
## R code
All R code goes under `R`.

## Python code
All Python code goe under `python`.

## DB
The [db](db/) folder contains the DB migrations. If you want to extend or modify the DB, this is the place to go. Read the [README](db/README.md) for more details how database migration works. To dry run your changes. To apply the migration run `pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -t latest migrate` 

## Build it!
To create a container which contains the statistic scripts and also the DB migrations run:
`docker build -t local-sormas/stats .` from this folder. Start and debug the container via `docker run -it local-sormas/stats bash`