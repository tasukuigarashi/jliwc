# Set up parameters
.onLoad <- function(libname, pkgname) {

  op <- options()
  op.jliwc <- list(
    #  home directory for MeCab dictionaries (IPADIC, USERDIC)
    jliwc_project_home = normalizePath(file.path(Sys.getenv("HOME"), "J-LIWC2015"),
                                       winslash = "/", mustWork = FALSE),
    # directory for LIWC dictionary
    jliwc_dic_home = normalizePath(file.path(Sys.getenv("HOME"), "J-LIWC2015", "dic"),
                                   winslash = "/", mustWork = FALSE),
    # Filename of the LIWC dictionary file (LIWC2015)
    jliwc_dic_LIWC2015 = "Japanese_Dictionary.dic",
    # Filename of the LIWC dictionary file (LIWC22)
    jliwc_dic_LIWC22 = "LIWC2015 Dictionary - Japanese.dicx",
    # IPADIC
    jliwc_IPADIC = normalizePath(file.path(Sys.getenv("HOME"), "J-LIWC2015", "mecab-ipadic"),
                                 winslash = "/", mustWork = FALSE),
    # USERDIC
    jliwc_USERDIC = normalizePath(file.path(Sys.getenv("HOME"), "J-LIWC2015", "user_dict.dic"),
                                  winslash = "/", mustWork = FALSE),
    # IPADI url: Alternative: "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
    jliwc_IPADIC_url = "https://sourceforge.net/projects/mecab/files/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz",
    jliwc_USERDIC_url = "https://github.com/tasukuigarashi/j-liwc2015/raw/main/user_dict.dic"
  )

  toset <- !(names(op.jliwc) %in% names(op))
  if (any(toset)) options(op.jliwc[toset])

  invisible()
}
