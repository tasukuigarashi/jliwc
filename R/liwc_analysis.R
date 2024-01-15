#' LIWC-style analysis of Japanese text data
#'
#' @param input A data frame or a list of character vector to analyze
#' @param text_field A column name of text data (if input is a data frame)
#' @param dict A dictionary2 class object of J-LIWC2015 dictionary
#' @param lang A character vector specifying language of the output tag (English or Japanese)
#' @param pos_tag logical; if TRUE, add POS percentage in MeCab
#' @param sys_dic A path to a MeCab system dictionary
#' @param user_dic A path to a MeCab user dictionary
#'
#' @importFrom rlang := .data
#' @importFrom dplyr %>% mutate select pull group_by summarise
#' @importFrom dplyr ungroup bind_rows count relocate n
#' @importFrom tidyr pivot_wider
#' @importFrom stringr str_remove_all str_split
#' @importFrom stringi stri_remove_empty
#' @importFrom quanteda as.tokens dfm dfm_lookup convert
#'
#' @return A data frame with LIWC-style analysis results
#'
#' @export
#'
#' @examples
#' setup_ipadic()
#' setup_userdic()
#' setup_jliwcdic()
#'
#' # Sample Japanese texts from Night on the Galactic Railroad (Kenji Miyazawa)
#' x <- gibasa::ginga[1:10]
#' x
#'
#' liwc_results <- x |> liwc_analysis()
#' liwc_results
#'
liwc_analysis <- function(input, text_field = "text", dict = getOption("jliwc_dictfile"), lang = c("en", "ja"), pos_tag = TRUE, sys_dic = getOption("jliwc_IPADIC"), user_dic = getOption("jliwc_USERDIC")) {
  # Default category labels are in English
  lang <- match.arg(lang)

  # Document identifier
  docid_field <- "doc_id"

  if (inherits(input, "data.frame")) {
    # if there is not a column named "doc_id", use it as document ID
    if (!docid_field %in% colnames(input)) {
      input[[docid_field]] <- as.character(seq_len(nrow(input)))
    }
  } else if (inherits(input, "character")) {
    doc_id <- if (is.null(names(input))) {
      as.character(seq_len(length(input)))
    } else {
      as.character(names(input))
    }

    input <- data.frame(text = input)
    text_field <- "text"

    input[[docid_field]] <- doc_id
  } else {
    stop("Input must be a data frame or a list of character vector.")
  }

  # Stop if dictionary is not a dictionary2 class object
  if (!inherits(dict, "dictionary2")) {
    stop("'dict' must be a quanteda dictionary2 class object.")
  }

  # Stop if text_field is not in input
  if (!text_field %in% names(input)) {
    stop("The column '", text_field, "' (text) must be included in the data frame.")
  }

  # Stop if docid_field is not in input
  if (!docid_field %in% names(input)) {
    stop("The column '", docid_field, "' (identifier) must be included in the data frame.")
  }

  text_df <- input |>
    dplyr::mutate(!!text_field := preprocess(.data[[text_field]])) |>
    # mutate(text = preprocess(text)) |>
    count_mecab(text_field = text_field, sys_dic = sys_dic, user_dic = user_dic, liwclike = TRUE)

  # Calculate word count
  WC <- text_df |>
    dplyr::group_by(.data[[docid_field]]) |>
    dplyr::summarise(WC = n()) |>
    dplyr::pull(WC)

  dict_count <- text_df %>%
    dplyr::group_by(.data[[docid_field]]) %>%
    dplyr::select(.data[[docid_field]], .data[["token"]]) %>%
    dplyr::summarise(token = list(.data[["token"]])) %>%
    dplyr::select(.data[["token"]]) %>%
    dplyr::pull() %>%
    quanteda::as.tokens() %>%
    quanteda::dfm() %>%
    quanteda::dfm_lookup(dictionary = dict, nomatch = "nomatch")

  dict_proportion <- (dict_count / WC) * 100

  dfr <- data.frame(WC = WC) %>%
    dplyr::bind_cols(dict_proportion %>% quanteda::convert(to = "data.frame")) %>%
    dplyr::mutate(
      Dic = 100 - .data[["nomatch"]]
    ) %>% # % of dictionary words
    dplyr::select(-.data[["nomatch"]])

  # doc_id in the original data
  dfr[[docid_field]] <- input[[docid_field]]
  dfr <- dfr %>%
    dplyr::relocate(.data[[docid_field]], WC, .data[["Dic"]])

  # Translate category names into Japanese
  if (lang == "ja") {
    names(dfr)[names(dfr) %in% names(dict)] <- jliwc_env$liwc_cat_ja
  }

  # Add MeCab categories if pos_tag is true
  if (pos_tag) {
    # Add MeCab categories
    MECAB_LOOKUP <- jliwc_env$MECAB_LOOKUP

    text_pos <- text_df %>%
      dplyr::group_by(.data[[docid_field]]) %>%
      dplyr::count(.data[["POS1"]]) %>%
      dplyr::mutate(total = sum(n)) %>%
      dplyr::mutate(text_pos = (n / .data[["total"]]) * 100) %>%
      dplyr::select(-n, -.data[["total"]]) %>%
      dplyr::ungroup()

    wide_text_pos <- text_pos |>
      tidyr::pivot_wider(
        names_from = .data[["POS1"]],
        values_from = text_pos,
        values_fill = list(text_pos = 0)
      )

    # Insert MeCab columns if missing
    missing_cols <- base::setdiff(names(MECAB_LOOKUP), names(wide_text_pos))
    wide_text_pos[missing_cols] <- 0

    # Reorder columns
    ordered_columns <- c(docid_field, names(MECAB_LOOKUP))
    wide_text_pos <- wide_text_pos[, ordered_columns]

    # Rename pos-tag categories in English
    if (lang == "en") {
      new_names <- unname(MECAB_LOOKUP[names(wide_text_pos)])
      new_names[is.na(new_names)] <- names(wide_text_pos)[is.na(new_names)]
      names(wide_text_pos) <- new_names
    }

    # Add "2" to MeCab column names
    names(wide_text_pos)[-1] <- paste0(names(wide_text_pos)[-1], "2")

    dfr <- dfr |>
      merge(wide_text_pos, by = docid_field, all.x = TRUE, sort = FALSE)
  }

  dfr
}
