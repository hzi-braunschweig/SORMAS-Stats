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
 library(shinyjs)



 library(visNetwork) 
 library(ggplot2)
 library(dplyr)
 library(plotly)
 library(extrafont)
 library(rpart)
 library(RColorBrewer)



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

# server function
shinyServer(function(input, output,session) {
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
    
  ## Contacts per case
    p = reactive({ 
      data.frame(as.table(summary(as.factor(d()$caze_id), maxsum = 5000000)))
      })
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
    
    # Trasmission chain
    ## defining reaxtivne functions for noted and edges
    elistSel <- reactive({ 
      elist[elist$id %in% d()$id, ]
      
      })
    
    nodedUniqueSel = reactive({
      unique(c(d()$person_id, d()$person_idCase ))
    })
    
    nodeLineListSel <- reactive({ 
      nodeLineList[nodeLineList$id %in% nodedUniqueSel() , ]  
      
    })
      output$transChain <- renderVisNetwork({ 
       if(nrow(d( ) ) != 0)
       { 
        plotNet(nodeLineList= nodeLineListSel(), elist = elistSel() )
    
      }
    
     })
   ############################### 
  # Generate a summary of the data ----
     output$tableCount <- renderPrint({
    #summary(as.factor(d( )) )
       if(input$regionUi == "All regions")
       { 
          as.table(summary(apply( d( )[, colnames(d( )) %in% c("contactproximity","contactclassification", "caseclassificationCase", "region_name", "outcomeCase")], 2, as.factor ),  maxsum = 50000 ) )
       } else{
         as.table(summary(apply( d( )[, colnames(d( )) %in% c("contactproximity","contactclassification", "caseclassificationCase", "region_name", "district_name", "outcomeCase")], 2, as.factor ), maxsum = 500000 ) )
       }
  })
  # exporting raw data 
  rawDat = reactive({
    data.frame(contactReportDate =as.character( d()$reportdatetime),  caseID= d()$caze_id, contactID =  d()$id, contactProximity = d()$contactproximity, contactClassification = d()$contactclassification,
               caseClassification = d()$caseclassificationCase, disease = d()$disease, caseOutcome = d()$outcomeCase, contactRegion = d()$region_name,
               contactDistrict = d()$district_name) 
  })  
  output$rawData <- renderTable({rawDat() })
  
})
