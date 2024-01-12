setup_ipadic()
setup_userdic()
setup_jliwcdic()

test_that("my function works correctly", {
  expect_equal(gibasa::ginga[1:10] |> count_mecab() %>% nrow(), 291)
})
