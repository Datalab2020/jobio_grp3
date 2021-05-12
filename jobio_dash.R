## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title="Test"),
  dashboardSidebar(
    sidebarMenu(
      menuItem('Test', tabName = 'tab1')
    )
  ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'tab1', fluidRow(box(title = "testTest"))
        )
      )
    )
)

shinyApp(ui, server)