#' Save and load a setting file
#'
#' @description Load and save a setting file for jliwc package
#'
#' @param file_path A character string of the file path
#' @param config_key A character string of the key to save the file path
#'
#' @importFrom tools R_user_dir
#' @importFrom jsonlite write_json fromJSON
#' @return NULL
#'
# Save a setting file
save_jliwc_config <- function(file_path, config_key) {
  config_dir <- tools::R_user_dir("jliwc", "config")

  if (!dir.exists(config_dir)) {
    dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  }

  config_file <- file.path(config_dir, "config.json")

  if (file.exists(config_file)) {
    config <- jsonlite::fromJSON(config_file)

    if ("files" %in% names(config)) {
      config[[config_key]] <- c(config[[config_key]], file_path)
    } else {
      config[[config_key]] <- file_path
    }
  } else {
    config <- list()
    config[[config_key]] <- file_path
  }

  # remove duplicates
  config[[config_key]] <- unique(config[[config_key]])

  jsonlite::write_json(config, config_file)
}

# Read a setting file
load_jliwc_config <- function() {
  config_file <- file.path(tools::R_user_dir("jliwc", "config"), "config.json")
  if (file.exists(config_file)) {
    config <- jsonlite::fromJSON(config_file)
    return(config)
  }
  NULL
}

# Uninstall dictionary files installed by jliwc
uninstall_dictionaries <- function(ipadic = TRUE, userdic = TRUE, jliwcdic = FALSE) {
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
      return()
    }


  if (ipadic && "ipadic" %in% keys) {
    ipadic_files <- config$ipadic
    if (length(ipadic_files) > 0) {
      unlink(ipadic_files)
      message("IPADic files were removed from: ", ipadic_files)
    }
    config$ipadic <- NULL
  }

  if (userdic && "userdic" %in% keys) {
    userdic_files <- config$userdic
    if (length(userdic_files) > 0) {
      unlink(userdic_files)
      message("User dictionary files were removed from: ", userdic_files)
    }
    config$userdic <- NULL
  }

  if (jliwcdic && "jliwcdic" %in% keys) {
    jliwcdic_files <- config$jliwcdic
    if (length(jliwcdic_files) > 0) {
      unlink(jliwcdic_files)
      message("JLIWC dictionary files were removed from: ", jliwcdic_files)
    }
    config$jliwcdic <- NULL
  }

  # Remove the dictionary information from the config_file
  config_dir <- tools::R_user_dir("jliwc", "config")
  config_file <- file.path(config_dir, "config.json")

  jsonlite::write_json(config, config_file)
}

