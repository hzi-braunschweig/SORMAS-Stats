# 
# if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
# if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
# if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
# if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
# 
# 
# if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
# if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
# if(!require(RColorBrewer)) install.packages("RColorBrewer", repos = "http://cran.us.r-project.org")
# if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
# if(!require(visNetwork)) install.packages("visNetwork", repos = "http://cran.us.r-project.org")
# if(!require(extrafont)) install.packages("extrafont", repos = "http://cran.us.r-project.org")
# if(!require(rpart)) install.packages("rpart", repos = "http://cran.us.r-project.org")
# if(!require(ggthemes)) install.packages("ggthemes", repos = "http://cran.us.r-project.org")
# if(!require(lubridate)) install.packages("lubridate", repos = "http://cran.us.r-project.org")
# if(!require(Hmisc)) install.packages("Hmisc", repos = "http://cran.us.r-project.org")
# if(!require(gdata)) install.packages("gdata", repos = "http://cran.us.r-project.org")
# if(!require(scales)) install.packages("scales", repos = "http://cran.us.r-project.org")
# if(!require(EpiEstim)) install_github("annecori/EpiEstim", force = TRUE)
# if(!require(incidence))  install.packages("incidence",  repos = "http://cran.us.r-project.org")
# if(!require(tidyr))  install.packages("tidyr",  repos = "http://cran.us.r-project.org")


#if(!require(XML2)) install.packages("XML2", repos = "http://cran.us.r-project.org")
#if(!require(reshape2)) install.packages("reshape2", repos = "http://cran.us.r-project.org")

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
library(webshot) # for plot export
library(ggthemes)
library(lubridate)
library(Hmisc)
library(gdata)
library(scales)
library(EpiEstim)
library(incidence)
library(tidyr)

###
####### function to plot maps ############""
# For linux system, before installing rgdal, you need to install the following 2 packages
# sudo apt-get update
# sudo apt-get install libgdal-dev libproj-dev
# link to install other packaged like sf for linux users
# https://geocompr.github.io/post/2020/installing-r-spatial-ubuntu/
# isntalling tmaptools from github    devtools::install_github("r-spatial/lwgeom"), afterr running this command, isntall lwgeom and latter tmaptools
# install.packages("XML", repos = "http://www.omegahat.net/R")  # to install xml on linux
#install.packages("tamp")
# install.packages("rgdal")

library(rgdal)
library(maps)
library(maptools)
library(mapdata)
library(ggplot2)
library(RColorBrewer)
library(foreign)    
library(sp)
library(broom)

library(ggmap)
library(rgeos)
library(tmap)
#library(sf)
library(lattice)
library(RPostgreSQL)

#specifying the path
#mypath = "/media/bsi17/Transcend/sormas_export_2020-08-05" # set this to the working directory of the server.R file

#mypath = "/home/bsi17/Dropbox/sormas_2020/sormasDevelopment/dashboardShiny/sormas/sormasApp" # this is the folder specified from ui containig all the data needed by app
#sep = ";"
#setwd(mypath)

## loading functions needed  #####

# loading functions needed ###
#load(file.path("./utils", "dateTimeToDate.R"))

load("importingData.R")
load("dateTimeToDate.R")
load("import.multiple.csv.files.R")
load("plotNet.R")
load("mergingData.R")
load("mergingDataFromDB.R")
load("contIdsForSingleChain.R")

## Functions for case data analysis
load("ImportingUnformatedDataFromDB.R")
load("pyramidPlotFunction.R")
load("timeSeriesPlotDay.R")
load("timeSeriesPlotWeek.R")
load("timeSeriesPlotMonth.R")
load("timeSeriesPlotDayRegion.R")
load("epicurveDate.R")
load("epicurveMonth.R")
load("regionMapPlot.R")
load("districtMapPlot.R")
load("RtPlot.R")

## loading data #####
# dataListImprted = importingData(mypath = mypath, sep = sep)   # ## This is needed only when loading data exported from front end of sormas. 
# importDataFrontEndOutput = mergingData(dataList = dataListImprted)
# To read data from postgres, use this code. Connection to db is brokem immediately function is done reading data
importDataFrontEndOutput = mergingDataFromDB(DB_USER = "sormas_user", DB_PASS = "password", DB_HOST = "127.0.0.1", DB_PORT = "5432", DB_NAME= "sormas")

contRegionDist = importDataFrontEndOutput$contRegionDist
nodeLineList = importDataFrontEndOutput$nodeLineList  # id here is person id
elist = importDataFrontEndOutput$elist  # id here is contact id
siDat = importDataFrontEndOutput$siDat

##loading and cleaning shap files. This cleaning will depend on the country and the source of teh shap file, thus codes nedd to be adjusted in this section.
# lnd <- rgdal::readOGR(dsn = "Shapefiles", layer = "State_Aug28")
  districtShapes <- rgdal::readOGR(dsn = "Shapefiles", layer = "LGAs_Aug28")

# renaming region names to match shapfiles, do this for all names that are not the same
# lnd@data$StateName = as.character(lnd@data$StateName)
# lnd@data$StateName[lnd@data$StateName == "Fct, Abuja"] = "FCT"
# lnd@data$StateName[lnd@data$StateName == "Akwa Ibom"] = "Akwa-Ibom"
# need to later chechk that all districtd names in db are the same as in shap file, if not remane shap file usint this format and logic

regionShapes <- rgdal::readOGR(dsn = "Shapefiles", layer = "State_Aug28") 
# renaming region names to match shapfiles, do this for all names that are not the same
regionShapes@data$StateName = as.character(regionShapes@data$StateName)
regionShapes@data$StateName[regionShapes@data$StateName == "Fct, Abuja"] = "FCT"
regionShapes@data$StateName[regionShapes@data$StateName == "Akwa Ibom"] = "Akwa-Ibom"





#################################################################################################"
#################### CASE DATA management  #####


# case data cleaning and merging

#dataListImprted = importingData(mypath = mypath, sep = sep)
## reading raw data
dataCombined = ImportingUnformatedDataFromDB(DB_USER = "sormas_user", DB_PASS = "password", DB_HOST = "127.0.0.1", DB_PORT = "5432", DB_NAME= "sormas")

# case = dataCombined$case
# person = dataCombined$person
#region = dataCombined$region
#district = dataCombined$district

# cleaning case data
# case$creationdate = dateTimeToDate(case$creationdate)
# case$reportdate = dateTimeToDate(case$reportdate)
# case$caseclassification = as.character(case$caseclassification)

# caseVar=c("id","disease","reportdate","creationdate",  "person_id","region_id","district_id", "caseclassification", "outcome",
#           "epidnumber", "symptoms_id", "healthfacility_id", "outcome", "caseorigin", "quarantine" )
# case = case[case$deleted == "f", colnames(case) %in% caseVar]
# case = case[case$caseclassification != "NO_CASE", ]
# case = case %>% rename(case_id = id )


#cleaning person table  
person = dataCombined$person
#person$birthDate = as.Date(with(person, paste(birthdate_yyyy, birthdate_mm, birthdate_dd, sep = "-")), format = "%Y/%m/%d")
perTemp = person[is.na(person$birthdate_yyyy) == F, ]
perTemp2 = person[is.na(person$birthdate_yyyy) == T, ]

dm = rep(1,nrow(perTemp))
perTemp$birthDate = as.Date(with(perTemp, paste(birthdate_yyyy, dm, dm, sep = "-")))
perTemp2$birthDate = rep(NA,nrow(perTemp2)) 
person = rbind(perTemp, perTemp2)


personVar=c( "person_id", "sex","occupationtype","presentcondition", "birthDate")  # "approximateage","approximateagetype", "birthdate_dd", "birthdate_mm", "birthdate_yyyy"
person = person[, colnames(person) %in% personVar]
# person = person %>% rename(person_id = id)
#df <- subset(df, select = -c(a, c))

## mergig case and person table
casePerson = merge(dataCombined$case , person, by=  "person_id",  all.x = T, all.y = F ) # to ge the casevaraibles of contacts. Contacts that
# calculating age at point that the person was a case
casePerson$age = as.numeric(round((casePerson$reportdate - casePerson$birthDate)/365))

# merging casePerson with region
# region = region[, colnames(region) %in% c("id", "name" )]
# region = region %>% rename(region_id = id, region_name = name)

casePersonRegion = merge(casePerson, dataCombined$region, by = "region_id", all.x = T, all.y = F)
#casePersonRegion$region_name = as.character(casePersonRegion$region_name)

## Adding week, monthe year  as individual colums using date of report
casePersonRegion = casePersonRegion[casePersonRegion$reportdate > as.Date("2017-05-01"),] # deleting cases with date errors 

casePersonRegion$total = rep(1, nrow(casePersonRegion))
casePersonRegion$reportweek = week(casePersonRegion$reportdate)
casePersonRegion$reportmonth = month(casePersonRegion$reportdate)
casePersonRegion$reportyear = year(casePersonRegion$reportdate)
casePersonRegion$total = rep(1, nrow(casePersonRegion))

### merging casePersonRegion with district  ##
#districts = districts[, colnames(districts) %in% c("id", "name" )]
#districts = districts %>% rename(district_id = id, district_name = name)

casePersonRegionDist = merge(casePersonRegion, dataCombined$district, by = "district_id", all.x = T, all.y = F)
#casePersonRegionDist$district_name = as.character(casePersonRegionDist$district_name)

#### End of data management ###########

colCase = "red" # colour to use for back groun of infoBox for cases
colEvent = "green"

# server function
shinyServer(
  function(input, output,session) {
    ### loading data ####
    ### importing data
    
    # if(is.na(input$reference_files) !=F )
    # {
    #     dataListImprted <- reactive({
    #         req(input$reference_files)
    #         mypath <- input$reference_files$datapath
    #         dataList = import.multiple.csv.files(mypath = mypath, mypattern = ".csv$", sep = ";")
    #         return(dataList)
    #     })
    #     
    #     importDataFrontEndOutput = reactive({
    #         mergingData(dataList = dataListImprted() )
    #     }) 
    #     contRegionDist = reactive({
    #         importDataFrontEndOutput()$contRegionDist
    #     }) 
    #     nodeLineList = reactive({
    #         importDataFrontEndOutput()$nodeLineList
    #     }) 
    #     elist = reactive({
    #         importDataFrontEndOutput()$elist
    #     }) 
    #     siDat = reactive({
    #         importDataFrontEndOutput()$siDat
    #     })  
    # }
    
    ######################################
    ## Calling  
    
    
    
    ###################    
    # d render contact table based on region district time and disease
    d = reactive({ 
      if(input$regionUi == "All regions")
      {
        contRegionDist[((contRegionDist$disease == input$diseaseUi) & (contRegionDist$reportdatetime >= (min(input$reportdateUi))) & (contRegionDist$reportdatetime <= (max(input$reportdateUi)) )), ] 
      } else{
        contRegionDist[((contRegionDist$region_name == input$regionUi) & (contRegionDist$disease == input$diseaseUi) & (contRegionDist$reportdatetime >= (min(input$reportdateUi) )  ) & (contRegionDist$reportdatetime <= (max(input$reportdateUi) ))),]
      }
      
    })
    
    ## Bar plot
    output$plot <- renderPlot({ 
      if(nrow(d( ) ) == 0)
      { 
        plot(NULL, xlim=c(0,1), ylim=c(0,1), ylab="Number of contacts", xlab=" ",
             main = "No data exist based on your selection, please choose another selection for which data exist")
      }else{
        if(input$regionUi == "All regions" )
        {
          par(las=2, mar=c(7,4,4,2)) # make label text perpendicular to axis
          barplot (table(as.factor(d( )$region_name)), ylab = "Number of contacts",main = "Bar plot for number of contacts")
        } else {
          par(las=2, mar=c(7,4,4,2)) # make label text perpendicular to axis
          barplot (table(as.factor(d( )$district_name)), ylab = "Number of contacts",main = "Bar plot for number of contacts")
        }
      }
    }, height=700)
    
    ## exporting bar plot
    output$downloadBarplot = downloadHandler(
      filename = function(){
        paste("barPlotContacts", "png", sep = ".")
      },
      content = function(file){
        png(file)
        ##
          if(input$regionUi == "All regions" )
          {
            par(las=2, mar=c(7,4,4,2)) # make label text perpendicular to axis
            barplot (table(as.factor(d( )$region_name)), ylab = "Number of contacts",main = "Bar plot for number of contacts")
          } else {
            par(las=2, mar=c(7,4,4,2)) # make label text perpendicular to axis
            barplot (table(as.factor(d( )$district_name)), ylab = "Number of contacts",main = "Bar plot for number of contacts")
          }
        ##
        dev.off()
      }
    )
    
    
    
    
    ### Begining of  KPI ###########
    #Row 1,  All contacts, used d
    output$allCont <- renderInfoBox({
      infoBox(
        "All contacts", nrow(d( )), icon = icon("handshake"),
        color = "blue", fill = TRUE
      )
    })
    
    # confrimed contacts
    output$contConfirmed = renderInfoBox({ 
      temp = d()
      temp = temp[temp$contactclassification == "CONFIRMED" ,]
      infoBox("Confirmed", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    }) 
    # Uncofirmed contacts
    output$contUnconfirmed = renderInfoBox({ 
      temp = d()[d()$contactclassification == "UNCONFIRMED" ,] 
      infoBox("Unconfirmed", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    }) 
    # Not a contact contacts
    output$contNot = renderInfoBox({ 
      temp =  d()[d()$contactclassification == "NO_CONTACT" ,] 
      infoBox("Discarded", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    }) 
    
    #### Row 2  contact status ####
    ## Active contacts
    output$activeCont = renderInfoBox({ 
      temp = d()[d()$contactstatus == "ACTIVE" ,] 
      infoBox("Active", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
      }) 
    ## converted to case
    output$convertedToCase = renderInfoBox({ 
      temp =  d()[d()$contactstatus == "CONVERTED" ,]
      infoBox("Converted to case", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
      
    })
    ## dropped contacts
    output$dropped = renderInfoBox({ 
     temp =   d()[d()$contactstatus == "DROPPED" ,] 
     infoBox("Dropped", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
     )
    })
    ## inactive
    output$inactiveCont = renderInfoBox({ 
      temp =  d()[d()$contactstatus == "INACTIVE",] 
      infoBox("Inactive", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    })
    
    #### Row 3 contact followup status ####
    ## under FU
    output$ongoingFollowupContact = renderInfoBox({ 
      temp =  d()[d()$followupstatus == "FOLLOW_UP" ,] 
      infoBox("Ongoing-FU", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    }) 
    ## Overdue followup/  not converted to case (this indicator should be updated when the new contact categories are intriduced) 
    output$overdueFU = renderInfoBox({ 
      temp =  d()[d()$followupstatus == "NO_FOLLOW_UP" ,] # will later add the category of overdue fillow up and delete no_followup.
      infoBox("Overdue-FU", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    })
    ## stopped followup
    output$stoppedFUContact = renderInfoBox({ 
      temp =  d()[d()$followupstatus == "CANCELED_FOLLOW_UP" ,]
      infoBox("Stopped-FU", nrow(temp), icon = icon("handshake"), color = "blue", fill = TRUE
      )
    }) 
    # ## lost to followup
    # output$lostToFU = renderText({ 
    #   nrow( d()[d()$followupstatus == "LOST" ,] )
    # })
    
    ### Row 4, summary of number of contacts per case 
    p = reactive({ 
      data.frame(as.table(summary(as.factor(d()$caze_id), maxsum = 5000000)))
    })
    # Use p()$Freq
    ## min contact per case
    output$minConPerCase = renderInfoBox({ 
      infoBox("Minimum",   min(p()$Freq) , icon = icon("handshake"), color = "blue", fill = TRUE
      )
    })
    
    ## median contacte per case
    output$medianConPerCase = renderInfoBox({ 
      infoBox("Median", median(p()$Freq) , icon = icon("handshake"), color = "blue", fill = TRUE
      )
    })
   ## mean contact per case 
    output$meanConPerCase = renderInfoBox({ 
      infoBox("Mean",  mean(p()$Freq)  , icon = icon("handshake"), color = "blue", fill = TRUE
      )
    })
    ## max contacte per case
    output$maxConPerCase = renderInfoBox({ 
     
      infoBox("Maximum",  max(p()$Freq)   , icon = icon("handshake"), color = "blue", fill = TRUE
      )
    })
    
   ##### beginning of case KPI #############
 
  
    
    ##########  end of case KPI #################""  
    
  ### event kpi ####

    ### Contacts per case ####
    minLim = reactive({
      c( min(p()$Freq), max(p()$Freq)+20)
    })
    
    output$plotContPerCase <- renderPlot({ 
      if(nrow(d( ) ) == 0)
      { 
        plot(NULL, xlim=c(0,1), ylim=c(0,1), ylab="Number of contacts", xlab=" ",
             main = "No data exist based on your selection, please choose another selection for which data exist")
      }else{
        #summary(p$Freq)
        par(mar=c(5,4,4,1), mfrow = c(1,2))
        hist(p()$Freq, breaks = 50,  xlim = minLim(), col = "grey", main = "Histogram of number of contacts per case", xlab = "Number of contacts per case")
        plot(sort(p()$Freq), col="black", cex=1, pch=16, xlab = "Case index", ylab = "Number of contacts",
             main = "Number of contacts per case")
      }
    }, height=700)
    
    ## exporting contact per case plot
    output$downloadContPerCasePlot = downloadHandler(
      filename = function(){
        paste("contactPerCasePlot", "png", sep = ".")
      },
      content = function(file){
        png(file)
        ##
        par(mar=c(5,4,4,1), mfrow = c(1,2))
        hist(p()$Freq, breaks = 50,  xlim = minLim(), col = "grey", main = "Histogram of number of contacts per case", xlab = "Number of contacts per case")
        plot(sort(p()$Freq), col="black", cex=1, pch=16, xlab = "Case index", ylab = "Number of contacts",
             main = "Number of contacts per case")
        ##
        dev.off()
      }
    )
    
    
    
    
    
    
    ## serial interval
    #selecting siDat baed on disease, time; regiion and district just as in d 
    siD = reactive({ 
      if(input$regionUi == "All regions")
      {
        siDat[((siDat$disease == input$diseaseUi) & (siDat$reportdatetime >= (min(input$reportdateUi))) & (siDat$reportdatetime <= (max(input$reportdateUi)) )), ] 
      } else{
        siDat[((siDat$region_name == input$regionUi) & (siDat$disease == input$diseaseUi) & (siDat$reportdatetime >= (min(input$reportdateUi) )  ) & (siDat$reportdatetime <= (max(input$reportdateUi) ))),]
      }
    })
    
    output$siHist <- renderPlot({
      if(nrow(siD( ) ) == 0)
      { 
        plot(NULL, xlim=c(0,1), ylim=c(0,1), xlab="Time to secondary onset (days)", ylab="Frequency",
             main = "No data exist based on your selection, please choose another selection for which data exist")
      }else{
        par(las=1, mar=c(7,4,4,2)) # make label text perpendicular to axis
        hist(siD()$si, col = "grey", border = "white", nclass = 30, xlab = "Time to secondary onset (days)", 
             main = "Distribution of the serial interval")
      }}, height=700)
    
    output$si <- renderPrint({
      if(nrow(siD( ) ) == 0)
      { 
        print("No data exist based on your selection, please choose another selection for which data exist")
      }else{ 
        
        summary(siD()$si)
      }
    })
  
    ### 
    ## exporting serial interval plot
    output$downloadSerialIntervalPlot = downloadHandler(
      filename = function(){
        paste("serialIntervelPlot", "png", sep = ".")
      },
      content = function(file){
        png(file)
        ##
        par(las=1, mar=c(7,4,4,2)) # make label text perpendicular to axis
        hist(siD()$si, col = "grey", border = "white", nclass = 30, xlab = "Time to secondary onset (days)", 
             main = "Distribution of the serial interval")
        ##
        dev.off()
      }
    )
    
    
    
    ###### Trasmission chain ######################################
    
    ########################## Nework option 2 code #############"""
    
    # plotting network
    ## Filter elist by region, district, disease, time, etc
    selElistUI = reactive({ 
      if(input$regionUi == "All regions")
      {
        as.numeric(elist[((elist$disease == input$diseaseUi) & (elist$reportdatetime >= (min(input$reportdateUi))) & (elist$reportdatetime <= (max(input$reportdateUi)) )), colnames(elist) == "id" ]) 
      } else{
        as.numeric(elist[((elist$region_name == input$regionUi) & (elist$disease == input$diseaseUi) & (elist$reportdatetime >= (min(input$reportdateUi) )  ) & (elist$reportdatetime <= (max(input$reportdateUi) ))),  colnames(elist) == "id"])
      }
    })
    
    # pltting network using selElist 
    
    output$transChain <- renderVisNetwork({
      elistSel <- elist[elist$id %in% selElistUI(), ]
      #Filter elist based on resulting cases varaible
      if(input$resultingCaseOnlyUi == FALSE){
        elistSel2ResCase = elistSel
      } else{
        elistSel2ResCase =  elistSel[is.na(elistSel$resultingcase_id) == FALSE,]
      }
      
      #Filter elistSel2ResCase based on source case ID
      
      if( is.na(input$visSingleChainUi) == T){
        elistSel2ResCaseSourseCase <- elistSel2ResCase
      } else{
        contIdTemp = contIdsForSingleChain(elist =  elistSel2ResCase, id = input$visSingleChainUi) # retain list of contact ids
        elistSel2ResCaseSourseCase = elistSel2ResCase[elistSel2ResCase$id %in% contIdTemp,]
      }
      
      #filtering node that corresponde to the final elist filter using  node ID
      # nodeLineListSelResCase <- reactive({
      #   nodeLineListSel()[nodeLineListSel()$id %in% unique(c(elistSel2ResCaseSourseCase()$from, elistSel2ResCaseSourseCase()$to)), ]
      # })
      nodeLineListSelResCase <- nodeLineList[nodeLineList$id %in% unique(c(elistSel2ResCaseSourseCase$from, elistSel2ResCaseSourseCase$to)), ]
      
      plotNet(nodeLineList= nodeLineListSelResCase, elist = elistSel2ResCaseSourseCase)
    })
    
    ############################### 
    # Generate a summary of the data ----
    output$tableCount <- renderPrint({
      #summary(as.factor(d( )) )
      if(input$regionUi == "All regions")
      { 
        as.table(summary(apply( d( )[, colnames(d( )) %in% c("contactstatus","followupstatus", "contactproximity","contactclassification", "caseclassificationCase", "region_name", "outcomeCase")], 2, as.factor ),  maxsum = 50000 ) )
      } else{
        as.table(summary(apply( d( )[, colnames(d( )) %in% c("contactstatus","followupstatus","contactproximity","contactclassification", "caseclassificationCase", "region_name", "district_name", "outcomeCase")], 2, as.factor ), maxsum = 500000 ) )
      }
    })
    
    # Begin exportation of  data 
    # cotactRegionDist export
    conRegionDistExp = reactive({
      data.frame(contactReportDate =as.character( d()$reportdatetime),  caseID= d()$caze_id, contactID =  d()$id, contactProximity = d()$contactproximity, contactClassification = d()$contactclassification,
                 caseClassification = d()$caseclassificationCase, disease = d()$disease, caseOutcome = d()$outcomeCase, contactRegion = d()$region_name,
                 contactDistrict = d()$district_name) 
    }) 
    # output to download data
    output$conRegionDistExpCsv <- downloadHandler(
      filename = function() {
        paste("sormas_export_", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(conRegionDistExp(), file)
      }
    )
    output$conRegionDistExpTable <- renderPrint({
      orig <- options(width = 1000)
      # print(tail(cv_cases %>% select(c(country, date, cases, new_cases, deaths, new_deaths,
      #                                  recovered, new_recovered, active_cases, 
      #                                  per100k, newper100k, activeper100k, deathsper100k, newdeathsper100k)), input$maxrows), row.names = FALSE)
      print(head(conRegionDistExp(), input$maxrows), row.names = FALSE)
      options(orig)
    })
    
    
    ### Number of contacts per case exprt
    # use p()
    conPerCaseExp = reactive({
      p() %>% rename(Case_id = Var1, Nunber_of_contacts = Freq )
    }) 
    
    output$conPerCaseExpCsv <- downloadHandler(
      filename = function() {
        paste("sormas_contactPerCaseExp_", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(conPerCaseExp(), file)
      }
    )
    output$conPerCaseExpTable <- renderPrint({
      orig <- options(width = 1000)
      print(head(conPerCaseExp(), input$maxrows), row.names = FALSE)
      options(orig)
    })
    
    
    
    
    ## Serail interval
    # use siD()
    siExp = reactive({
      #p() %>% rename(Case_id = Var1, Nunber_of_contacts = Freq )
      siD() %>% rename(Contact_report_date = reportdatetime, Disease = disease, Contact_region = region_name, Contact_district = district_name, Serial_interval = si)
    }) 
    
    output$siExpCsv <- downloadHandler(
      filename = function() {
        paste("sormas_serialIntervalExp_", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(siExp(), file)
      }
    )
    output$siExpTable <- renderPrint({
      orig <- options(width = 1000)
      print(head(siExp(), input$maxrows), row.names = FALSE)
      options(orig)
    })
    
    # use d()
    conPerGerionExp = reactive({
      temp =  data.frame(table(as.factor(d( )$region_name)))
      colnames(temp) = c("Region_name", "Number_of_Contacts")
      temp = temp[order(temp$Number_of_Contacts, decreasing = T), ]
      return(temp)
    }) 
    
    output$conPerGerionExpCsv <- downloadHandler(
      filename = function() {
        paste("sormas_conPerGerionExp_", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(conPerGerionExp(), file)
      }
    )
    output$conPerGerionExpTable <- renderPrint({
      orig <- options(width = 1000)
      print(head(conPerGerionExp(), input$maxrows), row.names = FALSE)
      options(orig)
    })
 
  ## end exportation of data    
    
  ####################################################"
  #### CASE DATA ANALYSIS  #################
   
    # Filtering casepersonRegion
    casePersonFilter = reactive({ 
      if(input$regionUi == "All regions")
      {
        casePersonRegionDist[((casePersonRegionDist$disease == input$diseaseUi) & (casePersonRegionDist$reportdate >= (min(input$reportdateUi))) & (casePersonRegionDist$reportdate <= (max(input$reportdateUi)) )), ] 
      } else{
        casePersonRegionDist[((casePersonRegionDist$region_name == input$regionUi) & (casePersonRegionDist$disease == input$diseaseUi) & (casePersonRegionDist$reportdate >= (min(input$reportdateUi) )  ) & (casePersonRegionDist$reportdate <= (max(input$reportdateUi) ))),]
      }
      
    })
    
    ## plotting case pyramid ########
    output$casePyramidPlot <- renderPlotly({
      temp = casePersonFilter()
      print(
        ggplotly(
          pyramidPlotFunction(data = temp)
        ))
    })
    
   #### Plotting time series plot for cases ###
    output$caseTimeSeriesPlot <- renderPlotly({
      temp = casePersonFilter()

      if (input$timeUnitUi == "Day")
      {
        if(input$byRegiontimeUnitUi == F)
        {
          dateSumCase = aggregate(total ~ reportdate, data = temp, sum, na.rm = F)
          fg=  timeSeriesPlotDay(data = dateSumCase, cum = input$cumUi )
          
        } else{
          dateSumCaseRegion = aggregate(total ~ reportdate + region_name, data = temp, sum, na.rm = F)
          #fg = timeSeriesPlotDayRegion(data = dateSumCaseRegion)
          fg = timeSeriesPlotDayRegion(data = dateSumCaseRegion, cum = input$cumRegionUi)
          
        }
        
      }
      if (input$timeUnitUi == "Epi-week")
      {
        weekSumCase = aggregate(total ~ reportweek+ reportyear, data = temp, sum, na.rm = F)
        fg=   timeSeriesPlotWeek(data = weekSumCase )
      }
      if (input$timeUnitUi == "Month")
      {
        monthSumCase = aggregate(total ~ reportmonth+ reportyear, data = temp, sum, na.rm = F)
        fg=  timeSeriesPlotMonth(data = monthSumCase )
      }
      return(fg)
      
    })
   ###
   
    ## Plotting epicurve
   
    output$caseEpicurvePlot <- renderPlotly({
      temp = casePersonFilter()
      if (input$timeUnitEpicurveUi == "Day")
      {
        dateSumCaseClass = aggregate(total ~ reportdate + caseclassification, data = temp, sum, na.rm = F)
        fg=  epicurveDate(data = dateSumCaseClass)
      }
      if (input$timeUnitEpicurveUi == "Epi-week")
      {
        # weekSumCase = aggregate(total ~ reportweek+ reportyear, data = temp, sum, na.rm = F)
        # fg=   timeSeriesPlotWeek(data = weekSumCase )
        dateSumCaseClass = aggregate(total ~ reportdate + caseclassification, data = temp, sum, na.rm = F)
        fg=  epicurveDate(data = dateSumCaseClass)
      }
      if (input$timeUnitEpicurveUi == "Month")
      {
        # monthSumCase = aggregate(total ~ reportmonth+ reportyear, data = temp, sum, na.rm = F)
        # fg=  timeSeriesPlotMonth(data = monthSumCase )
        fg =   epicurveMonth(data = temp)
      }
      return(fg)
    })
    
    ### Maps of cases ####
    ## map plot
    output$regionMapCaseCount <- renderPlot({
      if(input$caseMapshapesUi == "By region")
      {
        fg = regionMapPlot(data = casePersonFilter(), lnd = regionShapes)
      }
      if(input$caseMapshapesUi == "By district")
      {
        fg = districtMapPlot(data = casePersonFilter(), districtShapes =districtShapes)
      }
      return(fg)
    })
    
    ## plotting Rt 
    # using casePersonFilter() and siD()
    output$rtPlot <- renderPlot({
      dateSumCase = aggregate(total ~ reportdate, data = casePersonFilter(), sum, na.rm = F)
      # completting missing dates
      dateSumCase =  dateSumCase %>%
        dplyr::mutate(Date = as.Date(reportdate)) %>%
        tidyr::complete(Date = seq.Date(min(Date), max(Date), by="day"), fill = list(total = 0))
      dateSumCase = dateSumCase[,c(1,3)] # dropping old ulcompletted date
      colnames(dateSumCase) = c("dates","I")
      
      temp = siD()
      temp = temp[temp$si > 0,]  # deleting pairs with si = 0, this is needed for downtream analysis
      n = nrow(temp)
      si_data = data.frame(matrix(0,n,5))
      si_data[,2] = 1
      si_data[,3] = c(temp$si -1)
      si_data[,4] = temp$si
      colnames(si_data) =  c("EL", "ER", "SL", "SR", "type")
      si_data[,-5] = apply(si_data[,-5], 2, as.integer) # all columns except type should be integer
      
      if(input$rtMethodUi == "Parametric-Gamma"){
        fig = RtPlot(mean_si = 5.2, std_si = 2.3, method = "parametric_si",  burnin = 1000, dateSumCase = dateSumCase, si_data = si_data, rsi = input$rsiUi) # method = "parametric_si" or "si_from_data"; rsi = "all", "R", "SI"
      }
      if(input$rtMethodUi == "Transmission data" ){
        fig =  RtPlot(dateSumCase = dateSumCase, method = "si_from_data",  burnin = 1000,  si_data = si_data, rsi = input$rsiUi) # method = "parametric_si" or "si_from_data"; rsi = "all", "R", "SI"
      }
      return(fig)

    })
    
    
    
    
    
  }
)

