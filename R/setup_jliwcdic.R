#' Set J-LIWC2015 dictionary path
#' @param dic path to the J-LIWC2015 dictionary
#'
#' @export
#' @examples
#' setup_jliwcdic()
#'
setup_jliwcdic <- function(dir = getOption("jliwc_dic_home")) {

  # The default path is "~/J-LIWC2015/"
  # IPADIC and USERDIC are expected to be installed at the home directory
  # home <- Sys.getenv("HOME") # path.expand("~")
  # project_home <- file.path(home, "J-LIWC2015")

  # The default path to the dictionary file is "~/J-LIWC2015/dic/Japanese_Dictionary.dic"
  # dic_home <- file.path(project_home, "dic")

  # File name of the dictionary file
  # dic_LIWC2015 <- "Japanese_Dictionary.dic"
  # dic_LIWC22 <- "LIWC2015 Dictionary - Japanese.dicx"

  # dir <- dirname(dir)
  dic_LIWC2015 <- file.path(dir, getOption("jliwc_dic_LIWC2015"))
  dic_LIWC22 <- file.path(dir, getOption("jliwc_dic_LIWC22"))

  # check if the dictionary file exists at the home directory
  # if (file.exists(file.path(dir, dic_LIWC2015))) {
  #   dic <- file.path(dir, dic_LIWC2015)
  #  cat("The LIWC dictionary file was found.")
  # } else if (file.exists(file.path(dir, dic_LIWC22))) {
  #   dic <- file.path(dir, dic_LIWC22)
  #  cat("The LIWC dictionary file was found.")
  if (file.exists(dic_LIWC2015)) {
    dic <- dic_LIWC2015
    cat("The LIWC dictionary file was found. ")
  } else if (file.exists(dic_LIWC22)) {
    dic <- dic_LIWC22
    cat("The LIWC dictionary file was found. ")
  } else {
    cat("The LIWC dictionary file was not found at", dir, "\n\n")
    cat("You need to set the path to the dictionary file manually. You can copy the dictionary file from a directory to", dir, "for later use.\n\n")
    # choose 1 or 2
    cat("1. Copy the dictionary file and use it (default)\n")
    cat("2. Use the dictionary file but do not copy it\n\n")
    cat("Please type 1 or 2 (ESC to quit): ")
    copy <- readline()

    while (copy != 1 & copy != 2) {
      cat("Please type 1 or 2 (ESC to quit): ")
      copy <- readline()
    }

    # choose the dictionary file
    cat("Please choose the dictionary file (a window opens).\n")
    dic <- file.choose()

    # Copy the dictionary file to the home directory
    if (copy == 1) {
      if (!dir.exists(dir)) {
        dir.create(dir, recursive = TRUE)
      }

      file.copy(from = dic, to = dir)
      cat("The dictionary file was copied to ", dir, "\n")
      dic <- file.path(dir, basename(dic))
    }
  }

  options(jliwc_dic_home = normalizePath(dic, winslash = "/", mustWork = TRUE))
  cat("The path to the dictionary file was set to", dic, "\n")
}
