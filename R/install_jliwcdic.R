#' Install J-LIWC dictionary file
#' @param dir a path to the J-LIWC2015 dictionary
#' @param format A format of the dictionary (LIWC2015 or LIWC22).
#' Use this option if the dictionary type is not automatically detected.
#' @param silent Boolean. Whether to print messages
#'
#' @importFrom utils read.csv
#' @importFrom withr with_dir
#'
#' @return Boolean, \code{TRUE} if the setup is successful,
#'   \code{FALSE} otherwise
#'
#' @examples
#' \dontrun{
#' install_jliwcdic()
#' }
#'
#' @export
#'
install_jliwcdic <- function(dir = getOption("jliwc_project_home"),
                             format = getOption("jliwc_format", default = "LIWC2015"),
                             silent = FALSE) {
  # set the temporary directory to avoid errors to install IPADIC
  # to the path including full-byte characters
  temp_dir <- tempdir()
  withr::with_dir(temp_dir, {
    check <- tryCatch(
      {
        # Check the format
        format <- match.arg(format, c("LIWC2015", "LIWC22"))

        # Dictionary file name
        dic_format <- getOption("jliwc_dic_filename")

        dic <- file.path(dir, dic_format) |> path.expand()

        isdir <- file.info(dic)$isdir
        isdic <- file.exists(dic)

        if (any(isdir, na.rm = TRUE) | !any(isdic)) {
          # dir <- ifelse(isdir, dic, dirname(dic))

          # Copy the dictionary file to the home directory
          cat("The LIWC dictionary file '", paste0(dic_format, collapse = "', '"),
            "' was not found at ", dir, "\n\n",
            sep = ""
          )
        } else {
          dic_file <- basename(dic[isdic])
          cat("The LIWC dictionary file '", dic_file, "' was found at ", dir, "\n\n", sep = "")
          # dictliwc <- read_dict(dic[isdic], format = names(dic_format)[isdic])
        }

          cat("You have three options:\n\n")
          # choose 1 or 2
          cat("1. Install the dictionary file at ", dir, " (for later use) and load it (default)\n", sep = "")
          cat("2. Only load the dictionary file (do not copy it)\n", sep = "")
          cat("3. Quit\n\n")
          cat("Please type 1, 2, or 3 (ESC or CTRL+C to quit): ")
          copy <- readline()

          while (!copy %in% 1:3) {
            cat("Please type 1, 2, or 3 (ESC or CTRL+C to quit): ")
            copy <- readline()
          }

          if (copy == 3) {
            message("The installation was canceled.\n")
            return(FALSE)
          }

          # choose the dictionary file
          cat("Please choose the dictionary file (another window opens). If you can't find the window, reduce the size of the current R/RStudio window.\n\n")
          dic <- file.choose()

          # Stop if dic does not match dic_file
          if (!basename(dic) %in% dic_format) {
            stop("The dictionary file must be named '", paste(dic_format, collapse = "', '"), "'.", call. = FALSE)
          }

          # Read the dictionary file
          format <- names(dic_format)[dic_format == basename(dic)]
          dictliwc <- read_dict(dic, format = format)

          # Copy the dictionary file to the home directory
          if (copy == 1) {
            if (!dir.exists(dir)) {
              dir.create(dir, recursive = TRUE)
            }

            file.copy(from = dic, to = dir)
            message("The dictionary file was copied to ", dir, "\n")
            dic <- file.path(dir, basename(dic)) # Not necessary
            dic_file <- basename(dic)
          }

        # save the dictionary path to the configuration file
        save_jliwc_config(dic, "jliwcdic")

        if (!silent) message("The LIWC dictionary file '", dic_file, "' was successfully loaded from ", dir, "\n")
        options(jliwc_dictfile = dictliwc)
        # Set the option for the dictionary file
        return(TRUE)
      },
      warning = function(w) {
        message(w)
        message("\nThe LIWC dictionary file is not properly installed/loaded.\n")
        return(FALSE)
      },
      error = function(e) {
        message(e)
        message("\nThe LIWC dictionary file is not properly installed/loaded.\n")
        return(FALSE)
      }
    )
  })
  invisible(check)
}
