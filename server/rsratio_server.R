source("modules/rs_ratio_module.R")
source("modules/file_upload_module.R")

#Data preprocessing
df_ratio <- read_rs_ratio_data("Data/R-S_Ratio")

# Generating inputdata for R-S Ratio visualization
sample_names_ratio <- unique(df_ratio$Sample)
Group_names_ratio <- unique(df_ratio$Group)
Immunoglobulin_names_ratio <- unique(df_ratio$Immunoglobulin)
Filtering_names_ratio <- unique(df_ratio$Filtering)

# Initialize a reactiveVal to track the uploaded data
uploaded_data <- reactiveVal(NULL)

#Initialize a reactiveVal to track the filter options
filter_options <- reactiveVal(NULL)

rsratio_server <- function(input, output, session) {
  #Make select all/none buttons
  observe({
    updateCheckboxGroupButtons(
      session,"group_rsrat", choices = Group_names_ratio,
      selected = if(input$all_groups_rsrat) Group_names_ratio
    )
    updateCheckboxGroupButtons(
      session, "sample_rsrat", choices = sample_names_ratio,
      selected = if(input$all_samples_rsrat) sample_names_ratio
    )
    updateCheckboxGroupButtons(
      session, "filtering_rsrat", choices = Filtering_names_ratio,
      selected = if(input$all_filtering_rsrat) Filtering_names_ratio
    )
  })
  
  # Upload button click handler
  observeEvent(input$upload_rsratio, {
    # Check if a ZIP file was uploaded
    if (!is.null(input$zip_rsratio)) {
      # Read and process the uploaded data
      df_uploaded <- read_and_process_uploaded_data(input$zip_rsratio$datapath, input$renaming_option_rsratio == "With Renaming", input$new_filenames_rsratio)
      
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
  
  #Looks at all the filter options the user made and filter the dataframe with these options
  plotData_ratio <- reactive({
    df_ratio %>%
      filter(Immunoglobulin == input$immunoglobulin_rsrat) %>%
      filter(Group %in% input$group_rsrat) %>%
      filter(Sample %in% input$sample_rsrat) %>%
      filter(Filtering %in% input$filtering_rsrat)
  })
  
  #Looks what immunoglobulin is chosen and makes the corresponding plot title
  plotTitle_ratio <- function(){
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
  
  #Retrieves y axis slider values
  y_slider_values <- reactive({
    input$y_slider_ratio
  })
  
  violinOptions <- function(){
    if (input$violin_rsrat == "Grouped")
      violin_display <- "group"
    else if (input$violin_rsrat == "Overlayed")
      violin_display <- "overlay"
    return(violin_display)
  }
  
  #Uses plotly to make the violin plot with the filtered data and correct plot title
  groupedViolin <- renderPlotly({
    dataForPlot <- plotData_ratio()
    title_ratio <- plotTitle_ratio()
    violin_display <- violinOptions()
    FR = dataForPlot$FR
    CDR = dataForPlot$CDR
    
    # Retrieve chosen color palette
    selected_palette <- input$palette_rsratio
    
    selected_palette <- brewer.pal(n = length(unique(dataForPlot$Group)), name = selected_palette)
    
    #Hoverfunction in ggplot acts weird, so then we calculate the mean en median and put it in the dataframe
    dataForPlot <- dataForPlot %>%
      group_by(Group, Immunoglobulin) %>%
      mutate(
        median_FR = ifelse(all(is.numeric(FR)), median(FR), NA),
        mean_FR = ifelse(all(is.numeric(FR)), mean(FR), NA),
        median_CDR = ifelse(all(is.numeric(CDR)), median(CDR), NA),
        mean_CDR = ifelse(all(is.numeric(CDR)), mean(CDR), NA),
        num_samples_in_group = n_distinct(Sample)
      ) %>%
      ungroup()
    
    # Determine which groups of samples to display on the x-axis based on user choice
    x_axis_variable <- if (input$xaxis_display_rsratio == "Samples") {
      ~Sample
    } else {
      ~Group
    }
    
    #Makes the actual violin plot
    fig <- dataForPlot %>%
      plot_ly(type = "violin",
              text = ~paste(
                if (input$xaxis_display_rsratio == "Samples") {
                  paste("Sample:", Sample)
                } else {
                  paste("Group:", Group, "<br>
                        Mean FR Group:", round(mean_FR, 2), "<br>
                        Median FR Group:", round(median_FR, 2), "<br>
                        Mean CDR Group:", round(median_CDR, 2), "<br>
                        Median CDR Group:", round(median_CDR, 2), "<br>
                        Number of Samples in Group:", num_samples_in_group)
                }
              ))
    
    # Customize the hoverlabel for a neat display
    fig <- fig %>%
      layout(hoverlabel = list(
        bgcolor = "white",
        bordercolor = "black",
        font = list(family = "Arial", size = 12),
        align = "left"
      ))
    
    fig <- fig %>%
      add_trace(
        x = x_axis_variable,
        y = ~ FR,
        name = "FR",
        box = list(visible = T),
        meanline = list(visible = T),
        spanmode = "hard"
      )
    
    fig <- fig %>%
      add_trace(
        x = x_axis_variable,
        y = ~ CDR,
        name = "CDR",
        box = list(visible = T),
        meanline = list(visible = T),
        spanmode = "hard"
      )
    
    #Make all the axis titles and the plot title
    fig <- fig %>%
      layout(
        title = list(text = title_ratio),
        xaxis = list(title = "Groups", rangemode = "tozero"),
        yaxis = list(title = "FR and CDR ratio frequency", rangemode = "tozero", range = y_slider_values()),
        violinmode = violin_display
      )
    
    fig
  })
  
  #Uses plotly to make the violin plot with the filtered data and correct plot title
  splittedViolin <- renderPlotly({
    dataForPlot <- plotData_ratio()
    title_ratio <- plotTitle_ratio()
    FR = dataForPlot$FR
    CDR = dataForPlot$CDR
    
    # Retrieve chosen color palette
    selected_palette <- input$palette_rsratio
    
    selected_palette <- brewer.pal(n = length(unique(dataForPlot$Group)), name = selected_palette)
    
    #Hoverfunction in ggplot acts weird, so then we calculate the mean en median and put it in the dataframe
    dataForPlot <- dataForPlot %>%
      group_by(Group, Immunoglobulin) %>%
      mutate(
        median_FR = ifelse(all(is.numeric(FR)), median(FR), NA),
        mean_FR = ifelse(all(is.numeric(FR)), mean(FR), NA),
        median_CDR = ifelse(all(is.numeric(CDR)), median(CDR), NA),
        mean_CDR = ifelse(all(is.numeric(CDR)), mean(CDR), NA),
        num_samples_in_group = n_distinct(Sample)
      ) %>%
      ungroup()
    
    # Determine which groups of samples to display on the x-axis based on user choice
    x_axis_variable <- if (input$xaxis_display_rsratio == "Samples") {
      ~Sample
    } else {
      ~Group
    }
    
    #Makes the actual violin plot
    fig <- dataForPlot %>%
      plot_ly(type = "violin",
              text = ~paste(
                if (input$xaxis_display_rsratio == "Samples") {
                  paste("Sample:", Sample)
                } else {
                  paste("Group:", Group, "<br>
                        Mean FR Group:", round(mean_FR, 2), "<br>
                        Median FR Group:", round(median_FR, 2), "<br>
                        Mean CDR Group:", round(median_CDR, 2), "<br>
                        Median CDR Group:", round(median_CDR, 2), "<br>
                        Number of Samples in Group:", num_samples_in_group)
                }
              ))
    
    # Customize the hoverlabel for a neat display
    fig <- fig %>%
      layout(hoverlabel = list(
        bgcolor = "white",
        bordercolor = "black",
        font = list(family = "Arial", size = 12),
        align = "left"
      ))
    
    fig <- fig %>%
      add_trace(
        x = x_axis_variable,
        y = ~ FR,
        name = "FR",
        side = "negative",
        box = list(visible = T),
        meanline = list(visible = T),
        spanmode = "hard"
      )
    
    fig <- fig %>%
      add_trace(
        x = x_axis_variable,
        y = ~ CDR,
        name = "CDR",
        side = "positive",
        box = list(visible = T),
        meanline = list(visible = T),
        spanmode = "hard"
      )
    
    #Make all the axis titles and the plot title
    fig <- fig %>%
      layout(
        title = list(text = title_ratio),
        xaxis = list(title = "Groups", rangemode = "tozero"),
        yaxis = list(title = "FR and CDR ratio frequency", range = y_slider_values()),
        violinmode = "overlay"
      )
    
    fig
  })
  
  scatterDots <- renderPlotly({
    dataForPlot <- plotData_ratio()
    title_ratio <- plotTitle_ratio()
    FR = dataForPlot$FR
    CDR = dataForPlot$CDR
    
    fig <- plot_ly(
      data = dataForPlot,
      x = ~ Sample,
      y = ~FR,
      name = "FR",
      type = "scatter",
      mode = "markers"
    )
    
    fig <- fig %>%
      add_trace(
        x = ~ Sample,
        y = ~ CDR,
        name = "CDR",
        type = "scatter",
        mode = "markers"
      )
    
    fig <- fig %>% layout(
      title = list(text = title_ratio),
      xaxis = list(title = "Samples"),
      yaxis = list(title = "FR and CDR ratio frequency", range = y_slider_values())
    )
    fig
  })
  
  observe({
    if (input$xaxis_display_rsratio == "Groups") {
      if (input$violin_rsrat == "Grouped" | input$violin_rsrat == "Overlayed")
        output$RSRatio <- groupedViolin
      else if (input$violin_rsrat == "Splitted")
        output$RSRatio <- splittedViolin
    } else {
      output$RSRatio <- scatterDots
    }
  })
  
  
  #Statistics Report
  output$stats_rsratio <- renderPrint({
    dataForStats <- plotData_ratio()
    
    if (is.null(dataForStats)) {
      return(NULL)
    }

    # Remove rows with missing values in 'FR' and 'CDR' columns
    dataForStats <- na.omit(dataForStats)
    
    cat("Summary Statistics for Filtered Data:\n")
    cat("Number of Data Points: ", nrow(dataForStats), "\n")
    cat("Mean FR: ", mean(dataForStats$FR), "\n")
    cat("Median FR: ", median(dataForStats$FR), "\n")
    cat("Mean CDR: ", mean(dataForStats$CDR), "\n")
    cat("Median CDR: ", median(dataForStats$CDR), "\n")
    
    })
  
  }
