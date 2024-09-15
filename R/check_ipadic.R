#' Check if IPADIC is properly installed
#'
#' @param dir A directory where IPADIC is installed
#' @param ipadic_dictname a name of the directory where IPADIC is installed
#' @param silent Boolean. Whether to print messages
#'
#' @return Boolean, \code{TRUE} if the setup is successful, \code{FALSE} otherwise
#'
#' @examples
#' \dontrun{
#' check_ipadic()
#' }
#' @export
#'
check_ipadic <- function(dir = getOption("jliwc_project_home"), ipadic_dictname = getOption("jliwc_IPADIC_dir"), silent = FALSE) {
  # Main
  check <- tryCatch(
    {
      IPADIC <- file.path(dir, ipadic_dictname)
      # check if IPADIC is properly installed
      dictionary_info2(sys_dic = IPADIC)
      # Success
      if (!silent) message("\u2714  IPADIC is installed at ", IPADIC, "\n")
      # Set IPADIC as the path to the dictionary
      options(jliwc_IPADIC = IPADIC)
      return(TRUE)
    },
    warning = function(w) {
      if (!silent) message(w)
      if (!silent) message("\nIPADIC is not properly installed. Check the directory at ", IPADIC)
      return(FALSE)
    },
    error = function(e) {
      if (!silent) message(e)
      if (!silent) message("\nIPADIC is not properly installed. Check the directory at ", IPADIC)
      return(FALSE)
    }
  )

  # return a flag whether the IPADIC is properly loaded
  invisible(check)
}
