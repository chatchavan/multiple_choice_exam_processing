library(tidyverse)
library(fs)

output_path <- "example/00 Questions"
n_questions <- 20      # max. 45 questions (limit of the `exams` package)


# Uncomment the following lines if using a temporary path
# output_path <- file_temp()
# on.exit(unlink(output_path, recursive = TRUE), add = TRUE)

#-------------------------------------------------------------------------------
question_template <- "
Question
========
Q
\
![](image.pdf)

Answerlist
----------
* Correct
* x
* y


Meta-information
================
exname: Question %d
extype: schoice
exsolution: 100
exshuffle: 3
expoints: 1
"

#-------------------------------------------------------------------------------
# generate dummy question files

dir_create(output_path)

file_paths <- path(output_path, sprintf("q%02d.rmd", 1:n_questions))

for (i in 1:n_questions) {
  q_text <- sprintf(question_template, i)
  write_file(q_text, file_paths[i])
}

# utils::browseURL(output_path)   # to check the content of the temp path

## NOTE: If there's an error like "Error in open.connection(file, "wb") : cannot open the connection"
## Just re-run the lines above line-by-line manually, and it'll just work. The reason is unknown.
