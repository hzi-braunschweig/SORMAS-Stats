# This is just an example

epi_number_of_cases_per_day <- function(sormas_db){

    start <- as.Date(Sys.time() - as.difftime(7, unit="days"), format="%Y-%m-%d")
    end   <- as.Date(Sys.time(), format="%Y-%m-%d")
    cur <- start
    
    while (cur <= end)
    {
        d_str <- format(cur,"%Y-%m-%d")
        cases <- number_of_cases_per_day(sormas_db, d_str)
        print(cases)
        
        do_writeback_cases_per_day(stats_db, cases)
        cur <- cur + 1                    
    }
}


number_of_cases_per_day <- function(con, date){
    res <- dbSendQuery(con, 
    "SELECT reportdate::date AS date, COUNT(id) from cases WHERE disease = 'CORONAVIRUS' AND reportdate::date = CAST($1 AS DATE) GROUP BY date;"
    )
    dbBind(res, list(date))
    frame <- dbFetch(res)
    dbClearResult(res)
    return(frame)
}