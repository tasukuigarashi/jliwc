#' Download and install J-LIWC2015 user dictionary
#'
#' @param dir A home directory for J-LIWC2015
#' @param user_dic A file name of the user dictionary file
#' @param userdic_url A URL to the user dictionary file (default on GitHub)
#' @param silent Boolean. Whether to print messages
#'
#' @importFrom withr with_dir
#'
#' @return Boolean, \code{TRUE} if the setup is successful,
#'   \code{FALSE} otherwise
#'
#' @examples
#' \dontrun{
#' install_userdic()
#' }
#'
#' @export
#'
install_userdic <- function(dir = getOption("jliwc_project_home"),
                            user_dic = getOption("jliwc_USERDIC_name"),
                            userdic_url = getOption("jliwc_USERDIC_url"),
                            silent = FALSE) {
  # set the temporary directory to avoid errors to install the dictionary
  # to the path including full-byte characters
  temp_dir <- tempdir()
  withr::with_dir(temp_dir, {
    check <- tryCatch(
      {
        USERDIC <- file.path(dir, user_dic)

        if (check_userdic(dir, silent = TRUE)) {
          cat("J-LIWC2015 user dictionary is already installed at ", USERDIC, ".\n\n", sep = "")
        } else {
          cat("J-LIWC2015 user dictionary is not installed at ", USERDIC, ".\n\n", sep = "")
        }

        download <- readline("Do you install the user dictionary? [Y/N] ")

        while (!download %in% c("Y", "N", "y", "n")) {
          download <- readline("Do you install the user dictionary? [Y/N] ")
        }

        if (download %in% c("Y", "y")) {
          # make a directory "dic" in the home directory
          if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
          # download the user dictionary file from GitHub
          download.file(userdic_url,
            destfile = USERDIC, mode = "wb"
          )
          # save the file path to the configuration file
          save_jliwc_config(USERDIC, "userdic")

          cat("The user dictionary file was downloaded from GitHub.\n")
        }

        if (file.info(USERDIC)$size == 0) {
          message("The user dictionary file is found at ", dir, " but the file size is 0.\n")
        }

        # check if the user dictionary file is properly installed
        check_userdic(dir, user_dic)

        # Set USERDIC as the path to the dictionary
        options(jliwc_USERDIC = USERDIC)
        return(TRUE)
      },
      warning = function(w) {
        # This warning is probably because of the broken file
        message(w)
        message("\nUser dictionary is not properly installed (the file might be broken). Try installing it again.\n")
        return(FALSE)
      },
      error = function(e) {
        message(e)
        message("\nUser dictionary is not properly installed. Try installing it again.\n")
        return(FALSE)
      }
    )
  })

  invisible(check)
}
