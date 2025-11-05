# Process multiple choice exam

A worked out template for processing the multiple-choice exam scans using the [exams package](https://www.r-exams.org/)

## Usage

1. Put the questions in the `input/01 Questions` folder. 
See each `.md` file for how to specify the questions. 
(If you need to generate a template of `.rmd` file, use `R/01_generate_question_files.R`).
Important meta-information fields are listed in a section below.

2. Name the files such that when sorting by file name, the first question appears first. (E.g., prefix with 01, 02, 03).
The order of the question file name corresponds to the question ID in the `question_order` variable in `R/02_generate_exam_template.R`.

3. Use `R/02_generate_exam_template.R` to generate answer sheets for students to fill in.
See the beginning of the file for the parameter to change such as exam title.
Also, look for the custom question order section to adjust the order.

3. After the exam, scan the sheets and use `03_process_scanned_sheets.R`.
   - In the output `nops_eval.csv`, column "points" are the score. The column "mark" is the grade. Ignore it.


## Example files
The subfolder `workspace-example` provide example files for both input and output


## Question specification meta-information

- `extype: schoice` single-choice
- `exsolution: 100` is a binary coding of the answer alternatives. The value `100` means that the first item on in the `Answerlist` is the correct answer. If you have more answers, add more code to this field.
- `exshuffle: 3` means `1` correct answer. If you give more than two answers candidates, two additional wrong answers are sampled and used.


## Adding image in the question
Use the syntax like the following. The image has to be in the image path.
```
Question
========
This is the test question 1
\
![](q1_image.pdf)
```

## Session Info
```
R version 4.3.1 (2023-06-16)
Platform: aarch64-apple-darwin20 (64-bit)
Running under: macOS Sonoma 14.7

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: Europe/Zurich
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] exams_2.4-1     fs_1.6.3        lubridate_1.9.3 forcats_1.0.0   stringr_1.5.1  
 [6] dplyr_1.1.4     purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
[11] ggplot2_3.5.0   tidyverse_2.0.0

loaded via a namespace (and not attached):
 [1] gtable_0.3.4      qpdf_1.3.3        compiler_4.3.1    Rcpp_1.0.12      
 [5] tidyselect_1.2.0  magick_2.8.5      png_0.1-8         scales_1.3.0     
 [9] fastmap_1.1.1     R6_2.5.1          generics_0.1.3    knitr_1.45       
[13] munsell_0.5.0     pillar_1.9.0      tzdb_0.4.0        rlang_1.1.3      
[17] utf8_1.2.4        stringi_1.8.3     xfun_0.42         timechange_0.3.0 
[21] cli_3.6.2         withr_3.0.0       magrittr_2.0.3    digest_0.6.34    
[25] grid_4.3.1        rstudioapi_0.15.0 askpass_1.2.0     base64enc_0.1-3  
[29] hms_1.1.3         lifecycle_1.0.4   vctrs_0.6.5       evaluate_0.23    
[33] glue_1.7.0        fansi_1.0.6       colorspace_2.1-0  rmarkdown_2.25   
[37] htmltools_0.5.7   tools_4.3.1       pkgconfig_2.0.3  
```
