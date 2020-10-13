# This is just an example

epi_number_of_cases <- function(con){
    # fetch all results:
    res <- dbSendQuery(con, "SELECT COUNT(*) FROM cases WHERE disease = 'CORONAVIRUS';")
    frame <- dbFetch(res)
    dbClearResult(res)
    return(frame)
}