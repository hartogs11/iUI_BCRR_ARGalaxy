general_info_ui <- function() {
  tabItem(
    tabName = "info",
    fluidRow(
      h2("Welcome to the interactive analysis of B-cell receptor repertoire", align = "center"),
      h3("-an extending functionality of ARGalaxy-", align = "center"),
      p("ARGalaxy stands for Antigen Receptor Galaxy. It is a web-based tool, which automates the analysis and visual display of data from sequencing of the B-cell receptor repertoires. A main technical aspect of ARGalaxy is the creation of multiple reports that present and visualize immune repertoire and somatic hypermutation information of input samples. In the current ARGalaxy, these reports are created as static pages and images which are sufficient for analyzing a few samples. However, when comparing a large number of samples, such as more than 10 samples, the static user interface (UI) suffers a clear limitation in viewing and navigating through complex figures and tracking each sample."),
    ),
    fluidRow(
      box(
        title = ("Somatic Hypermutation Frequency"),
        p("This is an interactive graph of the somatic hypermutation frequency. Currently in ARGalaxy, the user can only view one sample at a time, so for this visualization was the main goal to visualize all the desired samples of the user. The user can choose which immunoglobulin they want (including memory and naive IgM). The user can also choose which groups and samples are being shown. You can zoom in and zoom out in the visualization and when the user has the desired result, the visualization can be downloaded as a png file."),
      ),
      box(
        title = ("R-S ratio of FR and CDR Frequency"),
        p("This is an interactive graph of the R-S ratio of FR and CDR Frequency. Currently in ARGalaxy, this visualization isn't an option because of the one sample viewing. There is no plot or graph, but only a table with 2 values, one of FR and one of CDR. The main goal for this visualization was to create one plot where both FR and CDR values are being visualized of all the desired samples of the user. The user can choose which immunoglobulin they want (including memory and naive IgM). The user can also choose which groups and samples are being shown. The used filtering options depend on the user's filtering options in ARGalaxy. The user can also choose which data should be displayed on the x-axis. When groups are selected, a violin plot is shown. The user can choose the kind of violin plot (overlayed, splitted, and grouped). When samples are selected, a dot plot is shown. You can zoom in and zoom out in the visualization and when the user has the desired result, the visualization can be downloaded as a png file.")
      )
    )
  )
}
