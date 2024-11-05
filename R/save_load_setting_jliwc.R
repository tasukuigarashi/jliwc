#' Save and load a setting file
#'
#' @description Load and save a setting file for jliwc package
#'
#' @param file_path A character string of the file path
#' @param config_key A character string of the key to save the file path
#' @param config_dir A character string of the directory path to save the configuration file
#'
#' @importFrom tools R_user_dir
#' @importFrom jsonlite write_json fromJSON
#' @return NULL
#'
#' @noRd
#'
# Save a setting file
save_jliwc_config <- function(file_path, config_key, config_dir = tools::R_user_dir("jliwc", "config")) {
  file_path <- normalizePath(file_path, winslash = "/", mustWork = FALSE)

  if (!dir.exists(config_dir)) {
    dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  }

  config_file <- file.path(config_dir, "config.json") |>
    normalizePath(winslash = "/", mustWork = FALSE)

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

# Read a setting file with enhanced error handling and optional custom path
load_jliwc_config <- function(config_dir = tools::R_user_dir("jliwc", "config")) {
  config_file <- file.path(config_dir, "config.json")

  # Check if the configuration file exists
  if (file.exists(config_file)) {
    config <- jsonlite::fromJSON(config_file)

    # Validate the content structure (add required keys as needed)
    required_keys <- c("jliwcdic", "ipadic", "userdic")  # Replace or modify as necessary
    missing_keys <- setdiff(required_keys, names(config))

    if (length(missing_keys) > 0) {
      message(paste("Configuration file is missing required keys:", paste(missing_keys, collapse = ", "), "\n"))
    }

    return(config)
  } else {
    stop(paste("No configuration file found at:", config_file))
  }
}
