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

  return(con)
}
