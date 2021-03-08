source('network_contact.R')
source('sormas_db.R')
library('dplyr')

db <- do_connect('sormas', 'sormas_user', 'password')
net <- contact_network(db)
net