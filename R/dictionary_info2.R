#' function that calls \code{\link[gibasa]{dictionary_info}} with locally installed MeCab
#'
#' @param ... other arguments passed to \code{\link[gibasa]{dictionary_info}}
#' @return tokenized character vector
#' @importFrom withr with_envvar
#' @importFrom gibasa dictionary_info
#'
dictionary_info2 <- function(...) {
  withr::with_envvar(
    c(
      "MECABRC" = if (.Platform$OS.type == "windows") {
        "nul"
      } else {
        "/dev/null"
      }
    ),
    gibasa::dictionary_info(...)
  )
}
