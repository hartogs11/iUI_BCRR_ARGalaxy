general_info_ui <- function() {
  tabItem(
    tabName = "info",
    fluidRow(
      h2("Welcome to the Interactive B-Cell Receptor Repertoire Analysis", align = "center"),
      h3("Extending the Functionality of Antigen Receptor Galaxy", align = "center"),
      p("This Shiny application offers an interactive interface for in-depth analysis of B-cell receptor repertoires. It extends the capabilities of Antigen Receptor Galaxy (ARGalaxy) and facilitates exploration of critical biological datasets related to V(D)J recombination, R-S ratio, and somatic hypermutation frequency."),
    ),
    fluidRow(
      box(
        title = "Somatic Hypermutation Frequency Visualization",
        p("Interactively explore the somatic hypermutation frequency across multiple samples. Choose the immunoglobulin type, select groups and samples, and explore timepoints. The visualization includes filter options, such as color palette selection, X-axis display preferences, and a custom Y-axis slider for adjusting the range. Upload options allow users to bring their own data or use the default dataset."),
        p("The main panel displays a violin plot representing somatic hypermutation frequency. A detailed statistics report is available, including median, mean, standard deviation, variance, count, quartiles, ANOVA results, and post-hoc Tukey HSD tests."),
        p("Data Source: 'ClonalityComplete.txt' in 'Data/VDJ_genes_timepoints' directory.")
      ),
      box(
        title = "R-S Ratio Visualization",
        p("Interactively explore the R-S ratio of FR and CDR frequency. Choose immunoglobulin types, select groups and samples, and utilize filtering options. Customize the color palette, overlayed or grouped boxplots, and adjust the Y-axis range. Upload options allow users to provide their own data."),
        p("The main panel displays scatter plots and boxplots representing the R-S ratio in the FR1 and CDR3 regions. A detailed statistics report includes median, mean, standard deviation, variance, count, quartiles, skewness, and kurtosis."),
        p("Data Source: 'shm_overview.txt' files in 'Data/R-S_Ratio' directory.")
      )
    ),
    fluidRow(
      box(
        title = "V(D)J Recombination Visualization",
        p("Explore an interactive V(D)J recombination viewer. Choose a specific sample and set minimal frequency and counts for filtering. The main panel provides an interactive display of V(D)J recombination patterns based on selected filter options."),
        p("Data Source: `ClonalityComplete.txt` file in the `Data/VDJ_genes_timepoints` directory.")
      ),
      box(
        title = "Top V(D)J Recombination Visualization",
        p("Explore the top V(D)J gene segment combinations for a specific sample. Choose the number of best gene segment combinations to display. The main panel provides an interactive display of the top V(D)J recombination patterns."),
        p("Data Source: `ClonalityComplete.txt` file in the `Data/VDJ_genes_timepoints` directory.")
      )
    ),
    fluidRow(
      box(
        title = "Folder Structure",
        p("The project follows a structured folder organization, with separate directories for 'ui', 'server', and 'modules'. Each directory contains specific files for different components and functionalities of the Shiny application.")
      ),
      box(
        title = "R Packages",
        p("The project utilizes various R packages for different purposes, including 'shiny', 'shinydashboard', 'shinyWidgets', 'tidyverse', 'dplyr', 'plotly', 'readr', 'e1071', 'ggplot2', 'shinyFiles', and 'RColorBrewer'. These packages contribute to the development, visualization, and functionality of the Shiny application.")
      )
    ),
    fluidRow(
      box(
        title = "Usage",
        p("To use the application locally, make sure you have the required R packages installed. Run the 'app.R' file to start the Shiny application, and follow the instructions within the application to explore and analyze different visualizations.")
      ),
      box(
        title = "User Manual",
        p("Refer to the user manual sections for each visualization component ('Somatic Hypermutation Frequency Visualization', 'R-S Ratio Visualization', 'V(D)J Recombination Visualization', 'Top V(D)J Recombination Visualization') for detailed instructions on filter options, visualization customization, and other functionalities.")
      )
    )
  )
}
