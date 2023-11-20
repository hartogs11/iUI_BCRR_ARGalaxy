# Function to read and process R-S Ratio data
read_rs_ratio_data <- function(path) {
  all_files <- list.files(path, pattern = "*.txt", full.names = TRUE)
  df_ratio <- data.frame()
  
  for (file in all_files) {
    df_add <- read.delim(file, dec = ",")
    
    # Create a list of columns to process
    columns_to_process <- c("IGA", "IGA1", "IGA2", "IGE", "IGG", "IGG1", "IGG2", "IGG3", "IGG4", "IGM", "IGE", "all", "un")
    
    # Iterate over the columns and perform the necessary calculations
    for (col in columns_to_process) {
      numerator_col <- paste0(col, ".x")
      denominator_col <- paste0(col, ".y")
      
      # Convert the columns to numeric
      df_add[[numerator_col]] <- as.numeric(df_add[[numerator_col]])
      df_add[[denominator_col]] <- as.numeric(df_add[[denominator_col]])
      
      # Perform the division operation, handle NA values by replacing with 0
      df_add[[col]] <- ifelse(is.na(df_add[[numerator_col]]) | is.na(df_add[[denominator_col]]), 0, df_add[[numerator_col]] / df_add[[denominator_col]])
    }
    
    df_add[is.na(df_add)] <- 0
    df_add <- df_add[, c(1, 38:49)]
    df_add <- df_add[9:10, ]
    df_add <- as.data.frame(t(df_add))
    colnames(df_add) <- df_add[1, ]
    df_add <- df_add[-1, ]
    
    i <- tail(unlist(gregexpr("[0-9]", file)), n = 1)
    j <- unlist(gregexpr("[0-9]", file))[1]
    
    Sample <- gsub("Data/R-S_Ratio/", "", substr(file, 1, i))
    
    # Hier controleren we of er een underscore aanwezig is in de Sample-variabele
    if (grepl("_", Sample)) {
      # Split Sample in Sample en Timepoint
      sample_parts <- strsplit(Sample, "_")[[1]]
      Sample <- sample_parts[1]
      Timepoint <- sample_parts[2]
    } else {
      Timepoint <- NA
    }
    
    Group <- gsub("Data/R-S_Ratio/", "", substr(file, 1, j - 1))
    Immunoglobulin <- switch(
      substr(file, i + 1, i + 1),
      "a" = "IgA",
      "g" = "IgG",
      "m" = "IgM",
      "_" = "Naive IgM"
    )
    df_add <- df_add %>%
      mutate(Sample = Sample, Timepoint = Timepoint, Group = Group, Immunoglobulin = Immunoglobulin, Filtering = row.names(df_add))
    
    df_ratio <- bind_rows(df_ratio, df_add)
  }
  
  df_ratio <- df_ratio %>%
    select(Sample, Timepoint, Group, Immunoglobulin, Filtering, everything())
  
  df_ratio$`FR R/S (ratio)` <- as.numeric(df_ratio$`FR R/S (ratio)`)
  df_ratio$`CDR R/S (ratio)` <- as.numeric(df_ratio$`CDR R/S (ratio)`)
  return(df_ratio)
}


