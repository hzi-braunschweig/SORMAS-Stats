library(here)
dr_here()
library(DBI)
library(RPostgres)

source(here('R/env_setup.R'))

sormas_db <- do_connect('sormas', 'sormas_reader', 'password')
stats_db <- do_connect('sormas_stats', 'stats_user', 'password')
epi_number_of_cases_per_day(sormas_db)