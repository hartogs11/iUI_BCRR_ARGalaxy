rsratio_ui <- function() {
  tabItem(tabName = "rsratio",
          dropdownButton(
            tags$h3("Filter Options:"),
            
            selectInput(
              inputId = "immunoglobulin_rsrat",
              label = "Immunoglobulin:",
              choices = c(Immunoglobulin_names_ratio)
            ),
            
            checkboxGroupButtons(
              inputId = "group_rsrat",
              label = "Groups to show:",
              choices = c(Group_names_ratio),
              selected = c(Group_names_ratio),
              justified = TRUE
            ),
            
            checkboxInput(
              inputId = "all_groups_rsrat",
              label = "Select All/None groups",
              value = TRUE
            ),
            
            checkboxGroupButtons(
              inputId = "sample_rsrat",
              label = "Samples to show:",
              choices = c(sample_names_ratio),
              selected = c(sample_names_ratio),
              direction = "vertical",
              justified = TRUE
            ),
            
            checkboxInput(
              inputId = "all_samples_rsrat",
              label = "Select All/None samples",
              value = TRUE
            ),
            
            checkboxGroupButtons(
              inputId = "filtering_rsrat",
              label = "Used filtering:",
              choices = c(Filtering_names_ratio),
              selected = c("all", "un"),
              direction = "vertical",
              justified = TRUE
            ),
            
            checkboxInput(
              inputId = "all_filtering_rsrat",
              label = "Select All/None filtering",
              value = FALSE
            ),
            
            circle = TRUE,
            icon = icon("gear"), width = "300px",
            tooltip = tooltipOptions(title = "Click to see filter options!")
          ),
          #Visualization
          plotlyOutput("RSRatio"),
          
          
          #Additional visualization options
          fluidRow(
            column(
              width = 4,
              #Grouping under a wellPanel with a title
              title = "Visualization Options",
              # Color pickers for FR and CDR
              textInput("color_fr", "Color for FR (hex):", value = "#FFC20A"),
              textInput("color_cdr", "Color for CDR (hex):", value = "#0C7BDC")
            ),
          
          column(
            width = 4,
            wellPanel(
              title = "Visualization Options",
              #Boxplot visualization options
              selectInput(
                inputId = "display_type",
                label = "Overlayed, or splitted boxplots:",
                choices = c("Overlayed", "Grouped"),
                selected = "Overlayed"
              )
            )
          ),
          
          column(
            width = 4,
            wellPanel(
              title = "Visualization Options",
              #Custom y-axis
              sliderInput(
                inputId = "y_slider_rsratio",
                label = "Custom Y-Axis Slider:",
                min = 0, max = 15,
                value = c(0, 10)
              )
            )
          )
        ),
        
        #Upload options
        fluidRow(
          column(
            width = 12,
            wellPanel(
              title = "Upload Options",
              #Upload ZIP file function
              fileInput("zip_rsratio", "Upload ZIP file:", accept = ".zip"),
              
              #Radio buttons to choose the upload option
              radioButtons(
                "renaming_option_rsratio",
                "Choose an upload option:",
                choices = c("Without Renaming", "With Renaming"),
                selected = "Without Renaming"
              ),
              # Add a text input for users to specify new filenames
              textInput("new_filenames_rsratio", "New Filenames (comma-separated):", ""),
              
              #Upload button
              actionButton("upload_rsratio", "Upload Data")
            )
          )
        ),
        
        #Statistics report
        wellPanel(
          title = "Statistics Report",
          verbatimTextOutput("stats_rsratio")
        )
  )
  
}