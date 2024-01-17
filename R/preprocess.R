#' Preprocessing text for morphological analysis
#'
#' @param text A character vector
#'
#' @importFrom stringr str_to_lower str_replace_all coll
#' @importFrom stringi stri_trans_nfkc
#'
#' @return A character vector. The text is converted to lowercase,
#'  line breaks are replaced with `\n`,
#'  numbers are replaced with half-width characters,
#'  and characters such as `!` and `@` are replaced with full-width characters.
#'
#' @examples
#' \dontrun{
#' x <- preprocess("OK、今日の２時に！\r\n")
#' x
#' }
#'
#' @export
#'
preprocess <- function(text) {
  # characters_replace <- c(
  #   "!" = "！", '"' = "”", "#" = "＃", "$" = "＄", "%" = "％",
  #   "&" = "＆", "'" = "’", "(" = "（", ")" = "）", "*" = "＊",
  #   "+" = "＋", "," = "，", "-" = "−", "." = "．", "/" = "／",
  #   ":" = "：", ";" = "；", "<" = "＜", "=" = "＝", ">" = "＞",
  #   "?" = "？", "@" = "＠", "[" = "［", "\\" = "＼", "]" = "］",
  #   "^" = "＾", "_" = "＿", "`" = "｀", "{" = "｛", "|" = "｜",
  #   "}" = "｝", "\\r\\n" = "\\n", "\\r" = "\\n"
  # )

  characters_replace <- c(
    "!" = "\uFF01", '"' = "\u201D", "#" = "\uFF03", "$" = "\uFF04", "%" = "\uFF05",
    "&" = "\uFF06", "'" = "\u2019", "(" = "\uFF08", ")" = "\uFF09", "*" = "\uFF0A",
    "+" = "\uFF0B", "," = "\uFF0C", "-" = "\u2212", "." = "\uFF0E", "/" = "\uFF0F",
    ":" = "\uFF1A", ";" = "\uFF1B", "<" = "\uFF1C", "=" = "\uFF1D", ">" = "\uFF1E",
    "?" = "\uFF1F", "@" = "\uFF20", "[" = "\uFF3B", "]" = "\uFF3D",
    "^" = "\uFF3E", "_" = "\uFF3F", "`" = "\uFF40", "{" = "\uFF5B", "|" = "\uFF5C",
    "}" = "\uFF5D",
    # for special dictionary words (emoticons)
    r"(\()" = "\uff3c\uff08", r"(\o)" = "\uff3c\u25cb",
    # for escape sequences
    "\r\\n" = "\n", "\r" = "\n"
  )

  zenkaku_leftsingle <- "\xe2\x80\x98"
  Encoding(zenkaku_leftsingle) <- "UTF-8"

  text |>
    stringr::str_to_lower() |>
    stringi::stri_trans_nfkc() |>
    stringr::str_replace_all(stringr::coll(characters_replace)) |>
    stringr::str_replace_all("[\u2019\u00b4\uff40]", zenkaku_leftsingle) # ’´｀
}
