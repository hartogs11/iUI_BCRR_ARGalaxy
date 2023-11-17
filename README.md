# Interactive user-friendly interface for B-cell receptor repertoire analysis: extending the functionality of Antigen Receptor Galaxy

[![GitHub](https://img.shields.io/badge/GitHub-hartogs11-blue)](https://github.com/hartogs11/iUI_BCRR_ARGalaxy)

## Project Description

The project is a web-based data visualization and analysis tool built using R and Shiny. It aims to provide users with interactive visualizations and insights into three different biological datasets related to V(D)J recombination, R-S ratio, and mutation frequency. The application helps researchers and biologists explore these datasets to gain a deeper understanding of the underlying data patterns and relationships.

## Table of Contents

- [Folder Structure](#folder-structure)
- [Data and Files](#data-and-files)
- [Usage](#usage)
- [R Packages](#r-packages)
- [Modules](#modules)
- [User Manual](#manual)


## Folder Structure

The project has the following folder structure:

- `app.R`: The main application file.
- `ui/`: Contains user interface components.
  - `general_info_ui.R`: UI for General Information.
  - `mutfreq_ui.R`: UI for SHM Frequency.
  - `rsratio_ui.R`: UI for R-S Ratio.
  - `vdj_ui.R`: UI for V(D)J Recombination Viewer.
- `server/`: Contains server logic for corresponding UI components.
  - `general_info_server.R`: Server logic for General Information.
  - `mutfreq_server.R`: Server logic for SHM Frequency.
  - `rsratio_server.R`: Server logic for R-S Ratio.
  - `vdj_server.R`: Server logic for V(D)J Recombination Viewer.
- `modules/`: Contains module files.
  - `file_upload_module.R`: Module for reading and processing uploaded data.
  - `mutation_frequency_module.R`: Module for mutation frequency data preprocessing.
  - `rs_ratio_module.R`: Module for R-S Ratio data preprocessing.
  - `vdj_module.R`: Module for V(D)J recombination data.

## Data and Files

- The VDJ visualization uses data from the file `ClonalityComplete.txt`.

- The R-S Ratio visualization uses data from the `Data/R-S_Ratio` directory. There is also an upload button to upload new data in a zip file.

- The Mutation Frequency visualization uses data from the `Data/Frequency_mutation` directory. There is also an upload button to upload new data in a zip file.

## Usage

1. Make sure you have the required R packages installed.

2. Run the `app.R` file to start the Shiny application locally.

3. Follow the instructions in the application to explore and analyze different visualizations.

## R Packages
This project utilized various R packages for different purposes. Here is a list of the used packages and their key functionalities:

- **shiny**: Shiny is used to develop and deploy interactive web applications.
- **shinydashboard**: shinydashboard is used to create a dashboard-like layout for the Shiny application.
- **shinyWidgets**: shinyWidgets is used to create a nice-looking filter option input areas.
- **tidyverse**: tidyverse is used for data reshaping and making data suitable for visualization.
- **dplyr**: dplyr is used for data manipulation and data frame filtering.
- **plotly**: plotly is used to create interactive plots and visualizations.
- **readr**: readr is used to import and read data from various file formats.
- **ggplot2**: ggplot2 is used for data visualization and chart production.
- **shinyFiles**: shinyFiles is used for file upload functionality in the Shiny app.
- **RColorBrewer**: RColorBrewer is used to change the colors of the visualisation and to import color-blind friendly color palettes.
- **visNetwork**: visNetwork is used to create the visNetwork visualization for the V(D)J recombination plot

## Modules

Purpose of each module in your project.

- `file_upload_module.R`: Handles the reading and processing of uploaded data.
- `mutation_frequency_module.R`: Processes mutation frequency data.
- `rs_ratio_module.R`: Processes R-S Ratio data.
- `vdj_module.R`: Processes V(D)J recombination data.

## User Manual

### Somatic Hypermutation Frequency Visualization
The `mutfreq_ui.R` and `mutfreq_server.R` files handle the user interface and server logic for the Mutation Frequency visualization. This section provides a brief user manual for interacting with this specific module.

#### Filter Options
- **Immunoglobulin:** Choose the immunoglobulin (e.g., IgA, IgG, IgM, Naive IgM, Memory IgM) for analysis.
- **Groups to Show:** Select the groups to display in the visualization.
- **Samples to Show:** Choose specific samples for visualization.
- **Timepoints to Show:** Select timepoints for visualization. You can choose to display all timepoints or select specific ones.

#### Visualization Options
- **Color Palette:** Choose a color-blind-friendly color palette for the visualization (e.g., Set1, Set2, Set3, Dark2).
- **X-Axis Display:** Decide what information to display on the x-axis (Groups, Samples, or Timepoints).
- **Custom Y-Axis Slider:** Adjust the Y-axis range using the slider.

#### Upload Options
- **Upload ZIP file:** Upload a ZIP file containing mutation frequency data. The application will extract and process the data. Please ensure that the ZIP file contains only `scatter.txt` files generated by the SHM&CSR pipeline of ARGalaxy. 
- **Choose an Upload Option:** Select whether to upload data with or without renaming the files.
- **New Filenames:** If renaming, provide new filenames (comma-separated).
- **Upload Data:** Click to initiate the data upload and processing.

#### Visualization
The main panel displays a violin plot representing the mutation frequency. The plot can be customized based on the chosen filter and visualization options.

#### Statistics Report
This section provides detailed statistics for the selected data, including median, mean, standard deviation, variance, count, and quartiles. Additionally, the ANOVA results are displayed, and post-hoc Tukey HSD tests are performed if the ANOVA is significant.
