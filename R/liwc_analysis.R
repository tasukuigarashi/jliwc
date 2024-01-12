#' LIWC-style analysis of Japanese text data
#'
#' @param input A data frame or a list of character vector to be analyzed
#' @param dict A dictionary2 class object of J-LIWC2015 dictionary
#' @param text_field A column name of the input data frame to be analyzed
#' @param lang A character vector specifying language of the output tag (English or Japanese)
#' @param pos_tag logical; if TRUE, add POS percentage in MeCab
#' @param sys_dic A path to the MeCab system dictionary
#' @param user_dic A path to the MeCab user dictionary
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
#' dict <- read_dict()
#'
#' x <- gibasa::ginga[1:10] |> liwc_analysis(dict = dict)
#' x
#'
liwc_analysis <- function(input, dict, text_field = "text", lang = c("en", "ja"), pos_tag = TRUE, sys_dic = getOption("jliwc_IPADIC"), user_dic = getOption("jliwc_USERDIC")) {
  # Default category labels are in English
  lang <- match.arg(lang)
  docid_field <- "doc_id"

  if (inherits(input, "data.frame")) {
    # if there is not a column named "doc_id", use it as document ID
    if (!docid_field %in% colnames(input)) {
      input[[docid_field]] <- as.character(seq_len(nrow(input)))
    }
  } else if (inherits(input, "character")) {
    doc_id <- if (is.null(names(input))) {
      as.character(seq_len(length(input))) } else {
        as.character(names(input)) }

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
      Dic = 100 - .data[["nomatch"]]) %>% # % of dictionary words
    dplyr::select(-.data[["nomatch"]])

  # doc_id in the original data
  dfr[[docid_field]] <- input[[docid_field]]
  dfr <- dfr %>%
    dplyr::relocate(.data[[docid_field]], WC, .data[["Dic"]])

  if (lang == "ja") {
    # Category names of J-LIWC2015 (in Japanese)
    # liwc_cat_ja <- c(
    #   "機能語", "代名詞", "人称代名詞", "一人称単数", "一人称複数",
    #   "二人称", "三人称単数", "三人称複数", "不定代名詞", "格助詞",
    #   "助動詞", "副詞", "接続詞", "否定詞", "動詞", "疑問詞",
    #   "数詞", "数量詞・助数詞", "形容動詞", "連体詞",
    #   "感情プロセス", "ポジティブ感情", "ネガティブ感情",
    #   "不安", "怒り", "悲しみ", "社会的（相互作用）プロセス",
    #   "家族", "友人", "女性", "男性", "認知プロセス", "洞察",
    #   "原因", "不一致", "あいまいさ", "確かさ", "差別化",
    #   "知覚プロセス", "視覚・知覚", "聴覚",
    #   "感覚（触覚・味覚・嗅覚）", "生物学的プロセス", "身体",
    #   "健康", "性", "摂取", "動因", "つながり", "達成",
    #   "社会的地位・権力", "報酬", "リスク", "相対性", "動作",
    #   "空間", "時間", "仕事・学業", "趣味・余暇", "家", "金銭",
    #   "宗教", "死", "インフォーマル", "罵倒", "ネットスラング",
    #   "うなずき", "間投詞", "フィラー"
    # )

    liwc_cat_ja <- c(
      "\u6a5f\u80fd\u8a9e",
      "\u4ee3\u540d\u8a5e",
      "\u4eba\u79f0\u4ee3\u540d\u8a5e",
      "\u4e00\u4eba\u79f0\u5358\u6570",
      "\u4e00\u4eba\u79f0\u8907\u6570",
      "\u4e8c\u4eba\u79f0",
      "\u4e09\u4eba\u79f0\u5358\u6570",
      "\u4e09\u4eba\u79f0\u8907\u6570",
      "\u4e0d\u5b9a\u4ee3\u540d\u8a5e",
      "\u683c\u52a9\u8a5e",
      "\u52a9\u52d5\u8a5e",
      "\u526f\u8a5e",
      "\u63a5\u7d9a\u8a5e",
      "\u5426\u5b9a\u8a5e",
      "\u52d5\u8a5e",
      "\u7591\u554f\u8a5e",
      "\u6570\u8a5e",
      "\u6570\u91cf\u8a5e\u30fb\u52a9\u6570\u8a5e",
      "\u5f62\u5bb9\u52d5\u8a5e",
      "\u9023\u4f53\u8a5e",
      "\u611f\u60c5\u30d7\u30ed\u30bb\u30b9",
      "\u30dd\u30b8\u30c6\u30a3\u30d6\u611f\u60c5",
      "\u30cd\u30ac\u30c6\u30a3\u30d6\u611f\u60c5",
      "\u4e0d\u5b89",
      "\u6012\u308a",
      "\u60b2\u3057\u307f",
      "\u793e\u4f1a\u7684\uff08\u76f8\u4e92\u4f5c\u7528\uff09\u30d7\u30ed\u30bb\u30b9",
      "\u5bb6\u65cf",
      "\u53cb\u4eba",
      "\u5973\u6027",
      "\u7537\u6027",
      "\u8a8d\u77e5\u30d7\u30ed\u30bb\u30b9",
      "\u6d1e\u5bdf",
      "\u539f\u56e0",
      "\u4e0d\u4e00\u81f4",
      "\u3042\u3044\u307e\u3044\u3055",
      "\u78ba\u304b\u3055",
      "\u5dee\u5225\u5316",
      "\u77e5\u899a\u30d7\u30ed\u30bb\u30b9",
      "\u8996\u899a\u30fb\u77e5\u899a",
      "\u8074\u899a",
      "\u611f\u899a\uff08\u89e6\u899a\u30fb\u5473\u899a\u30fb\u55c5\u899a\uff09",
      "\u751f\u7269\u5b66\u7684\u30d7\u30ed\u30bb\u30b9",
      "\u8eab\u4f53",
      "\u5065\u5eb7",
      "\u6027",
      "\u6442\u53d6",
      "\u52d5\u56e0",
      "\u3064\u306a\u304c\u308a",
      "\u9054\u6210",
      "\u793e\u4f1a\u7684\u5730\u4f4d\u30fb\u6a29\u529b",
      "\u5831\u916c",
      "\u30ea\u30b9\u30af",
      "\u76f8\u5bfe\u6027",
      "\u52d5\u4f5c",
      "\u7a7a\u9593",
      "\u6642\u9593",
      "\u4ed5\u4e8b\u30fb\u5b66\u696d",
      "\u8da3\u5473\u30fb\u4f59\u6687",
      "\u5bb6",
      "\u91d1\u92ad",
      "\u5b97\u6559",
      "\u6b7b",
      "\u30a4\u30f3\u30d5\u30a9\u30fc\u30de\u30eb",
      "\u7f75\u5012",
      "\u30cd\u30c3\u30c8\u30b9\u30e9\u30f3\u30b0",
      "\u3046\u306a\u305a\u304d",
      "\u9593\u6295\u8a5e",
      "\u30d5\u30a3\u30e9\u30fc"
    )

    names(dfr)[names(dfr) %in% names(dict)] <- liwc_cat_ja
  }

  # Add MeCab categories if pos_tag is true
  if (pos_tag) {

    # MeCab lookup table
    # MECAB_LOOKUP <- c(
    #   "記号" = "symbol", "形容詞" = "adj", "助詞" = "particle",
    #   "助動詞" = "auxverb", "接続詞" = "conj", "接頭詞" = "prefix",
    #   "動詞" = "verb", "副詞" = "adverb", "名詞" = "noun",
    #   "連体詞" = "preadj", "その他" = "others", "フィラー" = "filler",
    #   "感動詞" = "interject"
    # )

    MECAB_LOOKUP <- c(
      "\u8a18\u53f7" = "symbol",
      "\u5f62\u5bb9\u8a5e" = "adj",
      "\u52a9\u8a5e" = "particle",
      "\u52a9\u52d5\u8a5e" = "auxverb",
      "\u63a5\u7d9a\u8a5e" = "conj",
      "\u63a5\u982d\u8a5e" = "prefix",
      "\u52d5\u8a5e" = "verb",
      "\u526f\u8a5e" = "adverb",
      "\u540d\u8a5e" = "noun",
      "\u9023\u4f53\u8a5e" = "preadj",
      "\u305d\u306e\u4ed6" = "others",
      "\u30d5\u30a3\u30e9\u30fc" = "filler",
      "\u611f\u52d5\u8a5e" = "interject"
    )

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

    # Rename columns in English
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
