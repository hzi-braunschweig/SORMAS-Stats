#' Connects to a PostgreSQL DB
#'
#' @param db_host The name of the DB host
#' @param db_name The name of the database
#' @param user The name of the database
#' @param pwd The name of the database
#' @return A connection to the DB
#' @export
do_connect <- function(host, db_name, user, pwd) {
  # Connect to postgres database

  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = db_name,
    host = host,
    port = 5432,
    user = user,
    password = pwd
  )

  return(con)
}
