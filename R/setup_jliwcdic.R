#' Set J-LIWC2015 dictionary path
#' @param dir a path to the J-LIWC2015 dictionary
#' @param format A format of the dictionary (LIWC2015 or LIWC22)
#'
#' @importFrom utils read.csv
#'
#' @return Boolean, \code{TRUE} if the setup is successful,
#'   \code{FALSE} otherwise
#'
#' @examples
#' setup_jliwcdic()
#' @export
#'
setup_jliwcdic <- function(dir = getOption("jliwc_project_home"),
                           format = getOption("jliwc_format", default = "LIWC2015")) {
  format <- match.arg(format, c("LIWC2015", "LIWC22"))

  # Dictionary file name
  dic_format <- c(LIWC2015 = "Japanese_Dictionary.dic", LIWC22 = "LIWC2015 Dictionary - Japanese.dicx")
  dic_file <- dic_format[[format]]

  dic <- file.path(dir, dic_file)

  dic <- path.expand(dic)
  isdir <- file.info(dic)$isdir

  if (isdir | !file.exists(dic)) {
    # dir <- ifelse(isdir, dic, dirname(dic))

    # Copy the dictionary file to the home directory
    cat("The LIWC dictionary file '", dic_file, "' was not found at ", dir, "\n\n", sep = "")
    cat("You have two options:\n\n")
    # choose 1 or 2
    cat("1. Read the dictionary file, copy it to ", dir, " for later use (default)\n", sep = "")
    cat("2. Only read the dictionary file (do not copy it)\n\n", sep = "")
    cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
    copy <- readline()

    while (!copy %in% 1:2) {
      cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
      copy <- readline()
    }

    # choose the dictionary file
    cat("Please choose the dictionary file (another window opens). If you can't find the window, reduce the size of the current R/RStudio window.\n\n")
    dic <- file.choose()

    # Stop if dic does not match dic_file
    if (basename(dic) != dic_file) {
      stop("The dictionary file must be named '", dic_file, "'.", call. = FALSE)
    }

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

  message("The LIWC dictionary file '", dic_file, "' was successfully loaded.")
}
