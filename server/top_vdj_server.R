# Load required module
source("modules/vdj_module.R")

# Read V(D)J recombination data
df_recombination <- read_vdj_recombination_data("Data/VDJ_genes_timepoints/ClonalityComplete.txt")

# Make max freq and max count values
max_freq <- max(df_recombination$Freq_VDJ)
max_count <- max(df_recombination$Count)

# Define the Shiny server function
top_vdj_server <- function(input, output, session) {
  # Reactive function to filter data based on user input
  filteredData_vdj <- reactive({
    df_filtered <- df_recombination %>%
      filter(Sample == input$sample_top_vdj)
    
    return(df_filtered)
  })
  
  # Reactive function to add the slider top genes to the filter options
  plotData_top_vdj <- reactive({
    df_filtered <- filteredData_vdj()
    head_select <- input$top_genes
    df_filtered <- df_filtered[order(-df_filtered$Count),]
    df_filtered <- head(df_filtered, head_select)
    
    return(df_filtered)
  })
  
  
  
  # Render the V(D)J recombination plot
  output$top_VDJ <- renderPlot({
    df_filtered <- plotData_top_vdj()
    
    ggplot(df_filtered, aes(axis1 = Top.V.Gene, axis2 = Top.D.Gene, axis3 = Top.J.Gene, y = Freq_VDJ)) +
      geom_alluvium(aes(fill = Alpha), width = 0.2) +
      geom_stratum() +
      geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
      theme_minimal() +
      ggtitle("Top V(D)J recombination viewer") +
      theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()
      )
  })
}
