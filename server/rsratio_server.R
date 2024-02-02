source("modules/rs_ratio_module.R")
source("modules/file_upload_module.R")

# Data preprocessing
df_ratio <- read_rs_ratio_data("Data/R-S_Ratio")

# Generating input data for R-S Ratio visualization
sample_names_ratio <- unique(df_ratio$Sample)
Group_names_ratio <- unique(df_ratio$Group)
Immunoglobulin_names_ratio <- unique(df_ratio$Immunoglobulin)
Filtering_names_ratio <- unique(df_ratio$Filtering)

# Initialize a reactiveVal to track the uploaded data
uploaded_data <- reactiveVal(NULL)

# Initialize a reactiveVal to track the filter options
filter_options <- reactiveVal(NULL)

rsratio_server <- function(input, output, session) {
  # Make select all/none buttons
  observe({
    updateCheckboxGroupButtons(
      session, "group_rsrat", choices = Group_names_ratio,
      selected = if (input$all_groups_rsrat) Group_names_ratio
    )
    
    observeEvent(input$group_rsrat, {
      # Filter available samples based on selected groups
      filtered_samples <- df_ratio %>%
        filter(Group %in% input$group_rsrat)
      
      sample_names_ratio <- unique(filtered_samples$Sample)
      
      # Update checkboxGroupButtons for sample with unique samples from filtered samples
      updateCheckboxGroupButtons(session, "sample_rsrat", choices = sample_names_ratio, selected = sample_names_ratio)
    })
  })
  
  # Upload button click handler
  observeEvent(input$upload_rsratio, {
    # Check if a ZIP file was uploaded
    if (!is.null(input$zip_rsratio)) {
      # Read and process the uploaded data
      df_uploaded <- read_and_process_uploaded_data(
        input$zip_rsratio$datapath,
        input$renaming_option_rsratio == "With Renaming",
        input$new_filenames_rsratio
      )
      
      # Update the uploaded_data reactiveVal with the new data
      uploaded_data(df_uploaded)
      
      # Update filter_options with the new filter options
      filter_options(list(
        immunoglobulin = unique(df_uploaded$Immunoglobulin),
        group = unique(df_uploaded$Group),
        sample = unique(df_uploaded$Sample),
        filtering = unique(df_uploaded$Filtering)
      ))
      
      # Clear the upload fields
      updateRadioButtons(session, "renaming_option_rsratio", selected = "Without Renaming")
      updateTextInput(session, "new_filenames_rsratio", value = "")
    }
  })
  
  # Update filter options in filter UI
  observe({
    if (!is.null(filter_options())) {
      # Update selectInput for immunoglobulin
      updateSelectInput(session, "immunoglobulin_rsrat", choices = filter_options()$immunoglobulin)
      
      # Update checkboxGroupButtons for group
      updateCheckboxGroupButtons(session, "group_rsrat", choices = filter_options()$group)
      
      # Update checkboxGroupButtons for sample
      updateCheckboxGroupButtons(session, "sample_rsrat", choices = filter_options()$sample)
      
      # Update checkboxGroupButtons for filtering
      updateCheckboxGroupButtons(session, "filtering_rsrat", choices = filter_options()$filtering)
    }
  })
  
  # Looks at all the filter options the user made and filter the dataframe with these options
  plotData_ratio <- reactive({
    if (!is.null(uploaded_data())) {
      return(uploaded_data())
    } else {
      df_filtered <- df_ratio %>%
        filter(Immunoglobulin == input$immunoglobulin_rsrat) %>%
        filter(Group %in% input$group_rsrat) %>%
        filter(Sample %in% input$sample_rsrat) %>%
        filter(Filtering %in% input$filtering_rsrat)
      return(df_filtered)
    }
  })
  
  # Looks what immunoglobulin is chosen and makes the corresponding plot title
  plotTitle_ratio <- function() {
    if (input$immunoglobulin_rsrat == "IgM")
      title_ratio <- "FR and CDR ratio frequency of IgM per group"
    else if (input$immunoglobulin_rsrat == "IgA")
      title_ratio <- "FR and CDR ratio frequency of IgA per group"
    else if (input$immunoglobulin_rsrat == "IgG")
      title_ratio <- "FR and CDR ratio frequency of IgG per group"
    else if (input$immunoglobulin_rsrat == "Naive IgM")
      title_ratio <- "FR and CDR ratio frequency of Naive IgM per group"
    return(title_ratio)
  }
  
  # Retrieves y axis slider values
  y_slider_values <- reactive({
    input$y_slider_rsratio
  })
  
  # Retrieve color values from user input
  color_fr <- reactive({
    validate(
      need(!is.null(input$color_fr), "Please enter a color for FR.")
    )
    return(input$color_fr)
  })
  
  color_cdr <- reactive({
    validate(
      need(!is.null(input$color_cdr), "Please enter a color for CDR.")
    )
    return(input$color_cdr)
  })
  
  # Choose between overlayed and grouped display
  display_type <- reactive({
    return(tolower(input$display_type))
  })
  
  # Makes the actual plot
  output$RSRatio <- renderPlotly({
    dataForPlot <- plotData_ratio()
    title_rs_ratio <- plotTitle_ratio()
    FR = dataForPlot$FR
    CDR = dataForPlot$CDR
    
    dataForPlot <- dataForPlot %>%
      group_by(Group, Immunoglobulin) %>%
      mutate(
        median_FR_group = median(FR),
        mean_FR_group = mean(FR),
        median_CDR_group = median(CDR),
        mean_CDR_group = mean(CDR),
        num_samples_in_group = n_distinct(Sample)
      ) %>%
      ungroup()
    
    # Initialize the plot object
    p <- plot_ly(data = dataForPlot)
    
    # Add scatter points for FR
    p <- p %>%
      add_trace(
        x = ~Group,
        y = ~FR,
        type = "scatter",
        mode = "markers",
        name = "FR",
        hoverinfo = "text",
        marker = list(color = color_fr()),
        text = ~paste("FR",
                      "<br>Group:", Group,
                      "<br>Mean Group:", round(mean_FR_group, 2),
                      "<br>Median Group:", round(median_FR_group, 2),
                      "<br>Number of Samples in Group:", num_samples_in_group
        )
      )
    
    # Add scatter points for CDR
    p <- p %>%
      add_trace(
        x = ~Group,
        y = ~CDR,
        type = "scatter",
        mode = "markers",
        name = "CDR",
        hoverinfo = "text",
        marker = list(color = color_cdr()),
        text = ~paste("CDR",
                      "<br>Group:", Group,
                      "<br>Mean Group:", round(mean_CDR_group, 2),
                      "<br>Median Group:", round(median_CDR_group, 2),
                      "<br>Number of Samples in Group:", num_samples_in_group
        )
      )
    
    p <- p %>%
      add_trace(
        x = ~Group,
        y = ~FR,
        type = "box",
        name = "FR",
        hoverinfo = "text",
        line = list(color = color_fr()),
        fillcolor = toRGB(color_fr(), alpha = 0.5),
        text = ~paste("FR",
                      "<br>Group:", Group,
                      "<br>Mean Group:", round(mean_FR_group, 2),
                      "<br>Median Group:", round(median_FR_group, 2),
                      "<br>Number of Samples in Group:", num_samples_in_group
        )
      ) %>%
      add_trace(
        x = ~Group,
        y = ~CDR,
        type = "box",
        name = "CDR",
        hoverinfo = "text",
        line = list(color = color_cdr()),
        fillcolor = toRGB(color_cdr(), alpha = 0.5),
        text = ~paste("CDR",
                      "<br>Group:", Group,
                      "<br>Mean Group:", round(mean_CDR_group, 2),
                      "<br>Median Group:", round(median_CDR_group, 2),
                      "<br>Number of Samples in Group:", num_samples_in_group
        )
      )
    
    if(input$display_type == "Grouped"){
      p <- p %>% layout(boxmode = "group")
    }
    
    
    
    # Customize the hoverlabel for a neat display
    p <- p %>%
      layout(hoverlabel = list(
        bgcolor = "white",
        bordercolor = "black",
        font = list(family = "Arial", size = 12),
        align = "left"
      ))
    
    p <- p %>%
      layout(
        title = list(text = title_rs_ratio),
        xaxis = list(title = "Group"),
        yaxis = list(title = "R-S Ratio in the FR1 and CDR3 region",
                     range = y_slider_values())
      )
    
    p
  })
  
  # Statistics Report
  output$stats_rsratio <- renderPrint({
    dataForStats <- plotData_ratio()
    if (is.null(dataForStats)) {
      return(NULL)
    }
    
    cat("Detailed Statistics for the selected data:\n")
    
    # Perform statistics for FR
    stats_FR <- dataForStats %>%
      group_by(Group) %>%
      summarize(
        Median_FR = median(`FR R/S (ratio)`),
        Mean_FR = mean(`FR R/S (ratio)`),
        SD_FR = sd(`FR R/S (ratio)`),
        Variance_FR = var(`FR R/S (ratio)`),
        Count_FR = n_distinct(Sample),
        Q1_FR = quantile(`FR R/S (ratio)`, 0.25),
        Q3_FR = quantile(`FR R/S (ratio)`, 0.75),
        # Add additional statistics
        Skewness_FR = skewness(`FR R/S (ratio)`),
        Kurtosis_FR = kurtosis(`FR R/S (ratio)`)
      ) %>%
      ungroup() %>%
      select(Group, Median_FR, Mean_FR, SD_FR, Variance_FR, Count_FR, Q1_FR, Q3_FR, Skewness_FR, Kurtosis_FR)
    
    # Perform statistics for CDR
    stats_CDR <- dataForStats %>%
      group_by(Group) %>%
      summarize(
        Median_CDR = median(`CDR R/S (ratio)`),
        Mean_CDR = mean(`CDR R/S (ratio)`),
        SD_CDR = sd(`CDR R/S (ratio)`),
        Variance_CDR = var(`CDR R/S (ratio)`),
        Count_CDR = n_distinct(Sample),
        Q1_CDR = quantile(`CDR R/S (ratio)`, 0.25),
        Q3_CDR = quantile(`CDR R/S (ratio)`, 0.75),
        # Add additional statistics
        Skewness_CDR = skewness(`CDR R/S (ratio)`),
        Kurtosis_CDR = kurtosis(`CDR R/S (ratio)`)
      ) %>%
      ungroup() %>% 
      select(Group, Median_CDR, Mean_CDR, SD_CDR, Variance_CDR, Count_CDR, Q1_CDR, Q3_CDR, Skewness_CDR, Kurtosis_CDR)
    
    # Print the statistics
    cat("\nFR Statistics:\n")
    print(stats_FR)
    
    cat("\nCDR Statistics:\n")
    print(stats_CDR)
  })
}
