test_that("test tokenize_mecab", {
  # Check if required dictionary files exist
  # if (!file.exists(getOption("jliwc_project_home"))) {
  #   skip("Skipping test because the dictionary file is not available")
  # }

  # Load the necessary dictionaries
  # load_dictionaries()

  # Test 1: Typical case - Analyze a sample text
  text_sample <- gibasa::ginga
  tokenized <- tokenize_mecab(text_sample[1:10])
  expect_equal(nrow(tokenized), 291) # Check if the token count matches the expected value
  message("Analysis of the sample text is successful")

  # Test 2: Edge case - Empty text
  empty_text <- ""
  tokenized_empty <- tokenize_mecab(empty_text)
  expect_equal(nrow(tokenized_empty), 0) # Should return no tokens
  message("Analysis of the empty text is successful")

  # Test 3: Edge case - Text with special characters
  special_text <- "こんにちは!!!@#$%^&*()"
  tokenized_special <- tokenize_mecab(special_text)
  expect_true(tokenized_special$token == "こんにちは") # Should tokenize properly and no special characters
  message("Analysis of the text with special characters is successful")

  # Test 4: Mixed language (Japanese and English)
  mixed_text <- "これは日本語とEnglishのテストです"
  tokenized_mixed <- tokenize_mecab(mixed_text)
  expect_true(nrow(tokenized_mixed) > 0) # Should tokenize the text with both Japanese and English
  message("Analysis of the mixed language text is successful")

  # Test 5: Large text input
  large_text <- rep(text_sample, 10)
  tokenized_large <- tokenize_mecab(large_text)
  expect_equal(nrow(tokenized_large), 221470) # Large text should generate a large number of tokens
  message("Analysis of the large text is successful")
})
