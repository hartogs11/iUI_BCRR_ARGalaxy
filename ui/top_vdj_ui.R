top_vdj_ui <- function() {
  tabItem(
    tabName = "top_vdj",
    dropdownButton(
      #All filter options
      tags$h3("Filter options:"),
      
      selectInput("sample_top_vdj", "Select Sample:", choices = unique(df_recombination$Sample)),
      
      sliderTextInput(
        inputId = "top_genes",
        label = "How many top VDJ recombination to show:",
        choices = c(1,5,10,25,50,100,250,500),
        grid = TRUE
      ),
      
      circle = "TRUE",
      icon = icon("gear"), width = "300px",
      tooltip = tooltipOptions(title = "Click to see filter options!")
    ),
    
    #Visualization
    plotOutput("top_VDJ")
    
  )
}
