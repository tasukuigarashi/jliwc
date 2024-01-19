load_ipadic()
load_userdic()
setup_jliwcdic()

test <- function() {
  gibasa::ginga[1:10] |>
    liwc_analysis() |>
    dplyr::pull(WC)
}

x <- test()

test_that("my function works correctly", {
  expect_equal(x[4], 75)
})
