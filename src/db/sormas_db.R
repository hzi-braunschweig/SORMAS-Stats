library(DBI)

do_connect <- function(){
# Connect to postgres database
con <- dbConnect(
        RPostgres::Postgres(),
        dbname = 'sormas', 
        host = 'postgres',
        port = 5432,
        user = 'postgres',
        password = 'password'
)
 return(con)
}