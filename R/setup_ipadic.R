#' Download and install IPADIC
#'
#' @param dir A directory where IPADIC is installed
#'   (e.g., "C:/Users/username/Documents/J-LIWC2015/")
#' @param ipadic_dictname a name of the directory where IPADIC is installed
#'   (e.g., "C:/Users/username/Documents/J-LIWC2015/mecab-ipadic")
#' @param tar_dic A name of the IPADIC tar file
#' @param ipadic_url A URL of the IPADIC tar file
#' @param silent Boolean. Whether to print messages
#'
#' @importFrom utils download.file
#' @importFrom gibasa build_sys_dic
#'
#' @return Boolean, \code{TRUE} if the setup is successful,
#'   \code{FALSE} otherwise
#'
#' @examples
#' setup_ipadic()
#'
#' @export
#'
setup_ipadic <- function(dir = getOption("jliwc_project_home"), ipadic_dictname = "mecab-ipadic",
                         tar_dic = "mecab-ipadic-2.7.0-20070801", ipadic_url = getOption("jliwc_IPADIC_url"),
                         silent = FALSE) {
  IPADIC <- file.path(dir, ipadic_dictname)

  # Main
  check <- tryCatch(
    {
      if (!file.exists(file.path(IPADIC, "dicrc"))) {
        cat("IPADIC is not installed at", IPADIC, "\n")
        cat("You have two options: \n\n")
        cat("1. Install IPADIC (Enter)\n")
        # create cat for installing IPADIC at the directory other than the home directory
        cat("2. Set the path to the installed IPADIC manually\n")
        cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
        install <- readline()

        while (!install %in% 1:2 & install != "") {
          cat("Please type 1 or 2 (ESC or CTRL+C to quit): ")
          install <- readline()
        }

        # install IPADIC at the home directory
        if (install == 1 | install == "") {
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
        } else {
          cat("Please choose the dictionary file of IPADIC (sys.dic).\n")
          IPADIC <- file.choose() |> dirname()
        }
      }

      # check if IPADIC is properly installed
      dictionary_info2(sys_dic = IPADIC)
      # Success
      if (!silent) message("IPADIC is installed at ", IPADIC, "\n")
      # Set IPADIC as the path to the dictionary
      options(jliwc_IPADIC = IPADIC)
      return(TRUE)
    },
    warning = function(w) {
      message("Error 1: IPADIC is not properly installed. Check the directory ", IPADIC, " and try installing again.\n")
      return(FALSE)
    },
    error = function(e) {
      message("Error 2: IPADIC is not properly installed. Check the directory ", IPADIC, " and try installing again.\n")
      return(FALSE)
    }
  )

  # return a flag whether the IPADIC is properly installed
  invisible(check)
}
