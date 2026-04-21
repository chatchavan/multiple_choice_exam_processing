library(tidyverse)
library(fs)
library("exams")


root_path <- "workspace/"
exam_start_id <- "All"

register_path <- path(root_path, "04 Student info.csv")
meta_data_path <- path(root_path, sprintf("03 Generated exam answersheet/%s/metainfo.rds", exam_start_id))
processed_zip_path <- path(root_path, sprintf("06 Processed zip/%s", exam_start_id))
eval_output_path <- path(root_path, sprintf("07 Evaluation output/%s", exam_start_id))
exam_scan_path <- path(root_path, sprintf("05 Exam scan/Scan%s.pdf", exam_start_id))

#-------------------------------------------------------------------------------
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
    path(root_path, "06 Processed zip", exam_start_id, "nops_scan_*.zip")
  )

# check and manually fix problems
nops_fix(scans = output_zip_path)

#-------------------------------------------------------------------------------
# evaluation
ev1 <- nops_eval(
  register = register_path,
  solutions = meta_data_path,
  scans = output_zip_path,
  eval = exams_eval(partial = FALSE, negative = FALSE),
  dir = eval_output_path
)
