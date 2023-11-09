# Function to read and process uploaded ZIP file
read_and_process_uploaded_data <- function(path, rename_files = FALSE, new_filenames = NULL) {
  # Unzip the uploaded ZIP file
  unzip(path, exdir = "uploaded_data")
  
  # List all the text files in the extracted directory
  uploaded_files <- list.files("uploaded_data", pattern = ".txt", full.names = TRUE)
  
  # Check if file renaming is required
  if (rename_files && !is.null(new_filenames)) {
    # Split the new_filenames input into a vector
    new_filenames <- strsplit(new_filenames, ",")[[1]]
    
    # Rename the uploaded files with the new filenames
    for (i in 1:length(uploaded_files)) {
      file.rename(uploaded_files[i], file.path("uploaded_data", paste0(new_filenames[i], ".txt")))
    }
  }
  
  # Process the uploaded data (similar to your existing data preprocessing code)
  df_uploaded <- read_mut_freq_data("uploaded_data")
  
  return(df_uploaded)
}

read_and_process_single_file <- function(){
  
}
