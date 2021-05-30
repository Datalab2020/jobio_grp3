library(shiny)
library(shinydashboard)
library(dashboardthemes)

setwd(dir = ".")

source("server.R")
source("ui.R")

shinyApp(ui, server)