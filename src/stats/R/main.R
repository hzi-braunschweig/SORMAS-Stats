source('/srv/src/R/db/sormas_db.R') # convenient functions
source('/srv/src/R/epi-stats/covid_cases.R') # import all your stats functions here

sormas_db <- do_connect('sormas', 'sormas_reader', 'password')
stats_db <- do_connect('sormas_stats', 'stats_user', 'password')

epi_number_of_cases_per_day(sormas_db)