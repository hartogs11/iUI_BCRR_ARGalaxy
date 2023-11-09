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
            
            selectInput(
              inputId = "violin_rsrat",
              label = "Overlayed, grouped, or splitted violin plots (only works with groups on xaxis):",
              choices = c("Overlayed", "Grouped", "Splitted")
            ),
            
            circle = TRUE,
            icon = icon("gear"), width = "300px",
            tooltip = tooltipOptions(title = "Click to see filter options!")
          ),
          #Visualization
          plotlyOutput("RSRatio"),
          
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
          actionButton("upload_rsratio", "Upload Data"),
          
          #Choose color palette for plot
          selectInput(
            inputId = "palette_rsratio",
            label = "Select Color Palette:",
            choices = c("Set1", "Set2", "Set3", "Dark2", "Paired"),
            selected = "Dark2"
          ),
          #Option to select groups or samples on xaxis
          selectInput(
            inputId = "xaxis_display_rsratio",
            label = "What should be displayed on the x-axis:",
            choices = c("Groups", "Samples"),
            selected = "Groups"),
          
          #Custom y-axis
          sliderInput(
            inputId = "y_slider_rsratio",
            label = "Custom Y-Axis Slider:",
            min = 0, max = 100,
            value = c(0, 10)
          ),
          
          #Statistics report
          verbatimTextOutput("stats_rsratio")
  )
  
}