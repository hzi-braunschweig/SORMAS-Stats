# This is just an example

epi_number_of_cases_per_day <- function(con, date){
    res <- dbSendQuery(con, 
    "SELECT reportdate::date AS date, COUNT(id) from cases WHERE disease = 'CORONAVIRUS' AND reportdate::date = CAST($1 AS DATE) GROUP BY date;"
    )
    dbBind(res, list(date))
    frame <- dbFetch(res)
    dbClearResult(res)
    return(frame)
}