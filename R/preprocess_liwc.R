#' Morphological analysis imitating LIWC's internal processing
#'
#' @param text A character vector
#'
#' @importFrom stringr str_remove_all str_split
#' @importFrom stringi stri_remove_empty
#'
#' @return A character vector. Japanese characters that can be interpreted as
#'  a word boundary `\b` in regular expressions are omitted from the original text.
#'
#' @noRd
#'
preprocess_liwc <- function(text) {
  text |>
    stringr::str_remove_all("\\*|:|\\|") |>
    stringr::str_split(" ") |>
    unlist() |>
    # stringr::str_remove_all("^[－、。，．・：；？！゛゜｀＾＿〃／〜｜’”（）〔〕［］｛｝〈〉《》「」『』【】＋＝＜＞￥＄％＃＆＊＠〒〓]$") |>
    stringr::str_remove_all("^[\uff0d\u3001\u3002\uff0c\uff0e\u30fb\uff1a\uff1b\uff1f\uff01\u309b\u309c\uff40\uff3e\uff3f\u3003\uff0f\u301c\uff5c\u2019\u201d\uff08\uff09\u3014\u3015\uff3b\uff3d\uff5b\uff5d\u3008\u3009\u300a\u300b\u300c\u300d\u300e\u300f\u3010\u3011\uff0b\uff1d\uff1c\uff1e\uffe5\uff04\uff05\uff03\uff06\uff0a\uff20\u3012\u3013]$") |>
    stringi::stri_remove_empty()
}
