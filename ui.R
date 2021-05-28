ui <- dashboardPage(
  dashboardHeader(
    title = "Tableau de bord JOBIO",
    titleWidth = 900
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Géographie", icon = icon("fas fa-tasks"),tabName = "og1"),
      menuItem("Les offres",icon = icon("fas fa-clipboard"), tabName = "og2"),
      menuItem("Au cours du temps ",icon = icon("fas fa-calculator"),  tabName = "og3"),
      menuItem("Divers", icon = icon("fas fa-object-group"),tabName = "og4")
    ), width = 300
  ),
  dashboardBody(
    tabItems( 
      tabItem(tabName = "og1"),
      tabItem(tabName = "og2",
              box(plotOutput("plot1")),
              box(plotOutput("plot2"))),
      tabItem(tabName = "og3"),
      tabItem(tabName = "og4")
  )#,
  # tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"))
))