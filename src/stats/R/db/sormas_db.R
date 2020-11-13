library(DBI)
library(RPostgres)

do_connect <- function(db_name, user, pwd){
# Connect to postgres database
con <- dbConnect(
        RPostgres::Postgres(),
        dbname = db_name, 
        host = 'postgres',
        port = 5432,
        user = user,
        password = pwd
)
# dbListTables(con)
return(con)
}


db_send_and_setch <- function(con,query){
    res <- dbSendQuery(con, query)
    frame <- dbFetch(res)
    dbClearResult(res)
    return(frame)
}


do_writeback_cases_per_day <- function(stat_db, cases){
    RPostgres::dbSendQuery(
        stat_db, 
        "INSERT INTO cases_per_day (date, number) VALUES ($1,$2);",
        list(
            cases$date,
            cases$count
        )
    )
}