#' Uninstall dictionary files
#' #'
#' @description Uninstall dictionary files installed by the jliwc package
#'
#' @param ipadic A logical value to remove IPADic files
#' @param userdic A logical value to remove user dictionary files
#' @param jliwcdic A logical value to remove JLIWC dictionary files
#'
#' @return Boolean, \code{TRUE} if the setup is successful,
#'   \code{FALSE} otherwise
#'
#' @importFrom tools R_user_dir
#' @importFrom jsonlite write_json
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' uninstall_dictionaries()
#' }
#'
#' @export
#'
uninstall_dictionaries <- function(ipadic = TRUE, userdic = TRUE, jliwcdic = FALSE) {
  check <- tryCatch(
    {
      config <- load_jliwc_config()
      keys <- names(config)

      # stop if there is no dictionary to remove
      if (length(keys) == 0) {
        stop("No dictionary to remove.")
      }

      # Prompt the user to confirm the removal
      message("The following dictionary files will be removed:")
      if (ipadic && "ipadic" %in% keys) {
        ipadic_files <- config$ipadic
        if (length(ipadic_files) > 0) {
          cat("IPADic files:\n")
          for (i in 1:length(ipadic_files)) {
            message(ipadic_files[i])
          }
        }
      }

      if (userdic && "userdic" %in% keys) {
        userdic_files <- config$userdic
        if (length(userdic_files) > 0) {
          cat("User dictionary files:\n")
          for (i in 1:length(userdic_files)) {
            message(userdic_files[i])
          }
        }
      }

      if (jliwcdic && "jliwcdic" %in% keys) {
        jliwcdic_files <- config$jliwcdic
        if (length(jliwcdic_files) > 0) {
          cat("JLIWC dictionary files:\n")
          for (i in 1:length(jliwcdic_files)) {
            message(jliwcdic_files[i])
          }
        }
      }

      uninstall <- readline("Do you uninstall these dictionary files? [Y/N] ")

      while (!uninstall %in% c("Y", "N", "y", "n")) {
        uninstall <- readline("Do you uninstall these dictionary files? [Y/N] ")
      }

      if (uninstall %in% c("N", "n")) {
        return(invisible(FALSE))
      }

      if (ipadic && "ipadic" %in% keys) {
        ipadic_files <- config$ipadic
        if (length(ipadic_files) > 0) {
          unlink(ipadic_files)
          message("IPADic files are removed from: ", ipadic_files)
        }
        config$ipadic <- NULL
      }

      if (userdic && "userdic" %in% keys) {
        userdic_files <- config$userdic
        if (length(userdic_files) > 0) {
          unlink(userdic_files)
          message("User dictionary files are removed from: ", userdic_files)
        }
        config$userdic <- NULL
      }

      if (jliwcdic && "jliwcdic" %in% keys) {
        jliwcdic_files <- config$jliwcdic
        if (length(jliwcdic_files) > 0) {
          unlink(jliwcdic_files)
          message("JLIWC dictionary files are removed from: ", jliwcdic_files)
        }
        config$jliwcdic <- NULL
      }

      # Remove the dictionary information from the config_file
      config_dir <- tools::R_user_dir("jliwc", "config")
      config_file <- file.path(config_dir, "config.json")

      jsonlite::write_json(config, config_file)

      return(invisible(TRUE))
    },
    warning = function(w) {
      message(w)
      return(invisible(FALSE))
    },
    error = function(e) {
      message(e)
      return(invisible(FALSE))
    }
  )

  invisible(check)
}
