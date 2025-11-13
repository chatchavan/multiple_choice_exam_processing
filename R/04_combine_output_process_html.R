library(tidyverse)
library(fs)
library(glue)

path_eval <- "workspace/07 Evaluation output/"
path_combined <- "workspace/08 Combined output and HTML/"

path_csv <- path(path_combined, "_all_students.csv")
path_html <- path(path_combined, "HTML")
html_file_name <- "midterm_part_1.html"

full_points <-  25

#===============================================================================
# combine CSV files
df_all <- 
  dir_ls(path_eval, recurse = TRUE, type = "file", regexp = ".+csv$") |> 
  map_dfr(~ read_delim(.x, delim = ";", col_types = cols(.default = "c")))

write_csv(df_all, path_csv)


#===============================================================================
# unzip all HTML files


unzip_to_target <- function(zip_path, target_dir){
  dir_create(target_dir, recurse = TRUE)
  
  unzip(zipfile = zip_path,
        exdir   = target_dir,
        junkpaths = FALSE)   # keep internal directory structure
}

unzip_all_zips <- function(source_folder, target_folder){
  zip_files <- dir_ls(path   = source_folder,
                      glob   = "*.zip",
                      type   = "file",
                      recurse = TRUE) 
  
  # Loop over the list and unzip each one
  invisible(
    lapply(zip_files, function(zf){
      message("Unzipping ", zf, " → ", target_folder)
      unzip_to_target(zf, target_folder)
    })
  )
}


unzip_all_zips(path_eval, path_html)


#===============================================================================
# replace HTML

## remove the <td>Mark:</td><td>5</td> pattern
remove_mark_td <- function(txt) {
  txt %>% str_remove_all(
    "<\\s*td\\s*>\\s*Mark:\\s*<\\/\\s*td\\s*>\\s*<\\s*td\\s*>\\s*\\d+\\s*<\\/\\s*td\\s*>"
  )
}

## add “ out of `full_points` point” to <td>Points:</td><td>10</td>
add_suffix_to_points <- function(txt) {
  txt %>% str_replace_all(
    regex("<\\s*td\\s*>\\s*Points:\\s*<\\/\\s*td\\s*>\\s*<\\s*td\\s*>\\s*(\\d+)\\s*<\\/\\s*td\\s*>",
          ignore_case = FALSE),
    sprintf("<td>Points:</td><td>\\1 out of %d points</td>", full_points)
  )
}



process_html_file <- function(path) {
  txt <- read_file(path)
  
  txt_cleaned <- txt %>%
    remove_mark_td() %>%
    add_suffix_to_points()
  
  # Write back only if something changed
  if (!identical(txt, txt_cleaned)) {
    write_file(txt_cleaned, path)
    message("Updated: ", path)
  } else {
    message("No changes needed: ", path)
  }
  
  # rename file
  old_abs   <- path_abs(path)
  dir_name  <- path_dir(old_abs)
  new_path  <- path(dir_name, html_file_name)
  file_move(old_abs, new_path)
  
  message(glue("{old_abs} → {new_path}"))
}


# process the HTML files
dir_ls(
    path = path_html,
    type = "file",
    pattern = "\\.html$",
    recursive = TRUE,
    full.names = TRUE
  ) |> 
    walk(process_html_file)

