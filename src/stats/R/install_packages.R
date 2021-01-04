local(
{
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.r-project.org"
  options(repos = r)
}
)
# FIXME(@JonasCir) dplyr is to old in Debian repo
install.packages(c("RPostgres", "here", "dplyr"))
