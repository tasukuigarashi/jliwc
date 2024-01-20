#' Load J-LIWC Dictionary File
#'
#' This function loads the J-LIWC dictionary file from a specified directory.
#' It sets a temporary directory to avoid errors related to installing IPADIC
#' in a path that includes full-byte characters.
#'
#' @param dir The directory from which to load the J-LIWC dictionary file.
#'   Defaults to the value set in the 'jliwc_project_home' option.
#'   Note that it is not a path to a dictionary file, but a path to a
#'   directory that contains the dictionary file.
#' @param silent Logical; if `FALSE`, prints messages to the console about the
#'   loading process. Defaults to `FALSE`.
#'
#' @return Invisibly returns `TRUE` if the dictionary file is successfully loaded.
#'   If an error occurs during the loading process, the function will stop and print
#'   an error message. If a warning is raised during the loading process, it will
#'   return `FALSE` and print the warning message.
#'
#' @examples
#' \dontrun{
#' # To load the dictionary from the default project home directory:
#' load_jliwcdic()
#'
#' # To load the dictionary from a specified directory and suppress messages:
#' load_jliwcdic("/path/to/dictionary", silent = TRUE)
#' }
#'
#' @export
#'
load_jliwcdic <- function(dir = getOption("jliwc_project_home"),
                          # format = getOption("jliwc_format", default = "LIWC2015"),
                          silent = FALSE) {
  # set the temporary directory to avoid errors to install IPADIC
  # to the path including full-byte characters
  temp_dir <- tempdir()
  withr::with_dir(temp_dir, {
    check <- tryCatch(
      {
        # Check the format
        # format <- match.arg(format, c("LIWC2015", "LIWC22"))

        # Dictionary file name
        dic_format <- getOption("jliwc_dic_filename")

        dic <- file.path(dir, dic_format) |> path.expand()

        isdir <- file.info(dic)$isdir
        isdic <- file.exists(dic)

        if (any(isdir, na.rm = TRUE) | !any(isdic)) {
          message("\nThe LIWC dictionary file is not properly installed/loaded.\n")
          stop()
        } else {
          dic_file <- basename(dic[isdic])
          dictliwc <- read_dict(dic[isdic], format = names(dic_format)[isdic])
        }

        if (!silent) message("The LIWC dictionary file '", dic_file, "' was successfully loaded from ", dir, "\n")
        options(jliwc_dictfile = dictliwc)
        # Set the option for the dictionary file
        return(TRUE)
      },
      warning = function(w) {
        message(w)
        return(FALSE)
      },
      error = function(e) {
        message(e)
        return(FALSE)
      }
    )
  })
  invisible(check)
}
