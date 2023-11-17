#---Preprocessing---
# Function to read and process mutation frequency data
read_mut_freq_data <- function(path) {
  all_files <- list.files(path, pattern = "*.txt", full.names = TRUE)
  df_mut_freq <- data.frame()
  
  for (file in all_files) {
    df_add <- read.delim(file, dec = ",")
    i <- tail(unlist(gregexpr("[0-9]", file)), n = 1)
    j <- unlist(gregexpr("[0-9]", file))[1]
  
    Sample <- gsub("Data/Frequency_mutation/", "", substr(file, 1, i))
    
    if (startsWith(Sample, "uploaded_data/")) {
      Sample <- gsub("uploaded_data/", "", Sample)
    }
    
    #Check if Sample contains an underscore
    if (grepl("_", Sample)) {
      #Split Sample into Sample and Timepoint
      sample_parts <- strsplit(Sample, "_")[[1]]
      Sample <- sample_parts[1]
      Timepoint <- sample_parts[2]
    } else {
      Timepoint <- NA
    }
    
    Immunoglobulin <- switch(
      substr(file, i + 1, i + 1),
      "a" = "IgA",
      "g" = "IgG",
      "m" = ifelse(df_add$percentage_mutations < 2, "Naive IgM", "Memory IgM"),
      "default_case" = "Naive IgM"
    )
    Group <- gsub("Data/Frequency_mutation/", "", substr(file, 1, j - 1))
    if (startsWith(Group, "uploaded_data/")) {
      Group <- gsub("uploaded_data/", "", Group)
    }
    
    df_add <- df_add %>%
      mutate(Sample = Sample, Timepoint = Timepoint, Immunoglobulin = Immunoglobulin, Group = Group) %>%
      select(Sample, Timepoint, Immunoglobulin, Group, everything())
    
    df_mut_freq <- bind_rows(df_mut_freq, df_add)
  }
  
  df_mut_freq <- df_mut_freq %>%
    select(Sample, Timepoint, Group, Immunoglobulin, `Sequence.ID`, `percentage_mutations`, `best_match`, `VRegionMutations`, `VRegionNucleotides`)
  df_mut_freq$percentage_mutations <- as.numeric(as.character(df_mut_freq$percentage_mutations))
  return(df_mut_freq)
}

