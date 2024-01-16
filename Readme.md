
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jliwc

<!-- badges: start -->
<!-- badges: end -->
<!-- write a paragraph to introduce the package -->

The *jliwc* package provides a simple R interface to use the Japanese
version of LIWC2015 (J-LIWC2015) dictionary. J-LIWC2015 is based on the
original English version of LIWC2015 (Pennebaker, Booth, Jordan, &
Blackburn, 2015), a de-facto standard text analysis dictionary for
psycholinguistics developed by Pennebaker et al. (2015). The J-LIWC2015
dictionary is developed by [Igarashi, Okuda, and Sasahara
(2022)](https://doi.org/10.3389/fpsyg.2022.841534). Further information
is available [here](https://github.com/tasukuigarashi/j-liwc2015).

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

You can install the released version of *jliwc* from
[GitHub](https://github.com/tasukuigarashi/jliwc).

``` r
# install.packages("devtools")
devtools::install_github("tasukuigarashi/jliwc")
```

<!-- Explain users need to download J-LIWC dictionary file from LIWC website -->

You also need to have the J-LIWC2015 dictionary file. You can download
it from the LIWC website with a valid serial number.

- [LIWC-22](https://www.liwc.app/dictionaries)
- [LIWC2015](https://www.liwc.net/dictionaries)

## Example

<!-- Write a paragraph about how to Setup the dictionaries: ipadic, userdic, and jliwcdic -->

At the first time of the use of the package, you need to set up three
dictionaries: (1) IPAdic, (2) user dictionary, and (3) J-LIWC2015
dictionary. The IPAdic and user dictionary files are automatically
downloaded and compiled by using the `setup_ipadic()` and
`setup_userdic()` functions, respectively.

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
under your home directory (e.g., `C:/Users/username/J-LIWC2015/` in
Windows). If you want to install the dictionaries at a different
directory, you can specify the directory path by the
`options("jliwc_project_home")` before setting up the dictionaries.

``` r
# Set up dictionaries at a different directory
options("jliwc_project_home" = "C:/JLIWC")

setup_ipadic()
setup_userdic()
setup_jliwcdic(format = "LIWC22")
```

Once you set up the dictionaries, you can use the `liwc_analysis()`
function to analyze Japanese texts. The function returns a data frame
with the LIWC category scores for each text.

``` r
x <- gibasa::ginga[1:10]
x

liwc_results <- x |> liwc_analysis()
head(liwc_results)
```

## Notes

Any request for the distribution of the J-LIWC2015 dictionary file is
not accepted. Queries about the commercial use of J-LIWC2015 should be
directed to \[Receptiviti\](<https://www.receptiviti.com/contact>.

## Reference

Igarashi, T., Okuda, S., & Sasahara, K. (2022). Development of the
Japanese Version of the Linguistic Inquiry and Word Count Dictionary
2015. *Frontiers in Psychology*, 13:841534.
<https://doi.org/10.3389/fpsyg.2022.841534>
