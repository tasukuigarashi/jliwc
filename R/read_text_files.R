#' Read Text Files into a Data Frame
#'
#' Reads text files specified in a list of file names or directories into a single data frame.
#' For each directory input, it reads all text files with the specified file extension.
#' It also displays the number of files read and the total bytes.
#'
#' @param inputs A character vector of file paths or directory paths.
#' @param filetype A string specifying the file extension to read from directories.
#' Defaults to "txt".
#'
#' @return A data frame where each row contains the content of a text file.
#'
#' @examples
#' \dontrun{
#' # Example usage
#' texts <- c("path/to/file1.txt", "path/to/file2.txt")
#' df <- read_text_files(texts, filetype = "txt")
#'
#' # directory
#' dir <- "path/to/files"
#' df <- read_text_files(dir, filetype = "txt")
#' }
#'
#' @export
#'
read_text_files <- function(inputs, filetype = "txt") {
  total_bytes <- 0
  total_files <- 0

  # Function to read a single file
  read_file <- function(file) {
    lines <- readLines(file, warn = FALSE)
    text <- paste(lines, collapse = "\n")
    data.frame(doc_id = basename(file), text = text, stringsAsFactors = FALSE)
  }

  # Function to process each input (file or directory)
  process_input <- function(input) {
    if (file.exists(input)) {
      if (isTRUE(file.info(input)$isdir)) {
        pattern <- paste0("\\.", filetype, "$")
        file_list <- list.files(input, pattern = pattern, full.names = TRUE)
      } else {
        file_list <- input
      }

      file_contents <- lapply(file_list, read_file)
      df <- do.call(rbind, file_contents)

      # Update file count and total bytes
      total_files <<- total_files + length(file_list)
      total_bytes <<- total_bytes + sum(file.info(file_list)$size)

      return(df)
    } else {
      stop("The specified path does not exist: ", input)
    }
  }

  all_data <- do.call(rbind, lapply(inputs, process_input))

  # Display the number of files read and total bytes
  message("Number of files read: ", total_files)
  message("Total bytes: ", total_bytes)

  return(all_data)
}
