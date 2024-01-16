#' Read the LIWC dictionary
#'
#' @param file A file path of the dictionary
#' @param format A format of the dictionary (LIWC2015 or LIWC22)
#'
#' @importFrom quanteda dictionary
#'
#' @return A dictionary object
#' @examples
#'
#' # Set up dictionaries
#' setup_ipadic()
#' setup_userdic()
#' setup_jliwcdic() # choose a dictionary file from a local directory
#'
#' # Read the dictionary (LIWC2015 format)
#' dictliwc <- read_dict(file.path(getOption("jliwc_project_home"), "Japanese_Dictionary.dic"))
#'
#' @export
#'
read_dict <- function(file, format = c("LIWC2015", "LIWC22")) {
  format <- match.arg(format)

  if (format == "LIWC2015") {
    dictliwc <- read_dict15(file)
  } else if (format == "LIWC22") {
    dictliwc <- read_dict22(file)
  }

  # message("IPA dictionary: ", getOption("jliwc_IPADIC"))
  # message("User dictionary: ", getOption("jliwc_USERDIC"))
  # message("J-LIWC2015 Dictionary: ", file, ".")

  dictliwc
}

# Reading the dictionary and getting English categories (LIWC2015 format)
# @param file A file path of the dictionary
# @importFrom quanteda dictionary
#
read_dict15 <- function(file) {
  dictliwc <- quanteda::dictionary(file = file, format = "LIWC")

  dictliwc
}

# Reading the dictionary and getting English categories (LIWC22 format)
# @param file A file path of the dictionary
# @importFrom quanteda dictionary
# @importFrom utils read.csv
#
read_dict22 <- function(file) {
  dic_raw <- read.csv(file)

  if (colnames(dic_raw)[1] != "DicTerm") {
    stop("The first column of the LIWC22 dictionary file must be 'DicTerm'.")
  }

  rownames(dic_raw) <- dic_raw$DicTerm
  dicx <- lapply(dic_raw, function(x) rownames(dic_raw)[x == "X"])
  dicx$DicTerm <- NULL
  dictliwc22 <- quanteda::dictionary(dicx)

  dictliwc22
}

