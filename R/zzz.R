# Assign a package environment
jliwc_env <- new.env()

# Read environmental variables defined in "jliwc_env.R"
# LIWC2015 dictionary categories (in Japanese)
jliwc_env$liwc_cat_ja <- liwc_cat_ja
# MeCab part-of-speech tags (in Japanese)
jliwc_env$MECAB_LOOKUP <- mecab_lookup

# Set up parameters
.onLoad <- function(libname, pkgname) {
  # If run on Windows, get the home directory of users
  # If run on Unix, get the user root directory ("~")
  # if (Sys.info()["sysname"] == "Windows") {
  #   # Windows ("C:/Users/username")
  #   HOME <- Sys.getenv("USERPROFILE")
  # } else {
  #   # Unix ("/home/username")
  #   HOME <- path.expand("~")
  # }

  # Directory of the project
  HOME <- path.expand("~") # Windows ("C:/Users/username/Documents")
  SUB <- "J-LIWC2015"
  DICDIR <- "dic"
  IPADIC <- "mecab-ipadic"

  # J-LIWC dictionary file format (default)
  LIWCFORMAT <- "LIWC2015"

  # User dictionary file
  USERDIC <- "user_dict.dic"

  jliwc_project_home <- normalizePath(file.path(HOME, SUB),
    winslash = "/", mustWork = FALSE
  )
  # directory for LIWC dictionary
  # jliwc_dic_home <- normalizePath(file.path(jliwc_project_home, DICDIR, LIWC2015),
  #   winslash = "/", mustWork = FALSE
  # )

  # J-LIWC dictionary2 object (set by setup_jliwcdic())
  jliwc_dictfile <- NULL

  jliwc_format <- LIWCFORMAT

  # IPADIC (directory)
  jliwc_IPADIC <- normalizePath(file.path(jliwc_project_home, IPADIC),
    winslash = "/", mustWork = FALSE
  )
  # USERDIC (file)
  jliwc_USERDIC <- normalizePath(file.path(jliwc_project_home, USERDIC),
    winslash = "/", mustWork = FALSE
  )
  # IPADIC url: Alternative: "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
  jliwc_IPADIC_url <- "https://sourceforge.net/projects/mecab/files/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz"
  jliwc_USERDIC_url <- "https://github.com/tasukuigarashi/j-liwc2015/raw/main/user_dict.dic"

  # Set options
  op <- options()
  op.jliwc <- list(
    jliwc_project_home = jliwc_project_home,
    # jliwc_dic_home = jliwc_dic_home,
    jliwc_dictfile = jliwc_dictfile,
    jliwc_IPADIC = jliwc_IPADIC,
    jliwc_USERDIC = jliwc_USERDIC,
    jliwc_IPADIC_url = jliwc_IPADIC_url,
    jliwc_USERDIC_url = jliwc_USERDIC_url
  )

  toset <- !(names(op.jliwc) %in% names(op))
  if (any(toset)) options(op.jliwc[toset])

  invisible()
}
