library(shiny)
library(shinydashboard)

setwd("C:/Users/Ga/Documents/GitHub/jobio_grp3")

source("server.R")
source("ui.R")

shinyApp(ui, server)