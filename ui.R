library(dashboardthemes)

ui <-
  dashboardPage(
    dashboardHeader(title = "Tableau de bord JOBIO",
                    titleWidth = 900),
    
    
    dashboardSidebar(
      sidebarMenu(
        menuItem(
          "Geographie",
          icon = icon("map-marked-alt"),
          tabName = "og1"
        ),
        menuItem(
          "Les offres",
          icon = icon("fas fa-clipboard"),
          tabName = "og2"
        ),
        menuItem(
          "Au cours du temps ",
          icon = icon("clock"),
          tabName = "og3"
        ),
        menuItem("Divers", icon = icon("cat"), tabName = "og4")
      ),
      width = 400
    ),
    
    
    dashboardBody(
      shinyDashboardThemes(theme = "purple_gradient"),
      tabItems(
        tabItem(tabName = "og1",
                fluidRow(
                  tabBox(
                    title = "Geolocalisation des offres d'emploi",
                    # The id lets us use input$tabset1 on the server to find the current tab
                    id = "tabset1",
                    height = "100%",
                    width = "500px",
                    tabPanel("WHERE ?", leafletOutput("carte1")),
                    tabPanel("HOW MUCH ?", leafletOutput("carte2"))
                  ),
                  width = 12
                )),
        
        tabItem(
          tabName = "og2",
          box(plotOutput("plot1")),
          box(plotOutput("plot2")),
          infoBox("Taux d'offres sans salaire :",perNoSal, icon = icon("credit-card")),
          infoBox("Nombre total d'offres :", nbOffres, icon = icon("credit-card")))
        ,
        tabItem(tabName = "og3", box(plotOutput("plot5", height = 500))),
        tabItem(tabName = "og4",
                box(wordcloud2Output("wc2")),
                box(plotOutput("barplot")))
        )
      )
    )
  