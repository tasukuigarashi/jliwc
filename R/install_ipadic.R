#' Download and install IPADIC
#'
#' @param dir A directory where IPADIC is installed
#'   (e.g., "C:/Users/username/Documents/J-LIWC2015/")
#' @param ipadic_dictname a name of the directory where IPADIC is installed
#'   (e.g., "C:/Users/username/Documents/J-LIWC2015/mecab-ipadic")
#' @param tar_dic A name of the IPADIC tar file
#' @param ipadic_url A URL of the IPADIC tar file. Default on SourceForge.
#' If you fail to download the file from the default URL,
#'  you can specify the URL of the tar file. For example, you can use the following URL:
#'  <https://sourceforge.net/projects/mecab/files/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz>
#' @param silent Boolean. Whether to print messages
#'
#' @importFrom utils download.file
#' @importFrom gibasa build_sys_dic
#' @importFrom withr with_dir
#'
#' @return Boolean, \code{TRUE} if the setup is successful,
#'   \code{FALSE} otherwise
#'
#' @examples
#' \dontrun{
#' install_ipadic()
#' }
#'
#' @export
#'
install_ipadic <- function(dir = getOption("jliwc_project_home"), ipadic_dictname = getOption("jliwc_IPADIC_dir"),
                           tar_dic = "mecab-ipadic-2.7.0-20070801", ipadic_url = getOption("jliwc_IPADIC_url"),
                           silent = FALSE) {
  # set the temporary directory to avoid errors to install IPADIC
  # to the path including full-byte characters
  temp_dir <- tempdir()
  withr::with_dir(temp_dir, {
    # Main
    check <- tryCatch(
      {
        IPADIC <- file.path(dir, ipadic_dictname)

        if (check_ipadic(dir, silent = TRUE)) {
          cat("IPAdic is already installed at ", IPADIC, ".\n\n", sep = "")
        } else {
          cat("IPAdic is not installed at ", IPADIC, ".\n\n", sep = "")
        }

        install <- readline("Do you install IPAdic? [Y/N] ")

        while (!install %in% c("Y", "N", "y", "n")) {
          install <- readline("Do you install IPAdic? [Y/N] ")
        }

        # install IPADIC at the home directory
        if (install %in% c("Y", "y")) {
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
          message("The installation is cancelled.\n")
          return(TRUE)
        }

        # check if IPADIC is properly installed
        dictionary_info2(sys_dic = IPADIC)

        # list files in the directory
        files <- list.files(IPADIC, full.names = TRUE, recursive = TRUE)
        # save to the configuration file
        save_jliwc_config(files, "ipadic")

        # Success
        if (!silent) message("\u2714  IPADIC is installed at ", IPADIC, "\n")
        # Set IPADIC as the path to the dictionary
        options(jliwc_IPADIC = IPADIC)
        return(TRUE)
      },
      warning = function(w) {
        message(w)
        message(
          "\nIPADIC is not properly installed. Check the directory ",
          IPADIC, " and try installing again.\n
          If you can't remove the tar.gz file, restart R and then remove the file.\n"
        )
        # save NULL to the configuration file
        save_jliwc_config(NULL, "ipadic")

        return(FALSE)
      },
      error = function(e) {
        message(e)
        message(
          "\nIPADIC is not properly installed. Check the directory ",
          IPADIC, " and try installing again.\n
          If you can't remove the tar.gz file, restart R and then remove the file.\n"
        )
        # save NULL to the configuration file
        save_jliwc_config(NULL, "ipadic")

        return(FALSE)
      }
    )
  })

  # return a flag whether the IPADIC is properly installed
  invisible(check)
}
