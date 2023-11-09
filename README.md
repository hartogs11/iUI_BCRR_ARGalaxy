# Interactive user-friendly interface for B-cell receptor repertoire analysis: extending the functionality of Antigen Receptor Galaxy

[![GitHub](https://img.shields.io/badge/GitHub-hartogs11-blue)](https://github.com/hartogs11/BAFSTU)

## Project Description

The project is a web-based data visualization and analysis tool built using R and Shiny. It aims to provide users with interactive visualizations and insights into three different biological datasets related to V(D)J recombination, R-S ratio, and mutation frequency. The application helps researchers and biologists explore these datasets to gain a deeper understanding of the underlying data patterns and relationships.

## Table of Contents

- [Folder Structure](#folder-structure)
- [Data and Files](#data-and-files)
- [Usage](#usage)
- [R Packages](#r-packages)
- [Modules](#modules)


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

