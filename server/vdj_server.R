source("modules/vdj_module.R")

df_recombination <- read_vdj_recombination_data("Data/VDJ_genes_timepoints/ClonalityComplete.txt")

#Make sample and group name lists
sample_names_vdj <- unique(df_recombination$Sample)
group_names_vdj <- unique(df_recombination$Group)
max_freq <- max(df_recombination$Freq)



vdj_server <- function(input, output, session) {
  #Makes the select all, none buttons
  observe({
    updateCheckboxGroupButtons(
      session,"group_vdj", choices = group_names_vdj,
      selected = if(input$all_groups_vdj) group_names_vdj
    )
    updateCheckboxGroupButtons(
      session, "sample_vdj", choices = sample_names_vdj,
      selected = if(input$all_samples_vdj) sample_names_vdj
    )
  })
  
  
  output$VDJ <- renderVisNetwork({
    df_recombination <- df_recombination[df_recombination$Freq > 20, ]
    nodes <- unique(c(df_recombination$Top.V.Gene, df_recombination$Top.D.Gene, df_recombination$Top.J.Gene))
    
    # Create nodes
    nodes_df <- data.frame(id = nodes, label = nodes)
    
    # Create edges
    edges_df <- data.frame(from = df_recombination$Top.V.Gene, to = df_recombination$Top.D.Gene, arrows = "to", value = df_recombination$Freq) %>%
      rbind(data.frame(from = df_recombination$Top.D.Gene, to = df_recombination$Top.J.Gene, arrows = "to", value = df_recombination$Freq))
    
    visNetwork(nodes_df, edges_df, width = "100%") %>%
      visEdges(smooth = TRUE) %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visInteraction(navigationButtons = TRUE)
  })
  
  output$stats_vdj <- renderPrint({
    stats <- df_recombination %>%
      group_by(Group, Sample) %>%
      summarize(
        Median = median(Freq),
        Mean = mean(Freq),
        SD = sd(Freq),
        Variance = var(Freq),
        Q1 = quantile(Freq, 0.25),
        Q3 = quantile(Freq, 0.75)
      ) %>%
      ungroup()
    
    cat("Detailed Statistics for the selected data:\n")
    print(stats)
  })
  
}

