
## ui
#############
shinyUI(bootstrapPage(
  #tags$head(includeHTML("gtag.html")),
  navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
             "SORMAS Stats", id="nav",
             
             tabPanel( "Filter options",
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
                           #
                           hr(),
                           br(),
                           h6("Powered by:"),
                           tags$img(src = "HZI_Logo.jpg", height = 50, width = 200),
                           
                           width = 3),
                         
                         mainPanel(
                           tabsetPanel(
                             tabPanel(title = "About", h4("SORMAS-Stats contain functions to analyze and visualize surveillance data collected by the Surveillance Outbreak 
                             Response Management and Analysis System (SORMAS). SORMAS is an open source mobile eHealth System that processes
                             disease control and outbreak management procedures in addition to surveillance and early detection of outbreaks through real-time digital
                            surveillance including peripheral health care facilities and laboratories. "), h4(strong("SORMAS User Personas")), 
                            img(src = "process-flow-sormas.png", width = "900", height = "900")
                                      ),
                             
                             tabPanel("Contact bar plot", plotOutput("plot", width = "100%", height = "90vh"), downloadButton("downloadBarplot", "Download this plot"), tags$br(),tags$br(),
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
                          tabPanel("Serial Interval", verbatimTextOutput("si"))
                         # tabPanel("Basic reproduction number (R0) ", verbatimTextOutput(1.5)),
                          # tabPanel("Contacts per case", plotOutput("plotContPerCase")),
                          #  tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh")),
                          # tabPanel("Serial Interval distribution", plotOutput("siHist", width = "100%", height = "100vh")),
                          # tabPanel("New", plotlyOutput("country_plot")),
                          #tabPanel("Followup", verbatimTextOutput("summaryVisit"))
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
             
             tabPanel("Performance indicators",
                      mainPanel( width=12,
                                 dashboardPage(
                                   # dashboardHeader(title = "Contact KPI"),
                                   dashboardHeader( ),
                                   dashboardSidebar(
                                     pickerInput("conPerson", "Contact entity type", choices = c("Contact", "Contact person"), # option to view contact or contact person
                                                 selected = c("Contact"),
                                                 multiple = FALSE)
                                   ),
                                   dashboardBody(  h2('Contact indicators'),
                                     ##################################""
                                     # infoBoxes with fill=FALSE
                                     # infoBoxes with fill=TRUE
                                     # fluidRow(
                                     #   infoBox("New Orders3", 10 * 2, icon = icon("handshake"), fill = TRUE),
                                     #   valueBox("New Orders3", 10 * 2, icon = icon("handshake"), fill = TRUE),
                                     #   # infoBoxOutput(textOutput("allCont"), width = 4),
                                     #   infoBoxOutput("approvalBox3")
                                     # ),
                                     # 
                                     # fluidRow(box(width = 12,
                                     #              infoBox("New Orders3", 10 * 2, icon = icon("procedures"), fill = TRUE),
                                     #              infoBox(" ", 10*2, icon = icon("handshake"),
                                     #                      color = "purple", fill = TRUE),
                                     #              infoBox(" ", 10*2, icon = icon("users"),
                                     #                      color = "purple", fill = TRUE)
                                     
                                     
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
                                      # fluidRow(width=12,
                                      #         column(12, wellPanel(p(" ")), valueBox(textOutput("EI"), "CONTACT INDICATORS", width = 12))), 
                                     h4('Contact classification'),
                                     fluidRow(width=12, 
                                              infoBoxOutput("allCont", width = 3),
                                              infoBoxOutput("contConfirmed", width = 3),
                                              infoBoxOutput("contUnconfirmed", width = 3),
                                              infoBoxOutput("contNot", width = 3)),
                                     h4('Contact status'),
                                     fluidRow(width=12,
                                              infoBoxOutput("activeCont", width = 3),
                                              infoBoxOutput("convertedToCase", width = 3),
                                              infoBoxOutput("dropped", width = 3),
                                              infoBoxOutput("inactiveCont", width = 3)),
                                     h4('Followup status'),
                                     fluidRow(width=9,
                                              infoBoxOutput("ongoingFollowupContact", width = 3),
                                              infoBoxOutput("overdueFU", width = 3),
                                              infoBoxOutput("stoppedFUContact", width = 3)),
                                     h4('Summary of number of contacts per case'),
                                     fluidRow(width=12,
                                              infoBoxOutput("minConPerCase", width = 3),
                                              infoBoxOutput("medianConPerCase", width = 3),
                                              infoBoxOutput("meanConPerCase", width = 3),
                                              infoBoxOutput("maxConPerCase", width = 3)),
                                              # 
                                              # column(3, wellPanel(p(" ")), valueBox(textOutput("minConPerCase"), "Minimum ", width = 12)),
                                              # column(3, wellPanel(p(" ")), valueBox(textOutput("medianConPerCase"), "Median ", width = 12)),
                                              # column(3, wellPanel(p(" ")), valueBox(textOutput("meanConPerCase"), "Mean", width = 12)),
                                              # column(3, wellPanel(p(" ")), valueBox(textOutput("maxConPerCase"), "Maximum", width = 12))),
                                     
                                     h2('Case indicators'),
                                     h4('Case classification'),
                                     fluidRow(width=12,
                                              infoBox("All cases", 10 * 2, icon = icon("procedures"), fill = F , width = 2, color = colCase),
                                              infoBox("Unclassified", 10 * 2, icon = icon("procedures"), fill = F, width = 2, color = colCase),
                                              infoBox("Suspected", 10 * 2, icon = icon("procedures"), fill = F, width = 2, color = colCase),
                                              infoBox("Probable", 10 * 2, icon = icon("procedures"), fill = F, width = 2, color = colCase),
                                              infoBox("Confirme", 10 * 2, icon = icon("procedures"), fill = F, width = 2, color = colCase),
                                              infoBox("Discarded", 10 * 2, icon = icon("procedures"), fill = F, width = 2, color = colCase)),
                                              
                                              # infoBox("All cases", 10 * 2, icon = icon("notCases"), fill = TRUE, width = 2, color = colCase),
                                              # #column(2, wellPanel(p(" ")),  valueBox(textOutput("allCases"), "All Cases", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("suspectedCases"), "suspected", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("ProbableCases"), "Probable", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("confirmedCases"), "Confirmed", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("notclasCases"), "Unclassified", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("notCases"), "Dropped/ Discarded", width = 12))),
                                     
                                     ########## EVENT INIKDICATORS ##############
                                     # fluidRow(width=12,
                                     #          column(12, wellPanel(p(" ")), valueBox(textOutput("EI"), "EVENT INDICATORS", width = 12))),
                                     h2('Events indicators'),
                                     fluidRow(width=12,
                                              infoBox("All Events", 10 * 2, icon = icon("users"), fill = TRUE, width = 2),
                                              #column(2, wellPanel(p(" ")),  valueBox(textOutput("allEvents"), "All Events", width = 12)),
                                              infoBox("Signal", 10 * 2, icon = icon("users"), fill = TRUE, width = 2),
                                              infoBox("Events", 10 * 2, icon = icon("users"), fill = TRUE, width = 2),
                                              infoBox("Sreaning", 10 * 2, icon = icon("users"), fill = TRUE, width = 2),
                                              infoBox("Cluster", 10 * 2, icon = icon("users"), fill = TRUE, width = 2),
                                              infoBox("Discarded", 10 * 2, icon = icon("users"), fill = TRUE, width = 2)),
                                              
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("signalEvents"), "Signal", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("Events"), "Events", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("ScreeningEvents"), "Sreaning", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("ClusterEvents"), "Cluster", width = 12)),
                                              # column(2, wellPanel(p(" ")), valueBox(textOutput("DroppedEvents"), "Dropped/ Discarded", width = 12))),
                                     fluidRow(width=12,
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeHotline"), "Hotline/ Person", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeMedia"), "Media/ news", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeModel"), "Mathematical Model", width = 12)),
                                              column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeNotApplicable"), "Not applicable", width = 12))),
                                     fluidRow(width=12,
                                              #column(3, wellPanel(p(" ")),  valueBox("not done", " All Transmission chains", width = 12)),
                                              #column(3, wellPanel(p(" ")), valueBox("not done", "Chains with new cases", width = 12)),
                                              column(4, wellPanel(p(" ")), valueBox(textOutput("minPartPerEvent"), "Minimum persons per event", width = 12)),
                                              column(4, wellPanel(p(" ")), valueBox(textOutput("medianPartPerEvent"), "Median persons per event", width = 12)),
                                              column(4, wellPanel(p(" ")), valueBox(textOutput("maxPartPerEvent"), "Maximum persons per event", width = 12))),
                                     
                                     
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
             
##### trans chain 2 #######
              
             tabPanel("Tranmission network",
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
                                 ))),
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
             
             
             
##### contat export tab ########
tabPanel("Contact data export",
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
             
##### Case data analysis ######## 
             tabPanel( "Case data analysis",
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
             
##### Case data export ######## 
             tabPanel("Case data export",
                      mainPanel( 
                        tabsetPanel(
                          tabPanel("Cumulative (log10)" )
                        )
                        , width = 12))
             ##
             # tabPanel("Events indicators",
             #          mainPanel( width=12,
             #                     dashboardPage(
             #                       # dashboardHeader(title = "Contact KPI"),
             #                       dashboardHeader( ),
             #                       dashboardSidebar(),
             #                       #   pickerInput("conPerson", "Contact entity type", choices = c("Contact", "Contact person"), # option to view contact or contact person
             #                       #               selected = c("Contact"),
             #                       #               multiple = FALSE)
             #                       # ),
             #                       dashboardBody(
             #                         fluidRow(width=12,
             #                                  column(12, wellPanel(p(" ")), valueBox(textOutput("EI"), "EVENT INDICATORS", width = 12)),
             #                         ),
             #                         fluidRow(width=12,
             #                                  column(2, wellPanel(p(" ")),  valueBox(textOutput("allEvents"), "All Events", width = 12)),
             #                                  column(2, wellPanel(p(" ")), valueBox(textOutput("signalEvents"), "Signal", width = 12)),
             #                                  column(2, wellPanel(p(" ")), valueBox(textOutput("Events"), "Events", width = 12)),
             #                                  column(2, wellPanel(p(" ")), valueBox(textOutput("ScreeningEvents"), "Sreaning", width = 12)),
             #                                  column(2, wellPanel(p(" ")), valueBox(textOutput("ClusterEvents"), "Cluster", width = 12)),
             #                                  column(2, wellPanel(p(" ")), valueBox(textOutput("DroppedEvents"), "Dropped/ Discarded", width = 12))),
             #                         fluidRow(width=12,
             #                                  column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeHotline"), "Hotline/ Person", width = 12)),
             #                                  column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeMedia"), "Media/ news", width = 12)),
             #                                  column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeModel"), "Mathematical Model", width = 12)),
             #                                  column(3, wellPanel(p(" ")), valueBox(textOutput("SourceTypeNotApplicable"), "Not applicable", width = 12))),
             #                         fluidRow(width=12,
             #                                  #column(3, wellPanel(p(" ")),  valueBox("not done", " All Transmission chains", width = 12)),
             #                                  #column(3, wellPanel(p(" ")), valueBox("not done", "Chains with new cases", width = 12)),
             #                                  column(4, wellPanel(p(" ")), valueBox(textOutput("minPartPerEvent"), "Minimum persons per event", width = 12)),
             #                                  column(4, wellPanel(p(" ")), valueBox(textOutput("medianPartPerEvent"), "Median persons per event", width = 12)),
             #                                  column(4, wellPanel(p(" ")), valueBox(textOutput("maxPartPerEvent"), "Maximum persons per event", width = 12)))
             #                         
             #                         
             #                       ))))
       
             
             
                   
             
  )          
))
