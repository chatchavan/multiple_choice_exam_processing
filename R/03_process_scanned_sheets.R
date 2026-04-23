library(tidyverse)
library(fs)
library("exams")

student_id_length <- 8 # UZH: 12-345-678
root_path <- "workspace/"

meta_data_path <- path(root_path,"03.1-combinedRDS.rds")
register_path <- path(root_path, "04 Student info.csv")
exam_scan_path <- path(root_path, "05 Exam scan.pdf")
processed_zip_path <- path(root_path, "06 Processed zip/")
eval_output_path <- path(root_path, "07 Evaluation output/")


#-------------------------------------------------------------------------------
register_clean_path <- path(root_path, "04.1 Student info clean.csv")

dir_create(processed_zip_path, recurse = TRUE)
dir_create(eval_output_path, recurse = TRUE)
#-------------------------------------------------------------------------------
# process the scan

scan_results <- 
  nops_scan(exam_scan_path,  
            verbose = TRUE,
            dir = processed_zip_path)

# output zip path
output_zip_path <- 
  Sys.glob(
    path(root_path, "06 Processed zip", "nops_scan_*.zip")
  )

# check and manually fix problems
nops_fix(scans = output_zip_path)


#-------------------------------------------------------------------------------
# prep register into the right form

reg_df <- read_delim(register_path, col_types = cols(.default = col_character()))
assertthat::has_name(reg_df, "registration")
assertthat::has_name(reg_df, "name")
assertthat::has_name(reg_df, "id")

# remove dashes in the ID
reg_df <- 
  reg_df %>% 
  mutate(registration = str_replace_all(registration, "-", ""))   

# ensure student id length
assertthat::see_if(all(str_length(reg_df$registration) == student_id_length))

# use semi-colon
write_delim(reg_df, register_clean_path, delim = ";")

#-------------------------------------------------------------------------------
# evaluation
ev1 <- nops_eval(
  register = register_clean_path,
  solutions = meta_data_path,
  scans = output_zip_path,
  eval = exams_eval(partial = FALSE, negative = FALSE),
  dir = eval_output_path
)
