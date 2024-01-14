# Set up parameters
.onLoad <- function(libname, pkgname) {

  # Assign a package environment
  jliwc_env <- new.env()

  # LIWC2015 dictionary categories (in Japanese)
  jliwc_env$liwc_cat_ja <- liwc_cat_ja
  # MeCab part-of-speech tags (in Japanese)
  jliwc_env$MECAB_LOOKUP <- mecab_lookup

  # Export the environment
  if(exists("package:jliwc", where = .GlobalEnv)) {
    assign("jliwc_env", jliwc_env, envir = as.environment("package:jliwc"))
  } else {
    message("Debug mode: jliwc_env is assigned to the global environment.")
    assign("jliwc_env", jliwc_env, envir = .GlobalEnv)
  }

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

  # J-LIWC dictionary file (default)
  LIWC2015 <- "Japanese_Dictionary.dic"

  # User dictionary file
  USERDIC <- "user_dict.dic"

  op <- options()
  op.jliwc <- list(
    #  home directory for MeCab dictionaries (IPADIC, USERDIC)
    jliwc_project_home = normalizePath(file.path(HOME, SUB),
                                       winslash = "/", mustWork = FALSE),
    # directory for LIWC dictionary
    jliwc_dic_home = normalizePath(file.path(HOME, SUB, DICDIR, LIWC2015),
                                   winslash = "/", mustWork = FALSE),

    # J-LIWC dictionary2 object
    jliwc_dictfile = NULL,

    # IPADIC (directory)
    jliwc_IPADIC = normalizePath(file.path(HOME, SUB, IPADIC),
                                 winslash = "/", mustWork = FALSE),
    # USERDIC (file)
    jliwc_USERDIC = normalizePath(file.path(HOME, SUB, USERDIC),
                                  winslash = "/", mustWork = FALSE),
    # IPADIC url: Alternative: "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
    jliwc_IPADIC_url = "https://sourceforge.net/projects/mecab/files/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz",
    jliwc_USERDIC_url = "https://github.com/tasukuigarashi/j-liwc2015/raw/main/user_dict.dic"
  )

  toset <- !(names(op.jliwc) %in% names(op))
  if (any(toset)) options(op.jliwc[toset])

  invisible()
}
