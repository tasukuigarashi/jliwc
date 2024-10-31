test_that("liwc_analysis with a mock dictionary", {
  load_dictionaries()

  sample <- gibasa::ginga[1:10]

  # Test 1: Analyze character vector
  test1 <- function() {
    sample |>
      liwc_analysis() |>
      dplyr::pull(Dic)
  }

  x <- test1()
  # Dic = 50
  expect_equal(x[3], 50)

  # Test 2: Analyze data frame
  test2 <- function() {
    data.frame(text = sample) |>
      liwc_analysis(text_field = "text") |>
      dplyr::pull(Dic)
  }

  x2 <- test2()
  # Dic = 50
  expect_equal(x2[3], 50)

  # Test 3: language = "ja"
  test3 <- function() {
    sample |>
      liwc_analysis(lang = "ja")
  }

  x3 <- test3() |> names()
  # Dic = 50
  expect_equal(x3[6], "動詞")
})
