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
      if (!silent) message("IPADIC is loaded from ", IPADIC, "\n")
      # Set IPADIC as the path to the dictionary
      options(jliwc_IPADIC = IPADIC)
      return(TRUE)
    },
    warning = function(w) {
      message(w)
      message("\nIPADIC is not properly loaded. Check the directory at ", IPADIC, "\n")
      return(FALSE)
    },
    error = function(e) {
      message(e)
      message("\nIPADIC is not properly loaded. Check the directory at ", IPADIC, "\n")
      return(FALSE)
    }
  )

  # return a flag whether the IPADIC is properly loaded
  invisible(check)
}
