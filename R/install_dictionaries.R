#' Install dictionaries
#'
#' @description
#' Install IPAdic, the user dictionary, and the J-LIWC2015 dictionaries.
#'
#' @param ipadic Install IPAdic (default: TRUE)
#' @param userdic Install the user dictionary (default: TRUE)
#' @param jliwcdic Install the J-LIWC2015 dictionary (default: TRUE)
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' install_dictionaries()
#' }
#'
#' @export
#'
install_dictionaries <- function(ipadic = TRUE,
                                   userdic = TRUE,
                                   jliwcdic = TRUE) {
  if (ipadic) {
    message("Installing IPAdic...\n")
    install_ipadic()
  }

  if (userdic) {
    message("Installing the user dictionary...\n")
    install_userdic()
  }

  if (jliwcdic) {
    message("Installing the J-LIWC2015 dictionary...\n")
    install_jliwcdic()
  }
}
