vdj_ui <- function() {
  tabItem(
    tabName = "vdj",
    dropdownButton(
      #All filter options
      tags$h3("Filter options:"),
      
      selectInput("sample_vdj", "Select Sample:", choices = unique(df_recombination$Sample)),
      
      sliderInput("freq_vdj", "Minimal frequency:", min = 0, max = max_freq, value = 80),
      sliderInput("count_vdj", "Minimal counts:", min = 0, max = max_count, value = 5),
      
      circle = "TRUE",
      icon = icon("gear"), width = "300px",
      tooltip = tooltipOptions(title = "Click to see filter options!")
    ),
    
    #Visualization
    plotOutput("VDJ")
    
  )
}
