# Test dictionary installation functions

# IPAdic
test_that("install_ipadic proceeds with user confirmation", {
  with_mocked_bindings(
    readline = function(prompt) "y", # Mock readline to return "y"
    {
      expect_true(install_ipadic()) # Should proceed with installation
    }
  )
})

test_that("install_ipadic aborts on 'no'", {
  with_mocked_bindings(
    readline = function(prompt) "n", # Mock readline to return "n"
    {
      expect_false(install_ipadic()) # Should abort installation
    }
  )
})

# User dictionary
test_that("install_userdic proceeds with user confirmation", {
  with_mocked_bindings(
    readline = function(prompt) "y", # Mock readline to return "y"
    {
      expect_true(install_userdic()) # Should proceed with installation
    }
  )
})

test_that("install_userdic aborts on 'no'", {
  with_mocked_bindings(
    readline = function(prompt) "n", # Mock readline to return "n"
    {
      expect_false(install_userdic()) # Should abort installation
    }
  )
})

# Check dictionaries
test_that("test check_ipadic and check_userdic", {
  expect_true(check_ipadic()) # Should return TRUE
  expect_true(check_userdic()) # Should return TRUE
})

# J-LIWC2015 dictionary
test_that("install_jliwc2015 proceeds with user confirmation", {
  with_mocked_bindings(
    readline = function(prompt) "y", # Mock readline to return "y"
    {
      filename <- "LIWC2015_mock_jp.dic"
      # override a file name
      options(jliwc_dic_filename = list(LIWC2015 = filename))
      dic <- system.file("extdata", filename, package = "jliwc")

      # Mock dictionary categories (in Japanese)
      jliwc_env$liwc_cat_ja <- c("機能語", "名詞", "動詞", "ポジティブ感情", "ネガティブ感情", "人物名")

      expect_true(file.exists(dic))
      expect_true(install_jliwcdic(dic = dic)) # Should proceed with installation
    }
  )
})
