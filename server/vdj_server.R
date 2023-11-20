# Load required module
source("modules/vdj_module.R")

# Read V(D)J recombination data
df_recombination <- read_vdj_recombination_data("Data/VDJ_genes_timepoints/ClonalityComplete.txt")

# Make max freq and max count values
max_freq <- max(df_recombination$Freq_VDJ)
max_count <- max(df_recombination$Count)

# Define the Shiny server function
vdj_server <- function(input, output, session) {
  # Reactive function to filter data based on user input
  plotData_vdj <- reactive({
    df_filtered <- df_recombination %>%
      filter(Sample == input$sample_vdj,
             Freq_VDJ > input$freq_vdj,
             Count > input$count_vdj)
    
    # Arrange the levels of Top.V.Gene, Top.D.Gene, Top.J.Gene based on frequency
    df_filtered$Top.V.Gene <- factor(df_filtered$Top.V.Gene, levels = unique(df_filtered$Top.V.Gene[order(-df_filtered$Freq_VDJ)]))
    df_filtered$Top.D.Gene <- factor(df_filtered$Top.D.Gene, levels = unique(df_filtered$Top.D.Gene[order(-df_filtered$Freq_VDJ)]))
    df_filtered$Top.J.Gene <- factor(df_filtered$Top.J.Gene, levels = unique(df_filtered$Top.J.Gene[order(-df_filtered$Freq_VDJ)]))
    return(df_filtered)
  })
  
  # Render the V(D)J recombination plot
  output$VDJ <- renderPlot({
    df_filtered <- plotData_vdj()
    
    ggplot(df_filtered, aes(axis1 = Top.V.Gene, axis2 = Top.D.Gene, axis3 = Top.J.Gene, y = Freq_VDJ)) +
      geom_alluvium(aes(fill = Alpha), width = 0.2) +
      geom_stratum() +
      geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
      theme_minimal() +
      ggtitle("V(D)J recombination viewer") +
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
