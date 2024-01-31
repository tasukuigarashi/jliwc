load_dictionaries()

test_that("my function works correctly", {
  expect_equal(gibasa::ginga[1:10] |> tokenize_mecab() %>% nrow(), 291)
})
