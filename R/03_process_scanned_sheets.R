library(tidyverse)
library(fs)
library("exams")


root_path <- "workspace/"
exam_start_id <- "10003"

register_path <- path(root_path, "04 Student info.csv")
meta_data_path <- path(root_path, sprintf("03 Generated exam answersheet/%s/metainfo.rds", exam_start_id))
processed_zip_path <- path(root_path, sprintf("06 Processed zip/%s", exam_start_id))
eval_output_path <- path(root_path, sprintf("07 Evaluation output/%s", exam_start_id))
exam_scan_path <- path(root_path, sprintf("05 Exam scan - %s.pdf", exam_start_id))

#-------------------------------------------------------------------------------
dir_create(processed_zip_path, recurse = TRUE)
dir_create(eval_output_path, recurse = TRUE)
#-------------------------------------------------------------------------------
# process the scan

scan_results <- 
  nops_scan(exam_scan_path,  
            verbose = TRUE,
            dir = processed_zip_path)

# check and manually fix problems
# nops_fix(
  # Sys.glob(path(root_path, "04 Processed zip/nops_scan_*.zip")))


#-------------------------------------------------------------------------------
# evaluation
ev1 <- nops_eval(
  register = register_path,
  solutions = meta_data_path,
  scans = Sys.glob(path(processed_zip_path, "nops_scan_*.zip")),
  eval = exams_eval(partial = FALSE, negative = FALSE),
  dir = eval_output_path
)
