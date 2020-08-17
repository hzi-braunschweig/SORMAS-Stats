# load shiny packages
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)

# load app-specific packages
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
library(rgdal)
library(maps)
library(maptools)
library(mapdata)
library(foreign)    
library(sp)
library(broom)
library(ggmap)
library(rgeos)
#library(tmap)
library(sf)
library(lattice)
library(fontawesome)

# Load data
# - use tryCatch lateron
# - Try (1) PSQL connection, (2) Load from mounted "last-data", (3) fallback to "demo-data"
load(file.path("./demo-data", "contRegionDist.RData")) 
load(file.path("./demo-data", "nodeLineList.RData"))
load(file.path("./demo-data", "elist.RData"))
load(file.path("./demo-data", "siDat.RData"))

# load binary files
# functions for contact data analysis
load(file.path("./utils", "dateTimeToDate.R"))
load(file.path("./utils", "import.multiple.csv.files.R"))
load(file.path("./utils", "plotNet.R"))
load(file.path("./utils","importingData.R"))
load(file.path("./utils","mergingData.R"))
load(file.path("./utils","contIdsForSingleChain.R"))

## Functions for case data analysis
load(file.path("./utils","pyramidPlotFunction.R"))
load(file.path("./utils","timeSeriesPlotDay.R"))
load(file.path("./utils","timeSeriesPlotWeek.R"))
load(file.path("./utils","timeSeriesPlotMonth.R"))
load(file.path("./utils","timeSeriesPlotDayRegion.R"))
load(file.path("./utils","epicurveDate.R"))
load(file.path("./utils","epicurveMonth.R"))
load(file.path("./utils","regionMapPlot.R"))
load(file.path("./utils","districtMapPlot.R"))
load(file.path("./utils","RtPlot.R"))


# Define UI for dataset viewer app ----
ui <- shinyUI(bootstrapPage(
  #tags$head(includeHTML("gtag.html")),
  navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
             "SORMAS Stats", id="nav",
             
             tabPanel( "Filter Options",
                       sidebarLayout(
                         sidebarPanel( 
                           span(tags$i(h6("Please filter the database using tabs below.")), style="color:#045a8d"),
                           
                           pickerInput("diseaseUi", "Disease of source case", choices = c("CORONAVIRUS", "LASSA","MONKEYPOX", "LASSA",
                                                                                          "CSM","EVD","NEW_INFLUENZA", "PLAGUE",
                                                                                          "UNDEFINED","UNSPECIFIED_VHF","MEASLES","OTHER"), 
                                       selected = c("CORONAVIRUS"),
                                       multiple = FALSE),
                           dateRangeInput("reportdateUi","Contact report date range (input: dd-mm-yyyy)" , start = Sys.Date()-30, end = Sys.Date()-1, min = NULL,
                                          max = NULL, format = "dd-mm-yyyy", startview = "month",
                                          weekstart = 0, language = "en", separator = " to ", width = NULL,
                                          autoclose = TRUE),
                           pickerInput("regionUi", "Region of contact (region of case is used if missing)", choices = c("All regions",levels(as.factor(contRegionDist$region_name)))),
                           pickerInput("districtUi", "District of contact (district of case is used if missing)", choices = c("All districts",levels(as.factor(contRegionDist$district_name)))),
                           
                           #pickerInput("resultingCaseOnlyUi", "Visualize only chains with resulting cases?", choices = c("Yes", "No")),
                           #checkboxInput("resultingCaseOnlyUi", "Visualize only chains with resulting cases?", TRUE),
                           #numericInput("visSingleChainUi", "Visualize only chain with this source case ID", value = NULL),
                           #selectizeInput(inputId = 'select_input', label = 'Choose your files...', choices = '*', multiple = TRUE),
                           #verbatimTextOutput('debug'),
                           # fileInput("case", "Input case data (.csv)",
                           #           multiple = TRUE,
                           #           accept = c("text/csv",
                           #                      "text/comma-separated-values,text/plain",
                           #                      ".csv")),
                           # fileInput('reference_files', 'References', multiple = T,
                           #           accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                           # # Horizontal line ----
                           # # tags$hr(),
                           # # Input: Checkbox if file has header ----
                           # checkboxInput("header", "Header", TRUE),
                           # 
                           # # Input: Select separator ----
                           # selectInput("sep", "Separator",
                           #             choices = c(Comma = ",",
                           #                         Semicolon = ";"), # Tab = "\t"
                           #             selected = ";"),
                           # 
                           # 
                           # # Horizontal line ----
                           # # tags$hr(),
                           # 
                           # # Input: Select number of rows to display ----
                           # radioButtons("disp", "Display",
                           #              choices = c(Head = "head",
                           #                          All = "all"),
                           #              selected = "head"),
                           # 
                           # pickerInput("outcome_select", "Outcome:",   
                           #            choices = c("Deaths per 100,000", "Cases per 100,000", "Cases (total)", "Deaths (total)"), 
                           #            selected = c("Deaths per 100,000"),
                           #            multiple = FALSE),
                           
                           #  pickerInput("start_date", "Plotting start date:",   
                           #            choices = c("Date", "Day of 100th confirmed case", "Day of 10th death"), 
                           #            options = list(`actions-box` = TRUE),
                           #            selected = "Date",
                           #            multiple = FALSE), 
                           
                           "All the statistics generated on all the tabs are based on the filter that you provided above.",
                           
                           width = 3),
                         
                         mainPanel(
                           tabsetPanel(
                             tabPanel("Bar plot", plotOutput("plot", width = "100%", height = "90vh"), downloadButton("downloadBarplot", "Download this plot"), tags$br(),tags$br(),
                                      " Each bar in this plot represents a region or district and the height of the bar corresponds to the number of contacts 
                                      in the region or district."),
                             tabPanel("Contacts per case", plotOutput("plotContPerCase", width = "100%", height = "90vh"),  downloadButton("downloadContPerCasePlot", "Download this plot"), tags$br(),tags$br(),
                                      " Contact per case."),
                             #tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh")),
                             tabPanel("Serial Interval distribution", plotOutput("siHist", width = "100%", height = "100vh"), downloadButton("downloadSerialIntervalPlot", "Download this plot"), tags$br(),tags$br(),
                                      "The Distribution of serial interval. This figure was obtained by plottig the histogram of the difference in number of days between symptom onset of a source case person and 
                                      a cantact person that became a case as a result of the contact. Only contacts that resulted to a case were considered here.")
                             #tabPanel("Time series and focasting", plotOutput(plot(rnorm(100)), width = "100%", height = "100vh"))
                             #tabPanel("Followup chart")
                             #tabPanel("More ??", plotlyOutput("country_plot"))
                             #tabPanel("Cumulative (log10)", plotlyOutput("country_plot_cumulative_log"))
                           )
                         )
                       )
                       
             ),
             
             ############################## contact summary counts ##########
             
             tabPanel("Contacts summary",
                      mainPanel( 
                        tabsetPanel(
                          tabPanel("Table counts", verbatimTextOutput("tableCount")),
                          tabPanel("Serial Interval", verbatimTextOutput("si")),
                          tabPanel("Basic reproduction number (R0) ", verbatimTextOutput(1.5)),
                          # tabPanel("Contacts per case", plotOutput("plotContPerCase")),
                          #  tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh")),
                          # tabPanel("Serial Interval distribution", plotOutput("siHist", width = "100%", height = "100vh")),
                          # tabPanel("New", plotlyOutput("country_plot")),
                          tabPanel("Followup", verbatimTextOutput("summaryVisit"))
                          #tabPanel("Cumulative (log10)", plotlyOutput("country_plot_cumulative_log"))
                        )
                        , width = 12)
                      
             ),
             ###############
             # tabPanel("Controls",
             #          fluidRow(column(4, offset=1, selectInput("X", label="x var",
             #                                                   choices = list("Age" = "Age", "Weight" = "Weight", "Circumference" = "Circumference"),
             #                                                   multiple=F) ),
             #                   column(4,selectInput("Y", label="y var",
             #                                        choices = list("Age" = "Age", "Weight" = "Weight", "Circumference" = "Circumference"),
             #                                        multiple=F))) ,
             #          fluidRow(column(5, offset=1, plotOutput("plot", height = "400px") ),
             #                   column(5, class= "R2C2", helpText("This is an exemple") ) ), width = 12),
             
             tabPanel("Performance Indicators",
                      mainPanel( width=12,
                                 dashboardPage(
                                   # dashboardHeader(title = "Contact KPI"),
                                   dashboardHeader( ),
                                   dashboardSidebar(
                                     pickerInput("conPerson", "Contact entity type", choices = c("Contact", "Contact person"), # option to view contact or contact person
                                                 selected = c("Contact"),
                                                 multiple = FALSE)
                                   ),
                                   dashboardBody(
                                     ##################################""
                                     # infoBoxes with fill=FALSE
                                     # infoBoxes with fill=TRUE
                                     # fluidRow(
                                     #   infoBox("New Orders3", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                                     #   infoBoxOutput("progressBox3"),
                                     #   infoBoxOutput("approvalBox3")
                                     # ),
                                     # fluidRow(
                                     #   infoBox("New Orders4", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                                     #   infoBoxOutput("progressBox4"),
                                     #   infoBoxOutput("approvalBox4")
                                     # ),
                                     # fluidRow(
                                     #   infoBox("New Orders5", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                                     #   infoBoxOutput("progressBox5"),
                                     #   infoBoxOutput("approvalBox5")
                                     # ),
                                     # fluidRow(
                                     #   column(2, wellPanel(p("Column width 2")  )),
                                     #   column(10, wellPanel(p("Column width 10")))),
                                     # fluidRow(
                                     #  column(12 , valueBox(15*8, "Butget", icon = icon("credit-card") )),
                                     #  #column(4, valueBox(1*8, "Butget", icon = icon("credit-card") )),
                                     #  column(12 , valueBox(5*8, "contacts converted to case" ))
                                     #  ),
                                     fluidRow(width=12,
                                              column(3, wellPanel(p(" ")),  valueBox(textOutput("allCont"), "All contacts", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("contUnconfirmed"), "Unconfirmed", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("contConfirmed"), "Confirmed", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("contNot"), "Discarded", width = 12))),
                                     # column(2, wellPanel(p(" ")), valueBox(440, "Symptomatic", width = 12))),
                                     fluidRow(width=12,
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("activeCont"), "Active", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("convertedToCase"), "Converted to case", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("notConvertedToCase"), "Not-converted to case", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("dropped"), "Dropped", width = 12))),
                                     fluidRow(width=12,
                                              column(3, wellPanel(p(" ")),  valueBox(textOutput("underFU"), "Under FU", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("overdueFU"), "Overdue FU", width = 12)),
                                              column(3, wellPanel(p(" ")),  valueBox(textOutput("canceledFU"), "Canceled FU", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("lostToFU"), "Lost to FU", width = 12))),
                                     # fluidRow(width=12,
                                     #          column(3, wellPanel(p(" ")),  valueBox(textOutput("overdueFU"), "Overdue FU", width = 12)),
                                     #          column(3, wellPanel(p(" ")), valueBox(55*8, "Visited on last day", width = 12)),
                                     #          column(3, wellPanel(p(" ")), valueBox(55*8, "Not FU in 1-2 days", width = 12)),
                                     #          column(3, wellPanel(p(" ")), valueBox(55*8, "Not FU in 3-6 days", width = 12)),
                                     #          column(3, wellPanel(p(" ")), valueBox(55*8, "Not FU in >= 7 days", width = 12))),
                                     # fluidRow(width=12,
                                     #   column(3, wellPanel(p(" ")),  valueBox(55*8+78*8, "Under followup", width = 12)),
                                     #   column(3, wellPanel(p(" ")), valueBox(55*8, "Not FU in 1-2 days", width = 12)),
                                     #   column(3, wellPanel(p(" ")), valueBox(55*8, "Not FU in 3-6 days", width = 12)),
                                     #   column(3, wellPanel(p(" ")), valueBox(55*8, "Not FU in >= 7 days", width = 12))),
                                     fluidRow(width=12,
                                              #column(3, wellPanel(p(" ")),  valueBox("not done", " All Transmission chains", width = 12)),
                                              #column(3, wellPanel(p(" ")), valueBox("not done", "Chains with new cases", width = 12)),
                                              column(4, wellPanel(p(" ")), valueBox(textOutput("minConPerCase"), "Minimum contact per case", width = 12)),
                                              column(4, wellPanel(p(" ")), valueBox(textOutput("medianConPerCase"), "Median contact per case", width = 12)),
                                              column(4, wellPanel(p(" ")), valueBox(textOutput("maxConPerCase"), "Maximum contact per case", width = 12))),
                                     
                                     
                                   )))),
             #############################################################################################
             
             ####### Trans chain old #####
             
             # tabPanel("Tranmission chain",
             #          mainPanel( 
             #            tabsetPanel(
             #            tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh"))
             #            
             #            )
             #            , width = 12)
             #          
             # ),
             
             ### trans chain 2 #######
              
             tabPanel("Tranmission Network",
                      mainPanel( width = 12,
                                 dashboardPage(
                                   dashboardHeader(),
                                   dashboardSidebar(#pickerInput("resultingCaseOnlyUi", "Contact entity type", choices = c("Contact", "Contact person"), # option to view contact or contact person
                                     #           selected = c("Contact"),
                                     #           multiple = FALSE)
                                     checkboxInput("resultingCaseOnlyUi", "Visualize only chains with resulting cases?", TRUE),
                                     numericInput("visSingleChainUi", "Visualize only chain with this source case person ID", value = NULL)
                                   ),
                                   dashboardBody(
                                     fluidRow(
                                     visNetworkOutput("transChain", width = "100%", height = "100vh"), width=12 )
                                    # visNetworkOutput("transChain", width = "100%", height = "100vh"), width=12,  tags$br(), tags$br(), downloadButton("downloadTransNetworkPlot", "Download this plot")) 
                                   )
                                 ))
                      
             ),
             ####
             # tabPanel("Map",
             #          mainPanel( 
             #            tabsetPanel(
             #              tabPanel("Cumulative (log10)" )
             #            )
             #            , width = 12)
             #          
             # ),
             ##################################################"
             
             
             
             tabPanel("Data Export",
                      mainPanel( 
                        tabsetPanel(
                          tabPanel("Detailed contact Export",
                                   numericInput("maxrows", "Rows to show", 20),
                                   verbatimTextOutput("conRegionDistExpTable"),
                                   downloadButton("conRegionDistExpCsv", "Download as CSV"),tags$br(),tags$br(),
                                   "Each row in this data is a contact between a case person and a contact person. The data was obtained by merging contacts and their cases, thus the columns contains variables for contacts and cases"),
                          tabPanel("Contacts by Case Export",
                                   numericInput("maxrows", "Rows to show", 20),
                                   verbatimTextOutput("conPerCaseExpTable"),
                                   downloadButton("conPerCaseExpCsv", "Download as CSV"),tags$br(),tags$br(),
                                   "Each row in this data is a case. The data was obtained by summing the number of contacts for each case. Cases with no contact are not included in this table"),
                          tabPanel("Contact by Region Export",
                                   numericInput("maxrows", "Rows to show", 20),
                                   verbatimTextOutput("conPerGerionExpTable"),
                                   downloadButton("conPerGerionExpCsv", "Download as CSV"),tags$br(),tags$br(),
                                   "Each row in this data is a region with corresponding number of contacts. 
                                         The data was obtained by summing the number of contacts in each region.
                                         The resgion of the source case was used in case the region of the contact was missing."
                                   
                          ),
                          tabPanel("Serial Interval Export",
                                   numericInput("maxrows", "Rows to show", 20),
                                   verbatimTextOutput("siExpTable"),
                                   downloadButton("siExpCsv", "Download as CSV"),tags$br(),tags$br(),
                                   "Each row in this data is a contact between a case person and a contact person. 
                                         The data was obtained by calculating the number of days between the symptom onset of the source case person and that of the secondary case (contact) person. 
                                         Only contacts that resulted to a case were cosidered."
                                   
                          ))
                        , width = 12)),
             
             
             
             
             # tabPanel("Case Survaillance Analysis",
             #          mainPanel( 
             #            tabsetPanel(
             #              tabPanel("Epidemic curve"),
             #              tabPanel("Case Pyramid",  plotlyOutput("casePyramidPlot", width = "70%", height = "80vh") ),
             #              tabPanel("Time series plot",  plotlyOutput("caseTimeSeriesPlot", width = "90%", height = "80vh") )
             #              
             #            )
             #            , width = 12)
             #          
             # ),
             
             # tabPanel( "Case Survaillance Analysis",
             #           sidebarLayout(
             #             sidebarPanel( 
             #               span(tags$i(h6("Visualization options.")), style="color:#045a8d"),
             #               
             #               pickerInput("timeUnitUi", "Grouping", choices = c("Day","Epi-week", "Month"),
             #                           selected = c("Epi-week"),
             #                           multiple = FALSE),
             #               #"All the statistics generated on all the tabs are based on the filter that you provided above.",                           
             #               width = 2),                         
             #             mainPanel( 
             #               tabsetPanel(
             #                 tabPanel("Epidemic curve"),
             #                 tabPanel("Time series plot",  plotlyOutput("caseTimeSeriesPlot", width = "100%", height = "80vh") ) ,
             #                 tabPanel("Case Pyramid",  plotlyOutput("casePyramidPlot", width = "100%", height = "80vh") )
             #               )
             #             )                       
             #           )
             # ),
             
             tabPanel( "Case Survaillance Analysis",
                       sidebarLayout(
                         sidebarPanel( 
                           span(tags$i(h6("Visualization options.")), style="color:#045a8d"),
                           
                           conditionalPanel(condition = "input.tabs1==1",
                                            #selectizeInput("timeUnitEpicurveUi", "Grouping", choices = c("Day","Epi-week", "Month"),selected = c("Epi-week"),multiple = FALSE)
                                            radioButtons("timeUnitEpicurveUi","Choose an option",  choices = c("Day","Epi-week", "Month"),selected = c("Epi-week"))
                                         
                                            ),
                           
                           conditionalPanel(condition = "input.tabs1==2",
                                            #selectizeInput("timeUnitUi", "Grouping", choices = c("Day","Epi-week", "Month"),selected = c("Epi-week"),multiple = FALSE),
                                            radioButtons("timeUnitUi","Choose",  choices = c("Day","Epi-week", "Month"),selected = c("Epi-week")),
                                            checkboxInput(inputId = "cumUi", label = "Cummulative cases", value =F),
                                            checkboxInput(inputId = "byRegiontimeUnitUi", label = "Cases by region", value =F),
                                            checkboxInput(inputId = "cumRegionUi", label = "Cummulative cases by region", value =F)
                                            ),
                           
                           conditionalPanel(condition = "input.tabs1==3", h4(" ")),
                           
                           conditionalPanel(condition = "input.tabs1==4",
                                            radioButtons("caseMapshapesUi","Map shapes",  choices = c("By region","By district"),selected = c("By region")),
                                           ),
                           conditionalPanel(condition = "input.tabs1==5",
                                            radioButtons("rtMethodUi","SI estimation method ",  choices = c("Parametric-Gamma","Transmission data"),selected = c("Parametric-Gamma")),
                                            radioButtons("rsiUi","Ploting parameters",  choices = c("all","R","SI"),selected = c("all"))
                                            # radioButtons("mean_siUi","Parametric dist mean",  choices = c("all","R","SI"),selected = c("all")),
                                            # radioButtons("std_siUi","Parametric dist sd",  choices = c("all","R","SI"),selected = c("all"))
                                            ),
                           
                                            #selectizeInput("timeUnitUi", "Grouping", choices = c("Day","Epi-week", "Month"),selected = c("Epi-week"),multiple = FALSE)),
                                            width = 2),
                         mainPanel( 
                           tabsetPanel(id="tabs1",
                             tabPanel("Epidemic curve", value = 1, plotlyOutput("caseEpicurvePlot", width = "100%", height = "80vh")),
                             tabPanel("Time series plot", value = 2, plotlyOutput("caseTimeSeriesPlot", width = "100%", height = "80vh") ) ,
                             tabPanel("Case Pyramid",  value = 3,  plotlyOutput("casePyramidPlot", width = "100%", height = "80vh") ),
                             tabPanel("Region map", value = 4, plotOutput("regionMapCaseCount", width = "100%", height = "80vh")),
                             tabPanel("Reproduction number", value = 5, plotOutput("rtPlot", width = "100%", height = "80vh"))
                           )
                         )                       
                       )
             ),
             
            
             tabPanel("Case Data exportations",
                      mainPanel( 
                        tabsetPanel(
                          tabPanel("Cumulative (log10)" )
                        )
                        , width = 12)
                      
             )
             ##
       
             ####
             # tabPanel("Maps",
             #          mainPanel(
             #            tabsetPanel(
             #              tabPanel("Region map", plotOutput("regionMapCaseCount", width = "100%", height = "90vh"))
             #            )
             #            , width = 12)
             # 
             # )
       
             
             
                   
             
  )          
))


# Define server logic to summarize and view selected dataset ----
server <- function(input, output,session) {
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
    
  ### Begining of  KPI ###########
    #Row 1,  All contacts, used d
    output$allCont = renderText({ nrow(d( )) }) 
    # confrimed contacts
    output$contConfirmed = renderText({ 
      temp = d()
      temp = temp[temp$contactclassification == "CONFIRMED" ,]
      nrow(temp)
      }) 
    # Uncofirmed contacts
    output$contUnconfirmed = renderText({ 
      nrow( d()[d()$contactclassification == "UNCONFIRMED" ,] )
    }) 
    # Not a contact contacts
    output$contNot = renderText({ 
      nrow( d()[d()$contactclassification == "NO_CONTACT" ,] )
    }) 
    
    #### Row 2  contact status ####
    ## Active contacts
    output$activeCont = renderText({ 
      nrow( d()[d()$contactstatus == "ACTIVE" ,] )
    }) 
    ## converted to case
    output$convertedToCase = renderText({ 
      nrow( d()[d()$contactstatus == "CONVERTED" ,] )
    })
    ## not converted to case
    output$notConvertedToCase = renderText({ 
      nrow( d()[d()$contactstatus == "NOT_CONVERTED" ,] )
    })
    ## dropped contacts
    output$dropped = renderText({ 
      nrow( d()[d()$contactstatus == "DROPPED" ,] )
    })
    
    #### Row 3 contact followup status ####
    
    ## under FU
    output$underFU = renderText({ 
      nrow( d()[d()$followupstatus == "FOLLOW_UP" ,] )
    }) 
    ## canceled FU
    output$canceledFU = renderText({ 
      nrow( d()[d()$followupstatus == "CANCELED_FOLLOW_UP" ,] )
    }) 
    ## lost to followup
    output$lostToFU = renderText({ 
      nrow( d()[d()$followupstatus == "LOST" ,] )
    })
    ## not converted to case
    output$overdueFU = renderText({ 
      nrow( d()[d()$followupstatus == "NO_FOLLOW_UP" ,] ) # will later add the category of overdue fillow up and delete no_followup.
    })

    ### Row 4, number of contacts per case and transmission tree
    # Use p()$Freq
    ## max contacte per case
    output$maxConPerCase = renderText({ 
      max(p()$Freq) 
    })
    ## min contacte per case
    output$medianConPerCase = renderText({ 
      median(p()$Freq) 
    })
    
##########  end of KPI #################""    
 ### Contacts per case
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
          as.table(summary(apply( d( )[, colnames(d( )) %in% c("contactstatus","followupstatus", "contactproximity","contactclassification", "caseclassificationCase", "region_name", "outcomeCase")], 2, as.factor ),  maxsum = 50000 ) )
       } else{
         as.table(summary(apply( d( )[, colnames(d( )) %in% c("contactstatus","followupstatus","contactproximity","contactclassification", "caseclassificationCase", "region_name", "district_name", "outcomeCase")], 2, as.factor ), maxsum = 500000 ) )
       }
  })
  # exporting raw data 
  rawDat = reactive({
    data.frame(contactReportDate =as.character( d()$reportdatetime),  caseID= d()$caze_id, contactID =  d()$id, contactProximity = d()$contactproximity, contactClassification = d()$contactclassification,
               caseClassification = d()$caseclassificationCase, disease = d()$disease, caseOutcome = d()$outcomeCase, contactRegion = d()$region_name,
               contactDistrict = d()$district_name) 
  })  
  output$rawData <- renderTable({rawDat() })
  
}
# Create Shiny app ----
shinyApp(ui, server)
