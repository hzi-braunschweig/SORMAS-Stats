source('/srv/src/R/db/sormas_db.R') # convenient functions
source('/srv/src/R/epi-stats/covid_cases.R') # import all your stats functions here
source('/srv/src/R/utils/case_export.R')

sormas_db <- do_connect('sormas', 'sormas_reader', 'password')
stats_db <- do_connect('sormas_stats', 'stats_user', 'password')


exp = caseExport(sormas_db)
dbWriteTable(stats_db, "cases1", exp)