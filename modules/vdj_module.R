# Function to read and process VDJ recombination data
read_vdj_recombination_data <- function(file) {
  df_vdjvar <- read.delim(file)
  df_vdjvar <- select(df_vdjvar, 1, 3, 4, 5, 63)
  
  df_vdjvar <- separate(df_vdjvar, Sample, into = c("Sample", "Timepoint"), sep = "_")
  
  df_vdjvar$Sample <- gsub("g", "", as.character(df_vdjvar$Sample))
  df_vdjvar$Timepoint <- gsub("g", "", as.character(df_vdjvar$Timepoint))
  
  df_vdjvar <- na.omit(df_vdjvar)
  
  df_occurrence_VDJ <- data.frame(table(df_vdjvar$Sample, df_vdjvar$Top.V.Gene, df_vdjvar$Top.D.Gene, df_vdjvar$Top.J.Gene))
  col_names_VDJ <- c("Sample", "Top.V.Gene", "Top.D.Gene", "Top.J.Gene", "Count")
  colnames(df_occurrence_VDJ) <- col_names_VDJ
  df_occurrence_VDJ <- df_occurrence_VDJ[df_occurrence_VDJ$Count != 0, ]
  df_occurrence_VDJ <- df_occurrence_VDJ[order(-df_occurrence_VDJ$Count), ]
  
  df_total_count_VDJ <- df_occurrence_VDJ %>%
    group_by(Sample, Top.V.Gene, Top.D.Gene) %>%
    summarise(Total_count_VDJ = sum(Count), .groups = 'drop') %>%
    ungroup()
  
  df_occurrence_VDJ <- df_occurrence_VDJ %>%
    left_join(df_total_count_VDJ, by = c("Sample", "Top.V.Gene", "Top.D.Gene")) %>%
    mutate(Freq_VDJ = round(Count / Total_count_VDJ * 100))
  
  df_occurrence_VDJ$Alpha <- df_occurrence_VDJ$Freq_VDJ / 100
  
  # Convert factor columns to character
  df_occurrence_VDJ$Top.V.Gene <- as.character(df_occurrence_VDJ$Top.V.Gene)
  df_occurrence_VDJ$Top.D.Gene <- as.character(df_occurrence_VDJ$Top.D.Gene)
  df_occurrence_VDJ$Top.J.Gene <- as.character(df_occurrence_VDJ$Top.J.Gene)
  
  return(df_occurrence_VDJ)
}











