#' Setup J-LIWC2015 user dictionary
#'
#' @param dir home directory for J-LIWC2015
#' @param user_dic filename of the user dictionary file
#' @param userdic_url URL to the user dictionary file
#' @param silent whether to print messages
#'
#' @examples
#' setup_userdic()
#'
#' @export
#'
setup_userdic <- function(dir = getOption("jliwc_project_home"), user_dic = "user_dict.dic",
                          userdic_url = getOption("jliwc_USERDIC_url"), silent = FALSE) {
  USERDIC <- file.path(dir, user_dic)

  # if (!file.exists(USERDIC)) {
  #   download.file(userdic_url,
  #     destfile = USERDIC, mode = "wb"
  #   )
  # }

  # check if the user dictionary file exists at the home directory
  # if it doesn't exist, ask users if they want to download it from GitHub
  # if not, check if the user dictionary file exists at the current folder
  # if it is at the current folder, prompt and copy it to the home directory
  # if it is not at the current folder, prompt and ask the user to manually set the path to the user dictionary file
  # finally, set USERDIC as the path to the user dictionary file
  check <- tryCatch(
    {
      if (!file.exists(USERDIC)) {
        cat("J-LIWC2015 user dictionary is not installed at", dir, "\n")
        cat("Do you want to download the user dictionary file from GitHub and install?\n")
        cat("1. Yes (Enter)\n")
        cat("2. No (set the path to the user dictionary file manually) \n")
        cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
        download <- readline()

        while (!download %in% 1:2 & download != "") {
          cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
          download <- readline()
        }

        if (download == 1 | download == "") {
          # make a directory "dic" in the home directory
          if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
          # download the user dictionary file from GitHub
          download.file(userdic_url,
            destfile = USERDIC, mode = "wb"
          )
          cat("The user dictionary file was downloaded from GitHub.\n")
        } else {
          cat("Please choose the user dictionary file '", user_dic, "' (another window opens). If you can't find the window, reduce the size of the current R/RStudio window.\n\n", sep = "")
          USERDIC <- file.choose()

          if (basename(USERDIC) != user_dic) {
            stop("The filename should be `", user_dic, "`.\n")
          }
        }

        # check if the user dictionary file is properly installed
        # check <- tryCatch(
        #   dictionary_info2(sys_dic = getOption("jliwc_IPADIC"), user_dic = USERDIC),
        #   error = function(e) {
        #     cat("The J-LIWC2015 user dictionary (or IPADIC in some cases) is not properly installed.\n")
        #     stop()
        #   }
        # )


        # if check is nrow() == 0, then USERDIC is not installed
        # if (nrow(check) == 0) {
        #   cat("J-LIWC2015 user dictionary (or IPADIC) is not properly installed.\n")
        #   stop()
        # }
      } else if (file.info(USERDIC)$size == 0) {
        message("J-LIWC2015 user dictionary file is found at ", dir, " but the file size is 0.\n")
      }

      # check if the user dictionary file is properly installed
      dictionary_info2(sys_dic = getOption("jliwc_IPADIC"), user_dic = USERDIC)
      # Success
      if (!silent) message("User dictionary is installed at ", USERDIC, "\n")
      # Set USERDIC as the path to the dictionary
      options(jliwc_USERDIC = USERDIC)
      return(TRUE)
    },
    warning = function(w) {
      message("Error 1: User dictionary is not properly installed (the file might be broken). Try installing it again.\n")
      return(FALSE)
    },
    error = function(e) {
      message("Error 2: User dictionary is not properly installed. Try installing it again.\n")
      return(FALSE)
    }
  )

  invisible(check)
}
