source('db/sormas_db.R') # convenient functions
source('epi-stats/covid_cases.R') # import all your stats functions here

sormas_db <- do_connect('sormas', 'sormas_reader', 'password')
stats_db <- do_connect('sormas_stats', 'stats_user', 'password')

start <- as.Date(Sys.time() - as.difftime(7, unit="days"), format="%Y-%m-%d")
end   <- as.Date(Sys.time(), format="%Y-%m-%d")
cur <- start

while (cur <= end)
{
    d_str <- format(cur,"%Y-%m-%d")
    cases <- epi_number_of_cases_per_day(sormas_db, d_str)
    print(cases)

    do_writeback_cases_per_day(stats_db, cases)
    cur <- cur + 1                    
}



