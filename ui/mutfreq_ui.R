mutfreq_ui <- function() {
  tabItem(
    tabName = "mutfreq",
    dropdownButton(
      #All filter options
      tags$h3("Filter options:"),
      
      selectInput(
        inputId = "immunoglobulin_mutfreq", 
        label = "Immunoglobulin:",
        choices = c(Immunoglobulin_names_mutfreq),
        selected = "IgG"
      ),
      
      checkboxGroupButtons(
        inputId = "group_mutfreq",
        label = "Groups to show:",
        choices = c(Group_names_mutfreq),
        selected = c(Group_names_mutfreq),
        justified = TRUE
      ),
      
      checkboxInput(
        inputId = "all_groups_mutfreq",
        label = "Select All/None groups",
        value = TRUE
      ),
      
      checkboxGroupButtons(
        inputId = "sample_mutfreq",
        label = "Samples to show:",
        choices = c(Sample_names_mutfreq),
        selected = c(Sample_names_mutfreq),
        direction = "vertical",
        justified = TRUE
      ),
      
      checkboxGroupButtons(
        inputId = "timepoint_mutfreq",
        label = "Timepoints to show:",
        choices = sort(Timepoint_names_mutfreq),
        selected = "none",
        direction = "vertical",
        justified = TRUE
      ),
      
      circle = "TRUE",
      icon = icon("gear"), width = "300px",
      tooltip = tooltipOptions(title = "Click to see filter options!")
    ),
    
    #Visualization
    plotlyOutput("mutFreq"),
    
    # Additional visualization options
    fluidRow(
      column(
        width = 4,
        # Grouping under a wellPanel with a title
        wellPanel(
          title = "Visualization Options",
          selectInput(
            inputId = "palette_mutfreq",
            label = "Select Color Palette:",
            choices = c("Set1", "Set2", "Set3", "Dark2"),
            selected = "Dark2"
          )
        )
      ),
      
      column(
        width = 4,
        wellPanel(
          title = "Visualization Options",
          selectInput(
            inputId = "xaxis_display_mutfreq",
            label = "What should be displayed on the x-axis:",
            choices = c("Groups", "Samples", "Timepoints"),
            selected = "Samples"
          )
        )
      ),
      
      column(
        width = 4,
        wellPanel(
          title = "Visualization Options",
          sliderInput(
            inputId = "y_slider_mutfreq",
            label = "Custom Y-Axis Slider:",
            min = 0, max = 100,
            value = c(0, 50)
          )
        )
      )
    ),
    
    # Upload options
    fluidRow(
      column(
        width = 12,
        wellPanel(
          title = "Upload Options",
          fileInput("zip_mutfreq", "Upload ZIP file:", accept = ".zip"),
          radioButtons(
            "renaming_option_mutfreq",
            "Choose an upload option:",
            choices = c("Without Renaming", "With Renaming"),
            selected = "Without Renaming"
          ),
          textInput("new_filenames_mutfreq", "New Filenames (comma-separated):", ""),
          actionButton("upload_mutfreq", "Upload Data")
        )
      )
    ),
    
    # Statistics report
    wellPanel(
      title = "Statistics Report",
      verbatimTextOutput("stats_mutfreq")
    )
  )
}
