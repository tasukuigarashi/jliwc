#' Function that calls \code{\link[gibasa]{gibasa::tokenize}} with locally installed MeCab
#'
#' @param x Character vector
#' @param ... Other arguments passed to \code{\link[gibasa]{gibasa::tokenize}}
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
