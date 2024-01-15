#' Setup J-LIWC2015 user dictionary
#'
#' @param dir home directory for J-LIWC2015
#' @param user_dic filename of the user dictionary file
#' @param userdic_url URL to the user dictionary file
#'
#' @export
#' @examples
#' setup_userdic()
#'
setup_userdic <- function(dir = getOption("jliwc_project_home"), user_dic = "user_dict.dic", userdic_url = getOption("jliwc_USERDIC_url")) {
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
  if (!file.exists(USERDIC)) {
    cat("J-LIWC2015 user dictionary is not installed at", dir, "\n")
    cat("Do you want to download the user dictionary file from GitHub and install?\n")
    cat("1. Yes (Enter)\n")
    cat("2. No (set the path to the user dictionary file manually) \n")
    cat("Please type 1 or 2 (ESC to quit): ")
    download <- readline()

    while (!download %in% 1:2 & download != "") {
      cat("Please type 1 or 2 (ESC to quit): ")
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
  }

  # check if the user dictionary file is properly installed
  check_userdic(USERDIC)
  # Set the path to USERDIC
  options(jliwc_USERDIC = USERDIC)
  # return TRUE as a flag that the user dictionary is properly installed
  invisible(TRUE)
}

# Check if IPADIC is properly installed
check_userdic <- function(USERDIC) {
  check <- tryCatch(
    dictionary_info2(sys_dic = getOption("jliwc_IPADIC"), user_dic = USERDIC),
    error = function(e) {
      message("User dictionary (probably also IPADIC) is not properly installed. Delete the file at ", USERDIC, " and try installing again.\n")
      stop()
    }
  )
  if (nrow(check) == 0) {
    message("Error 2: User dictionary is not properly installed. Delete the file at ", USERDIC, " and try installing again.\n")
    stop()
  }
  message("User dictionary is installed at ", USERDIC, "\n")
}
