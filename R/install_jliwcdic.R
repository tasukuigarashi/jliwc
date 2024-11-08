#' Install J-LIWC dictionary file
#' @param dir a path to a directory to install a J-LIWC2015 dictionary
#' @param dic a path to a dictionary file. If \code{NULL}, you can choose a file via a file chooser.
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
                             dic = NULL,
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

        dic_path <- file.path(dir, dic_format) |> path.expand()

        isdir <- file.info(dic_path)$isdir
        isdic <- file.exists(dic_path)

        if (any(isdir, na.rm = TRUE) | !any(isdic)) {
          # dir <- ifelse(isdir, dic, dirname(dic))

          # Copy the dictionary file to the home directory
          cat("The LIWC dictionary file '", paste0(dic_format, collapse = "', '"),
            "' is not found at ", dir, "\n\n",
            sep = ""
          )
        } else {
          dic_file <- basename(dic_path[isdic])
          cat("The LIWC dictionary file '", dic_file, "' is found at ", dir, "\n\n", sep = "")
          # dictliwc <- read_dict(dic[isdic], format = names(dic_format)[isdic])
        }

        # cat("You have three options:\n\n")
        # # choose 1 or 2
        # cat("1. (default) Install the dictionary file at ", dir, " (for later use) and load it\n", sep = "")
        # cat("2. Only load the dictionary file (do not copy it)\n", sep = "")
        # cat("3. Quit\n\n")

        # copy <- readline("Please type 1, 2, or 3 (ESC or CTRL+C to quit): ")

        # while (!copy %in% 1:3) {
        #   copy <- readline("Please type 1, 2, or 3 (ESC or CTRL+C to quit): ")
        # }

        # if (copy == 3) {
        #   message("The installation is canceled.\n")
        #   return(FALSE)
        # }

        copy <- readline("Do you install the J-LIWC2015 dictionary? [Y/N] ")

        while (!copy %in% c("Y", "N", "y", "n")) {
          copy <- readline("Do you install the J-LIWC2015 dictionary? [Y/N] ")
        }

        if (copy %in% c("N", "n")) {
          message("The installation is cancelled.")
          return(invisible(FALSE))
        }

        # choose the dictionary file if dic is NULL
        if (is.null(dic)) {
          cat("Please choose the dictionary file (another window opens). If you can't find the window, reduce the size of the current R/RStudio window.\n")
          if (capabilities("tcltk")) {
            dic <- tcltk::tk_choose.files()
          } else {
            dic <- file.choose()
          }
        }

        # Stop if dic does not match dic_file
        dic_file <- basename(dic)
        if (!dic_file %in% dic_format) {
          stop("The dictionary file must be named '", paste(dic_format, collapse = "', '"), "'.", call. = FALSE)
        }

        # Read the dictionary file
        format <- names(dic_format)[dic_format == basename(dic)]
        dictliwc <- read_dict(dic, format = format)

        # Copy the dictionary file to the home directory
        if (!dir.exists(dir)) {
          dir.create(dir, recursive = TRUE)
        }

        file.copy(from = dic, to = dir)
        message("The dictionary file is copied to ", dir, "\n")
        dic <- file.path(dir, dic_file) # Not necessary

        # save the dictionary path to the configuration file
        save_jliwc_config(dic, "jliwcdic")

        # if (!silent) message("The LIWC dictionary file '", dic_file, "' is successfully loaded from ", dir, "\n")
        if (!silent) cat("\u2714  The LIWC dictionary file '", dic_file, "' is successfully installed.\n")

        options(jliwc_dictfile = dictliwc)
        # Set the option for the dictionary file
        return(invisible(TRUE))
      },
      warning = function(w) {
        message(w)
        message("\nThe LIWC dictionary file is not properly installed/loaded.")
        return(invisible(FALSE))
      },
      error = function(e) {
        message(e)
        message("\nThe LIWC dictionary file is not properly installed/loaded.")
        return(invisible(FALSE))
      }
    )
  })
  invisible(check)
}
