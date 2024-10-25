# Generates exam answer sheets for multiple-choice exam

library(tidyverse)
library(fs)
library(qpdf)
library("exams")
options(exams_tex = "tools") # use LaTeX that was installed outside R



n_questions <- 20      # max. 45 questions (limit of the `exams` package)
n_choice <- 3          # Note: If changing the number of choices, edit the "Answerlist", "exsolution", and "exshuffle" below to match the number
student_id_length <- 8
exam_title <- "Fundamentals of People-Oriented Computing (HS 2024)"
exam_date <- "2024-11-01"
n_answer_sheets <- 3   # number of unique exam ID versions to generate


root_path <- "example/"
output_path <- path(root_path, "01 Exam sheets")
output_first_page_path <- path(root_path, "02 Exam sheets - firstpage only")
question_file_path <- path(root_path, "00 Questions")

#-------------------------------------------------------------------------------
# enumerate question files

question_file_paths <- dir_ls(question_file_path, type = "file", regexp = "[.]rmd$")

#-------------------------------------------------------------------------------
# generate the PDF exam files

the_seed <- 123
set.seed(the_seed)
exams2nops(
  as.list(question_file_paths), 
  n = n_answer_sheets,
  nchoice = n_choice,
  reglength = student_id_length,
  
  dir = output_path,
  
  # appearance 
  title = exam_title,
  date = exam_date,
  institution = "University of Zurich",
  logo = NULL,
  blank = 0,
  duplex = FALSE,
  twocolumn = TRUE)


#-------------------------------------------------------------------------------
# keep only the first page of each version of the exam sheet
pdf_paths <- dir_ls(output_path, type = "file", regexp = "[.]pdf$")

for (a_pdf_path in pdf_paths) {
  firstpage_output_path <- path(output_first_page_path, path_file(a_pdf_path))
  pdf_subset(a_pdf_path, pages = 1, output = firstpage_output_path)
}

