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
#' @noRd
#'
# Save a setting file
save_jliwc_config <- function(file_path, config_key) {
  file_path <- normalizePath(file_path, winslash = "/", mustWork = FALSE)
  config_dir <- tools::R_user_dir("jliwc", "config")

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

# Read a setting file
load_jliwc_config <- function() {
  config_file <- file.path(tools::R_user_dir("jliwc", "config"), "config.json")
  if (file.exists(config_file)) {
    config <- jsonlite::fromJSON(config_file)
    return(config)
  } else {
    stop("No configuration file found.")
  }
}
