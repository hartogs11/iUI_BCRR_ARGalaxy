vdj_ui <- function() {
  tabItem(
    tabName = "vdj",
    dropdownButton(
      #All filter options
      tags$h3("Filter options:"),
      
      checkboxGroupButtons(
        inputId = "group_vdj",
        label = "Groups to show:",
        choices = c(group_names_vdj),
        selected = c(group_names_vdj),
        justified = TRUE
      ),
      
      checkboxInput(
        inputId = "all_groups_vdj",
        label = "Select All/None groups",
        value = TRUE
      ),
      
      checkboxGroupButtons(
        inputId = "sample_vdj",
        label = "Samples to show:",
        choices = c(sample_names_vdj),
        selected = c(sample_names_vdj),
        direction = "vertical",
        justified = TRUE
      ),
      
      checkboxInput(
        inputId = "all_samples_vdj",
        label = "Select All/None samples",
        value = TRUE
      ),
      
      sliderInput("freq_vdj", "Minimal frequency:", min = 0, max = max_freq, value = 10),
      
      circle = "TRUE",
      icon = icon("gear"), width = "300px",
      tooltip = tooltipOptions(title = "Click to see filter options!")
    ),
    
    #Visualization
    visNetworkOutput("VDJ"),
    
    
    #Statistics report
    verbatimTextOutput("stats_vdj")
    
  )
}
