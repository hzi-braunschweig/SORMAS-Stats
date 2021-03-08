# Documentation

Documentation is done with [roxygen2](https://roxygen2.r-lib.org/articles/rd.html).

Created with `R -e 'library(roxygen2);roxygenise()'`.

## Install

`R -e 'install.packages("src/sormas_stats/stats/statistics/r_sormas_stats", repos = NULL, type = "source")'`

## Example Test Script

```R
library('RSormasStats')
con <- do_connect('sormas', 'postgres', 'password')
net <- contact_network(con)
```