#' Word segmentation using MeCab
#'
#' @param text A character vector
#' @param text_field A character vector
#' @param sys_dic A character vector
#' @param user_dic A character vector
#' @param liwclike A logical value
#'
#' @importFrom rlang sym
#' @importFrom dplyr filter
#' @importFrom gibasa prettify
#'
#' @return A data frame
#'
#' @examples
#' \dontrun{
#' setup_ipadic()
#' setup_userdic()
#' setup_jliwcdic()
#'
#' gibasa::ginga[1:10] |> count_mecab()
#' }
#'
#' @export
#'
count_mecab <- function(text, text_field = "text",
                        sys_dic = getOption("jliwc_IPADIC"), user_dic = getOption("jliwc_USERDIC"),
                        liwclike = TRUE) {
  text_df <- tokenize2(text, text_field = text_field, sys_dic = sys_dic, user_dic = user_dic)

  # Exclude delimiters according to LIWC2015
  if (liwclike) {
    token_col <- rlang::sym("token")
    text_df <- text_df |>
      dplyr::filter(!!token_col %in% preprocess_liwc(text_df$token))
  }

  text_df
}
