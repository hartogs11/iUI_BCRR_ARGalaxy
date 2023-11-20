#Importing all libraries
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(plotly)
library(remotes)
library(ggsankey)
library(ggplot2)
library(ggalluvial)
library(RColorBrewer)
library(shinyFiles)
library(visNetwork)
library(htmlwidgets)
library(e1071)

# Laden van de UI- en serverlogica voor elk tabblad
source("ui/general_info_ui.R")
source("server/general_info_server.R")
source("ui/mutfreq_ui.R")
source("server/mutfreq_server.R")
source("ui/rsratio_ui.R")
source("server/rsratio_server.R")
source("ui/vdj_ui.R")
source("server/vdj_server.R")

shinyApp(
  ui = dashboardPage(
    dashboardHeader(title = "Dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("SHM frequency", tabName = "mutfreq"),
        menuItem("R-S Ratio of FR1 and CDR3 frequency", tabName = "rsratio"),
        menuItem("V(D)J Recombination Viewer", tabName = "vdj")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "info",
                general_info_ui()
        ),
        tabItem(tabName = "mutfreq",
                mutfreq_ui()
        ),
        tabItem(tabName = "rsratio",
                rsratio_ui()
        ),
        tabItem(tabName = "vdj",
                vdj_ui()
        )
      )
    )
  ),
  server = function(input, output, session) {
    general_info_server(input, output, session)
    mutfreq_server(input, output, session)
    rsratio_server(input, output, session)
    vdj_server(input, output, session)
  }
)
