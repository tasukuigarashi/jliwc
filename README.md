
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
to explain LIWC license by Receptivi (LIWC2015 or LIWC22) is needed to use the J-LIWC2015 dictionary file, Non-commercial use only, How to get the license -->

Using the J-LIWC2015 dictionary file requires users to have a valid
academic and university license for LIWC2015 (end of sales) or LIWC-22.
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

- [LIWC2015](https://www.liwc.net/dictionaries/)
- [LIWC-22](https://www.liwc.app/dictionaries)

## Set up dictionaries

<!-- Write a paragraph about how to Setup the dictionaries: ipadic, userdic, and jliwcdic -->

To analyze Japanese text data in **jliwc**, you need to set up three
dictionaries: (1) IPAdic, (2) user dictionary, and (3) J-LIWC2015
dictionary.

What you need to do first is to install the dictionaries by using the
`install_dictionaries()` function. When installing the J-LIWC2015
dictionary on R GUI or RStudio, you will be asked to choose the
dictionary file by a file chooser dialog. If you use an R console, you
can select the dictionary file by typing the file path. This is only
needed to be done once.

``` r
library(jliwc)

# Do only once to install all dictionaries
install_dictionaries()
```

If necessary, you can also install the dictionaries separately. The
IPAdic and user dictionary files are automatically downloaded and
installed by using the `install_ipadic()` and `install_userdic()`
functions, respectively. Then you can set up the J-LIWC2015 dictionary
file by using the `install_jliwcdic()` function.

``` r
# You can skip the following if you installed all dictionaries by install_dictionaries()

# Install the dictionaries individually
# Set up IPAdic
install_ipadic()

# Set up the user dictionary
install_userdic()

# Set up the J-LIWC2015 dictionary
# You will choose the dictionary file by a file chooser dialog
install_jliwcdic()
```

By default, all dictionaries are installed under a hidden local
application directory (set by `tools::R_user_dir("jliwc", "data")`). In
most cases, this is reasonable to secure the access to the files across
different operating systems. However, you may fail to install the
dictionaries on Windows if your username includes non-ASCII characters
or spaces (e.g., `C:/Users/山田 太郎`). If you want to install the
dictionaries at a different directory, you can specify the directory
path by the `options(jliwc_project_home)`. It is strongly recommended
that the dictionary path is named with ASCII (one-byte alphabetical or
numeric) characters with no spaces (e.g., `C:/JLIWC`).

``` r
# You can skip the following if you installed all dictionaries at the default directory

# Set a dictionary path
options(jliwc_project_home = "C:/JLIWC")

# Do only once to install all dictionaries
install_dictionaries()

# Or install them individually
# install_ipadic()
# install_userdic()
# install_jliwcdic()
```

The dictionary file installation needs to be done only once.

Next time you can just use the `load_dictionaries()` function to load
the dictionaries.

``` r
# Load LIWC dictionary
load_dictionaries()
```

## Usage

### Analyze a column in a data frame

After installing and loading the dictionary files, you can use the
`liwc_analysis()` function to analyze Japanese texts. The function
preprocesses the texts (including word segmentation by IPAdic) and
returns a data frame with the LIWC category scores for each text. Don’t
forget to call the `load_dictionaries()` function before using the
`liwc_analysis()` function.

If you installed the dictionaries at a different directory from the
default, set `options(jliwc_project_home = "path/to/directory")` to
specify the directory path before loading the dictionary.

``` r
# Load LIWC dictionary
# If you installed the dictionaries at a different directory,
# specify the directory path before loading the dictionary
# options(jliwc_project_home = "C:/JLIWC")
library(jliwc)

load_dictionaries()

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
# Load LIWC dictionary
load_dictionaries()

# Sample text files: Nagoya University Conversation Corpus
# Reference: Fujimura, I., Chiba, S., & Ohso, M. (2012).
# Lexical and grammatical features of spoken and written Japanese in contrast:
# Exploring a lexical profiling approach to comparing spoken and written corpora.
# In Proceedings of the VIIth GSCP International Conference. Speech and Corpora (pp. 393-398).

# Download and extract the data
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

# Of course, you can use `read_text_files()` to read your own text files in a directory
# Change 'filetype' if necessary
# file1 <- read_text_files("/path/to/directory/", filetype = "txt")

# Analyze the text files
# Note that no preprocessing is performed for demonstration purposes
liwc_results_files <- files1 |> liwc_analysis()

dplyr::tibble(liwc_results_files)
#> # A tibble: 129 × 85
#>    doc_id         WC   Dic `function` pronoun ppron      i     we
#>    <chr>       <int> <dbl>      <dbl>   <dbl> <dbl>  <dbl>  <dbl>
#>  1 data001.txt  8774  64.0       34.8    3.93 0.809 0.399  0.194 
#>  2 data002.txt 14291  65.7       35.5    3.74 0.917 0.567  0.238 
#>  3 data003.txt  7315  65.8       34.0    4.02 0.902 0.574  0.123 
#>  4 data004.txt  8368  62.0       32.7    5.65 1.55  0.406  0.0478
#>  5 data005.txt 13223  59.6       32.2    4.30 1.31  0.159  0.0908
#>  6 data006.txt 11948  59.7       33.6    4.36 1.19  0.737  0.0251
#>  7 data007.txt  8550  63.5       36.5    4.62 0.795 0.0351 0.0234
#>  8 data008.txt 19817  68.3       38.2    5.63 1.18  0.636  0.0908
#>  9 data009.txt 19010  67.4       37.1    5.52 1.38  0.0789 0.0473
#> 10 data010.txt 10542  64.5       33.3    4.23 1.07  0.0664 0.0854
#> # ℹ 119 more rows
#> # ℹ 77 more variables: you <dbl>, shehe <dbl>, they <dbl>,
#> #   ipron <dbl>, casepart <dbl>, auxverb <dbl>, adverb <dbl>,
#> #   conj <dbl>, negate <dbl>, verb <dbl>, interrog <dbl>,
#> #   number <dbl>, quant <dbl>, adjverb <dbl>, preadj <dbl>,
#> #   affect <dbl>, posemo <dbl>, negemo <dbl>, anx <dbl>,
#> #   anger <dbl>, sad <dbl>, social <dbl>, family <dbl>, …
#> # ℹ Use `print(n = ...)` to see more rows
```

## Notes

Any request for the distribution of the J-LIWC2015 dictionary file is
not acceptable. Queries about the commercial use of J-LIWC2015 should be
directed to [Receptiviti](https://www.receptiviti.com/).

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
