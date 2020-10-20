# Database Migration
We use [pgmigrate](https://github.com/yandex/pgmigrate) to mange migrations. Run
`pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" info` inside of the container to see what `schema_version` you're at.


## Connect to the database
Run `psql --host=localhost -U stats_user sormas_stats`. In the dev setup, the password is `password`.

## How does it work?
If you want to make changes, place a file follwing the format `V<version>__<my_description>.sql` under [migrations](migrations/) (e.g., '`V0042__Add_column_to_table_bar.sql`'). **Note the two underscores after the version** or it will be ignored. Run 
```
pgmigrate -c "host=postgres dbname=sormas_stats user=stats_user password=password" -t latest migrate
``` 
to apply your changes. Use `--dryrun` with the previous command to not commit your changes.

## Debugging
Create a debug table:
```
CREATE TABLE IF NOT EXISTS debug (
    seq SERIAL PRIMARY KEY,
    msg TEXT NOT NULL
);
```
or uncomment the line (here)[stats/callbacks/beforeAll/00_debug_create_debug_tables.sql].
Then you can add `INSERT INTO debug (msg) VALUES ('My message');` to your SQL file and you can uncomment the debug statements from the (callbacks)[callbacks/] in case you are unsure about the order of which the changes are applied.