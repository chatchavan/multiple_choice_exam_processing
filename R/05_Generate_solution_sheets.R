library(tidyverse)
library(fs)
library("exams")
options(exams_tex = "tools") # use LaTeX that was installed outside R

n_questions <- 20      # max. 45 questions (limit of the `exams` package)
n_choice <- 3          # Note: If changing the number of choices, edit the "Answerlist", "exsolution", and "exshuffle" in the exam Markdown files to match
exam_title <- "Fundamentals of People-Oriented Computing"
exam_date <- "2025-11-07"  # format YYYY-MM-DD
student_id_length <- 8 # UZH: 12-345-678
the_institution = "University of Zurich"

question_file_path <- "/Users/chat/Library/Mobile Documents/com~apple~CloudDocs/_Projects/Projects and roles/IfI Lecturer - role/FPOC - IfI course/Exam/01 FPOC Exam 2025 - Obsidian"
image_file_path <- "workspace/02 Images/"
output_root_path <- "workspace/05 Solutions"

#-------------------------------------------------------------------------------
# custom question order for each version of the exam
question_order <- tribble(
  ~answersheet_id, ~question_indices,
  10101, c(1, 2,   3, 4, 5, 6,     7, 8, 9, 10, 11, 12,    13, 14,      15, 16,    17, 18, 19, 20),
  20101, c(2, 1,   3, 4, 6, 5,     7, 10, 11, 8, 9, 12,    13, 14,      16, 15,    17, 20, 18, 19),
  10003, c(1, 2,   6, 5, 4, 3,     12, 11, 9, 10, 8, 7,    14, 13,      15, 16,    17, 19, 18, 20),
  40104, c(2, 1,   6, 4, 3, 5,     10, 12, 11, 9, 7, 8,    13, 14,      16, 15,    17, 19, 20, 18)
)

#-------------------------------------------------------------------------------
# load question files
question_file_paths <- dir_ls(question_file_path, type = "file", regexp = "[.]md$")

image_file_path_abs <- path_abs(here::here(image_file_path))


#-------------------------------------------------------------------------------
# function to generate the PDF exam files

generate_solution <- function(the_question_paths, the_answersheet_id) {
  
  path_output <- path(output_root_path, the_answersheet_id)
  dir_create(path_output)
  
  
  exams2pdf(
    the_question_paths,
    dir = path_output,
    template = "templates/solution.tex",
    inputs = dir_ls(image_file_path_abs),
    header = list(ID = the_answersheet_id, Date = exam_date, Title = exam_title, Institution = the_institution)
    
  )
  # 
  # exams2nops(
  #   the_question_paths,
  #   dir = path_output,
  #   startid = the_answersheet_id,
  #   # n = n_answer_sheets,   # number of unique exam ID versions to generate (Not used because the question order is manually customized)
  #   nchoice = n_choice,
  #   reglength = student_id_length,
  #   inputs = dir_ls(image_file_path_abs),
  #   
  #   # appearance 
  #   title = exam_title,
  #   date = exam_date,
  #   institution = the_institution,
  #   logo = NULL,
  #   blank = 0,
  #   duplex = FALSE,
  #   showpoints = TRUE,
  #   twocolumn = FALSE,
  #   header = "\\renewenvironment{question}{\\item \\begin{samepage}}{\\end{samepage}}" # prevent page-break from a question
  # )  
}

#-------------------------------------------------------------------------------
# main()

the_seed <- 123
set.seed(the_seed)

for (i in 1:nrow(question_order)) {
  question_indices <- question_order$question_indices[[i]]
  answersheet_id <- question_order$answersheet_id[i]
  generate_solution(
    question_file_paths[question_indices], 
    answersheet_id)
}

