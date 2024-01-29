#' Load dictionaries
#'
#' Load IPAdic, user dictionary, and J-LIWC dictionary.
#' Prior to using this function, you need to install the dictionaries by
#' `install_ipadic()`, `install_userdic()`, and `install_jliwcdic()`. You also need to set
#' `options(jliwc_project_home = "/path/to/directory")` where the dictionaries are installed.
#'
#' @param silent Boolean. Whether to print messages
#'
#' @return Boolean, \code{TRUE} if the dictionaries are loaded successfully, \code{FALSE} otherwise
#'
#' @examples
#' \dontrun{
#' options(jliwc_project_home = "/path/to/directory")
#'
#' load_dictionaries()
#' }
#'
#' @export
#'
load_dictionaries <- function(silent = FALSE) {
  if (!silent) cat("Loading dictionaries from", getOption("jliwc_project_home"), "\n")

  tryCatch(
    {
      ipadic <- check_ipadic(silent = silent)
    },
    warning = function(w) {
      # This warning is probably because of the broken file
      message(w)
      cat("\nIPAdic is not properly loaded.\n")
    },
    error = function(e) {
      message(e)
      cat("\nIPAdic is not properly loaded.\n")
    })

  tryCatch(
    {
      userdic <- check_userdic(silent = silent)
    },
    warning = function(w) {
      # This warning is probably because of the broken file
      message(w)
      cat("\nUser dictionary is not properly loaded.\n")
    },
    error = function(e) {
      message(e)
      cat("\nUser dictionary is not properly loaded.\n")
    })

  tryCatch(
    {
      jliwcdic <- load_jliwcdic(silent = silent)
    },
    warning = function(w) {
      # This warning is probably because of the broken file
      message(w)
      cat("\nJ-LIWC dictionary is not properly loaded.\n")
    },
    error = function(e) {
      message(e)
      cat("\nJ-LIWC dictionary is not properly loaded.\n")
    })

  if (ipadic & userdic & jliwcdic) {
    if (!silent) cat("All dictionaries are properly loaded.\n")
    invisible(TRUE)
  } else {
    cat("Dictionary loading failed. Set 'silent = FALSE' and run again to check the error message.\n")
    invisible(FALSE)
  }
}
