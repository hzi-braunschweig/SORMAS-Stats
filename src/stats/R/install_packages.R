local(
    {
        r <- getOption("repos")
        r["CRAN"] <- "https://cran.r-project.org"
        options(repos=r)
    }
)

install.packages("RPostgres")
