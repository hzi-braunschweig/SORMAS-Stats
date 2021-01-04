library(DBI)
library(RPostgres)
# todo remove from main?

do_connect <- function(db_name, user, pwd) {
  # Connect to postgres database

  host <- Sys.getenv('DB_HOST')

  if (host == '') {
    host <- 'localhost'
  }

  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = db_name,
    host = host,
    port = 5432,
    user = user,
    password = pwd
  )
  # dbListTables(con)
  return(con)
}

do_writeback_cases_per_day <- function(stat_db, cases) {
  RPostgres::dbSendQuery(
    stat_db,
    "INSERT INTO cases_per_day (date, number) VALUES ($1,$2);",
    list(
      cases$date,
      cases$count
    )
  )
}