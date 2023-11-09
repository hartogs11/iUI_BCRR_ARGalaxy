read_vdj_recombination_data <- function(file) {
  # Read input file
  df_vdjvar <- read.delim(file)
  df_vdjvar <- select(df_vdjvar, 1,3,4,5,63)
  df_inputvdj <- df_vdjvar
  df_inputvdj$Group = sub("^([[:alpha:]]*).*", "\\1", df_inputvdj$Sample)
  
  #dataframe for vdj recombination plot
  df_vdjvar <- df_vdjvar %>% separate(Sample, c("Sample", "Timepoint"))
  df_vdjvar$Sample <- gsub("g", "",as.character(df_vdjvar$Sample))
  df_vdjvar$Timepoint <- gsub("g", "",as.character(df_vdjvar$Timepoint))
  df_vdjvar$Group = sub("^([[:alpha:]]*).*", "\\1", df_vdjvar$Sample)
  df_vdjvar <- na.omit(df_vdjvar)
  df_percentage <- data.frame(table(df_vdjvar$Sample))
  col_names <- c("Sample", "Total_count")
  colnames(df_percentage) <- col_names
  df_vdjvar <- merge(df_vdjvar, df_percentage, by = "Sample")
  
  df_occurence <- data.frame(table(df_vdjvar$Top.V.Gene, df_vdjvar$Top.D.Gene, df_vdjvar$Top.J.Gene))
  col_names <- c("Top.V.Gene", "Top.D.Gene", "Top.J.Gene", "Count")
  colnames(df_occurence) <- col_names
  df_occurence <- df_occurence[(df_occurence$Count != 0),]
  df_occurence <- df_occurence[order(-df_occurence$Count),]
  df_occurence <- merge(df_occurence, df_vdjvar)
  df_occurence$ID <- NULL
  df_occurence <- df_occurence %>%
    mutate(Freq = round(Count/Total_count*100))
  df_occurence <- unique(df_occurence)
  
  #Make sample and group name lists
  sample_names_vdj <- unique(df_vdjvar$Sample)
  group_names_vdj <- unique(df_vdjvar$Group)
  
  return(df_occurence)
}

#df_recombination <- read_vdj_recombination_data("Data/VDJ_genes_timepoints/ClonalityComplete.txt")
