source("modules/mutation_frequency_module.R")
source("modules/file_upload_module.R")

# Data preprocessing
df_mut_freq <- read_mut_freq_data("Data/Frequency_mutation")

# Generating inputdata voor Mutation Frequency visualization
Sample_names_mutfreq <- unique(df_mut_freq$Sample)
Group_names_mutfreq <- unique(df_mut_freq$Group)
Timepoint_names_mutfreq <- unique(df_mut_freq$Timepoint)
Immunoglobulin_names_mutfreq <- c("IgA", "IgG", "IgM", "Naive IgM", "Memory IgM")

# Initialize a reactiveVal to track the uploaded data
uploaded_data <- reactiveVal(NULL)

#Initialize a reactiveVal to track the filter options
filter_options <- reactiveVal(NULL)

# Reactive value for storing selected samples
selected_samples <- reactiveVal(NULL)

mutfreq_server <- function(input, output, session) {
  # Makes the select all, none buttons
  observe({
    updateCheckboxGroupButtons(
      session, "group_mutfreq", choices = Group_names_mutfreq,
      selected = if (input$all_groups_mutfreq) Group_names_mutfreq
    )
    
    observeEvent(input$group_mutfreq, {
      # Filter available samples based on selected groups
      filtered_samples <- df_mut_freq %>%
        filter(Group %in% input$group_mutfreq)
      
      Sample_names_mutfreq <- unique(filtered_samples$Sample)
      Timepoint_names_mutfreq <- unique(filtered_samples$Timepoint)
      
      # Update checkboxGroupButtons for sample with unique samples from filtered samples
      updateCheckboxGroupButtons(session, "sample_mutfreq", choices = Sample_names_mutfreq, selected = Sample_names_mutfreq)
      
      # Update selectInput for timepoint with unique timepoints from filtered samples
      updateCheckboxGroupButtons(session, "timepoint_mutfreq", choices = Timepoint_names_mutfreq, selected = Timepoint_names_mutfreq)
      
      
    })
  })
  
  
  # Upload button click handler
  observeEvent(input$upload_mutfreq, {
    # Check if a ZIP file was uploaded
    if (!is.null(input$zip_mutfreq)) {
      # Read and process the uploaded data
      df_uploaded <- read_and_process_uploaded_data(input$zip_mutfreq$datapath, input$renaming_option_mutfreq == "With Renaming", input$new_filenames_mutfreq)
      
      # Update the uploaded_data reactiveVal with the new data
      uploaded_data(df_uploaded)
      
      # Update filter_options with the new filter options
      filter_options(list(
        immunoglobulin = unique(df_uploaded$Immunoglobulin),
        group = unique(df_uploaded$Group),
        sample = unique(df_uploaded$Sample),
        timepoint = unique(df_uploaded$Timepoint)
      ))
      
      # Clear the upload fields   
      updateRadioButtons(session, "renaming_option_mutfreq", selected = "Without Renaming")
      updateTextInput(session, "new_filenames_mutfreq", value = "")
    }
  })
  
  # Update filter options in filter UI
  observe({
    if (!is.null(filter_options())) {
      # Update selectInput for immunoglobulin
      updateSelectInput(session, "immunoglobulin_mutfreq", choices = filter_options()$immunoglobulin)
      
      # Update checkboxGroupButtons for group
      updateCheckboxGroupButtons(session, "group_mutfreq", choices = filter_options()$group)
      
      # Update checkboxGroupButtons for sample
      updateCheckboxGroupButtons(session, "sample_mutfreq", choices = filter_options()$sample)
      
      # Update checkboxGroupButtons for timepoint
      updateCheckboxGroupButtons(session, "timepoint_mutfreq", choices = filter_options()$timepoint)
    }
  })
  
  
  #Looks at all the filter options the user made and filter the dataframe with these options
  #If the Immunoglobulin IgM is selected, both groups Memory IgM and Naive IgM are shown
  # Use uploaded_data reactiveVal for the data to display in the plot
  plotData_mutfreq <- reactive({
    if (!is.null(uploaded_data())) {
      return(uploaded_data())
    } else {
      df_filtered <- df_mut_freq %>%
        filter(Immunoglobulin %in% input$immunoglobulin_mutfreq) %>%
        filter(Group %in% input$group_mutfreq) %>%
        filter(Sample %in% input$sample_mutfreq)
      
      # Check if timepoints are selected, if yes, apply filter
      if (!is.null(input$timepoint_mutfreq)) {
        df_filtered <- df_filtered %>%
          filter(Timepoint %in% input$timepoint_mutfreq)
      }
      
      return(df_filtered)
    }
  })
  
  
  #Looks what immunoglobulin is chosen and makes the corresponding plot title
  # Looks what immunoglobulin is chosen and makes the corresponding plot title
  plotTitle_mutfreq <- function() {
    immunoglobulin <- input$immunoglobulin_mutfreq
    x_axis <- input$xaxis_display_mutfreq
    
    title_mut_freq <- switch(
      immunoglobulin,
      "IgM" = {
        switch(
          x_axis,
          "Groups" = "Somatic hypermutation frequency of IgM per group",
          "Samples" = "Somatic hypermutation frequency of IgM per sample",
          "Timepoints" = "Somatic hypermutation frequency of IgM per timepoint"
        )
      },
      "IgA" = {
        switch(
          x_axis,
          "Groups" = "Somatic hypermutation frequency of IgA per group",
          "Samples" = "Somatic hypermutation frequency of IgA per sample",
          "Timepoints" = "Somatic hypermutation frequency of IgA per timepoint"
        )
      },
      "Naive IgM" = {
        switch(
          x_axis,
          "Groups" = "Somatic hypermutation frequency of Naive IgM per group",
          "Samples" = "Somatic hypermutation frequency of Naive IgM per sample",
          "Timepoints" = "Somatic hypermutation frequency of Naive IgM per timepoint"
        )
      },
      "IgG" = {
        switch(
          x_axis,
          "Groups" = "Somatic hypermutation frequency of IgG per group",
          "Samples" = "Somatic hypermutation frequency of IgG per sample",
          "Timepoints" = "Somatic hypermutation frequency of IgG per timepoint"
        )
      },
      "default" = "Somatic hypermutation frequency per sample"
    )
    
    return(title_mut_freq)
  }
  
  
  #Retrieves y axis slider values
  y_slider_values <- reactive({
    input$y_slider_mutfreq
  })
  
  #Makes the actual plot
  output$mutFreq <- renderPlotly({
    dataForPlot <- plotData_mutfreq()
    title_mut_freq <- plotTitle_mutfreq()
    
    # Retrieve chosen color palette
    selected_palette <- input$palette_mutfreq
    
    selected_palette <- brewer.pal(n = length(unique(dataForPlot$Group)), name = selected_palette)
    
    #Hoverfunction in ggplot acts weird, so then we calculate the mean en median and put it in the dataframe
    dataForPlot <- dataForPlot %>%
      group_by(Sample, Group, Immunoglobulin) %>%
      mutate(
        median_sample = median(percentage_mutations),
        mean_sample = mean(percentage_mutations),
        num_timepoints = n_distinct(Timepoint),
        timepoints = paste(unique(Timepoint), collapse = ", ")
      ) %>%
      group_by(Group, Immunoglobulin) %>%
      mutate(
        median_group = median(percentage_mutations),
        mean_group = mean(percentage_mutations),
        num_samples_in_group = n_distinct(Sample)
      ) %>%
      ungroup()
    
    #Determine which groups of samples or timepoints to display on the x-axis based on user choice
    x_axis_variable <- switch(input$xaxis_display_mutfreq,
                              "Groups" = ~Group,
                              "Samples" = ~Sample,
                              "Timepoints" = ~Timepoint
    )
    
    #Makes the violin plots, including the hover function
    p <- dataForPlot %>%
      plot_ly(
        x = x_axis_variable,
        y = ~percentage_mutations,
        split = ~Group,
        type = "violin",
        color = ~Group,
        colors = c(selected_palette),
        box = list(visible = T, hoverinfo = "none"),
        meanline = list(visible = T, hoverinfo = "none"),
        spanmode = "hard",
        hoverinfo = "text",
        text = ~paste(
          if (input$xaxis_display_mutfreq == "Samples") {
            paste("Sample:", Sample, 
                  "<br>Mean Sample:", round(mean_sample, 2), 
                  "<br>Median Sample:", round(median_sample, 2),
                  "<br>Number of Timepoints:", num_timepoints,
                  "<br>Timepoints:", timepoints)
          } else if (input$xaxis_display_mutfreq == "Timepoints") {
            paste("Sample:", Sample,
                  "<br>Mean Sample:", round(mean_sample, 2),
                  "<br>Timepoint:", Timepoint)
          } else {
            paste("Group:", Group, 
                  "<br>Mean Group:", round(mean_group, 2), 
                  "<br>Median Group:", round(median_group, 2), 
                  "<br>Number of Samples in Group:", num_samples_in_group)
          }
        )
      )
    
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
        title = list(text = title_mut_freq),
        yaxis = list(title = "Mutation frequency in %",
                     range = y_slider_values())
      )
    
    if (input$xaxis_display_mutfreq == "Samples") {
      p <- p %>%
        layout(xaxis = list(title = "Sample"))
    } else if (input$xaxis_display_mutfreq == "Timepoints"){
      p <- p %>%  
        layout(xaxis = list(title = "Timepoint"))
    } else {
      p <- p %>%
        layout(xaxis = list(title = "Group"))
    }
    p
  })
  
  # Statistics Report
  
  
  # Modifying the statistics output
  output$stats_mutfreq <- renderPrint({
    dataForStats <- plotData_mutfreq()
    
    if (is.null(dataForStats)) {
      return(NULL)
    }
    
    x_axis_variable <- switch(input$xaxis_display_mutfreq,
                              "Groups" = "Group",
                              "Samples" = "Sample",
                              "Timepoints" = "Timepoint")
    
    # Check if at least two unique x-axis variables are selected
    if (length(unique(dataForStats[[x_axis_variable]])) < 2) {
      cat("Select at least two x-axis variables for statistics.")
    } else {
      stats <- dataForStats %>%
        group_by(!!sym(x_axis_variable), Immunoglobulin) %>%
        summarize(
          Median = median(percentage_mutations),
          Mean = mean(percentage_mutations),
          SD = sd(percentage_mutations),
          Variance = var(percentage_mutations),
          Count = n_distinct(Sample),
          Q1 = quantile(percentage_mutations, 0.25),
          Q3 = quantile(percentage_mutations, 0.75)
        ) %>%
        ungroup()
      
      cat("Detailed Statistics for the selected data:\n")
      print(stats)
      
      # Perform ANOVA
      anova_formula <- as.formula(paste("percentage_mutations ~ ", x_axis_variable))
      anova_results <- aov(anova_formula, data = dataForStats)
      cat("\nANOVA results:\n")
      print(summary(anova_results))
      
      # Check for significance in ANOVA
      p_value_anova <- summary(anova_results)[[1]]$`Pr(>F)`[1]
      
      # Check if ANOVA is significant
      if (p_value_anova < 0.05) {
        cat("\n p value of ANOVA test < 0.05\n")
        cat("Alternative Hypothesis (Ha): At least one pair of groups has a significantly different mean.\n")
        cat("\nPost-hoc Tests (Tukey HSD):\n")
        posthoc_anova <- TukeyHSD(anova_results)
        print(posthoc_anova)
        
      } else {
        cat("\n p value of ANOVA test > 0.05\n")
        cat("Null Hypothesis (H0): There is no significant difference between the means of any two groups.")
      }
    }
    
    
  })
  
  
  
}



