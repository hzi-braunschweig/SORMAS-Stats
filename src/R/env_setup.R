library(here)

library(DBI)
library(RPostgres)
library(dplyr)

source(here('R/db/sormas_db.R'))
source(here('R/epi-stats/covid_cases.R'))
source(here('R/export/contact_export.R'))
source(here('R/export/infector_infectee_export.R'))
source(here('R/network/contact_network.R'))
source(here('R/plotting/offspring_dist_plot.R'))
source(here('R/plotting/serial_interval_dist_plot.R'))
source(here('R/utils/fix_birth_data.R'))
source(here('R/utils/fix_contact_jurisdiction.R'))

sormas_db <- do_connect('sormas', 'sormas_reader', 'password')
stats_db <- do_connect('sormas_stats', 'stats_user', 'password')