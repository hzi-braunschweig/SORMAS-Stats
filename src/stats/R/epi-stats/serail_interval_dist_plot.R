# This function  take as input the infector-infectee data loaded in working directory and generate the disstribution and estimates of the
# serial interval as specified by issue https://github.com/hzi-braunschweig/SORMAS-Stats/issues/92

#Dependencies that should be loaded before calling the serialIntervalPlot function
# DB_USER = "sormas_user"; DB_PASS = "password"; DB_HOST = "127.0.0.1"; DB_PORT = "5432"; DB_NAME= "sormas"
# library(RPostgreSQL)
# library(DBI)
# library(lubridate)
# library(dplyr)
# library(tidyverse)
# library(fitdistrplus) # require by serialIntervalPlot to estimate CI by bootstrap
# sormas_db = dbConnect(PostgreSQL(), user=DB_USER,  dbname=DB_NAME, password = DB_PASS, host=DB_HOST, port=DB_PORT) # should be replaced when doin gpull request
# load("fixBirthDate.R") # to load this method
# load("infectorInfecteeExport.R")
# infectorInfecteePair = infectorInfecteeExport(sormas_db = sormas_db)

# Main functions 
#serialIntervalPlot = function(infectorInfecteePair, minSi = NA, maxSi = NA) {  
serialIntervalPlot = function(infectorInfecteePair, minSi = NULL, maxSi = NULL){  
  # minSi and maxSi are the min and max user specified values of si to be used for the analysis
  # fiting a normal distribution to serial intervals 
  # filtering based on user specified min and max values of serial interval.
  if(any(is.null(c(minSi, maxSi)))) {
    minSi = min(infectorInfecteePair$serial_interval, na.rm = T)
    maxSi = max(infectorInfecteePair$serial_interval, na.rm = T)
  }
  siVector = c(minSi: maxSi)
  selData <- infectorInfecteePair %>%
    dplyr::filter(serial_interval != 'NA' & serial_interval %in% siVector)

  fit  = selData %>%
    dplyr::pull(serial_interval) %>% # extracting si
    fitdistrplus::fitdist(data = ., distr = 'norm')  # fiting a normal distribution to the data
  
  # Estimating CI for mean and standard deviation by bootstrap method 
  #  1001 were used by default for bootstraping, Add a parameter for this at front end later if needed
  fit_boot <- summary(fitdistrplus::bootdist(fit))  
  
  # extracting estimates
  siEstmate = dplyr::bind_cols(data.frame(fit$estimate), data.frame(fit_boot$CI) ) # extracting estimates and CI as a data frame
  colnames(siEstmate) = c("Estimate", "Median", "2.5% CI", "97.5% CI")
  siEstmate = round(siEstmate, 2)
  
  #Plotting 
  siDistributionPlot = ggplot(data = selData) +
    geom_histogram(aes(x = serial_interval, y = ..density..), fill = '#dedede', colour = "black", binwidth = 1) +
    stat_function(fun = dnorm, args = list(mean = fit$estimate[[1]], sd = fit$estimate[[2]]), size = 0.8, linetype = 2) +
    scale_x_continuous("Serial Interval (Days)", limits = c(minSi-2,maxSi+2), breaks = seq(minSi-2,maxSi+2, by =5), expand = c(0,0)) +
    scale_y_continuous("Proportion", expand = c(0,0)) +
    theme_classic() +
    theme(aspect.ratio = 1)
  return(list(siEstmate = siEstmate, siDistributionPlot = siDistributionPlot)) # return a list object: table of estimates and image
}
#Function call
# siRet = serialIntervalPlot(infectorInfecteePair = infectorInfecteePair, minSi = NULL, maxSi = NULL) # minSi = 0, maxSi = 20
# siRet = serialIntervalPlot(infectorInfecteePair = infectorInfecteePair, minSi = 0, maxSi = 20)
# print(siRet$siDistributionPlot) # to visualize plot, siDistributionPlot is of class ggplot thus can be rendered as a figure
# print(siRet$siEstmate) # to visualize table of estimate. siEstmate is of class data.frame, thus can be rendered as a table.

