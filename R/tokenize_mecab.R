#' Word segmentation using MeCab
#'
#' Segments Japanese text into words using MeCab.
#'
#' @param text A character vector. If a data frame is given,
#' the function will use the column specified by \code{text_field}.
#' @param text_field A character vector. By default, the column name of \code{text} to be used.
#' @param sys_dic A character vector. The location of the system dictionary of MeCab.
#' @param user_dic A character vector. The location of the user dictionary of MeCab.
#' @param baseform A logical value. If \code{TRUE}, the function will use the base form of words.
#' @param original A logical value. If \code{TRUE}, Same as \code{baseform}.
#' @param liwclike A logical value. If \code{TRUE},
#' the function will exclude delimiters (\code{'\b'}) according to LIWC2015.
#'
#' @importFrom rlang .data
#' @importFrom dplyr filter mutate
#' @importFrom gibasa prettify
#'
#' @return A data frame
#'
#' @examples
#' \dontrun{
#' load_dictionaries()
#'
#' # Word segmentation
#' gibasa::ginga[10:20] |> tokenize_mecab()
#'
#' # Use original form of words
#' gibasa::ginga[10:20] |>
#'   tokenize_mecab(original = TRUE) |>
#'   dplyr::select(token, Original)
#' }
#'
#' @export
#'
tokenize_mecab <- function(text, text_field = "text",
                           sys_dic = getOption("jliwc_IPADIC"), user_dic = getOption("jliwc_USERDIC"),
                           baseform = FALSE, original = FALSE,
                           liwclike = TRUE) {
  text_df <- tokenize2(text, text_field = text_field, sys_dic = sys_dic, user_dic = user_dic) |>
    gibasa::prettify()

  # Use the base form of words
  if (any(original, baseform)) {
    text_df <- text_df |>
      # dplyr::mutate(token = ifelse(!is.na(.data[["Original"]]), .data[["Original"]], .data[["token"]]))
      dplyr::mutate(token = ifelse(!is.na(.data[["Original"]]), .data[["Original"]], .data[["token"]]))
  }

  # Exclude delimiters according to LIWC2015
  if (liwclike) {
    text_df <- text_df |>
      dplyr::filter(.data[["token"]] %in% preprocess_liwc(text_df[["token"]]))
  }

  text_df
}
