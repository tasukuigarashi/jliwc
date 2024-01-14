#' Set J-LIWC2015 dictionary path
#' @param dic path to the J-LIWC2015 dictionary
#'
#' @export
#' @examples
#' setup_jliwcdic()
#'
setup_jliwcdic <- function(dic = getOption("jliwc_dic_home"), format = c("LIWC2015", "LIWC22")) {
  # Default format is LIWC2015
  format <- match.arg(format)

  dic <- path.expand(dic)
  isdir <- file.info(dic)$isdir

  if (isdir | !file.exists(dic)) {
    dir <- ifelse(isdir, dic, dirname(dic))

    # Copy the dictionary file to the home directory
    cat("The LIWC dictionary file was not found at", dic, "\n\n")
    cat("You need to set the path to the dictionary file manually. You can copy the dictionary file from a directory to", dir, "for later use.\n\n")
    # choose 1 or 2
    cat("1. Choose the dictionary file, copy it to ", dir, ", and use it (default)\n")
    cat("2. Choose the dictionary file but do not copy it\n\n")
    cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
    copy <- readline()

    while (copy != 1 & copy != 2) {
      cat("Please type 1 or 2 (ESC to quit): ")
      copy <- readline()
    }

    # choose the dictionary file
    cat("Please choose the dictionary file (a window opens).\n")
    dic <- file.choose()

    dictliwc <- read_dict(dic, format = format)

    # Copy the dictionary file to the home directory
    if (copy == 1) {
        if (!dir.exists(dir)) {
        dir.create(dir, recursive = TRUE)
      }

      file.copy(from = dic, to = dir)
      cat("The dictionary file was copied to ", dir, "\n")
      dic <- file.path(dir, basename(dic))
    }
  } else {
    dictliwc <- read_dict(dic, format = format)
  }

  # Set the option for the dictionary file
  options(jliwc_dictfile = dictliwc)
  message("The LIWC dictionary file was successfully loaded.")

  # options(jliwc_dic_home = normalizePath(dic, winslash = "/", mustWork = TRUE))
  # cat("The path to the dictionary file was set to", dic, "\n")
}
