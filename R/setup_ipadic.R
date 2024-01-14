#' Download and install IPADIC
#'
#' @param dir the directory where IPADIC is installed
#' @param ipadic_dictname the name of the directory where IPADIC is installed
#' @param tar_dic the name of the tar file
#' @param ipadic_url the URL of the tar file
#' @param check whether to check if IPADIC is installed
#'
#' @importFrom utils download.file
#' @importFrom gibasa build_sys_dic
#'
#' @export
#' @examples
#' setup_ipadic()
#'
setup_ipadic <- function(
    dir = getOption("jliwc_project_home"),
    ipadic_dictname = "mecab-ipadic",
    tar_dic = "mecab-ipadic-2.7.0-20070801",
    ipadic_url = getOption("jliwc_IPADIC_url"),
    check = TRUE) {
  # check if IPADIC is installed at the home directory
  # if so, prompt the message and set IPADIC as the path to the dictionary
  # if not, prompt the message and install IPADIC
  IPADIC <- file.path(dir, ipadic_dictname)

  if (file.exists(file.path(IPADIC, "dicrc"))) {
    cat("IPADIC is installed at", IPADIC, "\n")
  } else {
    cat("IPADIC is not installed at", IPADIC, "\n")
    cat("Do you install IPADIC?\n\n")
    cat("1. Install IPADIC (Enter)\n")
    # create cat for installing IPADIC at the directory other than the home directory
    cat("2. Set the path to the installed IPADIC manually\n")
    cat("Please type the number (ESC to quit): ")
    install <- readline()

    while (!install %in% 1:2 & install != "") {
      cat("Please type the number (ESC to quit): ")
      install <- readline()
    }

    # install IPADIC at the home directory
    if (install == 1 | install == "") {
      # if (!file.exists(file.path(IPADIC, "dicrc"))) {
      # make a directory "mecab-ipadic" in the home directory
      if (!dir.exists(IPADIC)) dir.create(IPADIC, recursive = TRUE)
      # Download IPADIC
      ipadic_tar <- file.path(tempdir(), paste0(tar_dic, ".tar.gz"))
      download.file(ipadic_url, destfile = ipadic_tar, mode = "wb")

      system(paste0("tar -xf ", ipadic_tar, " -C ", tempdir()))

      # Compile IPADIC
      gibasa::build_sys_dic(
        dic_dir = file.path(tempdir(), tar_dic),
        out_dir = IPADIC,
        encoding = "euc-jp" # encoding of source csv files
      )

      # copy the 'dicrc' file
      file.copy(file.path(tempdir(), tar_dic, "dicrc"), IPADIC)

      # remove the tar file
      file.remove(ipadic_tar)
      # remove temporary directory
      unlink(tar_dic, recursive = TRUE)
      # } else {
      # cat("IPADIC is already installed at", dir)
      # cat("If you want to reinstall IPADIC, delete all the files in the directory and call the install_ipadic() again.\n")
      # stop()
      # }

      # Sys.setenv("IPADIC" = IPADIC)
      # IPADIC <- file.path(dic_home, "mecab-ipadic")
    } else {
      cat("Please choose the dictionary file of IPADIC (sys.dic).\n")
      IPADIC <- file.choose() |> dirname()
    }


    if (check) {
      # check if IPADIC is installed. TryCatch errors and stop
      check <- tryCatch(
        dictionary_info2(sys_dic = IPADIC),
        error = function(e) {
          cat("IPADIC is not properly installed.\n")
          stop()
        }
      )

      # if check is nrow() == 0, then IPADIC is not installed
      # if so, prompt the message and stop
      if (nrow(check) == 0) {
        cat("IPADIC is not properly installed.\n")
        stop()
      }
    }

  }
  # Set the path to IPADIC
  options(jliwc_IPADIC = IPADIC)
  # cat("IPADIC is installed at", IPADIC, "\n")
}
