
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jliwc

<!-- badges: start -->
<!-- badges: end -->
<!-- write a paragraph to introduce the package -->

The **jliwc** package provides a simple R interface to use the Japanese
version of LIWC2015 (J-LIWC2015) dictionary. The J-LIWC2015 dictionary
is developed by [Igarashi, Okuda, and Sasahara
(2022)](https://doi.org/10.3389/fpsyg.2022.841534) based on the original
English version of LIWC2015, a de-facto standard text analysis
dictionary for psycholinguistics [(Pennebaker, Boyd, Jordan, &
Blackburn,
2015)](https://repositories.lib.utexas.edu/server/api/core/bitstreams/b0d26dcf-2391-4701-88d0-3cf50ebee697/content).
Further information is available at [J-LIWC2015 official
repository](https://github.com/tasukuigarashi/j-liwc2015).

<!-- write a paragraph: run on Windows, Mac, and Linux. R > 4.2.0 for UTF-8 use-->

The package runs on Windows, Mac, and Linux. R version 4.2.0 or higher
is required to use UTF-8 encoding.

<!-- write a paragraph:
to explain LIWC licence by Receptivi (LIWC2015 or LIWC22) is needed to use the J-LIWC2015 dictionary file, Non-commercial use only, How to get the licence -->

Using the J-LIWC2015 dictionary file requires users to have a valid
academic and university licence for LIWC2015 (end of sales) or LIWC-22.
The dictionary is available for non-commercial use only. Please visit
the [LIWC website](https://www.liwc.app/buy) for more information.

## Installation

<!-- write a sentence to explain installation from github -->

You can install the released version of **jliwc** from
[GitHub](https://github.com/tasukuigarashi/jliwc). Windows users may
need to install [Rtools](https://cran.r-project.org/bin/windows/Rtools/)
first.

``` r
# install.packages("remotes")
remotes::install_github("tasukuigarashi/jliwc")
```

<!-- Explain users need to download J-LIWC dictionary file from LIWC website -->

You also need to have the J-LIWC2015 dictionary file. You can download
it from the LIWC website with a valid serial number.

- [LIWC2015](https://www.liwc.net/dictionaries)
- [LIWC-22](https://www.liwc.app/dictionaries)

## Set up dictionaries

<!-- Write a paragraph about how to Setup the dictionaries: ipadic, userdic, and jliwcdic -->

To analyze Japanese text data in **jliwc**, you need to set up three
dictionaries: (1) IPAdic, (2) user dictionary, and (3) J-LIWC2015
dictionary. If this is the first run, the IPAdic and user dictionary
files are automatically downloaded and installed by using the
`setup_ipadic()` and `setup_userdic()` functions, respectively.

Then you can set up the J-LIWC2015 dictionary file by using the
`setup_jliwcdic()` function. If you use R GUI or RStudio, you can select
the dictionary file by a file chooser dialog. If you use R console, you
can select the dictionary file by typing the file path.

``` r
library(jliwc)

# Set up IPAdic
setup_ipadic()

# Set up the user dictionary
setup_userdic()

# Set up the J-LIWC2015 dictionary
# If using the LIWC2015 format, specify format = "LIWC2015"
setup_jliwcdic(format = "LIWC22")
```

By default, all dictionaries are installed at `J-LIWC2015` directory
under your home directory (e.g.,
`C:/Users/username/Documents/J-LIWC2015` or
`C:/Users/username/OneDrive/Documents` on Windows). However, you may
fail to install the dictionaries if there are non-ASCII characters or
spaces in the home directory path (e.g., `C:/Users/山田　太郎` or
`C:/Users/username/OneDrive/ドキュメント`). If you want to install the
dictionaries at a different directory, you can specify the directory
path by the `options("jliwc_project_home")`. It is strongly recommended
that the dictionary path is named with ASCII (one-byte alphabetical or
numeric) characters with no spaces (e.g., `C:/JLIWC`).

``` r
# Set a dictionary path
options("jliwc_project_home" = "C:/JLIWC")

setup_ipadic()
setup_userdic()
setup_jliwcdic(format = "LIWC22")
```

The dictionary file installation needs to be done only once. Next time
you call the `setup_` functions, the dictionaries are loaded from the
installed files.

## Usage

### Analyze a column in a data frame

After you set up and load the dictionaries, you can use the
`liwc_analysis()` function to analyze Japanese texts. The function
preprocesses the texts (including word segmentation by IPAdic) and
returns a data frame with the LIWC category scores for each text.

``` r
# Load dictionaries
# if you installed the dictionaries at a different directory, specify the directory path
# options("jliwc_project_home" = "C:/JLIWC")
setup_ipadic()
setup_userdic()
setup_jliwcdic(format = "LIWC22")

# Sample texts
texts <- gibasa::ginga
head(texts)
#>  [1] "銀河鉄道の夜"
#>  [2] "宮沢賢治"
#>  [3] "一　午後の授業"
#>  [4] "「ではみなさんは、そういうふうに川だと言われたり、乳の流れたあとだと言われたりしていた、..."
#>  [5] "　カムパネルラが手をあげました。それから四、五人手をあげました。ジョバンニも手をあげようとして、..."
#>  [6] "　ところが先生は早くもそれを見つけたのでした。"

# Create a data frame
# The column name should be "text" by default
texts_df <- data.frame(text = texts)

liwc_results_df <- texts_df |> liwc_analysis()

dplyr::tibble(liwc_results_df)
#> # A tibble: 553 × 85
#>    doc_id    WC   Dic `function` pronoun ppron     i    we   you shehe  they
#>    <chr>  <int> <dbl>      <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 1          4  50         25      0        0     0     0     0     0     0
#>  2 2          2   0          0      0        0     0     0     0     0     0
#>  3 3          4 100         25      0        0     0     0     0     0     0
#>  4 4         75  76         46.7    5.33     0     0     0     0     0     0
#>  5 5         80  83.8       47.5    3.75     0     0     0     0     0     0
#>  6 6         12  91.7       50      8.33     0     0     0     0     0     0
#>  7 7         10  70         40     10       10     0     0    10     0     0
#>  8 8         62  69.4       45.2    1.61     0     0     0     0     0     0
#>  9 9         15  66.7       46.7    6.67     0     0     0     0     0     0
#> 10 10        22  68.2       50      0        0     0     0     0     0     0
#> # ℹ 543 more rows
#> # ℹ 74 more variables: ipron <dbl>, casepart <dbl>, auxverb <dbl>,
#> #   adverb <dbl>, conj <dbl>, negate <dbl>, verb <dbl>, interrog <dbl>,
#> #   number <dbl>, quant <dbl>, adjverb <dbl>, preadj <dbl>, affect <dbl>,
#> #   posemo <dbl>, negemo <dbl>, anx <dbl>, anger <dbl>, sad <dbl>,
#> #   social <dbl>, family <dbl>, friend <dbl>, female <dbl>, male <dbl>,
#> #   cogproc <dbl>, insight <dbl>, cause <dbl>, discrep <dbl>, tentat <dbl>,
# ℹ Use `print(n = ...)` to see more row

# You can also directly analyze a character vector
liwc_results <- texts |> liwc_analysis()

dplyr::tibble(liwc_results)
#> ... (same as above)
```

### Read and analyze text files

To read text files, you can use the `read_text_files()` function. The
function takes a character vector of file paths or a directory path and
returns a data frame that contains the text contents. You can directly
pass the output of `read_text_files()` to `liwc_analysis()`.

``` r
# Download and extract the NUCC data (Nagoya University Conversation Corpus)
temp_zip_file <- tempfile(fileext = ".zip")
temp_dir <- tempdir()

download.file(url = "https://mmsrv.ninjal.ac.jp/nucc/nucc.zip", dest = temp_zip_file, mode = "wb")
unzip(zipfile = temp_zip_file, exdir = temp_dir)

# Set the directory path
nucc_dir <- file.path(temp_dir, "nucc")

# Create a list of text files
text_files <- list.files(nucc_dir, pattern = "\\.txt$", full.names = TRUE)

head(text_files)
#> [1] "C:\\Users\\username\\AppData\\Local\\Temp\\RtmpCMTg7o/nucc/data001.txt"
#> [2] "C:\\Users\\username\\AppData\\Local\\Temp\\RtmpCMTg7o/nucc/data002.txt"
#> [3] "C:\\Users\\username\\AppData\\Local\\Temp\\RtmpCMTg7o/nucc/data003.txt"
#> [4] "C:\\Users\\username\\AppData\\Local\\Temp\\RtmpCMTg7o/nucc/data004.txt"
#> [5] "C:\\Users\\username\\AppData\\Local\\Temp\\RtmpCMTg7o/nucc/data005.txt"
#> [6] "C:\\Users\\username\\AppData\\Local\\Temp\\RtmpCMTg7o/nucc/data006.txt"

# Read the text files
# input as file names
files1 <- read_text_files(text_files)
#> Number of files read: 129
#> Total bytes: 7843788

# You can also use a directory path as an input
# The result is the same as `files1`
files2 <- read_text_files(nucc_dir, filetype = "txt")
#> Number of files read: 129
#> Total bytes: 7843788

# Analyze the text files
# Note that no preprocessing is performed for demonstration purposes
liwc_results_files <- files1 |> liwc_analysis()
dplyr::tibble(liwc_results_files)
```

Practically, before analyzing texts using LIWC, it is crucial to
preprocess the texts to ensure accurate and meaningful results. This
preprocessing typically involves cleaning the text data by removing
elements that are irrelevant to the analysis. For instance, this can
include stripping away HTML tags, which are common in web-sourced texts
but irrelevant to linguistic analysis. Additionally, one should remove
information such as metadata, non-lexical items, or any kind of coding
that does not contribute to the natural linguistic content. This
preprocessing step is vital because LIWC analyzes text based on word
frequencies and categories, and non-lexical items or irrelevant tags can
distort these frequencies, leading to skewed or inaccurate
interpretations of the data.

## Notes

Any request for the distribution of the J-LIWC2015 dictionary file is
not accepted. Queries about the commercial use of J-LIWC2015 should be
directed to [Receptiviti](https://www.receptiviti.com/contact).

The package relies on the
[gibasa](https://github.com/paithiov909/gibasa) package for the
compilation of IPAdic and word segmentation by MeCab and the
[quanteda](https://github.com/quanteda/quanteda) package for
dictionary-based psycholinguistic analysis.

## Reference

Igarashi, T., Okuda, S., & Sasahara, K. (2022). Development of the
Japanese Version of the Linguistic Inquiry and Word Count Dictionary
2015. *Frontiers in Psychology*, 13:841534.
<https://doi.org/10.3389/fpsyg.2022.841534>

Pennebaker, J.W., Boyd, R.L., Jordan, K., & Blackburn, K. (2015). *The
development and psychometric properties of LIWC2015*. Austin, TX:
University of Texas at Austin.

## License

GPL (\>=3) © Tasuku Igarashi
