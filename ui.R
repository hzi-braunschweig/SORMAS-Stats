
## ui
#############
shinyUI(bootstrapPage(
   #tags$head(includeHTML("gtag.html")),
   navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
              "Contacts Statistics", id="nav",
              tabPanel( "Contacts Plots",
                        sidebarLayout(
                          sidebarPanel( 
                            span(tags$i(h6("Please filter the database of contacts using tabs below.")), style="color:#045a8d"),
                            
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
                            
                            #selectizeInput(inputId = 'select_input', label = 'Choose your files...', choices = '*', multiple = TRUE),
                            #verbatimTextOutput('debug'),
                            fileInput("case", "Input case data (.csv)",
                                      multiple = TRUE,
                                      accept = c("text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
                            
                            # Horizontal line ----
                            # tags$hr(),
                            
                            # Input: Checkbox if file has header ----
                            checkboxInput("header", "Header", TRUE),
                            
                            # Input: Select separator ----
                            selectInput("sep", "Separator",
                                        choices = c(Comma = ",",
                                                    Semicolon = ";"), # Tab = "\t"
                                        selected = ";"),
                            
                            
                            # Horizontal line ----
                            # tags$hr(),
                            
                            # Input: Select number of rows to display ----
                            radioButtons("disp", "Display",
                                         choices = c(Head = "head",
                                                     All = "all"),
                                         selected = "head"),
                            
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
                              tabPanel("Graphs", plotOutput("plot")),
                              tabPanel("Contacts per case", plotOutput("plotContPerCase")),
                              #tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh")),
                              tabPanel("Serial Interval distribution", plotOutput("siHist", width = "100%", height = "100vh"))
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
                               dashboardHeader(title = "Contact KPI"),
                               dashboardSidebar( ),
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
                                   column(2, wellPanel(p(" ")),  valueBox(55*8+78*8, "All contacts", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Unconfirmed", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Confirmed", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Not a contact", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(78*8, "Symptomatic", width = 12))),
                                 fluidRow(width=12,
                                   column(2, wellPanel(p(" ")),  valueBox(55*8+78*8, "Overdue followup", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Lost to FU", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Completed FU", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Dropped", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(78*8, "Converted to case", width = 12))),
                                 fluidRow(width=12,
                                   column(2, wellPanel(p(" ")),  valueBox(55*8+78*8, "Under followup", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Not FU yesterday", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Not FU in 2-3 days", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Not FU in 4-6 days", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(78*8, "Not FU in >= 7 days", width = 12))),
                                 fluidRow(width=12,
                                   column(2, wellPanel(p(" ")),  valueBox(55*8+78*8, " All Transmission chain", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Chains with new cases", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Under followup", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(55*8, "Max contacts per case", width = 12)),
                                   column(2, wellPanel(p(" ")), valueBox(78*8, "Min contact per case", width = 12)))
                            
                               )))),

              #######
              
              tabPanel("Tranmission chain",
                       mainPanel( 
                         tabsetPanel(
                           #tabPanel("Table counts", verbatimTextOutput("tableCount")),
                           # tabPanel("Serial Interval", verbatimTextOutput("si")),
                           # tabPanel("Contacts per case", plotOutput("plotContPerCase")),
                           tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh"))
                           # tabPanel("Serial Interval distribution", plotOutput("siHist", width = "100%", height = "100vh")),
                           # tabPanel("New", plotlyOutput("country_plot")),
                           #tabPanel("Visits statisics", verbatimTextOutput("summaryVisit")),
                           #tabPanel("Cumulative (log10)", plotlyOutput("country_plot_cumulative_log"))
                         )
                         , width = 12)
                       
              ),
              ####
              tabPanel("Contact Map",
                       mainPanel( 
                         tabsetPanel(
                           #tabPanel("Table counts", verbatimTextOutput("tableCount")),
                           # tabPanel("Serial Interval", verbatimTextOutput("si")),
                           # tabPanel("Contacts per case", plotOutput("plotContPerCase")),
                           #tabPanel("Transmission chain", visNetworkOutput("transChain", width = "100%", height = "100vh"))
                           # tabPanel("Serial Interval distribution", plotOutput("siHist", width = "100%", height = "100vh")),
                           # tabPanel("New", plotlyOutput("country_plot")),
                           #tabPanel("Visits statisics", verbatimTextOutput("summaryVisit")),
                           tabPanel("Cumulative (log10)" )
                         )
                         , width = 12)
                       
              ),
            ##################################################"
              
              tabPanel("Data",
                       numericInput("maxrows", "Rows to show", 25),
                       #tabPanel("Contact linelisting", tableOutput("rawData"))
                       #verbatimTextOutput("rawData"),
                       tableOutput("rawData"),
                       downloadButton("downloadCsv", "Download as CSV"),tags$br(),tags$br(),
                       "Published by ", tags$a(href="https://github.com/hzi-braunschweig", 
                                               " SORMAS-Open Project, Helmholtz Centre for Infection Research, Braunschweig, Germany.")
              )
              
              

              
   )          
))


