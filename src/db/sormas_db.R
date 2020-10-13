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
# dbListTables(con)
return(con)
}

# mockup, write to DB later
do_writeback <- function(df,filename){
    f <- paste('/srv/output/',filename, sep="")
    saveRDS(df, file=f)
}