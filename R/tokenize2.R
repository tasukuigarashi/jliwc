#' function that always set the temporary mecabrc environment variable
#'
#' @param x character vector
#' @param ... other arguments passed to \code{\link[gibasa]{tokenize}}
#'
#' @importFrom withr with_envvar
#' @importFrom gibasa tokenize
#'
#' @return tokenized character vector
#'
tokenize2 <- function(x, ...) {
  withr::with_envvar(
    c(
      "MECABRC" = if (.Platform$OS.type == "windows") {
        "nul"
      } else {
        "/dev/null"
      },
      "RCPP_PARALLEL_BACKEND" = "tinythread"
    ),
    gibasa::tokenize(x, ...)
  )
}
