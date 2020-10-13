source('db/sormas_db.R')

con <- do_connect()

dbListTables(con)