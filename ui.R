# ui design
source('helper.R')

fluidPage(
dashboardPage(
  dashboardHeader(title = "Air Pollution in Albania"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("info")),
      menuItem("Interactive Map", tabName = "map", icon = icon("map"))
      )),
  dashboardBody(tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
    
    tabItem(tabName = "overview",
            fluidRow(column(12, overviewbox)),
            fluidRow(
              column(
                6,
                box(
                  width = NULL,
                  baselineinfobox,
                  title = "Baseline Information",
                  solidHeader = TRUE,
                  status = "primary"
                ),
                box(
                  width = NULL,
                  questionbox,
                  title = "Questions of Interest",
                  solidHeader = TRUE,
                  status = "primary"
                )
              ),
              box(
                width = 6,
                pollutantbox,
                title = "Pollutant Description",
                solidHeader = TRUE,
                status = "primary"
              )
            ),
            fluidRow(
              tabBox(width = 12,
                tabPanel("Overall Dataset", DT::dataTableOutput("data")),
                tabPanel("Pollutant Information", DT::dataTableOutput("infodata")),
                tags$b("Data Source: Kaggle"),
                br(),
                tags$a(href = "https://www.kaggle.com/bappekim/air-pollution-in-seoul",
                              "Air Pollution in Seoul"))
              )
            ),
    tabItem(tabName = "map",
            fluidRow(
              box(
                width = 9,
                leafletOutput("map", height = 500),
                title = "Map of Seoul City",
                solidHeader = TRUE,
                status = "primary"
              ),
              column(
                2,
                radioButtons(
                  inputId = "finedust",
                  label = h4("Select Pollutant"),
                  choices = c( "SO2", "NO2", "O3", "PM10", "PM2.5", "CO", "Benzen"),
                  inline = TRUE
                ),
                br()
              )
            ),
            h5(strong("*The minimum, average, maximum values are calculated with the timeline specified")),
            h5(strong("*The unit of measurement for the values is 'microgram/m3'")),
            # fluidRow(
            #   column(
            #     11,
            #     infoBoxOutput("good_neighborhood", width = 3),
            #     infoBoxOutput("good_min", width = 2),
            #     infoBoxOutput("good_avg", width = 2),
            #     infoBoxOutput("good_max", width = 2)
            #   )
            # ),
            # fluidRow(
            #   column(
            #     11,
            #     infoBoxOutput("bad_neighborhood", width = 3),
            #     infoBoxOutput("bad_min", width = 2),
            #     infoBoxOutput("bad_avg", width = 2),
            #     infoBoxOutput("bad_max", width = 2)
            #   ),
            # )
        )
))))
