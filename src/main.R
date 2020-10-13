source('db/sormas_db.R') # convenient functions
source('epi-stats/covid_cases.R') # import all your stats functions here

con <- do_connect()

n <- epi_number_of_cases(con)
print(n)
do_writeback(n,'number_of_cases')