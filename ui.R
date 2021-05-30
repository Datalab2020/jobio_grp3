library(dashboardthemes)

ui <- 
  dashboardPage(
  dashboardHeader(
    title = "Tableau de bord JOBIO",
    titleWidth = 900
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Géographie", icon = icon("map-marked-alt"),tabName = "og1"),
      menuItem("Les offres",icon = icon("fas fa-clipboard"), tabName = "og2"),
      menuItem("Au cours du temps ",icon = icon("clock"),  tabName = "og3"),
      menuItem("Divers", icon = icon("cat"),tabName = "og4")
    ), width = 300
  ),
  dashboardBody(
    shinyDashboardThemes(
      theme = "purple_gradient"
    ),
    tabItems(
      tabItem(tabName = "og1",
              fluidRow(
                tabBox(
                  title = "Géolocalisation des offres d'emploi",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1", height = "500px",width="500px",
                  tabPanel("WHERE ?", leafletOutput("carte1")),
                  tabPanel("HOW MUCH ?", leafletOutput("carte2"))
                ))),

    tabItem(tabName = "og2",
              box(plotOutput("plot1")),
              box(plotOutput("plot2"))),
              # infoBox("Taux d'offres sans salaire :",valueBoxOutput(kpi1) , icon = icon("credit-card"), color = "green")),
              #box(valueBoxOutput(kpi1) , icon = icon("credit-card"), color = "green")),
    tabItem(tabName = "og3"),
    tabItem(tabName = "og4"))
      #,
  # tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"))
))