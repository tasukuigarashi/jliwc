#' Reading the dictionary and getting English categories (LIWC2015 format)
#' @param file A file path of the dictionary
#' @importFrom quanteda dictionary
#'
read_dict15 <- function(file) {
  dictliwc <- quanteda::dictionary(file = file, format = "LIWC")

  # Set English categories
  # Sys.setenv(LIWC_CAT_EN = toJSON(names(dictliwc)))

  dictliwc
}

#' Reading the dictionary and getting English categories (LIWC22 format)
#' @param file A file path of the dictionary
#' @importFrom quanteda dictionary
#' @importFrom utils read.csv
#'
read_dict22 <- function(file) {
  dic_raw <- read.csv(file)
  rownames(dic_raw) <- dic_raw$DicTerm
  dicx <- lapply(dic_raw, function(x) rownames(dic_raw)[x == "X"])
  dicx$DicTerm <- NULL
  dictliwc22 <- quanteda::dictionary(dicx)

  # Set English categories
  # Sys.setenv(LIWC_CAT_EN = toJSON(names(dictliwc22)))

  dictliwc22
}

#' Read the dictionary and get English categories
#'
#' @param file A file path of the dictionary
#' @param format A format of the dictionary (LIWC2015 or LIWC22)
#' @param initialize A logical value. If TRUE, initialize MeCab dictionaries and J-LIWC2015 dictionary.
#' @param dic_dir A directory path of the J-LIWC2015 dictionary
#' @param mecab_dir A directory path of the MeCab dictionaries
#' @importFrom quanteda dictionary
#'
#' @return A dictionary object
#' @export
#' @examples
#' # Set up dictionaries
#' setup_ipadic()
#' setup_userdic()
#' setup_jliwcdic() # choose a dictionary file from a local directory
#'
#' # Read the dictionary (LIWC2015 format)
#' dictliwc <- read_dict()
#' # Read the dictionary (LIWC22 format)
#' dictliwc22 <- read_dict(format = "LIWC22")
#'
read_dict <- function(file = getOption("jliwc_dic_home"), format = "LIWC2015", initialize = FALSE, dic_dir = getOption("jliwc_dic_home"), mecab_dir = getOption("jliwc_project_home")) {

  # set up dictionaries
  if (initialize) {
    setup_ipadic(mecab_dir)
    setup_userdic(mecab_dir)
    setup_jliwcdic(dic_dir)
  }

  if (format == "LIWC2015") {
    dictliwc <- read_dict15(file)
  } else if (format == "LIWC22") {
    dictliwc <- read_dict22(file)
  } else {
    stop("A dictionary format must be LIWC2015 or LIWC22.")
  }
  # Category names of J-LIWC2015 (in Japanese)
  # LIWC_CAT_JA <- c(
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

  # ベクトルをJSON文字列に変換
  # liwc_cat_json <- toJSON(LIWC_CAT_JA)
  # 環境変数に設定
  # Sys.setenv(LIWC_CAT_JA = liwc_cat_json)

  message("IPA dictionary: ", getOption("jliwc_IPADIC"))
  message("User dictionary: ", getOption("jliwc_USERDIC"))

  message("J-LIWC2015 Dictionary loaded from ", file, ".\n")
  dictliwc
}
