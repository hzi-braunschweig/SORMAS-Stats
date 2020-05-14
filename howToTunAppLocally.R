
# load required packages
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")


if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(RColorBrewer)) install.packages("RColorBrewer", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(visNetwork)) install.packages("visNetwork", repos = "http://cran.us.r-project.org")
if(!require(extrafont)) install.packages("extrafont", repos = "http://cran.us.r-project.org")
if(!require(rpart)) install.packages("rpart", repos = "http://cran.us.r-project.org")


library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)

library(visNetwork)
library(ggplot2)
library(dplyr)
library(plotly)
library(extrafont)
library(rpart)
library(RColorBrewer)

###
mypath = "/home/bsi17/Dropbox/sormas_2020/sormasDevelopment/dashboardShiny/sormas/sormasApp"  
#mypath = "/media/bsi17/Transcend/sormas_export_2020-05-07"
setwd(mypath)
sep = ";"

#mypath = "/home/bsi17/Dropbox/sormas_2020/sormasDevelopment/dashboardShiny/sormas/sormasApp"  ## ununtu path
#setwd(mypath)
load("contRegionDist.RData")
load("nodeLineList.RData")
load("elist.RData")
load("siDat.RData")

load("dateTimeToDate.R")
load("import.multiple.csv.files.R")
load("importDataFrontEnd.R")
load("plotNet.R")
runApp()