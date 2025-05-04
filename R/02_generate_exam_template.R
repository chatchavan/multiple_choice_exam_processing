# Generates exam answer sheets for multiple-choice exam

library(tidyverse)
library(fs)
import::from(assertthat, assert_that)
library("exams")
options(exams_tex = "tools") # use LaTeX that was installed outside R


n_questions <- 20      # max. 45 questions (limit of the `exams` package)
n_choice <- 3          # Note: If changing the number of choices, edit the "Answerlist", "exsolution", and "exshuffle" in the exam Markdown files to match
exam_title <- "Empirical Quantitative Methods in Computer Science"
exam_date <- "2025-05-06"
student_id_length <- 8 # UZH: 12-345-678

question_file_path <- "/Users/chat/Library/Mobile Documents/com~apple~CloudDocs/_Projects/Projects and roles/IfI Lecturer - role/QUANT - IfI course/Exam/QUANT Exam FS25 - Obsidian/Questions"
image_file_path <- "/Users/chat/Library/Mobile Documents/com~apple~CloudDocs/_Projects/Projects and roles/IfI Lecturer - role/QUANT - IfI course/Exam/QUANT Exam FS25 - Obsidian/Ψ Supports/ΩΩ Attachments"
output_root_path <- "output/01 Generated exam answersheet"

#-------------------------------------------------------------------------------
# custom question order for each version of the exam
question_order <- tribble(
  ~answersheet_id, ~question_indices,
  10101, c(1, 2, 3, 4,    5, 6, 7,  8, 9,     10, 11, 12,    13, 14,   15, 16, 17,    18, 19,    20),
  20101, c(2, 1, 3, 4,    6, 5, 7,  9, 8,     11, 10, 12,    14, 13,   15, 17, 16,    19, 18,    20),
  10003, c(4, 3, 1, 2,    7, 6, 5,  8, 9,     12, 11, 10,    13, 14,   17, 16, 15,    18, 19,    20),
  40104, c(3, 2, 1, 4,    6, 7, 5,  9, 8,     12, 11, 10,    14, 13,   15, 17, 16,    19, 18,    20)
)

#-------------------------------------------------------------------------------
# load question files
question_file_paths <- dir_ls(question_file_path, type = "file", regexp = "[.]md$")

#-------------------------------------------------------------------------------
# check consistency

# ensure that the length of question files is the same as `n_questions`
assert_that(length(question_file_paths) == n_questions, msg = "Some question-indices rows do not have all possible question indices")

# ensure that no question idex were missing in the manual shuflling
sorted_indices <- 1:n_questions
question_order |> 
  mutate(sorted_match = map_lgl(question_indices, \(x) all(sort(x) == sorted_indices))) |> 
  pull(sorted_match) |> all() |> 
  assert_that(msg = "Some question-indices rows do not have all possible question indices")
  

#-------------------------------------------------------------------------------
# function to generate the PDF exam files

generate_exam <- function(the_question_paths, the_answersheet_id) {
  
  path_output <- path(output_root_path, the_answersheet_id)
  dir_create(path_output)
  
  exams2nops(
    the_question_paths,
    dir = path_output,
    startid = the_answersheet_id,
    # n = n_answer_sheets,   # number of unique exam ID versions to generate (cannot be used if the question order is manually customized)
    nchoice = n_choice,
    reglength = student_id_length,
    inputs = dir_ls(image_file_path),
    
    # appearance 
    title = exam_title,
    date = exam_date,
    institution = "University of Zurich",
    logo = NULL,
    blank = 0,
    duplex = FALSE,
    showpoints = TRUE,
    twocolumn = FALSE,
    header = "\\renewenvironment{question}{\\item \\begin{samepage}}{\\end{samepage}}" # prevent page-break from a question
  )  
}

#-------------------------------------------------------------------------------
# 

the_seed <- 123
set.seed(the_seed)

for (i in 1:nrow(question_order)) {
  question_indices <- question_order$question_indices[[i]]
  answersheet_id <- question_order$answersheet_id[i]
  generate_exam(
    question_file_paths[question_indices], 
    answersheet_id)
}

