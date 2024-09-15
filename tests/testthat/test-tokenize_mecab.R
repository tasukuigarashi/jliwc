test_that("my function works correctly", {
  if (!file.exists(getOption("jliwc_project_home"))) {
    skip("Skipping test because the dictionary file is not available")
  }
  load_dictionaries()

  expect_equal(gibasa::ginga[1:10] |> tokenize_mecab() %>% nrow(), 291)
})
