test_that("my function works correctly", {
  if (!file.exists(getOption("jliwc_project_home"))) {
    skip("Skipping test because the dictionary file is not available")
  }

  load_dictionaries()

  test <- function() {
    gibasa::ginga[1:10] |>
      liwc_analysis() |>
      dplyr::pull(WC)
  }

  x <- test()
  expect_equal(x[4], 75)
})
