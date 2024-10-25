library(tidyverse)
library(fs)
library("exams")


root_path <- "example/"
processed_zip_path <- path(root_path, "04 Processed zip")

scan_results <- 
  nops_scan(path(root_path, "03 Scan.pdf"),  
            verbose = TRUE,
            dir = processed_zip_path)

# check and manually fix problems
# nops_fix(
  # Sys.glob(path(root_path, "04 Processed zip/nops_scan_*.zip")))

ev1 <- nops_eval(
  register = path(root_path, "05 Student info.csv"),
  solutions = path(root_path, "01 Exam sheets/metainfo.rds"),
  scans = Sys.glob(path(root_path, "04 Processed zip/nops_scan_*.zip")),
  eval = exams_eval(partial = FALSE, negative = FALSE),
  dir = path(root_path, "06 Evaluation output")
)
