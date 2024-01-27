#' Check if user dictionary is properly installed
#'
#' @param dir A directory where IPADIC is installed
#' @param user_dic a name of the directory where a user dictionary is installed
#' @param silent Boolean. Whether to print messages
#'
#' @return Boolean, \code{TRUE} if the setup is successful, \code{FALSE} otherwise
#'
#' @examples
#' \dontrun{
#' check_userdic()
#' }
#' @export
#'
check_userdic <- function(dir = getOption("jliwc_project_home"), user_dic = "user_dict.dic",
                          silent = FALSE) {
  check <- tryCatch(
    {
      USERDIC <- file.path(dir, user_dic)

      # check if the user dictionary file is properly installed
      dictionary_info2(sys_dic = getOption("jliwc_IPADIC"), user_dic = USERDIC)
      # Success
      if (!silent) message("User dictionary is installed at ", USERDIC)
      return(TRUE)
    },
    warning = function(w) {
      # This warning is probably because of the broken file
      if (!silent) message(w)
      if (!silent) message("\nUser dictionary is not properly installed (the file might be broken). Check the directory at ", USERDIC)
      return(FALSE)
    },
    error = function(e) {
      if (!silent) message(e)
      if (!silent) message("\nUser dictionary is not properly installed. Check the directory at ", USERDIC)
      return(FALSE)
    }
  )

  invisible(check)
}
